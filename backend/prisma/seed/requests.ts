import { randomUUID } from 'node:crypto';
import { fromPaise, toPaise } from '../../src/common/money/money.js';
import {
  addDays,
  toDbDate,
  zonedInstant,
} from '../../src/common/time/business-time.js';
import type {
  Prisma,
  PrismaClient,
} from '../../src/generated/prisma/client.js';
import type {
  ApprovalStatus,
  LeaveType,
  Meal,
} from '../../src/generated/prisma/enums.js';
import {
  leaveDecided,
  leaveRequested,
  staffRequestCreated,
  staffRequestDecided,
  staffRequestSummary,
} from '../../src/notifications/notification-messages.js';
import {
  leaveCode,
  staffRequestCode,
} from '../../src/requests/request-common.js';

export interface RequestsSeedInput {
  today: string;
  timeZone: string;
  userId: (key: string) => string;
  userName: (key: string) => string;
  /** The staff member's current site and its engineers. */
  siteOf: (staffKey: string) => {
    id: string;
    name: string;
    engineerIds: string[];
  };
  adminId: string;
}

interface Decision {
  status: Exclude<ApprovalStatus, 'PENDING'>;
  byKey: string;
  daysAgo: number;
  time: string;
  note?: string;
}

interface LeaveSeed {
  userKey: string;
  /** Staff: their site (whose engineers decide). Engineers: none. */
  staff: boolean;
  type: LeaveType;
  /** Days from today (future leave keeps attendance untouched). */
  fromIn: number;
  toIn: number;
  reason: string;
  askedDaysAgo: number;
  askedAt: string;
  decision?: Decision;
}

/** Waiting, approved and rejected leave, for staff and an engineer. */
const LEAVE: LeaveSeed[] = [
  {
    userKey: 'ravi',
    staff: true,
    type: 'CASUAL',
    fromIn: 3,
    toIn: 4,
    reason: "Sister's wedding in the village",
    askedDaysAgo: 1,
    askedAt: '18:30',
  },
  {
    userKey: 'kumar',
    staff: true,
    type: 'SICK',
    fromIn: 1,
    toIn: 1,
    reason: 'Dental appointment at the government hospital',
    askedDaysAgo: 2,
    askedAt: '17:45',
    decision: {
      status: 'APPROVED',
      byKey: 'arun',
      daysAgo: 1,
      time: '09:15',
      note: 'Fine. Manoj covers the plastering.',
    },
  },
  {
    userKey: 'manoj',
    staff: true,
    type: 'OTHER',
    fromIn: 6,
    toIn: 6,
    reason: 'Bank work',
    askedDaysAgo: 3,
    askedAt: '12:10',
    decision: {
      status: 'REJECTED',
      byKey: 'prakash',
      daysAgo: 2,
      time: '10:05',
      note: 'Slab casting that day. Please choose another day.',
    },
  },
  {
    userKey: 'prakash',
    staff: false,
    type: 'CASUAL',
    fromIn: 10,
    toIn: 12,
    reason: 'Family function in Madurai',
    askedDaysAgo: 1,
    askedAt: '20:00',
  },
];

interface StaffRequestSeed {
  staffKey: string;
  money?: number;
  food?: { inDays: number; meal: Meal };
  note?: string;
  askedDaysAgo: number;
  askedAt: string;
  decision?: Decision;
}

/** Money and food: waiting, approved and rejected. */
const STAFF_REQUESTS: StaffRequestSeed[] = [
  {
    staffKey: 'ravi',
    money: 2000,
    note: "Advance for my son's school fees",
    askedDaysAgo: 1,
    askedAt: '19:10',
  },
  {
    staffKey: 'kumar',
    food: { inDays: 0, meal: 'LUNCH' },
    askedDaysAgo: 1,
    askedAt: '17:00',
    decision: {
      status: 'APPROVED',
      byKey: 'arun',
      daysAgo: 1,
      time: '17:30',
      note: 'From the canteen near the site.',
    },
  },
  {
    staffKey: 'sathish',
    money: 5000,
    note: 'House rent',
    askedDaysAgo: 4,
    askedAt: '08:50',
    decision: {
      status: 'REJECTED',
      byKey: 'admin',
      daysAgo: 3,
      time: '11:20',
      note: 'An advance was already given this month.',
    },
  },
];

/** Leave and staff requests, with the notifications they raised. */
export async function seedRequests(
  prisma: PrismaClient,
  input: RequestsSeedInput,
): Promise<{
  leaveRequests: number;
  staffRequests: number;
  notifications: Prisma.NotificationCreateManyInput[];
}> {
  const { today, timeZone } = input;
  const at = (daysAgo: number, time: string) =>
    zonedInstant(addDays(today, -daysAgo), time, timeZone);
  const notifications: Prisma.NotificationCreateManyInput[] = [];

  for (const seed of LEAVE) {
    const userId = input.userId(seed.userKey);
    const site = seed.staff ? input.siteOf(seed.userKey) : null;
    const from = addDays(today, seed.fromIn);
    const to = addDays(today, seed.toIn);
    const askedAt = at(seed.askedDaysAgo, seed.askedAt);
    const decidedAt = seed.decision
      ? at(seed.decision.daysAgo, seed.decision.time)
      : null;
    const row = await prisma.leaveRequest.create({
      data: {
        requestId: randomUUID(),
        userId,
        siteId: site?.id ?? null,
        type: seed.type,
        fromDate: toDbDate(from),
        toDate: toDbDate(to),
        reason: seed.reason,
        status: seed.decision?.status ?? 'PENDING',
        reviewedById: seed.decision ? input.userId(seed.decision.byKey) : null,
        reviewedAt: decidedAt,
        reviewNote: seed.decision?.note ?? null,
        createdAt: askedAt,
      },
    });
    const code = leaveCode(row.number);
    const approvers = [...(site?.engineerIds ?? []), input.adminId];
    const asked = leaveRequested({
      code,
      name: input.userName(seed.userKey),
      type: seed.type,
      from,
      to,
      siteName: site?.name ?? null,
    });
    for (const recipientId of approvers) {
      notifications.push({
        recipientId,
        type: 'LEAVE',
        ...asked,
        referenceType: 'LEAVE_REQUEST',
        referenceId: row.id,
        data: { leaveRequestId: row.id, ...(site && { siteId: site.id }) },
        dedupeKey: `leave:${row.id}`,
        // Decided ones were seen by whoever decided.
        isRead: Boolean(seed.decision),
        createdAt: askedAt,
      });
    }
    if (seed.decision && decidedAt) {
      notifications.push({
        recipientId: userId,
        type: 'LEAVE',
        ...leaveDecided({
          code,
          approved: seed.decision.status === 'APPROVED',
          from,
          to,
          byName: input.userName(seed.decision.byKey),
          note: seed.decision.note ?? null,
        }),
        referenceType: 'LEAVE_REQUEST',
        referenceId: row.id,
        data: { leaveRequestId: row.id },
        dedupeKey: `leave-decided:${row.id}:${decidedAt.getTime()}`,
        createdAt: decidedAt,
      });
    }
  }

  for (const seed of STAFF_REQUESTS) {
    const staffId = input.userId(seed.staffKey);
    const site = input.siteOf(seed.staffKey);
    const askedAt = at(seed.askedDaysAgo, seed.askedAt);
    const decidedAt = seed.decision
      ? at(seed.decision.daysAgo, seed.decision.time)
      : null;
    const amount = seed.money === undefined ? null : toPaise(seed.money);
    const forDate = seed.food ? addDays(today, seed.food.inDays) : null;
    const row = await prisma.staffRequest.create({
      data: {
        requestId: randomUUID(),
        kind: amount === null ? 'FOOD' : 'MONEY',
        staffId,
        siteId: site.id,
        amount: amount === null ? null : fromPaise(amount),
        forDate: forDate ? toDbDate(forDate) : null,
        meal: seed.food?.meal ?? null,
        note: seed.note ?? null,
        status: seed.decision?.status ?? 'PENDING',
        reviewedById: seed.decision ? input.userId(seed.decision.byKey) : null,
        reviewedAt: decidedAt,
        reviewNote: seed.decision?.note ?? null,
        createdAt: askedAt,
      },
    });
    const code = staffRequestCode(row.number);
    const summary = staffRequestSummary({
      kind: row.kind,
      amount,
      forDate,
      meal: seed.food?.meal ?? null,
    });
    const asked = staffRequestCreated({
      code,
      name: input.userName(seed.staffKey),
      summary,
      siteName: site.name,
    });
    for (const recipientId of [...site.engineerIds, input.adminId]) {
      notifications.push({
        recipientId,
        type: 'STAFF_REQUEST',
        ...asked,
        referenceType: 'STAFF_REQUEST',
        referenceId: row.id,
        data: { staffRequestId: row.id, siteId: site.id },
        dedupeKey: `staff-request:${row.id}`,
        isRead: Boolean(seed.decision),
        createdAt: askedAt,
      });
    }
    if (seed.decision && decidedAt) {
      notifications.push({
        recipientId: staffId,
        type: 'STAFF_REQUEST',
        ...staffRequestDecided({
          code,
          summary,
          approved: seed.decision.status === 'APPROVED',
          byName: input.userName(seed.decision.byKey),
          note: seed.decision.note ?? null,
        }),
        referenceType: 'STAFF_REQUEST',
        referenceId: row.id,
        data: { staffRequestId: row.id },
        dedupeKey: `staff-request-decided:${row.id}`,
        createdAt: decidedAt,
      });
    }
  }

  return {
    leaveRequests: LEAVE.length,
    staffRequests: STAFF_REQUESTS.length,
    notifications,
  };
}
