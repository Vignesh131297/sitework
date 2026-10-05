import { DateTime } from 'luxon';

/**
 * Business-date helpers. All business rules (work date, slot windows, shift start)
 * are evaluated in the configured business time zone using the server clock, never
 * the phone's. Business dates travel as ISO strings (YYYY-MM-DD).
 */

export function isValidTimeZone(timeZone: string): boolean {
  return DateTime.now().setZone(timeZone).isValid;
}

/** Calendar date of an instant in the business time zone. */
export function businessDate(instant: Date, timeZone: string): string {
  return valid(DateTime.fromJSDate(instant, { zone: timeZone })).toISODate()!;
}

/** The instant at which a wall-clock time ("HH:mm") occurs on a business date. */
export function zonedInstant(
  date: string,
  time: string,
  timeZone: string,
): Date {
  return valid(
    DateTime.fromISO(`${date}T${time}`, { zone: timeZone }),
  ).toJSDate();
}

/** Prisma maps DATE columns to JS Dates at UTC midnight. */
export function toDbDate(date: string): Date {
  return valid(DateTime.fromISO(date, { zone: 'utc' })).toJSDate();
}

export function fromDbDate(value: Date): string {
  return value.toISOString().slice(0, 10);
}

export function addDays(date: string, days: number): string {
  return valid(DateTime.fromISO(date, { zone: 'utc' }))
    .plus({ days })
    .toISODate()!;
}

export function addMinutes(instant: Date, minutes: number): Date {
  return new Date(instant.getTime() + minutes * 60_000);
}

/** ISO weekday: 1 = Monday … 7 = Sunday. */
export function isoWeekday(date: string): number {
  return valid(DateTime.fromISO(date, { zone: 'utc' })).weekday;
}

export function isWorkingDay(
  date: string,
  workingDays: readonly number[],
  holidays: ReadonlySet<string>,
): boolean {
  return workingDays.includes(isoWeekday(date)) && !holidays.has(date);
}

/** e.g. "10:42 AM" */
export function formatTime(instant: Date, timeZone: string): string {
  return DateTime.fromJSDate(instant, { zone: timeZone }).toFormat('h:mm a');
}

/** e.g. "Sat 3 Oct" */
export function formatShortDate(date: string): string {
  return valid(DateTime.fromISO(date, { zone: 'utc' })).toFormat('ccc d LLL');
}

function valid(value: DateTime): DateTime {
  if (!value.isValid) {
    throw new Error(
      `Invalid date/time: ${value.invalidExplanation ?? value.invalidReason}`,
    );
  }
  return value;
}
