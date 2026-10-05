import { HttpStatus, Injectable } from '@nestjs/common';
import {
  AttachmentsService,
  type AttachmentView,
} from '../attachments/attachments.service.js';
import type { AuthUser } from '../auth/auth-user.js';
import { siteRecordScope, siteScope } from '../common/access/access-scope.js';
import { AuditService } from '../common/audit/audit.service.js';
import { AppException } from '../common/errors/app.exception.js';
import { ErrorCode } from '../common/errors/error-codes.js';
import { badRequest, notFound } from '../common/errors/http-errors.js';
import { Paginated } from '../common/pagination/paginated.js';
import { Clock } from '../common/time/clock.js';
import type { Prisma } from '../generated/prisma/client.js';
import type { IssueStatus, Priority, Role } from '../generated/prisma/enums.js';
import {
  issueReported,
  issueResolved,
} from '../notifications/notification-messages.js';
import { NotificationsService } from '../notifications/notifications.service.js';
import { PrismaService } from '../prisma/prisma.service.js';
import type { UploadedPhoto } from '../staff-updates/staff-updates.dto.js';
import type {
  CreateIssueDto,
  IssueQueryDto,
  UpdateIssueDto,
} from './issues.dto.js';

export interface IssueView {
  id: string;
  title: string;
  description: string;
  priority: Priority;
  status: IssueStatus;
  site: { id: string; name: string };
  reportedBy: { id: string; name: string; role: Role };
  createdAt: string;
  resolvedAt: string | null;
  resolvedBy: { id: string; name: string } | null;
  resolutionNote: string | null;
  attachmentCount: number;
  /** Detail responses only. */
  attachments?: AttachmentView[];
}

const LIST_INCLUDE = {
  site: { select: { id: true, name: true } },
  reportedBy: { select: { id: true, name: true, role: true } },
  resolvedBy: { select: { id: true, name: true } },
  _count: { select: { attachments: true } },
} as const satisfies Prisma.IssueInclude;

const DETAIL_INCLUDE = {
  ...LIST_INCLUDE,
  attachments: {
    select: { id: true, mime: true, objectKey: true },
    orderBy: { createdAt: 'asc' },
  },
} as const satisfies Prisma.IssueInclude;

type ListRow = Prisma.IssueGetPayload<{ include: typeof LIST_INCLUDE }>;

/** Site problems, reported by engineers or admins and followed until resolved. */
@Injectable()
export class IssuesService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly attachments: AttachmentsService,
    private readonly notifications: NotificationsService,
    private readonly audit: AuditService,
    private readonly clock: Clock,
  ) {}

  async create(
    user: AuthUser,
    dto: CreateIssueDto,
    photos: readonly UploadedPhoto[],
    now = this.clock.now(),
  ): Promise<IssueView> {
    const site = await this.prisma.site.findFirst({
      where: { id: dto.siteId, ...siteScope(user) },
      select: {
        id: true,
        name: true,
        engineerAssignments: { select: { engineerId: true } },
      },
    });
    if (!site) throw notFound('site');
    const stored = await this.attachments.store(photos, now);
    try {
      const row = await this.prisma.$transaction(async (tx) => {
        const created = await tx.issue.create({
          data: {
            siteId: site.id,
            reportedById: user.id,
            title: dto.title,
            description: dto.description,
            priority: dto.priority ?? 'MEDIUM',
            createdAt: now,
            attachments: {
              create: stored.map((s) => ({ ...s, uploadedById: user.id })),
            },
          },
          include: DETAIL_INCLUDE,
        });
        // Admins and the site's engineers hear about it; the reporter already knows.
        const recipients = [
          ...(await this.notifications.adminIds(tx)),
          ...site.engineerAssignments.map((a) => a.engineerId),
        ].filter((id) => id !== user.id);
        await this.notifications.notify(
          [
            {
              recipientIds: recipients,
              type: 'ISSUE',
              ...issueReported({
                title: created.title,
                priority: created.priority,
                siteName: site.name,
                reporterName: user.name,
              }),
              referenceType: 'ISSUE',
              referenceId: created.id,
              data: { siteId: site.id },
              dedupeKey: `issue:${created.id}`,
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
    query: IssueQueryDto,
  ): Promise<Paginated<IssueView>> {
    const term = query.search;
    const where: Prisma.IssueWhereInput = {
      AND: [
        siteRecordScope(user),
        query.siteId ? { siteId: query.siteId } : {},
        query.status ? { status: query.status } : {},
        query.unresolved ? { status: { not: 'RESOLVED' } } : {},
        query.priority ? { priority: query.priority } : {},
        term
          ? {
              OR: [
                { title: { contains: term, mode: 'insensitive' } },
                { description: { contains: term, mode: 'insensitive' } },
              ],
            }
          : {},
      ],
    };
    const [rows, total] = await Promise.all([
      this.prisma.issue.findMany({
        where,
        include: LIST_INCLUDE,
        // Unresolved first, most urgent first, newest first.
        orderBy: [
          { status: 'asc' },
          { priority: 'desc' },
          { createdAt: 'desc' },
        ],
        skip: query.skip,
        take: query.limit,
      }),
      this.prisma.issue.count({ where }),
    ]);
    return new Paginated(rows.map(toView), query.page, query.limit, total);
  }

  async get(
    user: AuthUser,
    id: string,
    now = this.clock.now(),
  ): Promise<IssueView> {
    const row = await this.prisma.issue.findFirst({
      where: { id, ...siteRecordScope(user) },
      include: DETAIL_INCLUDE,
    });
    if (!row) throw notFound('issue');
    return {
      ...toView(row),
      attachments: await this.attachments.views(row.attachments, now),
    };
  }

  /**
   * Status and priority changes by the site's engineers or an admin. Resolving
   * needs a note; reopening a resolved issue is for admins.
   */
  async update(
    user: AuthUser,
    id: string,
    dto: UpdateIssueDto,
    now = this.clock.now(),
  ): Promise<IssueView> {
    const issue = await this.prisma.issue.findFirst({
      where: { id, ...siteRecordScope(user) },
      include: { site: { select: { name: true } } },
    });
    if (!issue) throw notFound('issue');
    const status = dto.status ?? issue.status;
    const resolving = status === 'RESOLVED' && issue.status !== 'RESOLVED';
    const reopening = issue.status === 'RESOLVED' && status !== 'RESOLVED';
    if (resolving && !dto.resolutionNote) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Say what was done to resolve it.',
        'resolutionNote',
      );
    }
    if (reopening && user.role !== 'ADMIN') {
      throw new AppException(
        ErrorCode.FORBIDDEN,
        'Only an admin can reopen a resolved issue.',
        HttpStatus.FORBIDDEN,
      );
    }

    const row = await this.prisma.$transaction(async (tx) => {
      const updated = await tx.issue.update({
        where: { id },
        data: {
          status,
          priority: dto.priority,
          ...(resolving && {
            resolvedAt: now,
            resolvedById: user.id,
            resolutionNote: dto.resolutionNote,
          }),
          ...(reopening && {
            resolvedAt: null,
            resolvedById: null,
            resolutionNote: null,
          }),
        },
        include: DETAIL_INCLUDE,
      });
      await this.audit.record(
        {
          actorId: user.id,
          action: 'issue.updated',
          entityType: 'Issue',
          entityId: id,
          changes: {
            before: { status: issue.status, priority: issue.priority },
            after: { status: updated.status, priority: updated.priority },
            ...(dto.resolutionNote && { resolutionNote: dto.resolutionNote }),
          },
        },
        tx,
      );
      if (resolving) {
        const recipients = [
          issue.reportedById,
          ...(await this.notifications.adminIds(tx)),
        ].filter((recipient) => recipient !== user.id);
        await this.notifications.notify(
          [
            {
              recipientIds: recipients,
              type: 'ISSUE',
              ...issueResolved({
                title: issue.title,
                siteName: issue.site.name,
              }),
              referenceType: 'ISSUE',
              referenceId: id,
              data: { siteId: issue.siteId },
              // Resolving again after a reopen is news again.
              dedupeKey: `issue-resolved:${id}:${now.getTime()}`,
            },
          ],
          tx,
        );
      }
      return updated;
    });
    return {
      ...toView(row),
      attachments: await this.attachments.views(row.attachments, now),
    };
  }
}

function toView(row: ListRow): IssueView {
  return {
    id: row.id,
    title: row.title,
    description: row.description,
    priority: row.priority,
    status: row.status,
    site: row.site,
    reportedBy: row.reportedBy,
    createdAt: row.createdAt.toISOString(),
    resolvedAt: row.resolvedAt?.toISOString() ?? null,
    resolvedBy: row.resolvedBy,
    resolutionNote: row.resolutionNote,
    attachmentCount: row._count.attachments,
  };
}
