import { Injectable } from '@nestjs/common';
import { addMinutes } from '../common/time/business-time.js';
import { Clock } from '../common/time/clock.js';
import { PrismaService } from '../prisma/prisma.service.js';
import { PushProvider, type PushMessage } from './push.provider.js';

const BATCH = 200;
const MAX_ATTEMPTS = 3;
/** Older than this, a push is no longer news (e.g. after downtime); it stays in the app list. */
const STALE_AFTER_MINUTES = 60;

export interface DispatchResult {
  sent: number;
  failed: number;
  noDevice: number;
}

/**
 * Delivers notification rows as pushes (the rows are the outbox). Each row is
 * pushed to every device of its recipient; it counts as sent when any device
 * accepted it. Dead tokens are deleted; other failures retry a few times.
 */
@Injectable()
export class PushDispatcher {
  constructor(
    private readonly prisma: PrismaService,
    private readonly push: PushProvider,
    private readonly clock: Clock,
  ) {}

  async dispatch(now = this.clock.now()): Promise<DispatchResult> {
    await this.prisma.notification.updateMany({
      where: {
        pushStatus: 'PENDING',
        createdAt: { lt: addMinutes(now, -STALE_AFTER_MINUTES) },
      },
      data: { pushStatus: 'FAILED', pushError: 'Too old to push' },
    });
    const due = await this.prisma.notification.findMany({
      where: { pushStatus: 'PENDING' },
      orderBy: { createdAt: 'asc' },
      take: BATCH,
      select: {
        id: true,
        recipientId: true,
        type: true,
        title: true,
        message: true,
        referenceType: true,
        referenceId: true,
        data: true,
        pushAttempts: true,
      },
    });
    const result: DispatchResult = { sent: 0, failed: 0, noDevice: 0 };
    if (due.length === 0) return result;

    // Inactive users get no pushes (their rows stay in the database).
    const devices = await this.prisma.deviceToken.findMany({
      where: {
        userId: { in: [...new Set(due.map((n) => n.recipientId))] },
        user: { isActive: true },
      },
      select: { userId: true, fcmToken: true },
    });
    const tokensByUser = new Map<string, string[]>();
    for (const device of devices) {
      tokensByUser.set(device.userId, [
        ...(tokensByUser.get(device.userId) ?? []),
        device.fcmToken,
      ]);
    }

    const unreachable = due
      .filter((n) => !tokensByUser.has(n.recipientId))
      .map((n) => n.id);
    if (unreachable.length > 0) {
      await this.prisma.notification.updateMany({
        where: { id: { in: unreachable } },
        data: { pushStatus: 'NO_DEVICE' },
      });
      result.noDevice = unreachable.length;
    }

    const messages: (PushMessage & { notificationId: string })[] = [];
    for (const n of due) {
      for (const token of tokensByUser.get(n.recipientId) ?? []) {
        const extra = (n.data as Record<string, string> | null) ?? {};
        messages.push({
          notificationId: n.id,
          token,
          title: n.title,
          body: n.message,
          data: {
            ...extra,
            notificationId: n.id,
            type: n.type,
            ...(n.referenceType && { referenceType: n.referenceType }),
            ...(n.referenceId && { referenceId: n.referenceId }),
          },
        });
      }
    }
    if (messages.length === 0) return result;

    let outcomes: Awaited<ReturnType<PushProvider['send']>>;
    try {
      outcomes = await this.push.send(messages);
    } catch (error) {
      outcomes = messages.map((m) => ({
        token: m.token,
        ok: false as const,
        invalidToken: false,
        error: (error as Error).message.slice(0, 200),
      }));
    }

    const dead = new Set<string>();
    const delivered = new Set<string>();
    const errors = new Map<string, string>();
    outcomes.forEach((outcome, i) => {
      const id = messages[i].notificationId;
      if (outcome.ok) delivered.add(id);
      else {
        errors.set(id, outcome.error);
        if (outcome.invalidToken) dead.add(outcome.token);
      }
    });
    if (dead.size > 0)
      await this.prisma.deviceToken.deleteMany({
        where: { fcmToken: { in: [...dead] } },
      });

    const attempted = due.filter((n) => tokensByUser.has(n.recipientId));
    for (const n of attempted) {
      if (delivered.has(n.id)) continue;
      const attempts = n.pushAttempts + 1;
      await this.prisma.notification.update({
        where: { id: n.id },
        data: {
          pushAttempts: attempts,
          pushError: errors.get(n.id) ?? 'No device accepted it',
          pushStatus: attempts >= MAX_ATTEMPTS ? 'FAILED' : 'PENDING',
        },
      });
      if (attempts >= MAX_ATTEMPTS) result.failed += 1;
    }
    if (delivered.size > 0) {
      await this.prisma.notification.updateMany({
        where: { id: { in: [...delivered] } },
        data: { pushStatus: 'SENT', pushSentAt: now, pushError: null },
      });
    }
    result.sent = delivered.size;
    return result;
  }
}
