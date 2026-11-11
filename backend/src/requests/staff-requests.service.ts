import { Injectable } from '@nestjs/common';
import { AuditService } from '../common/audit/audit.service.js';
import { ErrorCode } from '../common/errors/error-codes.js';
import {
  badRequest,
  conflict,
  notFound,
} from '../common/errors/http-errors.js';
import { fromPaise, toPaise, type Paise } from '../common/money/money.js';
import { contains } from '../common/pagination/page-query.dto.js';
import { Paginated } from '../common/pagination/paginated.js';
import {
  addDays,
  formatShortDate,
  fromDbDate,
  toDbDate,
} from '../common/time/business-time.js';
import { Clock } from '../common/time/clock.js';
import type { Prisma } from '../generated/prisma/client.js';
import type {
  ApprovalStatus,
  Meal,
  StaffRequestKind,
} from '../generated/prisma/enums.js';
import {
  MEAL_LABEL,
  staffRequestCreated,
  staffRequestDecided,
  staffRequestSummary,
} from '../notifications/notification-messages.js';
import { NotificationsService } from '../notifications/notifications.service.js';
import { PrismaService } from '../prisma/prisma.service.js';
import { CalendarService } from '../settings/calendar.service.js';
import {
  alreadyDecided,
  forbidden,
  formTaken,
  siteEngineerIds,
  staffRequestCode,
  type Caller,
  type Person,
} from './request-common.js';
import type {
  ApproveDto,
  CreateStaffRequestDto,
  StaffRequestQueryDto,
} from './requests.dto.js';

/** Largest advance one request may ask for, in rupees. */
export const MAX_ADVANCE_RUPEES = 100_000;
/** A meal can be asked for this many days ahead. */
export const FOOD_AHEAD_DAYS = 30;

export interface StaffRequestView {
  id: string;
  /** "RQ-0012" */
  code: string;
  kind: StaffRequestKind;
  staff: { id: string; name: string; employeeCode: string };
  site: { id: string; name: string };
  /** MONEY: rupees as a decimal string ("500.00"). */
  amount: string | null;
  /** FOOD: the day and the meal. */
  forDate: string | null;
  meal: Meal | null;
  note: string | null;
  status: ApprovalStatus;
  reviewedBy: Person | null;
  reviewedAt: string | null;
  reviewNote: string | null;
  createdAt: string;
  /** What the caller may do with it now. */
  canApprove: boolean;
  canCancel: boolean;
}

const INCLUDE = {
  staff: { select: { id: true, name: true, employeeCode: true } },
  site: {
    select: {
      id: true,
      name: true,
      engineerAssignments: { select: { engineerId: true } },
    },
  },
  reviewedBy: { select: { id: true, name: true } },
} as const satisfies Prisma.StaffRequestInclude;

type RequestRow = Prisma.StaffRequestGetPayload<{ include: typeof INCLUDE }>;

const NONE: Prisma.StaffRequestWhereInput = { id: { in: [] } };

/** Admins: all. Engineers: requests from their sites. Staff: their own. */
function requestScope(user: Caller): Prisma.StaffRequestWhereInput {
  switch (user.role) {
    case 'ADMIN':
      return {};
    case 'ENGINEER':
      return {
        site: { engineerAssignments: { some: { engineerId: user.id } } },
      };
    case 'STAFF':
      return { staffId: user.id };
    default:
      return NONE;
  }
}

function reviewScope(user: Caller): Prisma.StaffRequestWhereInput {
  switch (user.role) {
    case 'ADMIN':
      return { status: 'PENDING' };
    case 'ENGINEER':
      return { status: 'PENDING', ...requestScope(user) };
    default:
      return NONE;
  }
}

/**
 * Money (an advance) and food asked for by a staff member for themselves. An
 * engineer on their site or an admin approves or rejects it; the staff member
 * may withdraw it while it waits.
 */
@Injectable()
export class StaffRequestsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly calendar: CalendarService,
    private readonly notifications: NotificationsService,
    private readonly audit: AuditService,
    private readonly clock: Clock,
  ) {}

  async create(
    user: Caller,
    dto: CreateStaffRequestDto,
    now = this.clock.now(),
  ): Promise<StaffRequestView> {
    const existing = await this.prisma.staffRequest.findUnique({
      where: { requestId: dto.requestId },
      select: { id: true, staffId: true },
    });
    if (existing) {
      if (existing.staffId !== user.id) throw formTaken();
      return this.get(user, existing.id);
    }
    const today = await this.calendar.today(now);
    const fields = checkFields(dto, today);
    const assignment = await this.prisma.staffAssignment.findUnique({
      where: { staffId: user.id },
      select: { site: { select: { id: true, name: true } } },
    });
    if (!assignment) {
      throw badRequest(
        ErrorCode.NOT_ASSIGNED_TO_SITE,
        'You are not assigned to a site yet. Please contact your engineer.',
      );
    }
    const { site } = assignment;
    if (fields.kind === 'FOOD') {
      const same = await this.prisma.staffRequest.findFirst({
        where: {
          staffId: user.id,
          kind: 'FOOD',
          forDate: toDbDate(fields.forDate),
          meal: fields.meal,
          status: { in: ['PENDING', 'APPROVED'] },
        },
        select: { number: true },
      });
      if (same) {
        throw conflict(
          ErrorCode.CONFLICT,
          `You already asked for ${MEAL_LABEL[fields.meal].toLowerCase()} on ${formatShortDate(fields.forDate)} (${staffRequestCode(same.number)}).`,
        );
      }
    }

    try {
      const created = await this.prisma.$transaction(async (tx) => {
        const row = await tx.staffRequest.create({
          data: {
            requestId: dto.requestId,
            kind: fields.kind,
            staffId: user.id,
            siteId: site.id,
            amount: fields.kind === 'MONEY' ? fromPaise(fields.amount) : null,
            forDate: fields.kind === 'FOOD' ? toDbDate(fields.forDate) : null,
            meal: fields.kind === 'FOOD' ? fields.meal : null,
            note: dto.note || null,
            createdAt: now,
          },
          select: { id: true, number: true },
        });
        const code = staffRequestCode(row.number);
        await this.audit.record(
          {
            actorId: user.id,
            action: 'staff_request.created',
            entityType: 'StaffRequest',
            entityId: row.id,
            changes: {
              kind: fields.kind,
              ...(fields.kind === 'MONEY'
                ? { amount: fromPaise(fields.amount) }
                : { forDate: fields.forDate, meal: fields.meal }),
              ...(dto.note && { note: dto.note }),
            },
          },
          tx,
        );
        const approvers = [
          ...(await siteEngineerIds(tx, site.id)),
          ...(await this.notifications.adminIds(tx)),
        ];
        await this.notifications.notify(
          [
            {
              recipientIds: approvers,
              type: 'STAFF_REQUEST',
              ...staffRequestCreated({
                code,
                name: user.name,
                summary: summaryOf(fields),
                siteName: site.name,
              }),
              referenceType: 'STAFF_REQUEST',
              referenceId: row.id,
              data: { staffRequestId: row.id, siteId: site.id },
              dedupeKey: `staff-request:${row.id}`,
            },
          ],
          tx,
        );
        return row;
      });
      return this.get(user, created.id);
    } catch (error) {
      if ((error as { code?: string }).code === 'P2002') {
        const again = await this.prisma.staffRequest.findUnique({
          where: { requestId: dto.requestId },
          select: { id: true, staffId: true },
        });
        if (again?.staffId === user.id) return this.get(user, again.id);
      }
      throw error;
    }
  }

  async list(
    user: Caller,
    query: StaffRequestQueryDto,
  ): Promise<Paginated<StaffRequestView>> {
    const term = query.search;
    const where: Prisma.StaffRequestWhereInput = {
      AND: [
        requestScope(user),
        query.mine ? { staffId: user.id } : {},
        query.toReview ? reviewScope(user) : {},
        query.status ? { status: query.status } : {},
        query.kind ? { kind: query.kind } : {},
        query.siteId ? { siteId: query.siteId } : {},
        query.staffId ? { staffId: query.staffId } : {},
        term
          ? {
              OR: [
                { staff: { name: contains(term) } },
                { note: contains(term) },
              ],
            }
          : {},
      ],
    };
    const [rows, total] = await Promise.all([
      this.prisma.staffRequest.findMany({
        where,
        include: INCLUDE,
        // Waiting first, newest first.
        orderBy: [{ status: 'asc' }, { createdAt: 'desc' }],
        skip: query.skip,
        take: query.limit,
      }),
      this.prisma.staffRequest.count({ where }),
    ]);
    return new Paginated(
      rows.map((row) => toView(row, user)),
      query.page,
      query.limit,
      total,
    );
  }

  async get(user: Caller, id: string): Promise<StaffRequestView> {
    return toView(await this.find(user, id), user);
  }

  /** Waiting requests the caller may decide, for dashboards and badges. */
  toReviewCount(user: Caller): Promise<number> {
    return this.prisma.staffRequest.count({ where: reviewScope(user) });
  }

  async approve(
    user: Caller,
    id: string,
    dto: ApproveDto,
    now = this.clock.now(),
  ): Promise<StaffRequestView> {
    return this.decide(user, id, 'APPROVED', dto.note || null, now);
  }

  async reject(
    user: Caller,
    id: string,
    reason: string,
    now = this.clock.now(),
  ): Promise<StaffRequestView> {
    return this.decide(user, id, 'REJECTED', reason, now);
  }

  /** Withdrawn by the staff member while it waits. */
  async cancel(user: Caller, id: string): Promise<StaffRequestView> {
    const row = await this.find(user, id);
    const code = staffRequestCode(row.number);
    if (row.status === 'CANCELLED' && row.staffId === user.id)
      return toView(row, user);
    if (!toView(row, user).canCancel) {
      if (row.staffId !== user.id)
        throw forbidden('Only the person who asked can withdraw this request.');
      throw alreadyDecided(code);
    }
    await this.prisma.$transaction(async (tx) => {
      const { count } = await tx.staffRequest.updateMany({
        where: { id, status: 'PENDING' },
        data: { status: 'CANCELLED' },
      });
      if (count === 0) throw alreadyDecided(code);
      await this.audit.record(
        {
          actorId: user.id,
          action: 'staff_request.cancelled',
          entityType: 'StaffRequest',
          entityId: id,
        },
        tx,
      );
    });
    return this.get(user, id);
  }

  private async decide(
    user: Caller,
    id: string,
    status: 'APPROVED' | 'REJECTED',
    note: string | null,
    now: Date,
  ): Promise<StaffRequestView> {
    const row = await this.find(user, id);
    const code = staffRequestCode(row.number);
    if (row.status !== 'PENDING') throw alreadyDecided(code);
    if (!toView(row, user).canApprove) {
      throw forbidden(
        'Only an engineer on their site or an admin can decide this request.',
      );
    }
    const approved = status === 'APPROVED';
    await this.prisma.$transaction(async (tx) => {
      const { count } = await tx.staffRequest.updateMany({
        where: { id, status: 'PENDING' },
        data: {
          status,
          reviewedById: user.id,
          reviewedAt: now,
          reviewNote: note,
        },
      });
      if (count === 0) throw alreadyDecided(code);
      await this.audit.record(
        {
          actorId: user.id,
          action: approved
            ? 'staff_request.approved'
            : 'staff_request.rejected',
          entityType: 'StaffRequest',
          entityId: id,
          changes: note ? { [approved ? 'note' : 'reason']: note } : {},
        },
        tx,
      );
      await this.notifications.notify(
        [
          {
            recipientIds: [row.staffId],
            type: 'STAFF_REQUEST',
            ...staffRequestDecided({
              code,
              summary: summaryOf(rowFields(row)),
              approved,
              byName: user.name,
              note,
            }),
            referenceType: 'STAFF_REQUEST',
            referenceId: id,
            data: { staffRequestId: id },
            dedupeKey: `staff-request-decided:${id}`,
          },
        ],
        tx,
      );
    });
    return this.get(user, id);
  }

  private async find(user: Caller, id: string): Promise<RequestRow> {
    const row = await this.prisma.staffRequest.findFirst({
      where: { id, ...requestScope(user) },
      include: INCLUDE,
    });
    if (!row) throw notFound('request');
    return row;
  }
}

type Fields =
  | { kind: 'MONEY'; amount: Paise }
  | { kind: 'FOOD'; forDate: string; meal: Meal };

/** Money needs an amount; food a day (today or soon) and a meal. */
function checkFields(dto: CreateStaffRequestDto, today: string): Fields {
  if (dto.kind === 'MONEY') {
    if (!dto.amount) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Enter how much you need.',
        'amount',
      );
    }
    const amount = toPaise(dto.amount);
    if (amount <= 0n) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Enter an amount above zero.',
        'amount',
      );
    }
    if (amount > BigInt(MAX_ADVANCE_RUPEES) * 100n) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        `Ask for at most ₹${MAX_ADVANCE_RUPEES.toLocaleString('en-IN')} at a time.`,
        'amount',
      );
    }
    return { kind: 'MONEY', amount };
  }
  if (!dto.forDate) {
    throw badRequest(ErrorCode.VALIDATION_FAILED, 'Choose the day.', 'forDate');
  }
  if (!dto.meal) {
    throw badRequest(ErrorCode.VALIDATION_FAILED, 'Choose a meal.', 'meal');
  }
  if (dto.forDate < today || dto.forDate > addDays(today, FOOD_AHEAD_DAYS)) {
    throw badRequest(
      ErrorCode.VALIDATION_FAILED,
      `Choose today or a day in the next ${FOOD_AHEAD_DAYS} days.`,
      'forDate',
    );
  }
  return { kind: 'FOOD', forDate: dto.forDate, meal: dto.meal };
}

function rowFields(row: RequestRow): Fields {
  return row.kind === 'MONEY'
    ? { kind: 'MONEY', amount: toPaise(row.amount!) }
    : { kind: 'FOOD', forDate: fromDbDate(row.forDate!), meal: row.meal! };
}

function summaryOf(fields: Fields): string {
  return fields.kind === 'MONEY'
    ? staffRequestSummary({
        kind: 'MONEY',
        amount: fields.amount,
        forDate: null,
        meal: null,
      })
    : staffRequestSummary({
        kind: 'FOOD',
        amount: null,
        forDate: fields.forDate,
        meal: fields.meal,
      });
}

/** Admins and engineers on the site decide; the staff member may withdraw while it waits. */
function toView(row: RequestRow, user: Caller): StaffRequestView {
  const pending = row.status === 'PENDING';
  const engineerOnSite =
    user.role === 'ENGINEER' &&
    row.site.engineerAssignments.some((a) => a.engineerId === user.id);
  return {
    id: row.id,
    code: staffRequestCode(row.number),
    kind: row.kind,
    staff: row.staff,
    site: { id: row.site.id, name: row.site.name },
    amount: row.amount === null ? null : fromPaise(toPaise(row.amount)),
    forDate: row.forDate && fromDbDate(row.forDate),
    meal: row.meal,
    note: row.note,
    status: row.status,
    reviewedBy: row.reviewedBy,
    reviewedAt: row.reviewedAt?.toISOString() ?? null,
    reviewNote: row.reviewNote,
    createdAt: row.createdAt.toISOString(),
    canApprove: pending && (user.role === 'ADMIN' || engineerOnSite),
    canCancel: pending && row.staffId === user.id,
  };
}
