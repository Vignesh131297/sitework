import { Injectable } from '@nestjs/common';
import {
  addMinutes,
  toDbDate,
  zonedInstant,
} from '../common/time/business-time.js';
import type { Prisma } from '../generated/prisma/client.js';
import type {
  AttendanceStatus,
  Designation,
  ImageStatus,
  TimeSlot,
} from '../generated/prisma/enums.js';
import { PrismaService } from '../prisma/prisma.service.js';
import { staffOnLeave } from '../requests/request-common.js';
import { CalendarService } from '../settings/calendar.service.js';
import { SettingsService } from '../settings/settings.service.js';
import { slotState, slotWindows, type SlotState } from './slot-status.js';

export interface StaffDaySlot {
  slot: TimeSlot;
  state: SlotState;
  start: string;
  end: string;
  closesAt: string;
  update: {
    id: string;
    submittedAt: string;
    submittedOffline: boolean;
    imageStatus: ImageStatus;
    engineerViewedAt: string | null;
    adminViewedAt: string | null;
  } | null;
}

export interface StaffDay {
  staff: {
    id: string;
    name: string;
    phone: string;
    designation: Designation | null;
  };
  site: { id: string; name: string };
  engineer: { id: string; name: string };
  attendance: {
    status: AttendanceStatus;
    checkInAt: string | null;
    checkOutAt: string | null;
  } | null;
  /** True once the shift's late threshold has passed without a check-in. */
  notCheckedIn: boolean;
  /** Approved leave that day and not checked in: no check-in or updates expected. */
  onLeave: boolean;
  slots: StaffDaySlot[];
}

export interface DayActivity {
  date: string;
  isWorkingDay: boolean;
  holiday: string | null;
  staff: StaffDay[];
}

export interface DayTotals {
  expected: number;
  submitted: number;
  missing: number;
  pending: number;
  upcoming: number;
  notCheckedIn: number;
}

/**
 * Every assigned staff member's slots for one business date, judged by the server
 * clock. A slot is owed only by someone checked in before it closed (decision 10):
 * staff who never check in are absent, not "missing updates", and someone who
 * arrives after a window has closed could not have sent that update.
 */
@Injectable()
export class DayActivityService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly settings: SettingsService,
    private readonly calendar: CalendarService,
  ) {}

  async forDate(
    date: string,
    where: Prisma.StaffAssignmentWhereInput = {},
    now: Date = new Date(),
  ): Promise<DayActivity> {
    const settings = await this.settings.getAll();
    const [isWorkingDay, holiday] = await Promise.all([
      this.calendar.isWorkingDay(date),
      this.calendar.holidayName(date),
    ]);
    const windows = slotWindows(date, settings);
    const lateAfter = addMinutes(
      zonedInstant(
        date,
        settings.attendance.shiftStart,
        settings.business.timeZone,
      ),
      settings.attendance.lateAfterMinutes,
    );

    const assignments = await this.prisma.staffAssignment.findMany({
      where: { ...where, staff: { isActive: true } },
      select: {
        staff: {
          select: { id: true, name: true, phone: true, designation: true },
        },
        site: { select: { id: true, name: true } },
        engineer: { select: { id: true, name: true } },
      },
      orderBy: [{ site: { name: 'asc' } }, { staff: { name: 'asc' } }],
    });
    const staffIds = assignments.map((a) => a.staff.id);
    const workDate = toDbDate(date);
    const [updates, attendance, leave] = await Promise.all([
      this.prisma.staffUpdate.findMany({
        where: { workDate, staffId: { in: staffIds } },
        select: {
          id: true,
          staffId: true,
          slot: true,
          submittedAt: true,
          submittedOffline: true,
          imageStatus: true,
          engineerViewedAt: true,
          adminViewedAt: true,
        },
      }),
      this.prisma.attendance.findMany({
        where: { workDate, staffId: { in: staffIds } },
        select: {
          staffId: true,
          status: true,
          checkInAt: true,
          checkOutAt: true,
        },
      }),
      staffOnLeave(this.prisma, staffIds, date),
    ]);
    const updateByKey = new Map(
      updates.map((u) => [`${u.staffId}:${u.slot}`, u]),
    );
    const attendanceByStaff = new Map(attendance.map((a) => [a.staffId, a]));

    const staff = assignments.map((assignment): StaffDay => {
      const record = attendanceByStaff.get(assignment.staff.id);
      const checkedIn = Boolean(record?.checkInAt);
      // Someone on leave who turns up anyway works a normal day.
      const onLeave =
        !checkedIn &&
        (record?.status === 'ON_LEAVE' || leave.has(assignment.staff.id));
      const absent = record?.status === 'ABSENT' || onLeave;
      return {
        staff: assignment.staff,
        site: assignment.site,
        engineer: assignment.engineer,
        attendance: record
          ? {
              status: record.status,
              checkInAt: record.checkInAt?.toISOString() ?? null,
              checkOutAt: record.checkOutAt?.toISOString() ?? null,
            }
          : null,
        notCheckedIn: isWorkingDay && !checkedIn && !onLeave && now > lateAfter,
        onLeave,
        slots: windows.map((window) => {
          const update = updateByKey.get(
            `${assignment.staff.id}:${window.slot}`,
          );
          const checkedInInTime = record?.checkInAt
            ? record.checkInAt <= window.closesAt
            : false;
          const expected =
            isWorkingDay &&
            !absent &&
            (!settings.updates.requireCheckIn ||
              checkedInInTime ||
              (!checkedIn && now <= window.closesAt));
          return {
            slot: window.slot,
            state: slotState({
              window,
              submitted: Boolean(update),
              expected,
              now,
            }),
            start: window.start.toISOString(),
            end: window.end.toISOString(),
            closesAt: window.closesAt.toISOString(),
            update: update
              ? {
                  id: update.id,
                  submittedAt: update.submittedAt.toISOString(),
                  submittedOffline: update.submittedOffline,
                  imageStatus: update.imageStatus,
                  engineerViewedAt:
                    update.engineerViewedAt?.toISOString() ?? null,
                  adminViewedAt: update.adminViewedAt?.toISOString() ?? null,
                }
              : null,
          };
        }),
      };
    });
    return { date, isWorkingDay, holiday, staff };
  }
}

export function dayTotals(staff: StaffDay[]): DayTotals {
  const totals: DayTotals = {
    expected: 0,
    submitted: 0,
    missing: 0,
    pending: 0,
    upcoming: 0,
    notCheckedIn: 0,
  };
  for (const person of staff) {
    if (person.notCheckedIn) totals.notCheckedIn += 1;
    for (const slot of person.slots) {
      if (slot.state === 'NOT_EXPECTED') continue;
      totals.expected += 1;
      if (slot.state === 'SUBMITTED') totals.submitted += 1;
      if (slot.state === 'MISSING') totals.missing += 1;
      if (slot.state === 'PENDING') totals.pending += 1;
      if (slot.state === 'UPCOMING') totals.upcoming += 1;
    }
  }
  return totals;
}
