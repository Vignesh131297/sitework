import { addMinutes, zonedInstant } from '../common/time/business-time.js';
import type { TimeSlot } from '../generated/prisma/enums.js';
import type { Settings } from '../settings/settings.schema.js';

/**
 * UPCOMING     the window hasn't opened yet
 * PENDING      the window is open (or within the grace period after it)
 * SUBMITTED    an update exists
 * MISSING      the window and grace have passed with no update
 * NOT_EXPECTED no update is due (not a working day, or not assigned)
 */
export type SlotState =
  'UPCOMING' | 'PENDING' | 'SUBMITTED' | 'MISSING' | 'NOT_EXPECTED';

export interface SlotWindow {
  slot: TimeSlot;
  start: Date;
  end: Date;
  /** End plus the configured grace: after this an unsubmitted slot is missing. */
  closesAt: Date;
}

/** The three windows of a business date, as instants (server clock, business time zone). */
export function slotWindows(
  date: string,
  settings: Pick<Settings, 'business' | 'updates'>,
): SlotWindow[] {
  const zone = settings.business.timeZone;
  return settings.updates.slots.map((window) => {
    const end = zonedInstant(date, window.end, zone);
    return {
      slot: window.slot,
      start: zonedInstant(date, window.start, zone),
      end,
      closesAt: addMinutes(end, settings.updates.lateGraceMinutes),
    };
  });
}

export function slotState(input: {
  window: SlotWindow;
  submitted: boolean;
  expected: boolean;
  now: Date;
}): SlotState {
  if (input.submitted) return 'SUBMITTED';
  if (!input.expected) return 'NOT_EXPECTED';
  if (input.now < input.window.start) return 'UPCOMING';
  if (input.now <= input.window.closesAt) return 'PENDING';
  return 'MISSING';
}
