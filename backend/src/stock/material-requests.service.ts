import { HttpStatus, Injectable } from '@nestjs/common';
import type { AuthUser } from '../auth/auth-user.js';
import { AuditService } from '../common/audit/audit.service.js';
import { AppException } from '../common/errors/app.exception.js';
import { ErrorCode } from '../common/errors/error-codes.js';
import {
  badRequest,
  conflict,
  notFound,
} from '../common/errors/http-errors.js';
import { Paginated } from '../common/pagination/paginated.js';
import { contains } from '../common/pagination/page-query.dto.js';
import {
  formatQuantity,
  fromMilli,
  toMilli,
} from '../common/quantity/quantity.js';
import { fromDbDate, toDbDate } from '../common/time/business-time.js';
import { Clock } from '../common/time/clock.js';
import type { Prisma } from '../generated/prisma/client.js';
import type {
  MaterialRequestOutcome,
  MaterialRequestStatus,
} from '../generated/prisma/enums.js';
import {
  requestApproved,
  requestClosed,
  requestCreated,
  requestRejected,
  requestToSend,
} from '../notifications/notification-messages.js';
import {
  NotificationsService,
  type NotificationInput,
} from '../notifications/notifications.service.js';
import { PrismaService } from '../prisma/prisma.service.js';
import { SettingsService } from '../settings/settings.service.js';
import type {
  ApproveRequestDto,
  CloseRequestDto,
  CreateMaterialRequestDto,
  RequestQueryDto,
} from './material-requests.dto.js';
import {
  anythingOnTheWay,
  requestCode,
  requestProgress,
  sentInFull,
} from './request-progress.js';
import {
  godownManagerIds,
  StockEntriesService,
} from './stock-entries.service.js';
import {
  ENTRY_INCLUDE,
  findGodown,
  findSite,
  requestScope,
} from './stock-queries.js';
import {
  toEntryView,
  viewContext,
  type StockEntryView,
  type ViewContext,
} from './stock-views.js';

export interface MaterialRequestLineView {
  material: { id: string; name: string; unit: string };
  quantity: string;
  /** Set once approved; zero when not supplied. */
  approvedQuantity: string | null;
  sent: string;
  received: string;
  onTheWay: string;
  leftToSend: string | null;
}

export interface MaterialRequestView {
  id: string;
  /** "MR-0012" */
  code: string;
  site: { id: string; code: string; name: string };
  requestedBy: { id: string; name: string };
  status: MaterialRequestStatus;
  neededBy: string | null;
  note: string | null;
  createdAt: string;
  godown: { id: string; name: string } | null;
  reviewedBy: { id: string; name: string } | null;
  reviewedAt: string | null;
  reviewNote: string | null;
  outcome: MaterialRequestOutcome | null;
  closedBy: { id: string; name: string } | null;
  closedAt: string | null;
  closeNote: string | null;
  lines: MaterialRequestLineView[];
  sentInFull: boolean;
  /** Detail responses only: deliveries and returns made against it. */
  entries?: StockEntryView[];
  /** What the caller may do with it now. */
  canApprove: boolean;
  canCancel: boolean;
  canSend: boolean;
  canClose: boolean;
}

const REQUEST_INCLUDE = {
  site: {
    select: {
      id: true,
      code: true,
      name: true,
      status: true,
      engineerAssignments: { select: { engineerId: true } },
    },
  },
  requestedBy: { select: { id: true, name: true } },
  godown: {
    select: { id: true, name: true, managers: { select: { userId: true } } },
  },
  reviewedBy: { select: { id: true, name: true } },
  closedBy: { select: { id: true, name: true } },
  lines: {
    include: { material: { select: { id: true, name: true, unit: true } } },
    orderBy: { material: { name: 'asc' } },
  },
  entries: {
    select: {
      lines: {
        select: {
          materialId: true,
          fromPlace: true,
          toPlace: true,
          status: true,
          quantity: true,
          receivedQuantity: true,
        },
      },
    },
  },
} as const satisfies Prisma.MaterialRequestInclude;

type RequestRow = Prisma.MaterialRequestGetPayload<{
  include: typeof REQUEST_INCLUDE;
}>;

/**
 * Material requests: an engineer asks for material for their site, an admin
 * approves (choosing the godown and quantities) or rejects it, the godown's
 * manager sends it (see StockEntriesService.transfer), and the engineer
 * closes it when the work is done, returning any leftover.
 */
@Injectable()
export class MaterialRequestsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly entries: StockEntriesService,
    private readonly notifications: NotificationsService,
    private readonly audit: AuditService,
    private readonly settings: SettingsService,
    private readonly clock: Clock,
  ) {}

  async create(
    user: AuthUser,
    dto: CreateMaterialRequestDto,
    now = this.clock.now(),
  ): Promise<MaterialRequestView> {
    const existing = await this.prisma.materialRequest.findUnique({
      where: { requestId: dto.requestId },
      select: { id: true, requestedById: true },
    });
    if (existing) {
      if (existing.requestedById !== user.id) throw requestTaken();
      return this.get(user, existing.id, now);
    }
    const ctx = await viewContext(this.settings, user, now);
    const site = await findSite(this.prisma, user, dto.siteId);
    if (site.status === 'COMPLETED') {
      throw badRequest(
        ErrorCode.SITE_CLOSED,
        'This site is completed.',
        'siteId',
      );
    }
    if (dto.neededBy && dto.neededBy < ctx.today) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Choose today or a later date.',
        'neededBy',
      );
    }
    const seen = new Set<string>();
    const lines = dto.lines.map((line, index) => {
      if (seen.has(line.materialId)) {
        throw badRequest(
          ErrorCode.VALIDATION_FAILED,
          'Each material can appear only once.',
          `lines.${index}.materialId`,
        );
      }
      seen.add(line.materialId);
      if (toMilli(line.quantity) <= 0n) {
        throw badRequest(
          ErrorCode.VALIDATION_FAILED,
          'Enter a quantity above zero.',
          `lines.${index}.quantity`,
        );
      }
      return line;
    });
    const materials = await this.prisma.material.findMany({
      where: { id: { in: [...seen] } },
    });
    const unknown = lines.findIndex(
      (l) => !materials.some((m) => m.id === l.materialId),
    );
    if (unknown >= 0) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Choose a material from the list.',
        `lines.${unknown}.materialId`,
      );
    }
    const inactive = materials.find((m) => !m.isActive);
    if (inactive) {
      throw badRequest(
        ErrorCode.MATERIAL_INACTIVE,
        `${inactive.name} is no longer in use.`,
        'lines',
      );
    }

    try {
      const created = await this.prisma.$transaction(async (tx) => {
        const request = await tx.materialRequest.create({
          data: {
            requestId: dto.requestId,
            siteId: site.id,
            requestedById: user.id,
            neededBy: dto.neededBy ? toDbDate(dto.neededBy) : null,
            note: dto.note || null,
            createdAt: now,
            lines: {
              create: lines.map((l) => ({
                materialId: l.materialId,
                quantity: fromMilli(toMilli(l.quantity)),
              })),
            },
          },
          select: { id: true, number: true },
        });
        const code = requestCode(request.number);
        await this.audit.record(
          {
            actorId: user.id,
            action: 'material_request.created',
            entityType: 'MaterialRequest',
            entityId: request.id,
            changes: {
              siteId: site.id,
              neededBy: dto.neededBy ?? null,
              lines: lines.map((l) => ({ ...l })),
            },
          },
          tx,
        );
        await this.notifications.notify(
          [
            this.notice(
              request.id,
              (await this.notifications.adminIds(tx)).filter(
                (id) => id !== user.id,
              ),
              requestCreated({
                code,
                siteName: site.name,
                byName: user.name,
                items: lines.map((l) => {
                  const m = materials.find((x) => x.id === l.materialId)!;
                  return `${m.name}: ${formatQuantity(toMilli(l.quantity), m.unit)}`;
                }),
              }),
              `request:${request.id}`,
              site.id,
            ),
          ],
          tx,
        );
        return request;
      });
      return this.get(user, created.id, now);
    } catch (error) {
      if ((error as { code?: string }).code === 'P2002') {
        const again = await this.prisma.materialRequest.findUnique({
          where: { requestId: dto.requestId },
          select: { id: true, requestedById: true },
        });
        if (again?.requestedById === user.id)
          return this.get(user, again.id, now);
      }
      throw error;
    }
  }

  async list(
    user: AuthUser,
    query: RequestQueryDto,
    now = this.clock.now(),
  ): Promise<Paginated<MaterialRequestView>> {
    const ctx = await viewContext(this.settings, user, now);
    const term = query.search;
    const where: Prisma.MaterialRequestWhereInput = {
      AND: [
        requestScope(user),
        query.status ? { status: query.status } : {},
        query.open ? { status: { in: ['PENDING', 'APPROVED'] } } : {},
        query.siteId ? { siteId: query.siteId } : {},
        query.godownId ? { godownId: query.godownId } : {},
        term
          ? {
              OR: [
                { site: { name: contains(term) } },
                { note: contains(term) },
                { lines: { some: { material: { name: contains(term) } } } },
              ],
            }
          : {},
      ],
    };
    const [rows, total] = await Promise.all([
      this.prisma.materialRequest.findMany({
        where,
        include: REQUEST_INCLUDE,
        // Waiting first (pending, then being sent), newest first.
        orderBy: [{ status: 'asc' }, { createdAt: 'desc' }],
        skip: query.skip,
        take: query.limit,
      }),
      this.prisma.materialRequest.count({ where }),
    ]);
    return new Paginated(
      rows.map((row) => toRequestView(row, ctx)),
      query.page,
      query.limit,
      total,
    );
  }

  /** One request with its deliveries and returns. */
  async get(
    user: AuthUser,
    id: string,
    now = this.clock.now(),
  ): Promise<MaterialRequestView> {
    const ctx = await viewContext(this.settings, user, now);
    const row = await this.prisma.materialRequest.findFirst({
      where: { id, ...requestScope(user) },
      include: REQUEST_INCLUDE,
    });
    if (!row) throw notFound('material request');
    const entries = await this.prisma.stockEntry.findMany({
      where: { materialRequestId: id },
      include: ENTRY_INCLUDE,
      orderBy: { createdAt: 'asc' },
    });
    return {
      ...toRequestView(row, ctx),
      entries: entries.map((entry) => toEntryView(entry, ctx)),
    };
  }

  /**
   * An admin approves: the godown that supplies it and how much of each
   * material (zero for one that won't be supplied). The godown's managers and
   * the site hear about it.
   */
  async approve(
    user: AuthUser,
    id: string,
    dto: ApproveRequestDto,
    now = this.clock.now(),
  ): Promise<MaterialRequestView> {
    const row = await this.findPending(user, id);
    const godown = await findGodown(this.prisma, dto.godownId);
    if (!godown.isActive) {
      throw badRequest(
        ErrorCode.GODOWN_INACTIVE,
        `${godown.name} is closed. Choose another godown.`,
        'godownId',
      );
    }
    const approved = new Map(
      dto.lines.map((l) => [l.materialId, toMilli(l.approvedQuantity)]),
    );
    if (
      approved.size !== dto.lines.length ||
      approved.size !== row.lines.length ||
      row.lines.some((l) => !approved.has(l.materialId))
    ) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Give an approved quantity for each requested material.',
        'lines',
      );
    }
    if (![...approved.values()].some((q) => q > 0n)) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Approve at least one material, or reject the request.',
        'lines',
      );
    }
    const code = requestCode(row.number);
    await this.prisma.$transaction(async (tx) => {
      const { count } = await tx.materialRequest.updateMany({
        where: { id, status: 'PENDING' },
        data: {
          status: 'APPROVED',
          godownId: godown.id,
          reviewedById: user.id,
          reviewedAt: now,
          reviewNote: dto.note || null,
        },
      });
      if (count === 0) throw notOpen(code);
      for (const line of row.lines) {
        await tx.materialRequestLine.update({
          where: { id: line.id },
          data: {
            approvedQuantity: fromMilli(approved.get(line.materialId)!),
          },
        });
      }
      await this.audit.record(
        {
          actorId: user.id,
          action: 'material_request.approved',
          entityType: 'MaterialRequest',
          entityId: id,
          changes: {
            godownId: godown.id,
            lines: dto.lines.map((l) => ({ ...l })),
            ...(dto.note && { note: dto.note }),
          },
        },
        tx,
      );
      const site = [
        row.requestedById,
        ...row.site.engineerAssignments.map((a) => a.engineerId),
      ];
      const items = row.lines
        .filter((l) => approved.get(l.materialId)! > 0n)
        .map(
          (l) =>
            `${l.material.name}: ${formatQuantity(approved.get(l.materialId)!, l.material.unit)}`,
        );
      await this.notifications.notify(
        [
          this.notice(
            id,
            site.filter((u) => u !== user.id),
            requestApproved({ code, godownName: godown.name }),
            `request-approved:${id}`,
            row.siteId,
          ),
          this.notice(
            id,
            (await godownManagerIds(tx, godown.id)).filter(
              (u) => u !== user.id,
            ),
            requestToSend({ code, siteName: row.site.name, items }),
            `request-to-send:${id}`,
            row.siteId,
          ),
        ],
        tx,
      );
    });
    return this.get(user, id, now);
  }

  async reject(
    user: AuthUser,
    id: string,
    reason: string,
    now = this.clock.now(),
  ): Promise<MaterialRequestView> {
    const row = await this.findPending(user, id);
    const code = requestCode(row.number);
    await this.prisma.$transaction(async (tx) => {
      const { count } = await tx.materialRequest.updateMany({
        where: { id, status: 'PENDING' },
        data: {
          status: 'REJECTED',
          reviewedById: user.id,
          reviewedAt: now,
          reviewNote: reason,
        },
      });
      if (count === 0) throw notOpen(code);
      await this.audit.record(
        {
          actorId: user.id,
          action: 'material_request.rejected',
          entityType: 'MaterialRequest',
          entityId: id,
          changes: { reason },
        },
        tx,
      );
      await this.notifications.notify(
        [
          this.notice(
            id,
            [
              row.requestedById,
              ...row.site.engineerAssignments.map((a) => a.engineerId),
            ].filter((u) => u !== user.id),
            requestRejected({ code, reason }),
            `request-rejected:${id}`,
            row.siteId,
          ),
        ],
        tx,
      );
    });
    return this.get(user, id, now);
  }

  /** Withdrawn by the site (or an admin) before an admin decided. */
  async cancel(
    user: AuthUser,
    id: string,
    now = this.clock.now(),
  ): Promise<MaterialRequestView> {
    const ctx = await viewContext(this.settings, user, now);
    const row = await this.find(user, id);
    if (!toRequestView(row, ctx).canCancel) {
      if (row.status !== 'PENDING') throw notOpen(requestCode(row.number));
      throw forbidden('Only the site or an admin can withdraw this request.');
    }
    await this.prisma.$transaction(async (tx) => {
      const { count } = await tx.materialRequest.updateMany({
        where: { id, status: 'PENDING' },
        data: { status: 'CANCELLED' },
      });
      if (count === 0) throw notOpen(requestCode(row.number));
      await this.audit.record(
        {
          actorId: user.id,
          action: 'material_request.cancelled',
          entityType: 'MaterialRequest',
          entityId: id,
        },
        tx,
      );
    });
    return this.get(user, id, now);
  }

  /**
   * The site has finished with it: all used, or the leftover goes back to the
   * godown (recorded as a return the godown confirms). Admins and the godown
   * hear about it.
   */
  async close(
    user: AuthUser,
    id: string,
    dto: CloseRequestDto,
    now = this.clock.now(),
  ): Promise<MaterialRequestView> {
    const ctx = await viewContext(this.settings, user, now);
    const row = await this.find(user, id);
    const code = requestCode(row.number);
    if (row.status === 'CLOSED' && row.closedById === user.id)
      return this.get(user, id, now);
    const view = toRequestView(row, ctx);
    if (!view.canClose) {
      if (row.status !== 'APPROVED') throw notOpen(code);
      if (anythingOnTheWay(progressOf(row))) {
        throw conflict(
          ErrorCode.REQUEST_NOT_OPEN,
          'Confirm the delivery on its way before closing this request.',
        );
      }
      throw forbidden("Only the site's engineer or an admin can close this.");
    }
    const leftover = dto.outcome === 'LEFTOVER_RETURNED';
    const closeIt = async (tx: Prisma.TransactionClient) => {
      const { count } = await tx.materialRequest.updateMany({
        where: { id, status: 'APPROVED' },
        data: {
          status: 'CLOSED',
          outcome: dto.outcome,
          closedById: user.id,
          closedAt: now,
          closeNote: dto.note || null,
        },
      });
      if (count === 0) throw notOpen(code);
      await this.audit.record(
        {
          actorId: user.id,
          action: 'material_request.closed',
          entityType: 'MaterialRequest',
          entityId: id,
          changes: {
            outcome: dto.outcome,
            ...(dto.note && { note: dto.note }),
            ...(dto.lines && { returned: dto.lines.map((l) => ({ ...l })) }),
          },
        },
        tx,
      );
      await this.notifications.notify(
        [
          this.notice(
            id,
            [
              ...(await this.notifications.adminIds(tx)),
              ...(row.godownId ? await godownManagerIds(tx, row.godownId) : []),
            ].filter((u) => u !== user.id),
            requestClosed({ code, siteName: row.site.name, leftover }),
            `request-closed:${id}`,
            row.siteId,
          ),
        ],
        tx,
      );
    };
    if (leftover) {
      if (!dto.lines?.length || !dto.returnRequestId) {
        throw badRequest(
          ErrorCode.VALIDATION_FAILED,
          'Say what is going back to the godown.',
          'lines',
        );
      }
      // The return and the close are written together: never one without the other.
      await this.entries.transfer(
        user,
        {
          requestId: dto.returnRequestId,
          movedOn: ctx.today,
          fromSiteId: row.siteId,
          toGodownId: row.godownId!,
          lines: dto.lines,
          note: `Leftover from ${code}`,
          materialRequestId: id,
        },
        [],
        now,
        closeIt,
      );
    } else {
      await this.prisma.$transaction(closeIt);
    }
    return this.get(user, id, now);
  }

  /** Approved requests from these godowns with something still to send. */
  async toSendCount(godownIds: readonly string[]): Promise<number> {
    if (!godownIds.length) return 0;
    const rows = await this.prisma.materialRequest.findMany({
      where: { status: 'APPROVED', godownId: { in: [...godownIds] } },
      include: REQUEST_INCLUDE,
    });
    return rows.filter((row) => !sentInFull(progressOf(row))).length;
  }

  private async find(user: AuthUser, id: string): Promise<RequestRow> {
    const row = await this.prisma.materialRequest.findFirst({
      where: { id, ...requestScope(user) },
      include: REQUEST_INCLUDE,
    });
    if (!row) throw notFound('material request');
    return row;
  }

  private async findPending(user: AuthUser, id: string): Promise<RequestRow> {
    const row = await this.find(user, id);
    if (row.status !== 'PENDING') throw notOpen(requestCode(row.number));
    return row;
  }

  private notice(
    requestId: string,
    recipientIds: readonly string[],
    text: { title: string; message: string },
    dedupeKey: string,
    siteId: string,
  ): NotificationInput {
    return {
      recipientIds,
      type: 'STOCK',
      ...text,
      referenceType: 'MATERIAL_REQUEST',
      referenceId: requestId,
      data: { requestId, siteId },
      dedupeKey,
    };
  }
}

function progressOf(row: RequestRow) {
  return requestProgress(
    row.lines.map((l) => ({
      materialId: l.materialId,
      approved:
        l.approvedQuantity === null ? null : toMilli(l.approvedQuantity),
    })),
    row.entries.flatMap((e) =>
      e.lines.map((l) => ({
        materialId: l.materialId,
        fromPlace: l.fromPlace,
        toPlace: l.toPlace,
        status: l.status,
        quantity: toMilli(l.quantity),
        receivedQuantity:
          l.receivedQuantity === null ? null : toMilli(l.receivedQuantity),
      })),
    ),
  );
}

/**
 * Admins approve, reject, send (as a backup) and close. Engineers on the site
 * withdraw pending requests and close approved ones once nothing is on the
 * way. The godown's managers send.
 */
function toRequestView(row: RequestRow, ctx: ViewContext): MaterialRequestView {
  const { user } = ctx;
  const admin = user.role === 'ADMIN';
  const onSite =
    user.role === 'ENGINEER' &&
    row.site.engineerAssignments.some((a) => a.engineerId === user.id);
  const runsGodown =
    user.role === 'GODOWN_MANAGER' &&
    (row.godown?.managers.some((m) => m.userId === user.id) ?? false);
  const progress = progressOf(row);
  const full = sentInFull(progress);
  const approved = row.status === 'APPROVED';
  return {
    id: row.id,
    code: requestCode(row.number),
    site: { id: row.site.id, code: row.site.code, name: row.site.name },
    requestedBy: row.requestedBy,
    status: row.status,
    neededBy: row.neededBy && fromDbDate(row.neededBy),
    note: row.note,
    createdAt: row.createdAt.toISOString(),
    godown: row.godown && { id: row.godown.id, name: row.godown.name },
    reviewedBy: row.reviewedBy,
    reviewedAt: row.reviewedAt?.toISOString() ?? null,
    reviewNote: row.reviewNote,
    outcome: row.outcome,
    closedBy: row.closedBy,
    closedAt: row.closedAt?.toISOString() ?? null,
    closeNote: row.closeNote,
    lines: row.lines.map((line) => {
      const p = progress.get(line.materialId)!;
      return {
        material: line.material,
        quantity: fromMilli(toMilli(line.quantity)),
        approvedQuantity:
          line.approvedQuantity === null
            ? null
            : fromMilli(toMilli(line.approvedQuantity)),
        sent: fromMilli(p.sent),
        received: fromMilli(p.received),
        onTheWay: fromMilli(p.onTheWay),
        leftToSend: p.leftToSend === null ? null : fromMilli(p.leftToSend),
      };
    }),
    sentInFull: full,
    canApprove: admin && row.status === 'PENDING',
    canCancel:
      row.status === 'PENDING' &&
      (admin || onSite || row.requestedById === user.id),
    canSend: approved && !full && (admin || runsGodown),
    canClose: approved && (admin || onSite) && !anythingOnTheWay(progress),
  };
}

const forbidden = (message: string) =>
  new AppException(ErrorCode.FORBIDDEN, message, HttpStatus.FORBIDDEN);

const notOpen = (code: string) =>
  conflict(
    ErrorCode.REQUEST_NOT_OPEN,
    `${code} has already been dealt with. Reload it to see where it is.`,
  );

const requestTaken = () =>
  conflict(
    ErrorCode.CONFLICT,
    'This form was already sent by someone else. Start a new one.',
  );
