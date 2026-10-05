import { Injectable } from '@nestjs/common';
import type { AuthUser } from '../auth/auth-user.js';
import { siteScope, staffScope } from '../common/access/access-scope.js';
import { ErrorCode } from '../common/errors/error-codes.js';
import { badRequest } from '../common/errors/http-errors.js';
import { fromPaise, sumPaise, toPaise } from '../common/money/money.js';
import {
  addDays,
  toDbDate,
  zonedInstant,
} from '../common/time/business-time.js';
import { Clock } from '../common/time/clock.js';
import type { Prisma } from '../generated/prisma/client.js';
import type {
  AttendanceStatus,
  Designation,
  PaymentMethod,
  SiteStatus,
} from '../generated/prisma/enums.js';
import { siteFinancials } from '../payments/site-financials.js';
import { PrismaService } from '../prisma/prisma.service.js';
import { CalendarService } from '../settings/calendar.service.js';
import { SettingsService } from '../settings/settings.service.js';

export interface ReportRange {
  from: string;
  to: string;
  siteId?: string;
  clientId?: string;
}

export interface UpdateCounts {
  submitted: number;
  missed: number;
  offline: number;
  /** Sent away from the site, without a location, or from a mock location. */
  locationFlagged: number;
  /** Submitted of (submitted + missed); null when nothing was due. */
  compliancePercent: number | null;
}

export type AttendanceCounts = Record<
  'present' | 'late' | 'halfDay' | 'absent',
  number
>;

export interface SiteReportRow {
  site: { id: string; code: string; name: string; status: SiteStatus };
  client: { id: string; name: string };
  updates: UpdateCounts;
  attendance: AttendanceCounts;
  engineerUpdates: number;
  issues: { opened: number; resolved: number; openNow: number };
  /** Admins only; null for engineers. */
  received: string | null;
}

export interface StaffReportRow {
  staff: {
    id: string;
    name: string;
    employeeCode: string;
    designation: Designation | null;
    isActive: boolean;
  };
  site: { id: string; name: string } | null;
  attendance: AttendanceCounts;
  updates: UpdateCounts;
}

export interface EngineerReportRow {
  engineer: {
    id: string;
    name: string;
    employeeCode: string;
    isActive: boolean;
  };
  sites: number;
  engineerUpdates: number;
  issues: { reported: number; resolved: number };
  reviews: {
    photos: number;
    reviewed: number;
    reviewRatePercent: number | null;
    averageMinutes: number | null;
  };
}

export interface PaymentReport {
  totals: {
    received: string;
    count: number;
    byMethod: Partial<Record<PaymentMethod, string>>;
  };
  sites: {
    site: { id: string; code: string; name: string };
    client: { id: string; name: string };
    receivedInRange: string;
    contract: string;
    receivedToDate: string;
    pending: string;
    overdue: string;
  }[];
  payments: {
    id: string;
    paidOn: string;
    amount: string;
    method: PaymentMethod;
    reference: string | null;
    site: { id: string; name: string };
    client: { id: string; name: string };
  }[];
}

const MAX_DAYS = 366;

/**
 * Figures over a date range (business dates, inclusive). Engineers see only
 * their sites and staff, and no money; payment and engineer reports are for admins.
 */
@Injectable()
export class ReportsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly settings: SettingsService,
    private readonly calendar: CalendarService,
    private readonly clock: Clock,
  ) {}

  async sites(user: AuthUser, range: ReportRange): Promise<SiteReportRow[]> {
    checkRange(range);
    const sites = await this.prisma.site.findMany({
      where: {
        AND: [
          siteScope(user),
          range.siteId ? { id: range.siteId } : {},
          range.clientId ? { clientId: range.clientId } : {},
        ],
      },
      select: {
        id: true,
        code: true,
        name: true,
        status: true,
        client: { select: { id: true, name: true } },
      },
      orderBy: { name: 'asc' },
    });
    const siteIds = sites.map((s) => s.id);
    const days = { gte: toDbDate(range.from), lte: toDbDate(range.to) };
    const instants = await this.instants(range);
    const bySite = { siteId: { in: siteIds } };
    const [
      submitted,
      offline,
      flagged,
      missed,
      attendance,
      engineerUpdates,
      opened,
      resolved,
      openNow,
      received,
    ] = await Promise.all([
      this.prisma.staffUpdate.groupBy({
        by: ['siteId'],
        where: { ...bySite, workDate: days },
        _count: { _all: true },
      }),
      this.prisma.staffUpdate.groupBy({
        by: ['siteId'],
        where: { ...bySite, workDate: days, submittedOffline: true },
        _count: { _all: true },
      }),
      this.prisma.staffUpdate.groupBy({
        by: ['siteId'],
        where: { ...bySite, workDate: days, locationFlag: { not: 'OK' } },
        _count: { _all: true },
      }),
      this.prisma.missedUpdate.groupBy({
        by: ['siteId'],
        where: { ...bySite, workDate: days, resolvedAt: null },
        _count: { _all: true },
      }),
      this.prisma.attendance.groupBy({
        by: ['siteId', 'status'],
        where: { ...bySite, workDate: days },
        _count: { _all: true },
      }),
      this.prisma.engineerUpdate.groupBy({
        by: ['siteId'],
        where: { ...bySite, createdAt: instants },
        _count: { _all: true },
      }),
      this.prisma.issue.groupBy({
        by: ['siteId'],
        where: { ...bySite, createdAt: instants },
        _count: { _all: true },
      }),
      this.prisma.issue.groupBy({
        by: ['siteId'],
        where: { ...bySite, resolvedAt: instants },
        _count: { _all: true },
      }),
      this.prisma.issue.groupBy({
        by: ['siteId'],
        where: { ...bySite, status: { not: 'RESOLVED' } },
        _count: { _all: true },
      }),
      user.role === 'ADMIN'
        ? this.prisma.payment.groupBy({
            by: ['siteId'],
            where: { ...bySite, paidOn: days, voidedAt: null },
            _sum: { amount: true },
          })
        : Promise.resolve([]),
    ]);
    const count = (rows: { siteId: string; _count: { _all: number } }[]) =>
      new Map(rows.map((r) => [r.siteId, r._count._all]));
    const [
      submittedBy,
      offlineBy,
      flaggedBy,
      missedBy,
      engineerBy,
      openedBy,
      resolvedBy,
      openNowBy,
    ] = [
      submitted,
      offline,
      flagged,
      missed,
      engineerUpdates,
      opened,
      resolved,
      openNow,
    ].map(count);
    const receivedBy = new Map(received.map((r) => [r.siteId, r._sum.amount]));
    return sites.map((site) => ({
      site: {
        id: site.id,
        code: site.code,
        name: site.name,
        status: site.status,
      },
      client: site.client,
      updates: updateCounts(
        submittedBy.get(site.id) ?? 0,
        missedBy.get(site.id) ?? 0,
        offlineBy.get(site.id) ?? 0,
        flaggedBy.get(site.id) ?? 0,
      ),
      attendance: attendanceCounts(
        attendance.filter((a) => a.siteId === site.id),
      ),
      engineerUpdates: engineerBy.get(site.id) ?? 0,
      issues: {
        opened: openedBy.get(site.id) ?? 0,
        resolved: resolvedBy.get(site.id) ?? 0,
        openNow: openNowBy.get(site.id) ?? 0,
      },
      received:
        user.role === 'ADMIN'
          ? fromPaise(toPaise(receivedBy.get(site.id) ?? '0'))
          : null,
    }));
  }

  async staff(user: AuthUser, range: ReportRange): Promise<StaffReportRow[]> {
    checkRange(range);
    const days = { gte: toDbDate(range.from), lte: toDbDate(range.to) };
    const atSite = range.siteId ? { siteId: range.siteId } : {};
    // Everyone in scope who worked in the range or is assigned now.
    const people = await this.prisma.user.findMany({
      where: {
        AND: [
          staffScope(user),
          {
            OR: [
              {
                staffAssignment: range.siteId
                  ? { siteId: range.siteId }
                  : { isNot: null },
              },
              { attendance: { some: { workDate: days, ...atSite } } },
              { staffUpdates: { some: { workDate: days, ...atSite } } },
            ],
          },
        ],
      },
      select: {
        id: true,
        name: true,
        employeeCode: true,
        designation: true,
        isActive: true,
        staffAssignment: {
          select: { site: { select: { id: true, name: true } } },
        },
      },
      orderBy: { name: 'asc' },
    });
    const ids = { staffId: { in: people.map((p) => p.id) }, ...atSite };
    const [submitted, offline, flagged, missed, attendance] = await Promise.all(
      [
        this.prisma.staffUpdate.groupBy({
          by: ['staffId'],
          where: { ...ids, workDate: days },
          _count: { _all: true },
        }),
        this.prisma.staffUpdate.groupBy({
          by: ['staffId'],
          where: { ...ids, workDate: days, submittedOffline: true },
          _count: { _all: true },
        }),
        this.prisma.staffUpdate.groupBy({
          by: ['staffId'],
          where: { ...ids, workDate: days, locationFlag: { not: 'OK' } },
          _count: { _all: true },
        }),
        this.prisma.missedUpdate.groupBy({
          by: ['staffId'],
          where: { ...ids, workDate: days, resolvedAt: null },
          _count: { _all: true },
        }),
        this.prisma.attendance.groupBy({
          by: ['staffId', 'status'],
          where: { ...ids, workDate: days },
          _count: { _all: true },
        }),
      ],
    );
    const count = (rows: { staffId: string; _count: { _all: number } }[]) =>
      new Map(rows.map((r) => [r.staffId, r._count._all]));
    const [submittedBy, offlineBy, flaggedBy, missedBy] = [
      submitted,
      offline,
      flagged,
      missed,
    ].map(count);
    return people.map((p) => ({
      staff: {
        id: p.id,
        name: p.name,
        employeeCode: p.employeeCode,
        designation: p.designation,
        isActive: p.isActive,
      },
      site: p.staffAssignment?.site ?? null,
      attendance: attendanceCounts(
        attendance.filter((a) => a.staffId === p.id),
      ),
      updates: updateCounts(
        submittedBy.get(p.id) ?? 0,
        missedBy.get(p.id) ?? 0,
        offlineBy.get(p.id) ?? 0,
        flaggedBy.get(p.id) ?? 0,
      ),
    }));
  }

  async engineers(range: ReportRange): Promise<EngineerReportRow[]> {
    checkRange(range);
    const days = { gte: toDbDate(range.from), lte: toDbDate(range.to) };
    const instants = await this.instants(range);
    const engineers = await this.prisma.user.findMany({
      where: { role: 'ENGINEER' },
      select: {
        id: true,
        name: true,
        employeeCode: true,
        isActive: true,
        _count: { select: { engineerAssignments: true } },
      },
      orderBy: { name: 'asc' },
    });
    const [updates, reported, resolved, photos] = await Promise.all([
      this.prisma.engineerUpdate.groupBy({
        by: ['engineerId'],
        where: { createdAt: instants },
        _count: { _all: true },
      }),
      this.prisma.issue.groupBy({
        by: ['reportedById'],
        where: { createdAt: instants },
        _count: { _all: true },
      }),
      this.prisma.issue.groupBy({
        by: ['resolvedById'],
        where: { resolvedAt: instants },
        _count: { _all: true },
      }),
      // Aggregated in the database: a year of photos is tens of thousands of rows.
      this.prisma.$queryRaw<
        {
          engineerId: string;
          photos: number;
          reviewed: number;
          averageMinutes: number | null;
        }[]
      >`
        SELECT engineer_id AS "engineerId",
               count(*)::int AS photos,
               count(engineer_viewed_at)::int AS reviewed,
               round(avg(extract(epoch FROM engineer_viewed_at - submitted_at) / 60))::int
                 AS "averageMinutes"
        FROM staff_updates
        WHERE work_date BETWEEN ${days.gte} AND ${days.lte}
        GROUP BY engineer_id`,
    ]);
    const updatesBy = new Map(
      updates.map((r) => [r.engineerId, r._count._all]),
    );
    const reportedBy = new Map(
      reported.map((r) => [r.reportedById, r._count._all]),
    );
    const resolvedBy = new Map(
      resolved.map((r) => [r.resolvedById, r._count._all]),
    );
    const photosBy = new Map(photos.map((p) => [p.engineerId, p]));
    return engineers.map((e) => {
      const theirs = photosBy.get(e.id);
      const total = theirs?.photos ?? 0;
      const reviewed = theirs?.reviewed ?? 0;
      return {
        engineer: {
          id: e.id,
          name: e.name,
          employeeCode: e.employeeCode,
          isActive: e.isActive,
        },
        sites: e._count.engineerAssignments,
        engineerUpdates: updatesBy.get(e.id) ?? 0,
        issues: {
          reported: reportedBy.get(e.id) ?? 0,
          resolved: resolvedBy.get(e.id) ?? 0,
        },
        reviews: {
          photos: total,
          reviewed,
          reviewRatePercent: total
            ? Math.round((reviewed / total) * 100)
            : null,
          averageMinutes: theirs?.averageMinutes ?? null,
        },
      };
    });
  }

  async payments(
    range: ReportRange,
    now = this.clock.now(),
  ): Promise<PaymentReport> {
    checkRange(range);
    const days = { gte: toDbDate(range.from), lte: toDbDate(range.to) };
    const siteWhere: Prisma.SiteWhereInput = {
      ...(range.siteId && { id: range.siteId }),
      ...(range.clientId && { clientId: range.clientId }),
    };
    const [payments, sites] = await Promise.all([
      this.prisma.payment.findMany({
        where: { paidOn: days, voidedAt: null, site: siteWhere },
        select: {
          id: true,
          paidOn: true,
          amount: true,
          method: true,
          reference: true,
          siteId: true,
          site: {
            select: {
              id: true,
              name: true,
              client: { select: { id: true, name: true } },
            },
          },
        },
        orderBy: [{ paidOn: 'asc' }, { createdAt: 'asc' }],
      }),
      this.prisma.site.findMany({
        where: siteWhere,
        select: {
          id: true,
          code: true,
          name: true,
          contractAmount: true,
          client: { select: { id: true, name: true } },
          payments: { select: { amount: true, voidedAt: true } },
          paymentMilestones: {
            select: { id: true, title: true, amount: true, dueDate: true },
          },
        },
        orderBy: { name: 'asc' },
      }),
    ]);
    // Outstanding and overdue as of the report's end (or today, if earlier).
    const today = await this.calendar.today(now);
    const asOf = range.to < today ? range.to : today;
    const byMethod: Partial<Record<PaymentMethod, bigint>> = {};
    for (const p of payments)
      byMethod[p.method] = (byMethod[p.method] ?? 0n) + toPaise(p.amount);
    return {
      totals: {
        received: fromPaise(sumPaise(payments.map((p) => toPaise(p.amount)))),
        count: payments.length,
        byMethod: Object.fromEntries(
          Object.entries(byMethod).map(([method, paise]) => [
            method,
            fromPaise(paise),
          ]),
        ),
      },
      sites: sites.map((site) => {
        const money = siteFinancials(
          {
            contractAmount: site.contractAmount,
            payments: site.payments,
            milestones: site.paymentMilestones,
          },
          asOf,
        );
        return {
          site: { id: site.id, code: site.code, name: site.name },
          client: site.client,
          receivedInRange: fromPaise(
            sumPaise(
              payments
                .filter((p) => p.siteId === site.id)
                .map((p) => toPaise(p.amount)),
            ),
          ),
          contract: money.contract,
          receivedToDate: money.received,
          pending: money.pending,
          overdue: money.overdue,
        };
      }),
      payments: payments.map((p) => ({
        id: p.id,
        paidOn: p.paidOn.toISOString().slice(0, 10),
        amount: p.amount.toFixed(2),
        method: p.method,
        reference: p.reference,
        site: { id: p.site.id, name: p.site.name },
        client: p.site.client,
      })),
    };
  }

  /** The range as instants in the business time zone: from 00:00 to the end of `to`. */
  private async instants(range: ReportRange): Promise<{ gte: Date; lt: Date }> {
    const { timeZone } = (await this.settings.getAll()).business;
    return {
      gte: zonedInstant(range.from, '00:00', timeZone),
      lt: zonedInstant(addDays(range.to, 1), '00:00', timeZone),
    };
  }
}

function checkRange(range: ReportRange): void {
  if (range.from > range.to) {
    throw badRequest(
      ErrorCode.VALIDATION_FAILED,
      'The start date must be on or before the end date.',
      'from',
    );
  }
  if (addDays(range.from, MAX_DAYS) < range.to) {
    throw badRequest(
      ErrorCode.VALIDATION_FAILED,
      `Choose at most ${MAX_DAYS} days.`,
      'to',
    );
  }
}

function updateCounts(
  submitted: number,
  missed: number,
  offline: number,
  locationFlagged: number,
): UpdateCounts {
  const due = submitted + missed;
  return {
    submitted,
    missed,
    offline,
    locationFlagged,
    compliancePercent: due ? Math.round((submitted / due) * 100) : null,
  };
}

function attendanceCounts(
  rows: { status: AttendanceStatus; _count: { _all: number } }[],
): AttendanceCounts {
  const of = (status: AttendanceStatus) =>
    rows
      .filter((r) => r.status === status)
      .reduce((n, r) => n + r._count._all, 0);
  return {
    present: of('PRESENT'),
    late: of('LATE'),
    halfDay: of('HALF_DAY'),
    absent: of('ABSENT'),
  };
}
