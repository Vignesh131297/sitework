import { formatInr, type Paise } from '../common/money/money.js';
import { formatShortDate, formatTime } from '../common/time/business-time.js';
import type {
  EngineerUpdateType,
  Priority,
  TimeSlot,
} from '../generated/prisma/enums.js';
import { summarizeLines } from '../stock/stock-ledger.js';

/** Notification wording in one place, shared by the API and the seed data. */

export interface NotificationText {
  title: string;
  message: string;
}

export const SLOT_LABEL: Record<TimeSlot, string> = {
  MORNING: 'Morning',
  AFTERNOON: 'Afternoon',
  EVENING: 'Evening',
};

const ENGINEER_UPDATE_LABEL: Record<EngineerUpdateType, string> = {
  PROGRESS: 'site progress update',
  COMPLETED_WORK: 'completed work update',
  MATERIALS_REQUIRED: 'materials request',
  SAFETY_CONCERN: 'safety concern',
  CLIENT_REQUIREMENT: 'client requirement',
  REMARK: 'remark',
  DAILY_REPORT: 'daily report',
};

export function staffUpdateSubmitted(input: {
  staffName: string;
  slot: TimeSlot;
  siteName: string;
  submittedAt: Date;
  timeZone: string;
}): NotificationText {
  return {
    title: `${input.staffName} submitted ${SLOT_LABEL[input.slot]} Update`,
    message: `${input.siteName} · ${formatTime(input.submittedAt, input.timeZone)}`,
  };
}

export function updatesMissed(input: {
  staffNames: readonly string[];
  slot: TimeSlot;
  siteName: string;
  date: string;
}): NotificationText {
  const slot = SLOT_LABEL[input.slot];
  if (input.staffNames.length === 1) {
    return {
      title: `${input.staffNames[0]} has not submitted the ${slot} Update`,
      message: `${input.siteName} · ${formatShortDate(input.date)}`,
    };
  }
  return {
    title: `${input.staffNames.length} staff missed the ${slot} Update`,
    message: `${input.siteName} · ${input.staffNames.join(', ')}`,
  };
}

export function engineerUpdateSubmitted(input: {
  engineerName: string;
  type: EngineerUpdateType;
  siteName: string;
}): NotificationText {
  return {
    title: `Engineer ${input.engineerName} submitted a ${ENGINEER_UPDATE_LABEL[input.type]}`,
    message: input.siteName,
  };
}

export function issueReported(input: {
  title: string;
  priority: Priority;
  siteName: string;
  reporterName: string;
}): NotificationText {
  return {
    title: `New ${input.priority.toLowerCase()} issue: ${input.title}`,
    message: `${input.siteName} · reported by ${input.reporterName}`,
  };
}

export function issueResolved(input: {
  title: string;
  siteName: string;
}): NotificationText {
  return { title: `Issue resolved: ${input.title}`, message: input.siteName };
}

export function milestoneOverdue(input: {
  milestoneTitle: string;
  siteName: string;
  outstanding: Paise;
  dueDate: string;
}): NotificationText {
  return {
    title: `Payment overdue: ${input.milestoneTitle}`,
    message: `${input.siteName} · ${formatInr(input.outstanding)} due since ${formatShortDate(input.dueDate)}`,
  };
}

export function updateReminder(input: {
  slot: TimeSlot;
  closesAt: Date;
  timeZone: string;
}): NotificationText {
  return {
    title: `${SLOT_LABEL[input.slot]} Update due by ${formatTime(input.closesAt, input.timeZone)}`,
    message: 'Take a photo of your work and send it.',
  };
}

/** One summary per site and slot, for admins who chose digests over each update. */
export function slotSummary(input: {
  slot: TimeSlot;
  siteName: string;
  submitted: number;
  expected: number;
}): NotificationText {
  return {
    title: `${SLOT_LABEL[input.slot]} Updates: ${input.submitted} of ${input.expected} submitted`,
    message: input.siteName,
  };
}

/**
 * Stock sent between godowns and sites, for whoever confirms it at the other
 * end (and admins, when an engineer sent it).
 */
export function stockSent(input: {
  toName: string;
  fromName: string;
  items: readonly string[];
  byName: string;
}): NotificationText {
  return {
    title: `Stock on the way to ${input.toName}`,
    message: `${summarizeLines(input.items)} · from ${input.fromName} by ${input.byName}`,
  };
}

/** One line per material that came up short, e.g. "Cement: 58 of 60 bag". */
export function stockShort(input: {
  placeName: string;
  items: readonly string[];
}): NotificationText {
  return {
    title: `Short delivery at ${input.placeName}`,
    message: `${summarizeLines(input.items)} arrived`,
  };
}

export function stockWrittenOff(input: {
  placeName: string;
  items: readonly string[];
  note: string;
  byName: string;
}): NotificationText {
  return {
    title: `Stock written off at ${input.placeName}`,
    message: `${summarizeLines(input.items)} · ${input.note} · by ${input.byName}`,
  };
}

export function stockLow(input: {
  material: string;
  left: string;
  minimum: string;
}): NotificationText {
  return {
    title: `Low stock: ${input.material}`,
    message: `${input.left} left in the godowns (minimum ${input.minimum})`,
  };
}

/** Evening nudge to a site's engineers when no usage was recorded that day. */
export function stockUsageReminder(input: {
  siteName: string;
}): NotificationText {
  return {
    title: `Record today's material use at ${input.siteName}`,
    message: 'No usage has been entered for today yet.',
  };
}

/** A new material request, for admins to approve. */
export function requestCreated(input: {
  code: string;
  siteName: string;
  byName: string;
  items: readonly string[];
}): NotificationText {
  return {
    title: `${input.code}: material request from ${input.siteName}`,
    message: `${summarizeLines(input.items)} · by ${input.byName}`,
  };
}

/** For the site: approved, and who sends it. */
export function requestApproved(input: {
  code: string;
  godownName: string;
}): NotificationText {
  return {
    title: `${input.code} approved`,
    message: `${input.godownName} will send it.`,
  };
}

/** For the godown's managers: an approved request to send. */
export function requestToSend(input: {
  code: string;
  siteName: string;
  items: readonly string[];
}): NotificationText {
  return {
    title: `Send ${input.code} to ${input.siteName}`,
    message: summarizeLines(input.items),
  };
}

export function requestRejected(input: {
  code: string;
  reason: string;
}): NotificationText {
  return { title: `${input.code} rejected`, message: input.reason };
}

export function requestClosed(input: {
  code: string;
  siteName: string;
  leftover: boolean;
}): NotificationText {
  return {
    title: `${input.code} closed at ${input.siteName}`,
    message: input.leftover
      ? 'Leftover sent back to the godown.'
      : 'All of it was used.',
  };
}
