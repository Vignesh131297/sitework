import { Injectable } from '@nestjs/common';
import {
  AttendanceService,
  type AttendanceView,
} from '../attendance/attendance.service.js';
import type { AuthUser } from '../auth/auth-user.js';
import { businessDate } from '../common/time/business-time.js';
import { Clock } from '../common/time/clock.js';
import { PrismaService } from '../prisma/prisma.service.js';
import { SettingsService } from '../settings/settings.service.js';
import {
  DayActivityService,
  type StaffDaySlot,
} from './day-activity.service.js';
import { slotWindows } from './slot-status.js';

export interface StaffToday {
  /** Server clock; the app shows times relative to it, never to the phone's clock. */
  serverTime: string;
  date: string;
  isWorkingDay: boolean;
  holiday: string | null;
  assignment: {
    site: {
      id: string;
      code: string;
      name: string;
      address: string;
      latitude: number | null;
      longitude: number | null;
      geofenceRadiusM: number | null;
    };
    engineer: { id: string; name: string; phone: string };
  } | null;
  attendance: AttendanceView | null;
  slots: StaffDaySlot[];
  rules: {
    requireCheckIn: boolean;
    allowGallery: boolean;
    locationRequired: boolean;
    fixTimeoutSeconds: number;
    maxUploadMb: number;
    offlineAcceptanceMinutes: number;
    defaultGeofenceRadiusM: number;
  };
}

/** Everything the staff home screen needs in one request. */
@Injectable()
export class StaffTodayService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly settings: SettingsService,
    private readonly dayActivity: DayActivityService,
    private readonly attendance: AttendanceService,
    private readonly clock: Clock,
  ) {}

  async today(user: AuthUser, now = this.clock.now()): Promise<StaffToday> {
    const settings = await this.settings.getAll();
    const date = businessDate(now, settings.business.timeZone);
    const [day, assignment, attendance] = await Promise.all([
      this.dayActivity.forDate(date, { staffId: user.id }, now),
      this.prisma.staffAssignment.findUnique({
        where: { staffId: user.id },
        select: {
          site: {
            select: {
              id: true,
              code: true,
              name: true,
              address: true,
              latitude: true,
              longitude: true,
              geofenceRadiusM: true,
            },
          },
          engineer: { select: { id: true, name: true, phone: true } },
        },
      }),
      this.attendance.today(user.id, date),
    ]);
    const slots =
      day.staff[0]?.slots ??
      slotWindows(date, settings).map((window) => ({
        slot: window.slot,
        state: 'NOT_EXPECTED' as const,
        start: window.start.toISOString(),
        end: window.end.toISOString(),
        closesAt: window.closesAt.toISOString(),
        update: null,
      }));
    return {
      serverTime: now.toISOString(),
      date,
      isWorkingDay: day.isWorkingDay,
      holiday: day.holiday,
      assignment,
      attendance,
      slots,
      rules: {
        requireCheckIn: settings.updates.requireCheckIn,
        allowGallery: settings.updates.allowGallery,
        locationRequired: settings.location.required,
        fixTimeoutSeconds: settings.location.fixTimeoutSeconds,
        maxUploadMb: settings.images.maxUploadMb,
        offlineAcceptanceMinutes: settings.updates.offlineAcceptanceMinutes,
        defaultGeofenceRadiusM: settings.location.defaultGeofenceRadiusM,
      },
    };
  }
}
