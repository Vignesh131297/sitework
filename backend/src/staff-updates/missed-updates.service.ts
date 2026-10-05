import { Injectable } from '@nestjs/common';
import {
  addDays,
  addMinutes,
  businessDate,
  toDbDate,
} from '../common/time/business-time.js';
import { Clock } from '../common/time/clock.js';
import type { TimeSlot } from '../generated/prisma/enums.js';
import {
  slotSummary,
  updateReminder,
  updatesMissed,
} from '../notifications/notification-messages.js';
import {
  NotificationsService,
  type NotificationInput,
} from '../notifications/notifications.service.js';
import { PrismaService } from '../prisma/prisma.service.js';
import { CalendarService } from '../settings/calendar.service.js';
import type { Settings } from '../settings/settings.schema.js';
import { SettingsService } from '../settings/settings.service.js';
import {
  DayActivityService,
  dayTotals,
  type StaffDay,
} from './day-activity.service.js';
import { slotWindows } from './slot-status.js';

/** Reminders go out this long before a window ends. */
const REMIND_BEFORE_END_MINUTES = 30;

/**
 * Turns closed slot windows into missed-update records and alerts, and reminds
 * staff before a window ends. Runs on a schedule; every step is idempotent, so a
 * second run (or a second server) changes nothing and notifies nobody twice.
 */
@Injectable()
export class MissedUpdatesService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly settings: SettingsService,
    private readonly calendar: CalendarService,
    private readonly dayActivity: DayActivityService,
    private readonly notifications: NotificationsService,
    private readonly clock: Clock,
  ) {}

  /** Records misses for windows that have closed today, and yesterday's after downtime. */
  async detect(now = this.clock.now()): Promise<number> {
    const settings = await this.settings.getAll();
    const today = businessDate(now, settings.business.timeZone);
    let recorded = 0;
    for (const date of [addDays(today, -1), today])
      recorded += await this.detectForDate(date, settings, now);
    return recorded;
  }

  /** One reminder per slot to staff who still owe it, shortly before the window ends. */
  async remind(now = this.clock.now()): Promise<number> {
    const settings = await this.settings.getAll();
    const zone = settings.business.timeZone;
    const date = businessDate(now, zone);
    if (!(await this.calendar.isWorkingDay(date))) return 0;
    const due = slotWindows(date, settings).filter(
      (w) =>
        now >= addMinutes(w.end, -REMIND_BEFORE_END_MINUTES) && now < w.end,
    );
    if (due.length === 0) return 0;
    const day = await this.dayActivity.forDate(date, {}, now);
    const inputs: NotificationInput[] = due.flatMap((window) => {
      const owing = day.staff
        .filter((s) => slotOf(s, window.slot)?.state === 'PENDING')
        .map((s) => s.staff.id);
      return owing.length === 0
        ? []
        : [
            {
              recipientIds: owing,
              type: 'MISSING_UPDATE' as const,
              ...updateReminder({
                slot: window.slot,
                closesAt: window.end,
                timeZone: zone,
              }),
              data: { date, slot: window.slot },
              dedupeKey: `reminder:${date}:${window.slot}`,
            },
          ];
    });
    return this.notifications.notify(inputs);
  }

  private async detectForDate(
    date: string,
    settings: Settings,
    now: Date,
  ): Promise<number> {
    if (!(await this.calendar.isWorkingDay(date))) return 0;
    const closed = slotWindows(date, settings).filter((w) => w.closesAt <= now);
    if (closed.length === 0) return 0;
    const day = await this.dayActivity.forDate(date, {}, now);
    const workDate = toDbDate(date);
    let recorded = 0;
    for (const window of closed) {
      const missing = day.staff.filter(
        (s) => slotOf(s, window.slot)?.state === 'MISSING',
      );
      const known = new Set(
        (
          await this.prisma.missedUpdate.findMany({
            where: { workDate, slot: window.slot },
            select: { staffId: true },
          })
        ).map((m) => m.staffId),
      );
      const fresh = missing.filter((s) => !known.has(s.staff.id));
      if (fresh.length > 0) {
        await this.prisma.missedUpdate.createMany({
          data: fresh.map((s) => ({
            staffId: s.staff.id,
            siteId: s.site.id,
            engineerId: s.engineer.id,
            workDate,
            slot: window.slot,
            detectedAt: now,
          })),
          skipDuplicates: true,
        });
        recorded += fresh.length;
        await this.notifyMissed(fresh, window.slot, date, settings);
      }
      if (settings.notifications.adminStaffUpdatePush === 'DIGEST') {
        await this.sendDigest(day.staff, window.slot, date);
      }
    }
    return recorded;
  }

  /** Per site: each engineer hears about their own staff, admins about everyone. */
  private async notifyMissed(
    missing: StaffDay[],
    slot: TimeSlot,
    date: string,
    settings: Settings,
  ): Promise<void> {
    const admins = await this.notifications.adminIds();
    const inputs: NotificationInput[] = [];
    for (const [siteId, people] of groupBy(missing, (s) => s.site.id)) {
      const siteName = people[0].site.name;
      const base = {
        type: 'MISSING_UPDATE' as const,
        referenceType: 'SITE' as const,
        referenceId: siteId,
        data: { siteId, date, slot },
      };
      if (settings.notifications.missedUpdateDigest) {
        inputs.push({
          ...base,
          recipientIds: admins,
          ...updatesMissed({
            staffNames: people.map((p) => p.staff.name),
            slot,
            siteName,
            date,
          }),
          dedupeKey: `missed:${siteId}:${date}:${slot}`,
        });
        for (const [engineerId, theirs] of groupBy(
          people,
          (p) => p.engineer.id,
        )) {
          inputs.push({
            ...base,
            recipientIds: [engineerId],
            ...updatesMissed({
              staffNames: theirs.map((p) => p.staff.name),
              slot,
              siteName,
              date,
            }),
            dedupeKey: `missed:${siteId}:${date}:${slot}`,
          });
        }
      } else {
        for (const person of people) {
          inputs.push({
            ...base,
            recipientIds: [...admins, person.engineer.id],
            ...updatesMissed({
              staffNames: [person.staff.name],
              slot,
              siteName,
              date,
            }),
            dedupeKey: `missed:${person.staff.id}:${date}:${slot}`,
          });
        }
      }
    }
    await this.notifications.notify(inputs);
  }

  /** Admins who chose digests get one line per site when a window closes. */
  private async sendDigest(
    staff: StaffDay[],
    slot: TimeSlot,
    date: string,
  ): Promise<void> {
    const admins = await this.notifications.adminIds();
    const inputs: NotificationInput[] = [];
    for (const [siteId, people] of groupBy(staff, (s) => s.site.id)) {
      const totals = dayTotals(
        people.map((p) => ({
          ...p,
          slots: p.slots.filter((x) => x.slot === slot),
        })),
      );
      if (totals.expected === 0) continue;
      inputs.push({
        recipientIds: admins,
        type: 'STAFF_UPDATE',
        ...slotSummary({
          slot,
          siteName: people[0].site.name,
          submitted: totals.submitted,
          expected: totals.expected,
        }),
        referenceType: 'SITE',
        referenceId: siteId,
        data: { siteId, date, slot },
        dedupeKey: `digest:${siteId}:${date}:${slot}`,
      });
    }
    await this.notifications.notify(inputs);
  }
}

function slotOf(day: StaffDay, slot: TimeSlot) {
  return day.slots.find((s) => s.slot === slot);
}

function groupBy<T>(
  items: readonly T[],
  key: (item: T) => string,
): Map<string, T[]> {
  const groups = new Map<string, T[]>();
  for (const item of items) {
    const k = key(item);
    groups.set(k, [...(groups.get(k) ?? []), item]);
  }
  return groups;
}
