import { Injectable } from '@nestjs/common';
import type { AuthUser } from '../auth/auth-user.js';
import { Clock } from '../common/time/clock.js';
import type { Prisma } from '../generated/prisma/client.js';
import type { SiteStatus } from '../generated/prisma/enums.js';
import {
  siteFinancials,
  totalFinancials,
  type SiteFinancials,
} from '../payments/site-financials.js';
import { PrismaService } from '../prisma/prisma.service.js';
import { MaterialRequestsService } from '../stock/material-requests.service.js';
import { StockService } from '../stock/stock.service.js';
import type { GodownView } from '../stock/stock-views.js';
import { CalendarService } from '../settings/calendar.service.js';
import {
  DayActivityService,
  dayTotals,
  type DayTotals,
  type StaffDay,
} from '../staff-updates/day-activity.service.js';

interface Ref {
  id: string;
  name: string;
}

export type AttentionItem =
  | { type: 'MISSING_UPDATES'; site: Ref; count: number; staffNames: string[] }
  | { type: 'NOT_CHECKED_IN'; site: Ref; count: number; staffNames: string[] }
  | {
      type: 'OVERDUE_PAYMENT';
      site: Ref;
      milestone: { id: string; title: string };
      outstanding: string;
      dueDate: string;
    }
  | { type: 'CRITICAL_ISSUE'; site: Ref; issue: { id: string; title: string } };

export interface SiteActivity {
  site: { id: string; code: string; name: string; status: SiteStatus };
  engineers: string[];
  staffCount: number;
  updates: DayTotals;
  lastActivityAt: string | null;
}

/** The engineer's own sites only; no money. */
export interface EngineerDashboard {
  date: string;
  isWorkingDay: boolean;
  holiday: string | null;
  updates: DayTotals;
  /** Their staff's photos still waiting for their review. */
  toReview: number;
  issues: { open: number; critical: number };
  /** Deliveries on the way to their sites, for them to confirm. */
  stock: { toReceive: number; openRequests: number };
  attention: AttentionItem[];
  sites: SiteActivity[];
}

export interface AdminDashboard {
  date: string;
  isWorkingDay: boolean;
  holiday: string | null;
  counts: {
    activeSites: number;
    clients: number;
    engineers: number;
    staff: number;
  };
  payments: Omit<SiteFinancials, 'milestones'>;
  updates: DayTotals;
  /** Staff photos no admin has looked at yet. */
  toReview: number;
  issues: { open: number; critical: number };
  /** Materials below their minimum in the main store; returns to confirm there. */
  stock: { lowStock: number; toReceive: number; requestsToApprove: number };
  attention: AttentionItem[];
  sites: SiteActivity[];
}

/** A godown manager's day: their godowns, what to send and what is arriving. */
export interface GodownDashboard {
  date: string;
  godowns: { godown: GodownView; arriving: number }[];
  /** Approved requests from their godowns with something still to send. */
  toSend: number;
  /** Returns on the way to their godowns. */
  toReceive: number;
  /** Materials below their minimum across all godowns. */
  lowStock: number;
}

@Injectable()
export class DashboardService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly calendar: CalendarService,
    private readonly activity: DayActivityService,
    private readonly stock: StockService,
    private readonly requests: MaterialRequestsService,
    private readonly clock: Clock,
  ) {}

  async admin(now: Date = this.clock.now()): Promise<AdminDashboard> {
    const today = await this.calendar.today(now);
    const [
      activeSites,
      clients,
      engineers,
      staff,
      sites,
      openIssues,
      criticalIssues,
      day,
      lastStaff,
      lastEngineer,
      toReview,
      stock,
    ] = await Promise.all([
      this.prisma.site.count({ where: { status: 'IN_PROGRESS' } }),
      this.prisma.client.count(),
      this.prisma.user.count({ where: { role: 'ENGINEER', isActive: true } }),
      this.prisma.user.count({ where: { role: 'STAFF', isActive: true } }),
      this.prisma.site.findMany({
        orderBy: { name: 'asc' },
        select: {
          id: true,
          code: true,
          name: true,
          status: true,
          contractAmount: true,
          payments: { select: { amount: true, voidedAt: true } },
          paymentMilestones: {
            select: { id: true, title: true, amount: true, dueDate: true },
          },
          engineerAssignments: {
            select: { engineer: { select: { name: true } } },
          },
          _count: { select: { staffAssignments: true } },
        },
      }),
      this.prisma.issue.count({ where: { status: { not: 'RESOLVED' } } }),
      this.prisma.issue.findMany({
        where: { status: { not: 'RESOLVED' }, priority: 'CRITICAL' },
        select: CRITICAL_ISSUE_SELECT,
        orderBy: { createdAt: 'desc' },
      }),
      this.activity.forDate(today, {}, now),
      this.prisma.staffUpdate.groupBy({
        by: ['siteId'],
        _max: { submittedAt: true },
      }),
      this.prisma.engineerUpdate.groupBy({
        by: ['siteId'],
        _max: { createdAt: true },
      }),
      this.prisma.staffUpdate.count({
        where: { adminViewedAt: null, imageStatus: 'AVAILABLE' },
      }),
      this.stock.adminCounts(),
    ]);

    const financialsBySite = new Map(
      sites.map((site) => [
        site.id,
        siteFinancials(
          {
            contractAmount: site.contractAmount,
            payments: site.payments,
            milestones: site.paymentMilestones,
          },
          today,
        ),
      ]),
    );
    const staffBySite = groupBy(day.staff, (s) => s.site.id);
    const latest = new Map<string, Date>();
    for (const row of lastStaff)
      bumpLatest(latest, row.siteId, row._max.submittedAt);
    for (const row of lastEngineer)
      bumpLatest(latest, row.siteId, row._max.createdAt);

    const attention = staffAttention(staffBySite);
    for (const site of sites) {
      for (const milestone of financialsBySite.get(site.id)!.milestones) {
        if (milestone.status !== 'OVERDUE') continue;
        attention.push({
          type: 'OVERDUE_PAYMENT',
          site: { id: site.id, name: site.name },
          milestone: { id: milestone.id, title: milestone.title },
          outstanding: milestone.outstanding,
          dueDate: milestone.dueDate,
        });
      }
    }
    attention.push(...criticalIssues.map(criticalIssueItem));

    return {
      date: today,
      isWorkingDay: day.isWorkingDay,
      holiday: day.holiday,
      counts: { activeSites, clients, engineers, staff },
      payments: totalFinancials([...financialsBySite.values()]),
      updates: dayTotals(day.staff),
      toReview,
      issues: { open: openIssues, critical: criticalIssues.length },
      stock,
      attention,
      sites: sites
        .filter((site) => site.status !== 'COMPLETED')
        .map((site) => siteActivity(site, staffBySite, latest)),
    };
  }

  async engineer(
    user: AuthUser,
    now: Date = this.clock.now(),
  ): Promise<EngineerDashboard> {
    const today = await this.calendar.today(now);
    const mine: Prisma.SiteWhereInput = {
      engineerAssignments: { some: { engineerId: user.id } },
    };
    const [
      sites,
      openIssues,
      criticalIssues,
      day,
      toReview,
      lastStaff,
      lastEngineer,
      stock,
    ] = await Promise.all([
      this.prisma.site.findMany({
        where: { ...mine, status: { not: 'COMPLETED' } },
        orderBy: { name: 'asc' },
        select: ACTIVITY_SITE_SELECT,
      }),
      this.prisma.issue.count({
        where: { status: { not: 'RESOLVED' }, site: mine },
      }),
      this.prisma.issue.findMany({
        where: {
          status: { not: 'RESOLVED' },
          priority: 'CRITICAL',
          site: mine,
        },
        select: CRITICAL_ISSUE_SELECT,
        orderBy: { createdAt: 'desc' },
      }),
      this.activity.forDate(today, { site: mine }, now),
      this.prisma.staffUpdate.count({
        where: {
          engineerId: user.id,
          engineerViewedAt: null,
          imageStatus: 'AVAILABLE',
        },
      }),
      this.prisma.staffUpdate.groupBy({
        by: ['siteId'],
        where: { site: mine },
        _max: { submittedAt: true },
      }),
      this.prisma.engineerUpdate.groupBy({
        by: ['siteId'],
        where: { site: mine },
        _max: { createdAt: true },
      }),
      this.stock.engineerCounts(user),
    ]);
    const staffBySite = groupBy(day.staff, (s) => s.site.id);
    const latest = new Map<string, Date>();
    for (const row of lastStaff)
      bumpLatest(latest, row.siteId, row._max.submittedAt);
    for (const row of lastEngineer)
      bumpLatest(latest, row.siteId, row._max.createdAt);
    return {
      date: today,
      isWorkingDay: day.isWorkingDay,
      holiday: day.holiday,
      updates: dayTotals(day.staff),
      toReview,
      issues: { open: openIssues, critical: criticalIssues.length },
      stock,
      attention: [
        ...staffAttention(staffBySite),
        ...criticalIssues.map(criticalIssueItem),
      ],
      sites: sites.map((site) => siteActivity(site, staffBySite, latest)),
    };
  }

  /** A godown manager's day: their godowns, what to send and what is arriving. */
  async godown(
    user: AuthUser,
    now: Date = this.clock.now(),
  ): Promise<GodownDashboard> {
    const [date, mine, counts] = await Promise.all([
      this.calendar.today(now),
      this.stock.managerGodowns(user),
      this.stock.adminCounts(),
    ]);
    return {
      date,
      godowns: mine.godowns,
      toSend: await this.requests.toSendCount(
        mine.godowns.map((g) => g.godown.id),
      ),
      toReceive: mine.toReceive,
      lowStock: counts.lowStock,
    };
  }
}

const ACTIVITY_SITE_SELECT = {
  id: true,
  code: true,
  name: true,
  status: true,
  engineerAssignments: { select: { engineer: { select: { name: true } } } },
  _count: { select: { staffAssignments: true } },
} as const satisfies Prisma.SiteSelect;

const CRITICAL_ISSUE_SELECT = {
  id: true,
  title: true,
  site: { select: { id: true, name: true } },
} as const satisfies Prisma.IssueSelect;

type ActivitySite = Prisma.SiteGetPayload<{
  select: typeof ACTIVITY_SITE_SELECT;
}>;

function siteActivity(
  site: ActivitySite,
  staffBySite: Map<string, StaffDay[]>,
  latest: Map<string, Date>,
): SiteActivity {
  return {
    site: {
      id: site.id,
      code: site.code,
      name: site.name,
      status: site.status,
    },
    engineers: site.engineerAssignments.map((a) => a.engineer.name),
    staffCount: site._count.staffAssignments,
    updates: dayTotals(staffBySite.get(site.id) ?? []),
    lastActivityAt: latest.get(site.id)?.toISOString() ?? null,
  };
}

/** Per site: who has missed an update, and who has not checked in. */
function staffAttention(staffBySite: Map<string, StaffDay[]>): AttentionItem[] {
  const attention: AttentionItem[] = [];
  for (const [siteId, people] of staffBySite) {
    const site = people[0].site;
    const missing = people.filter((p) =>
      p.slots.some((s) => s.state === 'MISSING'),
    );
    if (missing.length) {
      const count = missing.reduce(
        (n, p) => n + p.slots.filter((s) => s.state === 'MISSING').length,
        0,
      );
      attention.push({
        type: 'MISSING_UPDATES',
        site,
        count,
        staffNames: missing.map((p) => p.staff.name),
      });
    }
    const absent = people.filter((p) => p.notCheckedIn);
    if (absent.length) {
      attention.push({
        type: 'NOT_CHECKED_IN',
        site: { id: siteId, name: site.name },
        count: absent.length,
        staffNames: absent.map((p) => p.staff.name),
      });
    }
  }
  return attention;
}

function criticalIssueItem(
  issue: Prisma.IssueGetPayload<{ select: typeof CRITICAL_ISSUE_SELECT }>,
): AttentionItem {
  return {
    type: 'CRITICAL_ISSUE',
    site: issue.site,
    issue: { id: issue.id, title: issue.title },
  };
}

function groupBy<T>(items: T[], key: (item: T) => string): Map<string, T[]> {
  const groups = new Map<string, T[]>();
  for (const item of items)
    groups.set(key(item), [...(groups.get(key(item)) ?? []), item]);
  return groups;
}

function bumpLatest(
  latest: Map<string, Date>,
  siteId: string,
  value: Date | null,
): void {
  if (value && (!latest.has(siteId) || latest.get(siteId)! < value))
    latest.set(siteId, value);
}
