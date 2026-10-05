import type { INestApplication } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import request from 'supertest';
import type { App } from 'supertest/types.js';
import { AppModule } from '../../src/app.module.js';
import { configureApp } from '../../src/app.setup.js';
import { Clock } from '../../src/common/time/clock.js';
import { MailSender, type MailMessage } from '../../src/mail/mail.module.js';
import { PrismaService } from '../../src/prisma/prisma.service.js';
import {
  PushProvider,
  type PushMessage,
  type PushResult,
} from '../../src/push/push.provider.js';

/** Collects e-mails instead of sending them. */
export class CapturingMailSender extends MailSender {
  readonly enabled = true;
  readonly sent: MailMessage[] = [];

  send(message: MailMessage): Promise<void> {
    this.sent.push(message);
    return Promise.resolve();
  }
}

/** Records pushes; tokens listed in `dead` answer like uninstalled apps. */
export class CapturingPushProvider extends PushProvider {
  readonly sent: PushMessage[] = [];
  readonly dead = new Set<string>();
  failing = false;

  send(messages: readonly PushMessage[]): Promise<PushResult[]> {
    if (this.failing) return Promise.reject(new Error('FCM unavailable'));
    this.sent.push(...messages);
    return Promise.resolve(
      messages.map((m) =>
        this.dead.has(m.token)
          ? {
              token: m.token,
              ok: false as const,
              invalidToken: true,
              error: 'messaging/registration-token-not-registered',
            }
          : { token: m.token, ok: true as const },
      ),
    );
  }
}

/** Business time for the app under test: real time until a test sets it. */
export class FakeClock extends Clock {
  private fixed: Date | null = null;

  now(): Date {
    return this.fixed ? new Date(this.fixed) : new Date();
  }

  set(at: Date): void {
    this.fixed = at;
  }

  reset(): void {
    this.fixed = null;
  }
}

export interface TestApp {
  app: INestApplication<App>;
  prisma: PrismaService;
  mail: CapturingMailSender;
  clock: FakeClock;
  push: CapturingPushProvider;
  http: () => ReturnType<typeof request>;
  close: () => Promise<void>;
}

/** Signs in through the API; returns the Authorization header value. */
export async function signInAs(
  t: TestApp,
  phone: string,
  password = 'Passw0rd2026',
): Promise<string> {
  const response = await t
    .http()
    .post('/api/v1/auth/login')
    .send({ identifier: phone, password });
  if (response.status !== 200) {
    throw new Error(
      `Sign-in failed for ${phone}: ${JSON.stringify(response.body)}`,
    );
  }
  return `Bearer ${response.body.data.accessToken as string}`;
}

/** Boots the real application (all modules, guards, pipes) against the test database. */
export async function createTestApp(): Promise<TestApp> {
  const mail = new CapturingMailSender();
  const clock = new FakeClock();
  const push = new CapturingPushProvider();
  const moduleRef = await Test.createTestingModule({ imports: [AppModule] })
    .overrideProvider(MailSender)
    .useValue(mail)
    .overrideProvider(Clock)
    .useValue(clock)
    .overrideProvider(PushProvider)
    .useValue(push)
    .compile();
  const app = moduleRef.createNestApplication<INestApplication<App>>();
  configureApp(app);
  await app.init();
  return {
    app,
    prisma: app.get(PrismaService),
    mail,
    clock,
    push,
    http: () => request(app.getHttpServer()),
    close: () => app.close(),
  };
}
