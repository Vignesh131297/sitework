import { randomUUID } from 'node:crypto';
import {
  addDays,
  addMinutes,
  businessDate,
  isWorkingDay,
  toDbDate,
  zonedInstant,
} from '../../src/common/time/business-time.js';
import type { Prisma } from '../../src/generated/prisma/client.js';
import type {
  AttendanceStatus,
  LocationFlag,
  TimeSlot,
} from '../../src/generated/prisma/enums.js';
import type { Settings } from '../../src/settings/settings.schema.js';
import { staffPhotoFolder } from '../../src/storage/storage.provider.js';
import type { Random } from './random.js';

/** Probabilities that shape one staff member's simulated behaviour. */
export interface StaffHabits {
  absent: number;
  late: number;
  halfDay: number;
  submit: number;
}

export interface StaffOnSite {
  staffId: string;
  siteId: string;
  engineerId: string;
  site: { latitude: number; longitude: number };
  habits: StaffHabits;
  descriptions: readonly string[];
}

export type SeedStaffUpdate = Prisma.StaffUpdateCreateManyInput & {
  id: string;
  staffId: string;
  siteId: string;
  engineerId: string;
  workDate: Date;
  slot: TimeSlot;
  submittedAt: Date;
  engineerViewedAt: Date | null;
  adminViewedAt: Date | null;
};

export type SeedMissedUpdate = Prisma.MissedUpdateCreateManyInput & {
  staffId: string;
  siteId: string;
  engineerId: string;
  workDate: Date;
  slot: TimeSlot;
  detectedAt: Date;
};

export interface FieldActivity {
  attendance: Prisma.AttendanceCreateManyInput[];
  updates: SeedStaffUpdate[];
  missed: SeedMissedUpdate[];
}

interface ActivityInput {
  now: Date;
  /** How many days of history to generate before today. */
  days: number;
  settings: Settings;
  holidays: ReadonlySet<string>;
  staff: readonly StaffOnSite[];
  adminId: string;
  random: Random;
}

/**
 * Simulates attendance, slot updates and missed slots, following the same rules
 * the server applies: working days only, absent staff are not expected to report,
 * a slot is missed once its window plus grace has passed, and photos move through
 * AVAILABLE → READY_FOR_DELETION → DELETED as they are viewed or expire.
 */
export function buildFieldActivity(input: ActivityInput): FieldActivity {
  const timeZone = input.settings.business.timeZone;
  const today = businessDate(input.now, timeZone);
  const activity: FieldActivity = { attendance: [], updates: [], missed: [] };

  for (let offset = input.days; offset >= 0; offset -= 1) {
    const date = addDays(today, -offset);
    if (
      !isWorkingDay(date, input.settings.business.workingDays, input.holidays)
    ) {
      continue;
    }
    for (const staff of input.staff) {
      simulateDay(activity, input, staff, date, today);
    }
  }
  return activity;
}

function simulateDay(
  activity: FieldActivity,
  input: ActivityInput,
  staff: StaffOnSite,
  date: string,
  today: string,
): void {
  const { now, random, settings } = input;
  const at = (time: string) =>
    zonedInstant(date, time, settings.business.timeZone);
  const workDate = toDbDate(date);
  const who = { staffId: staff.staffId, siteId: staff.siteId };

  if (random.chance(staff.habits.absent)) {
    // Marked absent at the end of the day; absent staff are not expected to report.
    if (date < today)
      activity.attendance.push({ ...who, workDate, status: 'ABSENT' });
    return;
  }

  const shiftStart = at(settings.attendance.shiftStart);
  const checkInAt = addMinutes(
    shiftStart,
    random.chance(staff.habits.late) ? random.int(16, 50) : random.int(-20, 10),
  );
  if (checkInAt > now) return;

  const leavesAt = random.chance(staff.habits.halfDay)
    ? addMinutes(at('12:30'), random.int(0, 20))
    : addMinutes(at('17:45'), random.int(0, 45));
  const checkOutAt = leavesAt <= now ? leavesAt : null;

  const workedHours = checkOutAt
    ? (checkOutAt.getTime() - checkInAt.getTime()) / 3_600_000
    : null;
  const lateAfter = addMinutes(
    shiftStart,
    settings.attendance.lateAfterMinutes,
  );
  const status: AttendanceStatus =
    workedHours !== null && workedHours < settings.attendance.halfDayMinHours
      ? 'HALF_DAY'
      : checkInAt > lateAfter
        ? 'LATE'
        : 'PRESENT';

  const checkIn = pointNear(staff.site, random.int(5, 80), random);
  const checkOut = checkOutAt
    ? pointNear(staff.site, random.int(5, 80), random)
    : null;
  activity.attendance.push({
    ...who,
    workDate,
    status,
    checkInAt,
    checkInLatitude: checkIn.latitude,
    checkInLongitude: checkIn.longitude,
    checkInAccuracyM: checkIn.accuracyM,
    checkInLocationFlag: 'OK',
    checkOutAt,
    checkOutLatitude: checkOut?.latitude ?? null,
    checkOutLongitude: checkOut?.longitude ?? null,
    checkOutAccuracyM: checkOut?.accuracyM ?? null,
    checkOutLocationFlag: checkOut ? 'OK' : null,
  });

  for (const window of settings.updates.slots) {
    const start = at(window.start);
    const end = at(window.end);
    const missedAfter = addMinutes(end, settings.updates.lateGraceMinutes);
    const onSite = leavesAt > start;
    const plan =
      onSite && random.chance(staff.habits.submit)
        ? planSubmission(start, end, random)
        : null;
    const slotIdentity = {
      ...who,
      engineerId: staff.engineerId,
      workDate,
      slot: window.slot,
    };

    if (plan && plan.submittedAt <= now) {
      const update = buildUpdate(input, staff, date, window.slot, plan);
      activity.updates.push(update);
      if (plan.submittedAt > missedAfter) {
        // An offline update that arrived after the slot was already flagged as missed.
        activity.missed.push({
          ...slotIdentity,
          detectedAt: addMinutes(missedAfter, 1),
          resolvedAt: plan.submittedAt,
          resolvedByUpdateId: update.id,
        });
      }
    } else if (missedAfter <= now) {
      activity.missed.push({
        ...slotIdentity,
        detectedAt: earliest(addMinutes(missedAfter, 1), now),
      });
    }
  }
}

interface SubmissionPlan {
  capturedAt: Date;
  submittedAt: Date;
  offline: boolean;
}

function planSubmission(
  start: Date,
  end: Date,
  random: Random,
): SubmissionPlan {
  const windowMinutes = (end.getTime() - start.getTime()) / 60_000;
  const capturedAt = addMinutes(start, random.int(5, windowMinutes - 10));
  // A few photos are taken without signal and reach the server after the window.
  const offline = random.chance(0.05);
  const submittedAt = offline
    ? addMinutes(end, random.int(20, 100))
    : addMinutes(capturedAt, random.int(1, 4));
  return { capturedAt, submittedAt, offline };
}

function buildUpdate(
  input: ActivityInput,
  staff: StaffOnSite,
  date: string,
  slot: TimeSlot,
  plan: SubmissionPlan,
): SeedStaffUpdate {
  const { random, settings } = input;
  const id = randomUUID();
  const location = updateLocation(staff.site, random);
  return {
    id,
    clientSubmissionId: randomUUID(),
    staffId: staff.staffId,
    siteId: staff.siteId,
    engineerId: staff.engineerId,
    workDate: toDbDate(date),
    slot,
    description: random.pick(staff.descriptions),
    ...location,
    photoSource:
      settings.updates.allowGallery && random.chance(0.06)
        ? 'GALLERY'
        : 'CAMERA',
    capturedAt: plan.capturedAt,
    submittedAt: plan.submittedAt,
    submittedOffline: plan.offline,
    imageBytes: random.int(180_000, 420_000),
    imageMime: 'image/jpeg',
    ...photoLifecycle(
      input,
      `${staffPhotoFolder(date)}/${id}.jpg`,
      plan.submittedAt,
    ),
  };
}

/** Where the photo is in its lifecycle at `now`, given who has viewed it and when. */
function photoLifecycle(
  input: ActivityInput,
  imageKey: string,
  submittedAt: Date,
) {
  const { now, random, adminId } = input;
  const { ttlHours, expiryAction, deleteGraceMinutes } = input.settings.images;
  const expiresAt = addMinutes(submittedAt, ttlHours * 60);
  const viewAt = (probability: number, minDelay: number, maxDelay: number) => {
    if (!random.chance(probability)) return null;
    const viewedAt = addMinutes(submittedAt, random.int(minDelay, maxDelay));
    return viewedAt <= now && viewedAt < expiresAt ? viewedAt : null;
  };
  const engineerViewedAt = viewAt(0.94, 4, 120);
  const adminViewedAt = viewAt(0.88, 10, 300);
  const views = {
    imageExpiresAt: expiresAt,
    engineerViewedAt,
    adminViewedAt,
    adminViewedById: adminViewedAt ? adminId : null,
  };

  let readyAt: Date | null = null;
  let reason: 'ALL_VIEWED' | 'EXPIRED' | null = null;
  if (engineerViewedAt && adminViewedAt) {
    readyAt = latest(engineerViewedAt, adminViewedAt);
    reason = 'ALL_VIEWED';
  } else if (expiryAction === 'DELETE' && expiresAt <= now) {
    readyAt = expiresAt;
    reason = 'EXPIRED';
  }

  if (!readyAt) {
    return { ...views, imageStatus: 'AVAILABLE' as const, imageKey };
  }
  const grace = reason === 'ALL_VIEWED' ? deleteGraceMinutes : 0;
  const deletedAt = addMinutes(readyAt, grace + random.int(1, 5));
  if (deletedAt > now) {
    // Not gone yet: viewed photos wait out the grace period; expired ones wait
    // for the cleanup job, still AVAILABLE (as in the API).
    return reason === 'ALL_VIEWED'
      ? {
          ...views,
          imageStatus: 'READY_FOR_DELETION' as const,
          imageKey,
          imageReadyAt: readyAt,
          imageExpiresAt: addMinutes(readyAt, grace),
        }
      : { ...views, imageStatus: 'AVAILABLE' as const, imageKey };
  }
  return {
    ...views,
    imageStatus: 'DELETED' as const,
    imageKey: null,
    imageReadyAt: reason === 'ALL_VIEWED' ? readyAt : null,
    imageDeletedAt: deletedAt,
    imageDeleteReason: reason,
  };
}

function updateLocation(
  site: { latitude: number; longitude: number },
  random: Random,
): {
  latitude: number | null;
  longitude: number | null;
  accuracyM: number | null;
  locationFlag: LocationFlag;
  distanceFromSiteM: number | null;
} {
  const roll = random.next();
  if (roll < 0.03) {
    return {
      latitude: null,
      longitude: null,
      accuracyM: null,
      locationFlag: 'UNAVAILABLE',
      distanceFromSiteM: null,
    };
  }
  const outside = roll < 0.05;
  const distance = outside ? random.int(400, 900) : random.int(5, 60);
  const point = pointNear(site, distance, random);
  return {
    ...point,
    locationFlag: outside ? 'OUTSIDE_SITE' : 'OK',
    distanceFromSiteM: distance,
  };
}

function pointNear(
  site: { latitude: number; longitude: number },
  meters: number,
  random: Random,
) {
  const bearing = random.next() * 2 * Math.PI;
  const metersPerDegree = 111_320;
  const latitude =
    site.latitude + (meters * Math.cos(bearing)) / metersPerDegree;
  const longitude =
    site.longitude +
    (meters * Math.sin(bearing)) /
      (metersPerDegree * Math.cos((site.latitude * Math.PI) / 180));
  return {
    latitude: Number(latitude.toFixed(6)),
    longitude: Number(longitude.toFixed(6)),
    accuracyM: random.int(4, 25),
  };
}

function latest(a: Date, b: Date): Date {
  return a > b ? a : b;
}

function earliest(a: Date, b: Date): Date {
  return a < b ? a : b;
}
