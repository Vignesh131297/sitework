import { Injectable } from '@nestjs/common';
import { AuditService } from '../common/audit/audit.service.js';
import { ErrorCode } from '../common/errors/error-codes.js';
import {
  badRequest,
  conflict,
  notFound,
} from '../common/errors/http-errors.js';
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
  LeaveType,
  Role,
} from '../generated/prisma/enums.js';
import {
  leaveDecided,
  leaveRequested,
} from '../notifications/notification-messages.js';
import { NotificationsService } from '../notifications/notifications.service.js';
import { PrismaService } from '../prisma/prisma.service.js';
import { CalendarService } from '../settings/calendar.service.js';
import {
  alreadyDecided,
  forbidden,
  formTaken,
  leaveCode,
  siteEngineerIds,
  type Caller,
  type Person,
} from './request-common.js';
import type {
  ApproveDto,
  CreateLeaveRequestDto,
  LeaveQueryDto,
} from './requests.dto.js';

/** Leave may be entered this many days after it started (e.g. sick leave). */
export const LEAVE_BACKDATE_DAYS = 30;
/** And at most this far ahead. */
export const LEAVE_AHEAD_DAYS = 365;
/** Longest single request, in calendar days. */
export const LEAVE_MAX_DAYS = 60;

export interface LeaveRequestView {
  id: string;
  /** "LV-0007" */
  code: string;
  user: { id: string; name: string; role: Role; employeeCode: string };
  /** Staff: their site when they asked. Engineers: null. */
  site: { id: string; name: string } | null;
  type: LeaveType;
  fromDate: string;
  toDate: string;
  /** Calendar days, both ends included. */
  days: number;
  reason: string;
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
  user: { select: { id: true, name: true, role: true, employeeCode: true } },
  site: {
    select: {
      id: true,
      name: true,
      engineerAssignments: { select: { engineerId: true } },
    },
  },
  reviewedBy: { select: { id: true, name: true } },
} as const satisfies Prisma.LeaveRequestInclude;

type LeaveRow = Prisma.LeaveRequestGetPayload<{ include: typeof INCLUDE }>;

/** Matches nothing. */
const NONE: Prisma.LeaveRequestWhereInput = { id: { in: [] } };

/**
 * Admins: all leave. Engineers: their own, and leave of staff on their sites.
 * Staff: their own.
 */
function leaveScope(user: Caller): Prisma.LeaveRequestWhereInput {
  switch (user.role) {
    case 'ADMIN':
      return {};
    case 'ENGINEER':
      return {
        OR: [
          { userId: user.id },
          {
            user: { role: 'STAFF' },
            site: { engineerAssignments: { some: { engineerId: user.id } } },
          },
        ],
      };
    default:
      return { userId: user.id };
  }
}

/** Waiting leave the caller may decide (never their own). */
function reviewScope(user: Caller): Prisma.LeaveRequestWhereInput {
  switch (user.role) {
    case 'ADMIN':
      return { status: 'PENDING', userId: { not: user.id } };
    case 'ENGINEER':
      return {
        status: 'PENDING',
        user: { role: 'STAFF' },
        site: { engineerAssignments: { some: { engineerId: user.id } } },
      };
    default:
      return NONE;
  }
}

/**
 * Leave: staff ask and an engineer on their site (or an admin) decides;
 * engineers ask and an admin decides. Approved staff leave is written into
 * attendance as ON_LEAVE (days up to today now, later days by the end-of-day
 * job) and those days expect no photo updates.
 */
@Injectable()
export class LeaveRequestsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly calendar: CalendarService,
    private readonly notifications: NotificationsService,
    private readonly audit: AuditService,
    private readonly clock: Clock,
  ) {}

  async create(
    user: Caller,
    dto: CreateLeaveRequestDto,
    now = this.clock.now(),
  ): Promise<LeaveRequestView> {
    const existing = await this.prisma.leaveRequest.findUnique({
      where: { requestId: dto.requestId },
      select: { id: true, userId: true },
    });
    if (existing) {
      if (existing.userId !== user.id) throw formTaken();
      return this.get(user, existing.id, now);
    }
    const today = await this.calendar.today(now);
    checkDates(dto.fromDate, dto.toDate, today);

    let site: { id: string; name: string } | null = null;
    if (user.role === 'STAFF') {
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
      site = assignment.site;
    }
    const overlap = await this.prisma.leaveRequest.findFirst({
      where: {
        userId: user.id,
        status: { in: ['PENDING', 'APPROVED'] },
        fromDate: { lte: toDbDate(dto.toDate) },
        toDate: { gte: toDbDate(dto.fromDate) },
      },
      select: { number: true, fromDate: true, toDate: true },
    });
    if (overlap) {
      throw conflict(
        ErrorCode.LEAVE_OVERLAPS,
        `You already asked for leave ${range(fromDbDate(overlap.fromDate), fromDbDate(overlap.toDate))} (${leaveCode(overlap.number)}).`,
      );
    }

    try {
      const created = await this.prisma.$transaction(async (tx) => {
        const row = await tx.leaveRequest.create({
          data: {
            requestId: dto.requestId,
            userId: user.id,
            siteId: site?.id ?? null,
            type: dto.type,
            fromDate: toDbDate(dto.fromDate),
            toDate: toDbDate(dto.toDate),
            reason: dto.reason,
            createdAt: now,
          },
          select: { id: true, number: true },
        });
        const code = leaveCode(row.number);
        await this.audit.record(
          {
            actorId: user.id,
            action: 'leave_request.created',
            entityType: 'LeaveRequest',
            entityId: row.id,
            changes: {
              type: dto.type,
              fromDate: dto.fromDate,
              toDate: dto.toDate,
              reason: dto.reason,
            },
          },
          tx,
        );
        // Staff leave: the site's engineers and admins. Engineer leave: admins.
        const approvers = [
          ...(site ? await siteEngineerIds(tx, site.id) : []),
          ...(await this.notifications.adminIds(tx)),
        ].filter((id) => id !== user.id);
        await this.notifications.notify(
          [
            {
              recipientIds: approvers,
              type: 'LEAVE',
              ...leaveRequested({
                code,
                name: user.name,
                type: dto.type,
                from: dto.fromDate,
                to: dto.toDate,
                siteName: site?.name ?? null,
              }),
              referenceType: 'LEAVE_REQUEST',
              referenceId: row.id,
              data: {
                leaveRequestId: row.id,
                ...(site && { siteId: site.id }),
              },
              dedupeKey: `leave:${row.id}`,
            },
          ],
          tx,
        );
        return row;
      });
      return this.get(user, created.id, now);
    } catch (error) {
      if ((error as { code?: string }).code === 'P2002') {
        const again = await this.prisma.leaveRequest.findUnique({
          where: { requestId: dto.requestId },
          select: { id: true, userId: true },
        });
        if (again?.userId === user.id) return this.get(user, again.id, now);
      }
      throw error;
    }
  }

  async list(
    user: Caller,
    query: LeaveQueryDto,
    now = this.clock.now(),
  ): Promise<Paginated<LeaveRequestView>> {
    const today = await this.calendar.today(now);
    const term = query.search;
    const where: Prisma.LeaveRequestWhereInput = {
      AND: [
        leaveScope(user),
        query.mine ? { userId: user.id } : {},
        query.toReview ? reviewScope(user) : {},
        query.status ? { status: query.status } : {},
        query.siteId ? { siteId: query.siteId } : {},
        query.userId ? { userId: query.userId } : {},
        term
          ? {
              OR: [
                { user: { name: contains(term) } },
                { reason: contains(term) },
              ],
            }
          : {},
      ],
    };
    const [rows, total] = await Promise.all([
      this.prisma.leaveRequest.findMany({
        where,
        include: INCLUDE,
        // Waiting first, then the latest leave first.
        orderBy: [
          { status: 'asc' },
          { fromDate: 'desc' },
          { createdAt: 'desc' },
        ],
        skip: query.skip,
        take: query.limit,
      }),
      this.prisma.leaveRequest.count({ where }),
    ]);
    return new Paginated(
      rows.map((row) => toView(row, user, today)),
      query.page,
      query.limit,
      total,
    );
  }

  async get(
    user: Caller,
    id: string,
    now = this.clock.now(),
  ): Promise<LeaveRequestView> {
    const row = await this.find(user, id);
    return toView(row, user, await this.calendar.today(now));
  }

  /** Waiting leave the caller may decide, for dashboards and badges. */
  toReviewCount(user: Caller): Promise<number> {
    return this.prisma.leaveRequest.count({ where: reviewScope(user) });
  }

  async approve(
    user: Caller,
    id: string,
    dto: ApproveDto,
    now = this.clock.now(),
  ): Promise<LeaveRequestView> {
    const today = await this.calendar.today(now);
    const row = await this.findDecidable(user, id, today);
    const code = leaveCode(row.number);
    const note = dto.note || null;
    await this.prisma.$transaction(async (tx) => {
      const { count } = await tx.leaveRequest.updateMany({
        where: { id, status: 'PENDING' },
        data: {
          status: 'APPROVED',
          reviewedById: user.id,
          reviewedAt: now,
          reviewNote: note,
        },
      });
      if (count === 0) throw alreadyDecided(code);
      const marked =
        row.user.role === 'STAFF' && row.siteId
          ? await this.markLeaveDays(tx, user, row, row.siteId, today)
          : 0;
      await this.audit.record(
        {
          actorId: user.id,
          action: 'leave_request.approved',
          entityType: 'LeaveRequest',
          entityId: id,
          changes: { ...(note && { note }), attendanceDaysMarked: marked },
        },
        tx,
      );
      await this.notifyRequester(tx, row, code, true, user, note, now);
    });
    return this.get(user, id, now);
  }

  async reject(
    user: Caller,
    id: string,
    reason: string,
    now = this.clock.now(),
  ): Promise<LeaveRequestView> {
    const today = await this.calendar.today(now);
    const row = await this.findDecidable(user, id, today);
    const code = leaveCode(row.number);
    await this.prisma.$transaction(async (tx) => {
      const { count } = await tx.leaveRequest.updateMany({
        where: { id, status: 'PENDING' },
        data: {
          status: 'REJECTED',
          reviewedById: user.id,
          reviewedAt: now,
          reviewNote: reason,
        },
      });
      if (count === 0) throw alreadyDecided(code);
      await this.audit.record(
        {
          actorId: user.id,
          action: 'leave_request.rejected',
          entityType: 'LeaveRequest',
          entityId: id,
          changes: { reason },
        },
        tx,
      );
      await this.notifyRequester(tx, row, code, false, user, reason, now);
    });
    return this.get(user, id, now);
  }

  /**
   * Withdrawn by the person who asked: while waiting, or once approved if it
   * hasn't started yet (so attendance holds nothing for it).
   */
  async cancel(
    user: Caller,
    id: string,
    now = this.clock.now(),
  ): Promise<LeaveRequestView> {
    const today = await this.calendar.today(now);
    const row = await this.find(user, id);
    const code = leaveCode(row.number);
    if (row.status === 'CANCELLED' && row.userId === user.id)
      return this.get(user, id, now);
    if (!toView(row, user, today).canCancel) {
      if (row.userId !== user.id)
        throw forbidden('Only the person who asked can withdraw this leave.');
      if (row.status === 'APPROVED') {
        throw conflict(
          ErrorCode.REQUEST_ALREADY_DECIDED,
          'This leave has already started. Ask an admin to change attendance instead.',
        );
      }
      throw alreadyDecided(code);
    }
    await this.prisma.$transaction(async (tx) => {
      const { count } = await tx.leaveRequest.updateMany({
        where: {
          id,
          OR: [
            { status: 'PENDING' },
            { status: 'APPROVED', fromDate: { gt: toDbDate(today) } },
          ],
        },
        data: { status: 'CANCELLED' },
      });
      if (count === 0) throw alreadyDecided(code);
      await this.audit.record(
        {
          actorId: user.id,
          action: 'leave_request.cancelled',
          entityType: 'LeaveRequest',
          entityId: id,
          changes: { before: row.status },
        },
        tx,
      );
    });
    return this.get(user, id, now);
  }

  /**
   * Working days of the leave up to today: a day with no check-in becomes
   * ON_LEAVE (created, or turned from ABSENT); days they worked stay as they
   * are. Missed-update alerts for those days are cleared. Later days are
   * marked by the end-of-day job (AttendanceService.markAbsentees).
   */
  private async markLeaveDays(
    tx: Prisma.TransactionClient,
    approver: Caller,
    row: LeaveRow,
    siteId: string,
    today: string,
  ): Promise<number> {
    const from = fromDbDate(row.fromDate);
    const to = fromDbDate(row.toDate);
    const last = to < today ? to : today;
    const note = `Approved leave ${leaveCode(row.number)}`;
    let marked = 0;
    for (let date = from; date <= last; date = addDays(date, 1)) {
      if (!(await this.calendar.isWorkingDay(date))) continue;
      const workDate = toDbDate(date);
      const existing = await tx.attendance.findUnique({
        where: { staffId_workDate: { staffId: row.userId, workDate } },
        select: { id: true, status: true, checkInAt: true },
      });
      if (existing) {
        if (existing.checkInAt || existing.status !== 'ABSENT') continue;
        await tx.attendance.update({
          where: { id: existing.id },
          data: {
            status: 'ON_LEAVE',
            correctedById: approver.id,
            correctionNote: note,
          },
        });
      } else {
        await tx.attendance.create({
          data: {
            staffId: row.userId,
            siteId,
            workDate,
            status: 'ON_LEAVE',
            correctedById: approver.id,
            correctionNote: note,
          },
        });
      }
      marked += 1;
    }
    if (from <= last) {
      await tx.missedUpdate.deleteMany({
        where: {
          staffId: row.userId,
          resolvedAt: null,
          workDate: { gte: toDbDate(from), lte: toDbDate(last) },
        },
      });
    }
    return marked;
  }

  private async notifyRequester(
    tx: Prisma.TransactionClient,
    row: LeaveRow,
    code: string,
    approved: boolean,
    by: Caller,
    note: string | null,
    now: Date,
  ): Promise<void> {
    await this.notifications.notify(
      [
        {
          recipientIds: [row.userId],
          type: 'LEAVE',
          ...leaveDecided({
            code,
            approved,
            from: fromDbDate(row.fromDate),
            to: fromDbDate(row.toDate),
            byName: by.name,
            note,
          }),
          referenceType: 'LEAVE_REQUEST',
          referenceId: row.id,
          data: { leaveRequestId: row.id },
          dedupeKey: `leave-decided:${row.id}:${now.getTime()}`,
        },
      ],
      tx,
    );
  }

  private async find(user: Caller, id: string): Promise<LeaveRow> {
    const row = await this.prisma.leaveRequest.findFirst({
      where: { id, ...leaveScope(user) },
      include: INCLUDE,
    });
    if (!row) throw notFound('leave request');
    return row;
  }

  /** A waiting request the caller may approve or reject. */
  private async findDecidable(
    user: Caller,
    id: string,
    today: string,
  ): Promise<LeaveRow> {
    const row = await this.find(user, id);
    if (row.status !== 'PENDING') throw alreadyDecided(leaveCode(row.number));
    if (!toView(row, user, today).canApprove) {
      if (row.userId === user.id)
        throw forbidden("You can't decide your own leave.");
      throw forbidden(
        row.user.role === 'STAFF'
          ? 'Only an engineer on their site or an admin can decide this leave.'
          : "Only an admin can decide an engineer's leave.",
      );
    }
    return row;
  }
}

function checkDates(from: string, to: string, today: string): void {
  if (to < from) {
    throw badRequest(
      ErrorCode.VALIDATION_FAILED,
      'The last day must be on or after the first day.',
      'toDate',
    );
  }
  if (from < addDays(today, -LEAVE_BACKDATE_DAYS)) {
    throw badRequest(
      ErrorCode.VALIDATION_FAILED,
      `Leave can be entered up to ${LEAVE_BACKDATE_DAYS} days after it started.`,
      'fromDate',
    );
  }
  if (to > addDays(today, LEAVE_AHEAD_DAYS)) {
    throw badRequest(
      ErrorCode.VALIDATION_FAILED,
      'Choose dates within the next year.',
      'toDate',
    );
  }
  if (dayCount(from, to) > LEAVE_MAX_DAYS) {
    throw badRequest(
      ErrorCode.VALIDATION_FAILED,
      `Ask for at most ${LEAVE_MAX_DAYS} days at a time.`,
      'toDate',
    );
  }
}

function dayCount(from: string, to: string): number {
  return Math.round((Date.parse(to) - Date.parse(from)) / 86_400_000) + 1;
}

function range(from: string, to: string): string {
  return from === to
    ? `on ${formatShortDate(from)}`
    : `from ${formatShortDate(from)} to ${formatShortDate(to)}`;
}

/**
 * Admins decide anyone's leave but their own; engineers decide leave of staff
 * on their sites. Whoever asked may withdraw it while it waits, or after
 * approval until it starts.
 */
function toView(row: LeaveRow, user: Caller, today: string): LeaveRequestView {
  const from = fromDbDate(row.fromDate);
  const pending = row.status === 'PENDING';
  const own = row.userId === user.id;
  const engineerOnSite =
    user.role === 'ENGINEER' &&
    row.user.role === 'STAFF' &&
    (row.site?.engineerAssignments.some((a) => a.engineerId === user.id) ??
      false);
  return {
    id: row.id,
    code: leaveCode(row.number),
    user: row.user,
    site: row.site && { id: row.site.id, name: row.site.name },
    type: row.type,
    fromDate: from,
    toDate: fromDbDate(row.toDate),
    days: dayCount(from, fromDbDate(row.toDate)),
    reason: row.reason,
    status: row.status,
    reviewedBy: row.reviewedBy,
    reviewedAt: row.reviewedAt?.toISOString() ?? null,
    reviewNote: row.reviewNote,
    createdAt: row.createdAt.toISOString(),
    canApprove: pending && !own && (user.role === 'ADMIN' || engineerOnSite),
    canCancel: own && (pending || (row.status === 'APPROVED' && from > today)),
  };
}
