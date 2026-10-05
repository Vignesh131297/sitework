import { Injectable } from '@nestjs/common';
import {
  AttachmentsService,
  type AttachmentView,
} from '../attachments/attachments.service.js';
import type { AuthUser } from '../auth/auth-user.js';
import { siteRecordScope, siteScope } from '../common/access/access-scope.js';
import { AuditService } from '../common/audit/audit.service.js';
import { ErrorCode } from '../common/errors/error-codes.js';
import { badRequest, notFound } from '../common/errors/http-errors.js';
import { Paginated } from '../common/pagination/paginated.js';
import { addDays, zonedInstant } from '../common/time/business-time.js';
import { Clock } from '../common/time/clock.js';
import type { Prisma } from '../generated/prisma/client.js';
import type {
  EngineerUpdateType,
  Priority,
} from '../generated/prisma/enums.js';
import { engineerUpdateSubmitted } from '../notifications/notification-messages.js';
import { NotificationsService } from '../notifications/notifications.service.js';
import { PrismaService } from '../prisma/prisma.service.js';
import { SettingsService } from '../settings/settings.service.js';
import type { UploadedPhoto } from '../staff-updates/staff-updates.dto.js';
import type {
  CreateEngineerUpdateDto,
  EngineerUpdateQueryDto,
} from './engineer-updates.dto.js';

export interface EngineerUpdateView {
  id: string;
  type: EngineerUpdateType;
  priority: Priority;
  title: string | null;
  description: string;
  progressPercent: number | null;
  site: { id: string; name: string };
  engineer: { id: string; name: string };
  createdAt: string;
  adminViewedAt: string | null;
  attachmentCount: number;
  /** Detail responses only. */
  attachments?: AttachmentView[];
}

const LIST_INCLUDE = {
  site: { select: { id: true, name: true } },
  engineer: { select: { id: true, name: true } },
  _count: { select: { attachments: true } },
} as const satisfies Prisma.EngineerUpdateInclude;

const DETAIL_INCLUDE = {
  ...LIST_INCLUDE,
  attachments: {
    select: { id: true, mime: true, objectKey: true },
    orderBy: { createdAt: 'asc' },
  },
} as const satisfies Prisma.EngineerUpdateInclude;

type ListRow = Prisma.EngineerUpdateGetPayload<{
  include: typeof LIST_INCLUDE;
}>;

/** Engineers' reports to the admin: progress, materials, safety, remarks. */
@Injectable()
export class EngineerUpdatesService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly attachments: AttachmentsService,
    private readonly notifications: NotificationsService,
    private readonly audit: AuditService,
    private readonly settings: SettingsService,
    private readonly clock: Clock,
  ) {}

  async create(
    user: AuthUser,
    dto: CreateEngineerUpdateDto,
    photos: readonly UploadedPhoto[],
    now = this.clock.now(),
  ): Promise<EngineerUpdateView> {
    const site = await this.prisma.site.findFirst({
      where: { id: dto.siteId, ...siteScope(user) },
      select: { id: true, name: true },
    });
    if (!site) throw notFound('site');
    if (dto.progressPercent !== undefined && dto.type !== 'PROGRESS') {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Progress belongs to progress updates only.',
        'progressPercent',
      );
    }
    const stored = await this.attachments.store(photos, now);
    try {
      const row = await this.prisma.$transaction(async (tx) => {
        const created = await tx.engineerUpdate.create({
          data: {
            engineerId: user.id,
            siteId: site.id,
            type: dto.type,
            priority: dto.priority ?? 'MEDIUM',
            title: dto.title || null,
            description: dto.description,
            progressPercent: dto.progressPercent,
            createdAt: now,
            attachments: {
              create: stored.map((s) => ({ ...s, uploadedById: user.id })),
            },
          },
          include: DETAIL_INCLUDE,
        });
        if (dto.progressPercent !== undefined) {
          // The site shows the latest progress its engineer reported.
          await tx.site.update({
            where: { id: site.id },
            data: { progressPercent: dto.progressPercent },
          });
          await this.audit.record(
            {
              actorId: user.id,
              action: 'site.progress_reported',
              entityType: 'Site',
              entityId: site.id,
              changes: {
                progressPercent: dto.progressPercent,
                engineerUpdateId: created.id,
              },
            },
            tx,
          );
        }
        await this.notifications.notify(
          [
            {
              recipientIds: await this.notifications.adminIds(tx),
              type: 'ENGINEER_UPDATE',
              ...engineerUpdateSubmitted({
                engineerName: user.name,
                type: dto.type,
                siteName: site.name,
              }),
              referenceType: 'ENGINEER_UPDATE',
              referenceId: created.id,
              data: { siteId: site.id },
              dedupeKey: `engineer-update:${created.id}`,
            },
          ],
          tx,
        );
        return created;
      });
      return {
        ...toView(row),
        attachments: await this.attachments.views(row.attachments, now),
      };
    } catch (error) {
      await this.attachments.discard(stored);
      throw error;
    }
  }

  async list(
    user: AuthUser,
    query: EngineerUpdateQueryDto,
  ): Promise<Paginated<EngineerUpdateView>> {
    const { timeZone } = (await this.settings.getAll()).business;
    const term = query.search;
    const where: Prisma.EngineerUpdateWhereInput = {
      AND: [
        siteRecordScope(user),
        query.siteId ? { siteId: query.siteId } : {},
        query.engineerId ? { engineerId: query.engineerId } : {},
        query.type ? { type: query.type } : {},
        query.from
          ? { createdAt: { gte: zonedInstant(query.from, '00:00', timeZone) } }
          : {},
        query.to
          ? {
              createdAt: {
                lt: zonedInstant(addDays(query.to, 1), '00:00', timeZone),
              },
            }
          : {},
        term
          ? {
              OR: [
                { description: { contains: term, mode: 'insensitive' } },
                { title: { contains: term, mode: 'insensitive' } },
              ],
            }
          : {},
      ],
    };
    const [rows, total] = await Promise.all([
      this.prisma.engineerUpdate.findMany({
        where,
        include: LIST_INCLUDE,
        orderBy: { createdAt: 'desc' },
        skip: query.skip,
        take: query.limit,
      }),
      this.prisma.engineerUpdate.count({ where }),
    ]);
    return new Paginated(rows.map(toView), query.page, query.limit, total);
  }

  async get(
    user: AuthUser,
    id: string,
    now = this.clock.now(),
  ): Promise<EngineerUpdateView> {
    const row = await this.prisma.engineerUpdate.findFirst({
      where: { id, ...siteRecordScope(user) },
      include: DETAIL_INCLUDE,
    });
    if (!row) throw notFound('update');
    return {
      ...toView(row),
      attachments: await this.attachments.views(row.attachments, now),
    };
  }

  /** The first admin to open it marks it seen. */
  async markViewed(
    user: AuthUser,
    id: string,
    now = this.clock.now(),
  ): Promise<EngineerUpdateView> {
    await this.prisma.engineerUpdate.updateMany({
      where: { id, adminViewedAt: null },
      data: { adminViewedAt: now, adminViewedById: user.id },
    });
    return this.get(user, id, now);
  }
}

function toView(row: ListRow): EngineerUpdateView {
  return {
    id: row.id,
    type: row.type,
    priority: row.priority,
    title: row.title,
    description: row.description,
    progressPercent: row.progressPercent,
    site: row.site,
    engineer: row.engineer,
    createdAt: row.createdAt.toISOString(),
    adminViewedAt: row.adminViewedAt?.toISOString() ?? null,
    attachmentCount: row._count.attachments,
  };
}
