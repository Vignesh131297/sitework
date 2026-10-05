import {
  addDays,
  addMinutes,
  businessDate,
  fromDbDate,
  zonedInstant,
} from '../../src/common/time/business-time.js';
import type { Paise } from '../../src/common/money/money.js';
import type { Prisma } from '../../src/generated/prisma/client.js';
import type {
  EngineerUpdateType,
  NotificationType,
  Priority,
  ReferenceType,
} from '../../src/generated/prisma/enums.js';
import {
  engineerUpdateSubmitted,
  issueReported,
  issueResolved,
  milestoneOverdue,
  staffUpdateSubmitted,
  updatesMissed,
  type NotificationText,
} from '../../src/notifications/notification-messages.js';
import type { SeedMissedUpdate, SeedStaffUpdate } from './field-activity.js';

export interface SeededEngineerUpdate {
  id: string;
  engineerId: string;
  siteId: string;
  type: EngineerUpdateType;
  createdAt: Date;
  adminViewedAt: Date | null;
}

export interface SeededIssue {
  id: string;
  siteId: string;
  reportedById: string;
  title: string;
  priority: Priority;
  createdAt: Date;
  resolvedAt: Date | null;
}

export interface OverdueMilestone {
  id: string;
  siteId: string;
  title: string;
  outstanding: Paise;
  dueDate: string;
}

interface NotificationInput {
  now: Date;
  timeZone: string;
  /** Only activity this recent produces notifications. */
  recentDays: number;
  adminIds: readonly string[];
  userNames: ReadonlyMap<string, string>;
  siteNames: ReadonlyMap<string, string>;
  updates: readonly SeedStaffUpdate[];
  missed: readonly SeedMissedUpdate[];
  engineerUpdates: readonly SeededEngineerUpdate[];
  issues: readonly SeededIssue[];
  overdueMilestones: readonly OverdueMilestone[];
}

/** Recreates the notifications the API would have sent for the seeded activity. */
export function buildNotifications(
  input: NotificationInput,
): Prisma.NotificationCreateManyInput[] {
  const since = addMinutes(input.now, -input.recentDays * 24 * 60);
  const today = businessDate(input.now, input.timeZone);
  const name = (id: string) => input.userNames.get(id) ?? 'Someone';
  const site = (id: string) => input.siteNames.get(id) ?? 'a site';
  const notifications: Prisma.NotificationCreateManyInput[] = [];

  const add = (n: {
    recipientId: string;
    type: NotificationType;
    text: NotificationText;
    referenceType: ReferenceType;
    referenceId: string;
    dedupeKey: string;
    createdAt: Date;
    readAt: Date | null;
    data?: Prisma.InputJsonValue;
  }) =>
    notifications.push({
      recipientId: n.recipientId,
      type: n.type,
      title: n.text.title,
      message: n.text.message,
      referenceType: n.referenceType,
      referenceId: n.referenceId,
      data: n.data,
      dedupeKey: n.dedupeKey,
      isRead: n.readAt !== null,
      readAt: n.readAt,
      // No phones are registered in seed data, so nothing was pushed.
      pushStatus: 'NO_DEVICE',
      createdAt: n.createdAt,
    });

  for (const update of input.updates) {
    if (update.submittedAt < since) continue;
    const text = staffUpdateSubmitted({
      staffName: name(update.staffId),
      slot: update.slot,
      siteName: site(update.siteId),
      submittedAt: update.submittedAt,
      timeZone: input.timeZone,
    });
    const common = {
      type: 'STAFF_UPDATE' as const,
      text,
      referenceType: 'STAFF_UPDATE' as const,
      referenceId: update.id,
      dedupeKey: `staff-update:${update.id}`,
      createdAt: update.submittedAt,
    };
    // Opening the update (viewing the photo) also reads its notification.
    add({
      ...common,
      recipientId: update.engineerId,
      readAt: update.engineerViewedAt,
    });
    for (const adminId of input.adminIds) {
      add({ ...common, recipientId: adminId, readAt: update.adminViewedAt });
    }
  }

  // Missed slots: one summary per recipient, site and slot.
  const groups = new Map<string, SeedMissedUpdate[]>();
  for (const miss of input.missed) {
    if (miss.detectedAt < since) continue;
    const key = `${miss.siteId}:${fromDbDate(miss.workDate)}:${miss.slot}`;
    groups.set(key, [...(groups.get(key) ?? []), miss]);
  }
  for (const [key, misses] of groups) {
    const [first] = misses;
    const date = fromDbDate(first.workDate);
    const readAt = date < today ? addMinutes(first.detectedAt, 45) : null;
    const notify = (recipientId: string, group: SeedMissedUpdate[]) =>
      add({
        recipientId,
        type: 'MISSING_UPDATE',
        text: updatesMissed({
          staffNames: group.map((m) => name(m.staffId)),
          slot: first.slot,
          siteName: site(first.siteId),
          date,
        }),
        referenceType: 'SITE',
        referenceId: first.siteId,
        data: { date, slot: first.slot },
        dedupeKey: `missed:${key}`,
        createdAt: first.detectedAt,
        readAt,
      });
    for (const engineerId of new Set(misses.map((m) => m.engineerId))) {
      notify(
        engineerId,
        misses.filter((m) => m.engineerId === engineerId),
      );
    }
    for (const adminId of input.adminIds) notify(adminId, misses);
  }

  for (const update of input.engineerUpdates) {
    if (update.createdAt < since) continue;
    for (const adminId of input.adminIds) {
      add({
        recipientId: adminId,
        type: 'ENGINEER_UPDATE',
        text: engineerUpdateSubmitted({
          engineerName: name(update.engineerId),
          type: update.type,
          siteName: site(update.siteId),
        }),
        referenceType: 'ENGINEER_UPDATE',
        referenceId: update.id,
        dedupeKey: `engineer-update:${update.id}`,
        createdAt: update.createdAt,
        readAt: update.adminViewedAt,
      });
    }
  }

  for (const issue of input.issues) {
    for (const adminId of input.adminIds) {
      add({
        recipientId: adminId,
        type: 'ISSUE',
        text: issueReported({
          title: issue.title,
          priority: issue.priority,
          siteName: site(issue.siteId),
          reporterName: name(issue.reportedById),
        }),
        referenceType: 'ISSUE',
        referenceId: issue.id,
        dedupeKey: `issue:${issue.id}`,
        createdAt: issue.createdAt,
        readAt:
          issue.resolvedAt ??
          (issue.priority === 'CRITICAL'
            ? null
            : addMinutes(issue.createdAt, 90)),
      });
    }
    if (issue.resolvedAt) {
      add({
        recipientId: issue.reportedById,
        type: 'ISSUE',
        text: issueResolved({
          title: issue.title,
          siteName: site(issue.siteId),
        }),
        referenceType: 'ISSUE',
        referenceId: issue.id,
        dedupeKey: `issue-resolved:${issue.id}`,
        createdAt: issue.resolvedAt,
        readAt: addMinutes(issue.resolvedAt, 60),
      });
    }
  }

  for (const milestone of input.overdueMilestones) {
    for (const adminId of input.adminIds) {
      add({
        recipientId: adminId,
        type: 'PAYMENT',
        text: milestoneOverdue({
          milestoneTitle: milestone.title,
          siteName: site(milestone.siteId),
          outstanding: milestone.outstanding,
          dueDate: milestone.dueDate,
        }),
        referenceType: 'PAYMENT_MILESTONE',
        referenceId: milestone.id,
        dedupeKey: `overdue:${milestone.id}`,
        // The daily overdue check runs the morning after the due date.
        createdAt: zonedInstant(
          addDays(milestone.dueDate, 1),
          '09:00',
          input.timeZone,
        ),
        readAt: null,
      });
    }
  }

  return notifications;
}
