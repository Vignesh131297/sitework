import { Injectable } from '@nestjs/common';
import type { Prisma } from '../generated/prisma/client.js';
import type {
  NotificationType,
  ReferenceType,
} from '../generated/prisma/enums.js';
import { PrismaService } from '../prisma/prisma.service.js';
import type { NotificationText } from './notification-messages.js';

export interface NotificationInput extends NotificationText {
  recipientIds: readonly string[];
  type: NotificationType;
  referenceType?: ReferenceType;
  referenceId?: string;
  /** Extra routing data for the app, e.g. { siteId }. */
  data?: Record<string, string>;
  /**
   * Same key for the same event: a recipient never gets it twice, however often
   * the code that raises it runs (jobs, retries).
   */
  dedupeKey: string;
}

export interface NotificationView {
  id: string;
  type: NotificationType;
  title: string;
  message: string;
  referenceType: ReferenceType | null;
  referenceId: string | null;
  data: Record<string, string> | null;
  isRead: boolean;
  createdAt: string;
}

/**
 * Records notifications in the database (the in-app list and the push outbox).
 * Push delivery reads rows still PENDING, so creating a row is all a feature does.
 */
@Injectable()
export class NotificationsService {
  constructor(private readonly prisma: PrismaService) {}

  async notify(
    inputs: readonly NotificationInput[],
    db: Prisma.TransactionClient = this.prisma,
  ): Promise<number> {
    const data = inputs.flatMap((input) =>
      [...new Set(input.recipientIds)].map((recipientId) => ({
        recipientId,
        type: input.type,
        title: input.title,
        message: input.message,
        referenceType: input.referenceType,
        referenceId: input.referenceId,
        data: input.data,
        dedupeKey: input.dedupeKey,
      })),
    );
    if (data.length === 0) return 0;
    const { count } = await db.notification.createMany({
      data,
      skipDuplicates: true,
    });
    return count;
  }

  /** Active admins: most events are reported to all of them. */
  async adminIds(
    db: Prisma.TransactionClient = this.prisma,
  ): Promise<string[]> {
    const admins = await db.user.findMany({
      where: { role: 'ADMIN', isActive: true },
      select: { id: true },
    });
    return admins.map((admin) => admin.id);
  }

  async list(
    recipientId: string,
    {
      unreadOnly,
      skip,
      take,
    }: { unreadOnly: boolean; skip: number; take: number },
  ): Promise<{ items: NotificationView[]; total: number }> {
    const where: Prisma.NotificationWhereInput = {
      recipientId,
      ...(unreadOnly && { isRead: false }),
    };
    const [rows, total] = await Promise.all([
      this.prisma.notification.findMany({
        where,
        orderBy: { createdAt: 'desc' },
        skip,
        take,
      }),
      this.prisma.notification.count({ where }),
    ]);
    return {
      items: rows.map((row) => ({
        id: row.id,
        type: row.type,
        title: row.title,
        message: row.message,
        referenceType: row.referenceType,
        referenceId: row.referenceId,
        data: (row.data as Record<string, string> | null) ?? null,
        isRead: row.isRead,
        createdAt: row.createdAt.toISOString(),
      })),
      total,
    };
  }

  unreadCount(recipientId: string): Promise<number> {
    return this.prisma.notification.count({
      where: { recipientId, isRead: false },
    });
  }

  /** Marks one notification read. Someone else's id behaves like a missing one. */
  async markRead(recipientId: string, id: string): Promise<boolean> {
    const { count } = await this.prisma.notification.updateMany({
      where: { id, recipientId },
      data: { isRead: true, readAt: new Date() },
    });
    return count > 0;
  }

  async markAllRead(recipientId: string): Promise<number> {
    const { count } = await this.prisma.notification.updateMany({
      where: { recipientId, isRead: false },
      data: { isRead: true, readAt: new Date() },
    });
    return count;
  }
}
