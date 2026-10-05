import { Logger } from '@nestjs/common';
import { cert, initializeApp, type App } from 'firebase-admin/app';
import { getMessaging } from 'firebase-admin/messaging';

export interface PushMessage {
  token: string;
  title: string;
  body: string;
  /** Routing data for the app; FCM requires string values. */
  data: Record<string, string>;
}

export type PushResult =
  | { token: string; ok: true }
  | { token: string; ok: false; invalidToken: boolean; error: string };

/** Sends push notifications to devices. Chosen by PUSH_DRIVER. */
export abstract class PushProvider {
  abstract send(messages: readonly PushMessage[]): Promise<PushResult[]>;
}

/** Development: writes pushes to the log. */
export class LogPushProvider extends PushProvider {
  private readonly logger = new Logger('Push');

  send(messages: readonly PushMessage[]): Promise<PushResult[]> {
    for (const message of messages) {
      this.logger.log(
        `To ${message.token.slice(0, 10)}…: ${message.title} — ${message.body}`,
      );
    }
    return Promise.resolve(
      messages.map((m) => ({ token: m.token, ok: true as const })),
    );
  }
}

/** Tokens FCM says will never work again; the device record is removed. */
const DEAD_TOKEN_CODES = new Set([
  'messaging/registration-token-not-registered',
  'messaging/invalid-registration-token',
]);

/** Firebase Cloud Messaging with a service account (server only). */
export class FcmPushProvider extends PushProvider {
  private readonly app: App;

  constructor(projectId: string, clientEmail: string, privateKey: string) {
    super();
    this.app = initializeApp(
      // Keys in .env usually carry "\n" escapes.
      {
        credential: cert({
          projectId,
          clientEmail,
          privateKey: privateKey.replace(/\\n/g, '\n'),
        }),
      },
      'sitework-push',
    );
  }

  async send(messages: readonly PushMessage[]): Promise<PushResult[]> {
    const results: PushResult[] = [];
    // FCM accepts at most 500 messages per batch.
    for (let start = 0; start < messages.length; start += 500) {
      const batch = messages.slice(start, start + 500);
      const response = await getMessaging(this.app).sendEach(
        batch.map((m) => ({
          token: m.token,
          notification: { title: m.title, body: m.body },
          data: m.data,
          android: { priority: 'high' as const },
        })),
      );
      response.responses.forEach((r, i) => {
        const token = batch[i].token;
        results.push(
          r.success
            ? { token, ok: true }
            : {
                token,
                ok: false,
                invalidToken: DEAD_TOKEN_CODES.has(r.error?.code ?? ''),
                error: r.error?.code ?? 'unknown',
              },
        );
      });
    }
    return results;
  }
}
