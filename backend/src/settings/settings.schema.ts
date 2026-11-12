import { z } from 'zod';
import { isValidTimeZone } from '../common/time/business-time.js';
import { TimeSlot } from '../generated/prisma/enums.js';

/**
 * Business rules stored in the app_settings table (one row per group below), so they
 * can change without a redeploy. Missing groups or fields fall back to DEFAULT_SETTINGS.
 */

const timeOfDay = z
  .string()
  .regex(/^([01]\d|2[0-3]):[0-5]\d$/, 'use 24-hour HH:mm');

const slotWindow = z
  .object({ slot: z.enum(TimeSlot), start: timeOfDay, end: timeOfDay })
  .refine((window) => window.start < window.end, {
    message: 'a slot must end after it starts',
  });

export const settingsSchemas = {
  business: z.object({
    timeZone: z
      .string()
      .refine(isValidTimeZone, { message: 'unknown IANA time zone' }),
    /** ISO weekdays: 1 = Monday … 7 = Sunday. */
    workingDays: z.array(z.number().int().min(1).max(7)).min(1),
  }),
  updates: z.object({
    slots: z
      .array(slotWindow)
      .length(3)
      .refine(
        (slots) =>
          new Set(slots.map((s) => s.slot)).size === 3 &&
          slots.every((s, i) => i === 0 || slots[i - 1].end <= s.start),
        {
          message:
            'slots must be MORNING, AFTERNOON, EVENING in order, not overlapping',
        },
      ),
    /** Minutes after a window closes before the slot counts as missed. */
    lateGraceMinutes: z.number().int().min(0).max(120),
    /** How long after the window an offline capture taken inside it is still accepted. */
    offlineAcceptanceMinutes: z.number().int().min(0).max(1440),
    requireCheckIn: z.boolean(),
    allowGallery: z.boolean(),
  }),
  images: z.object({
    ttlHours: z.number().int().min(1).max(720),
    /** What happens to a photo that not every required person viewed within ttlHours. */
    expiryAction: z.enum(['DELETE', 'KEEP']),
    /** Delay between "both viewed" and deletion, so a viewer can reopen the photo. */
    deleteGraceMinutes: z.number().int().min(0).max(1440),
    maxUploadMb: z.number().min(1).max(20),
  }),
  location: z.object({
    required: z.boolean(),
    fixTimeoutSeconds: z.number().int().min(3).max(60),
    defaultGeofenceRadiusM: z.number().int().min(25).max(5000),
    outsideSiteAction: z.enum(['FLAG', 'BLOCK']),
    mockLocationAction: z.enum(['FLAG', 'BLOCK']),
  }),
  attendance: z.object({
    shiftStart: timeOfDay,
    lateAfterMinutes: z.number().int().min(0).max(240),
    halfDayMinHours: z.number().min(1).max(12),
    autoAbsentAtDayEnd: z.boolean(),
  }),
  notifications: z.object({
    adminStaffUpdatePush: z.enum(['EACH', 'DIGEST', 'OFF']),
    missedUpdateDigest: z.boolean(),
  }),
  stock: z.object({
    /** Remind site engineers when a site holding stock has no usage recorded today. */
    usageReminders: z.boolean(),
    /** When, on working days (business time). */
    usageReminderAt: timeOfDay,
  }),
  vehicles: z.object({
    /** Largest amount one repair request may ask for, in rupees. */
    maxRepairRupees: z.number().int().min(1).max(10_000_000),
  }),
};

export type SettingsKey = keyof typeof settingsSchemas;
export type Settings = {
  [K in SettingsKey]: z.infer<(typeof settingsSchemas)[K]>;
};
export const SETTINGS_KEYS = Object.keys(settingsSchemas) as SettingsKey[];

export const DEFAULT_SETTINGS: Settings = {
  business: {
    timeZone: 'Asia/Kolkata',
    workingDays: [1, 2, 3, 4, 5, 6],
  },
  updates: {
    slots: [
      { slot: 'MORNING', start: '10:00', end: '12:00' },
      { slot: 'AFTERNOON', start: '13:00', end: '15:00' },
      { slot: 'EVENING', start: '16:00', end: '19:00' },
    ],
    lateGraceMinutes: 15,
    offlineAcceptanceMinutes: 180,
    requireCheckIn: true,
    allowGallery: true,
  },
  images: {
    ttlHours: 24,
    expiryAction: 'DELETE',
    deleteGraceMinutes: 30,
    maxUploadMb: 5,
  },
  location: {
    required: true,
    fixTimeoutSeconds: 10,
    defaultGeofenceRadiusM: 300,
    outsideSiteAction: 'FLAG',
    mockLocationAction: 'FLAG',
  },
  attendance: {
    shiftStart: '09:00',
    lateAfterMinutes: 15,
    halfDayMinHours: 4,
    autoAbsentAtDayEnd: true,
  },
  notifications: {
    adminStaffUpdatePush: 'EACH',
    missedUpdateDigest: true,
  },
  stock: {
    usageReminders: true,
    usageReminderAt: '18:30',
  },
  vehicles: {
    maxRepairRupees: 50_000,
  },
};

export interface StoredSetting {
  key: string;
  value: unknown;
}

/**
 * Merges stored values over the defaults, group by group. A stored group that fails
 * validation is ignored (defaults used) and reported in invalidKeys.
 */
export function resolveSettings(rows: readonly StoredSetting[]): {
  settings: Settings;
  invalidKeys: SettingsKey[];
} {
  const stored = new Map(rows.map((row) => [row.key, row.value]));
  const settings: Record<string, unknown> = { ...DEFAULT_SETTINGS };
  const invalidKeys: SettingsKey[] = [];

  for (const key of SETTINGS_KEYS) {
    if (!stored.has(key)) continue;
    const value = stored.get(key);
    const merged = isPlainObject(value)
      ? { ...DEFAULT_SETTINGS[key], ...value }
      : value;
    const parsed = settingsSchemas[key].safeParse(merged);
    if (parsed.success) settings[key] = parsed.data;
    else invalidKeys.push(key);
  }

  return { settings: settings as Settings, invalidKeys };
}

function isPlainObject(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}
