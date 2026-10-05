import { formatInr, type Paise } from '../common/money/money.js';
import { formatShortDate, formatTime } from '../common/time/business-time.js';
import type {
  EngineerUpdateType,
  Priority,
  TimeSlot,
} from '../generated/prisma/enums.js';

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
