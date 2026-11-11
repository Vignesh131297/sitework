import { hashPassword } from '../../src/auth/password-hasher.js';
import { sumPaise, toPaise } from '../../src/common/money/money.js';
import {
  addDays,
  addMinutes,
  businessDate,
  isWorkingDay,
  toDbDate,
  zonedInstant,
} from '../../src/common/time/business-time.js';
import type {
  Prisma,
  PrismaClient,
} from '../../src/generated/prisma/client.js';
import type { Role } from '../../src/generated/prisma/enums.js';
import { allocatePayments } from '../../src/payments/payment-allocation.js';
import {
  DEFAULT_SETTINGS,
  SETTINGS_KEYS,
} from '../../src/settings/settings.schema.js';
import {
  CLIENTS,
  DEV_PASSWORDS,
  ENGINEER_UPDATES,
  ISSUES,
  PEOPLE,
  SITES,
  STAFF_ASSIGNMENTS,
  WORK_DESCRIPTIONS,
} from './data.js';
import { buildFieldActivity } from './field-activity.js';
import {
  buildNotifications,
  type OverdueMilestone,
  type SeededEngineerUpdate,
  type SeededIssue,
} from './notifications.js';
import { createRandom } from './random.js';
import { seedRequests } from './requests.js';
import { seedStock } from './stock.js';

const HISTORY_DAYS = 14;
const NOTIFICATION_DAYS = 3;

/**
 * Replaces all data with a realistic, re-runnable development dataset. Dates are
 * relative to `now`, so dashboards always show "today" and the last two weeks.
 */
export async function seedDatabase(
  prisma: PrismaClient,
  now: Date,
): Promise<Record<string, number>> {
  const settings = DEFAULT_SETTINGS;
  const timeZone = settings.business.timeZone;
  const today = businessDate(now, timeZone);
  const daysAgo = (days: number) => addDays(today, -days);
  const random = createRandom(20_261_004);

  await truncateAllTables(prisma);

  await prisma.appSetting.createMany({
    data: SETTINGS_KEYS.map((key) => ({
      key,
      value: settings[key] as Prisma.InputJsonValue,
    })),
  });

  const holidays = nationalHolidays(today);
  await prisma.holiday.createMany({
    data: holidays.map((holiday) => ({
      date: toDbDate(holiday.date),
      name: holiday.name,
    })),
  });

  // People. One hash per role: argon2 is deliberately slow.
  const hashes = Object.fromEntries(
    await Promise.all(
      Object.entries(DEV_PASSWORDS).map(async ([role, password]) => [
        role,
        await hashPassword(password),
      ]),
    ),
  ) as Record<Role, string>;
  const users = new Map<string, { id: string; name: string }>();
  for (const person of PEOPLE) {
    const user = await prisma.user.create({
      data: {
        role: person.role,
        name: person.name,
        phone: person.phone,
        email: person.email,
        employeeCode: person.employeeCode,
        designation: person.designation,
        joiningDate: toDbDate(daysAgo(person.joinedDaysAgo)),
        passwordHash: hashes[person.role],
      },
    });
    users.set(person.key, user);
  }
  const userId = (key: string) => required(users.get(key), `user ${key}`).id;
  const adminId = userId('admin');

  // Clients and sites.
  const clientIds = new Map<string, string>();
  for (const client of CLIENTS) {
    const { key, ...data } = client;
    clientIds.set(key, (await prisma.client.create({ data })).id);
  }

  const sites = new Map<
    string,
    { id: string; name: string; latitude: number; longitude: number }
  >();
  for (const site of SITES) {
    const created = await prisma.site.create({
      data: {
        code: site.code,
        name: site.name,
        clientId: required(
          clientIds.get(site.clientKey),
          `client ${site.clientKey}`,
        ),
        contactName: site.contactName,
        contactPhone: site.contactPhone,
        address: site.address,
        latitude: site.latitude,
        longitude: site.longitude,
        geofenceRadiusM: settings.location.defaultGeofenceRadiusM,
        startDate: toDbDate(daysAgo(site.startedDaysAgo)),
        expectedCompletionDate: toDbDate(addDays(today, site.completesInDays)),
        contractAmount: site.contractAmount,
        status: 'IN_PROGRESS',
        progressPercent: site.progressPercent,
        createdById: adminId,
      },
    });
    sites.set(site.key, {
      id: created.id,
      name: site.name,
      latitude: site.latitude,
      longitude: site.longitude,
    });

    await prisma.engineerAssignment.createMany({
      data: site.engineerKeys.map((key) => ({
        siteId: created.id,
        engineerId: userId(key),
        assignedAt: zonedInstant(
          daysAgo(site.startedDaysAgo - 1),
          '10:00',
          timeZone,
        ),
        assignedById: adminId,
      })),
    });
  }
  const siteOf = (key: string) => required(sites.get(key), `site ${key}`);

  // Staff assignments, including one earlier assignment kept as history.
  for (const assignment of STAFF_ASSIGNMENTS) {
    const assignedAt = zonedInstant(
      daysAgo(assignment.assignedDaysAgo),
      '09:30',
      timeZone,
    );
    await prisma.staffAssignment.create({
      data: {
        staffId: userId(assignment.staffKey),
        siteId: siteOf(assignment.siteKey).id,
        engineerId: userId(assignment.engineerKey),
        assignedAt,
        assignedById: adminId,
      },
    });
    if (assignment.previous) {
      await prisma.assignmentHistory.create({
        data: {
          kind: 'STAFF',
          userId: userId(assignment.staffKey),
          siteId: siteOf(assignment.previous.siteKey).id,
          engineerId: userId(assignment.previous.engineerKey),
          assignedAt: zonedInstant(
            daysAgo(assignment.previous.assignedDaysAgo),
            '09:30',
            timeZone,
          ),
          unassignedAt: assignedAt,
          endedById: adminId,
        },
      });
    }
  }

  // Payment schedule and receipts; overdue milestones feed the notifications below.
  const overdueMilestones: OverdueMilestone[] = [];
  let paymentCount = 0;
  for (const site of SITES) {
    const siteId = siteOf(site.key).id;
    const milestones = await prisma.paymentMilestone.createManyAndReturn({
      data: site.milestones.map((milestone) => ({
        siteId,
        title: milestone.title,
        amount: milestone.amount,
        dueDate: toDbDate(addDays(today, milestone.dueInDays)),
        createdById: adminId,
      })),
    });
    await prisma.payment.createMany({
      data: site.payments.map((payment) => ({
        siteId,
        amount: payment.amount,
        paidOn: toDbDate(daysAgo(payment.daysAgo)),
        method: payment.method,
        reference: payment.reference,
        remarks: payment.remarks,
        recordedById: adminId,
        createdAt: zonedInstant(daysAgo(payment.daysAgo), '16:00', timeZone),
        ...(payment.voided && {
          voidedAt: zonedInstant(
            daysAgo(payment.voided.daysAgo),
            '11:00',
            timeZone,
          ),
          voidedById: adminId,
          voidReason: payment.voided.reason,
        }),
      })),
    });
    paymentCount += site.payments.length;

    const received = sumPaise(
      site.payments.filter((p) => !p.voided).map((p) => toPaise(p.amount)),
    );
    const allocation = allocatePayments(
      milestones.map((m) => ({
        id: m.id,
        amount: toPaise(m.amount),
        dueDate: m.dueDate.toISOString().slice(0, 10),
      })),
      received,
      today,
    );
    const titles = new Map(milestones.map((m) => [m.id, m.title]));
    for (const milestone of allocation.milestones) {
      if (milestone.status !== 'OVERDUE') continue;
      overdueMilestones.push({
        id: milestone.id,
        siteId,
        title: required(titles.get(milestone.id), 'milestone title'),
        outstanding: milestone.outstanding,
        dueDate: milestone.dueDate,
      });
    }
  }

  // Attendance, slot updates and missed slots for the last two weeks.
  const activity = buildFieldActivity({
    now,
    days: HISTORY_DAYS,
    settings,
    holidays: new Set(holidays.map((h) => h.date)),
    adminId,
    random,
    staff: STAFF_ASSIGNMENTS.map((assignment) => {
      const person = required(
        PEOPLE.find((p) => p.key === assignment.staffKey),
        `person ${assignment.staffKey}`,
      );
      const site = siteOf(assignment.siteKey);
      return {
        staffId: userId(assignment.staffKey),
        siteId: site.id,
        engineerId: userId(assignment.engineerKey),
        site,
        habits: assignment.habits,
        descriptions: WORK_DESCRIPTIONS[person.designation ?? 'GENERAL_WORKER'],
      };
    }),
  });
  await prisma.attendance.createMany({ data: activity.attendance });
  await prisma.staffUpdate.createMany({ data: activity.updates });
  await prisma.missedUpdate.createMany({ data: activity.missed });

  // Engineer updates and issues.
  const engineerUpdates: SeededEngineerUpdate[] = [];
  for (const update of ENGINEER_UPDATES) {
    const createdAt = zonedInstant(
      daysAgo(update.daysAgo),
      update.time,
      timeZone,
    );
    const viewedAt = addMinutes(createdAt, 120);
    const adminViewedAt =
      update.viewedByAdmin && viewedAt <= now ? viewedAt : null;
    const created = await prisma.engineerUpdate.create({
      data: {
        engineerId: userId(update.engineerKey),
        siteId: siteOf(update.siteKey).id,
        type: update.type,
        priority: update.priority,
        title: update.title,
        description: update.description,
        progressPercent: update.progressPercent,
        createdAt,
        adminViewedAt,
        adminViewedById: adminViewedAt ? adminId : null,
      },
    });
    engineerUpdates.push(created);
  }

  const issues: SeededIssue[] = [];
  for (const issue of ISSUES) {
    const createdAt = zonedInstant(daysAgo(issue.daysAgo), '10:30', timeZone);
    const resolvedAt = issue.resolved
      ? zonedInstant(daysAgo(issue.resolved.daysAgo), '17:00', timeZone)
      : null;
    const created = await prisma.issue.create({
      data: {
        siteId: siteOf(issue.siteKey).id,
        reportedById: userId(issue.reporterKey),
        title: issue.title,
        description: issue.description,
        priority: issue.priority,
        status: issue.status,
        createdAt,
        resolvedAt,
        resolvedById: resolvedAt ? adminId : null,
        resolutionNote: issue.resolved?.note,
      },
    });
    issues.push(created);
  }

  const notifications = buildNotifications({
    now,
    timeZone,
    recentDays: NOTIFICATION_DAYS,
    adminIds: [adminId],
    userNames: new Map([...users.values()].map((u) => [u.id, u.name])),
    siteNames: new Map([...sites.values()].map((s) => [s.id, s.name])),
    updates: activity.updates,
    missed: activity.missed,
    engineerUpdates,
    issues,
    overdueMilestones,
  });
  const stock = await seedStock(prisma, {
    today,
    timeZone,
    isWorkingDay: (date) =>
      isWorkingDay(
        date,
        settings.business.workingDays,
        new Set(holidays.map((h) => h.date)),
      ),
    userId,
    userName: (key) => required(users.get(key), `user ${key}`).name,
    site: (key) => {
      const seed = required(
        SITES.find((s) => s.key === key),
        `site ${key}`,
      );
      return {
        ...siteOf(key),
        engineerIds: seed.engineerKeys.map(userId),
      };
    },
    adminIds: [adminId],
  });

  const requests = await seedRequests(prisma, {
    today,
    timeZone,
    userId,
    userName: (key) => required(users.get(key), `user ${key}`).name,
    siteOf: (staffKey) => {
      const assignment = required(
        STAFF_ASSIGNMENTS.find((a) => a.staffKey === staffKey),
        `assignment of ${staffKey}`,
      );
      const seed = required(
        SITES.find((s) => s.key === assignment.siteKey),
        `site ${assignment.siteKey}`,
      );
      const site = siteOf(assignment.siteKey);
      return {
        id: site.id,
        name: site.name,
        engineerIds: seed.engineerKeys.map(userId),
      };
    },
    adminId,
  });

  await prisma.notification.createMany({
    data: [...notifications, ...stock.notifications, ...requests.notifications],
  });

  return {
    users: users.size,
    clients: clientIds.size,
    sites: sites.size,
    paymentMilestones: SITES.reduce((n, s) => n + s.milestones.length, 0),
    payments: paymentCount,
    attendance: activity.attendance.length,
    staffUpdates: activity.updates.length,
    missedUpdates: activity.missed.length,
    engineerUpdates: engineerUpdates.length,
    issues: issues.length,
    godowns: stock.godowns,
    materials: stock.materials,
    materialRequests: stock.materialRequests,
    stockEntries: stock.stockEntries,
    leaveRequests: requests.leaveRequests,
    staffRequests: requests.staffRequests,
    notifications:
      notifications.length +
      stock.notifications.length +
      requests.notifications.length,
  };
}

async function truncateAllTables(prisma: PrismaClient): Promise<void> {
  const tables = await prisma.$queryRaw<{ tablename: string }[]>`
    SELECT tablename FROM pg_tables
    WHERE schemaname = 'public' AND tablename <> '_prisma_migrations'`;
  if (tables.length === 0) return;
  // Names come from the catalog, not user input.
  const list = tables.map((t) => `"public"."${t.tablename}"`).join(', ');
  // RESTART IDENTITY: requests are numbered from MR-0001, LV-0001, RQ-0001 again.
  await prisma.$executeRawUnsafe(
    `TRUNCATE TABLE ${list} RESTART IDENTITY CASCADE`,
  );
}

/** Fixed-date national holidays around the seed window. */
function nationalHolidays(today: string): { date: string; name: string }[] {
  const year = Number(today.slice(0, 4));
  return [year - 1, year, year + 1].flatMap((y) => [
    { date: `${y}-01-26`, name: 'Republic Day' },
    { date: `${y}-05-01`, name: 'May Day' },
    { date: `${y}-08-15`, name: 'Independence Day' },
    { date: `${y}-10-02`, name: 'Gandhi Jayanti' },
    { date: `${y}-12-25`, name: 'Christmas' },
  ]);
}

function required<T>(value: T | undefined, what: string): T {
  if (value === undefined)
    throw new Error(`Seed data is inconsistent: missing ${what}`);
  return value;
}
