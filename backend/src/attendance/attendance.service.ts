import { Injectable } from '@nestjs/common';
import type { AuthUser } from '../auth/auth-user.js';
import { staffRecordScope } from '../common/access/access-scope.js';
import { AuditService } from '../common/audit/audit.service.js';
import { ErrorCode } from '../common/errors/error-codes.js';
import {
  badRequest,
  conflict,
  notFound,
} from '../common/errors/http-errors.js';
import {
  checkLocation,
  type ReportedLocation,
} from '../common/location/geo.js';
import { Paginated } from '../common/pagination/paginated.js';
import {
  addMinutes,
  businessDate,
  formatTime,
  fromDbDate,
  toDbDate,
  zonedInstant,
} from '../common/time/business-time.js';
import { Clock } from '../common/time/clock.js';
import type { Prisma } from '../generated/prisma/client.js';
import type {
  AttendanceStatus,
  LocationFlag,
} from '../generated/prisma/enums.js';
import { PrismaService } from '../prisma/prisma.service.js';
import { CalendarService } from '../settings/calendar.service.js';
import { SettingsService } from '../settings/settings.service.js';
import type {
  AttendanceQueryDto,
  CorrectAttendanceDto,
  MarkAttendanceDto,
} from './attendance.dto.js';

export interface AttendanceView {
  id: string;
  workDate: string;
  status: AttendanceStatus;
  staff: { id: string; name: string };
  site: { id: string; name: string };
  checkInAt: string | null;
  checkInLocationFlag: LocationFlag | null;
  checkOutAt: string | null;
  checkOutLocationFlag: LocationFlag | null;
  /** Between check-in and check-out, when both exist. */
  workedMinutes: number | null;
  correctionNote: string | null;
}

const VIEW_INCLUDE = {
  staff: { select: { id: true, name: true } },
  site: { select: { id: true, name: true } },
} as const satisfies Prisma.AttendanceInclude;

type AttendanceRow = Prisma.AttendanceGetPayload<{
  include: typeof VIEW_INCLUDE;
}>;

@Injectable()
export class AttendanceService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly settings: SettingsService,
    private readonly calendar: CalendarService,
    private readonly audit: AuditService,
    private readonly clock: Clock,
  ) {}

  /** Staff check-in for today (server clock). Late after shift start + allowance. */
  async checkIn(
    user: AuthUser,
    reported: ReportedLocation,
    now = this.clock.now(),
  ): Promise<AttendanceView> {
    const settings = await this.settings.getAll();
    const zone = settings.business.timeZone;
    const date = businessDate(now, zone);
    if (!(await this.calendar.isWorkingDay(date))) {
      throw badRequest(
        ErrorCode.NOT_A_WORKING_DAY,
        'Today is not a working day.',
      );
    }
    const assignment = await this.prisma.staffAssignment.findUnique({
      where: { staffId: user.id },
      select: {
        site: {
          select: {
            id: true,
            latitude: true,
            longitude: true,
            geofenceRadiusM: true,
          },
        },
      },
    });
    if (!assignment) {
      throw badRequest(
        ErrorCode.NOT_ASSIGNED_TO_SITE,
        'You are not assigned to a site yet. Please contact your engineer.',
      );
    }
    const workDate = toDbDate(date);
    const existing = await this.prisma.attendance.findUnique({
      where: { staffId_workDate: { staffId: user.id, workDate } },
    });
    if (existing?.checkInAt) {
      throw conflict(
        ErrorCode.ALREADY_CHECKED_IN,
        `You already checked in at ${formatTime(existing.checkInAt, zone)}.`,
      );
    }

    const location = checkLocation(
      reported,
      assignment.site,
      settings.location,
    );
    const lateAfter = addMinutes(
      zonedInstant(date, settings.attendance.shiftStart, zone),
      settings.attendance.lateAfterMinutes,
    );
    const data = {
      siteId: assignment.site.id,
      status: (now > lateAfter ? 'LATE' : 'PRESENT') as AttendanceStatus,
      checkInAt: now,
      checkInLatitude: location.latitude,
      checkInLongitude: location.longitude,
      checkInAccuracyM: location.accuracyM,
      checkInLocationFlag: location.flag,
    };
    try {
      const row = existing
        ? // A day marked absent in advance becomes a normal day once they turn up.
          await this.prisma.attendance.update({
            where: { id: existing.id },
            data,
            include: VIEW_INCLUDE,
          })
        : await this.prisma.attendance.create({
            data: { ...data, staffId: user.id, workDate },
            include: VIEW_INCLUDE,
          });
      return toView(row);
    } catch (error) {
      if ((error as { code?: string }).code === 'P2002') {
        throw conflict(
          ErrorCode.ALREADY_CHECKED_IN,
          'You have already checked in today.',
        );
      }
      throw error;
    }
  }

  /** Check-out never blocks on location (people must be able to leave). */
  async checkOut(
    user: AuthUser,
    reported: ReportedLocation,
    now = this.clock.now(),
  ): Promise<AttendanceView> {
    const settings = await this.settings.getAll();
    const date = businessDate(now, settings.business.timeZone);
    const record = await this.prisma.attendance.findUnique({
      where: {
        staffId_workDate: { staffId: user.id, workDate: toDbDate(date) },
      },
      include: {
        site: {
          select: { latitude: true, longitude: true, geofenceRadiusM: true },
        },
      },
    });
    if (!record?.checkInAt)
      throw badRequest(
        ErrorCode.NOT_CHECKED_IN,
        "You haven't checked in today.",
      );
    if (record.checkOutAt) {
      throw conflict(
        ErrorCode.ALREADY_CHECKED_OUT,
        `You already checked out at ${formatTime(record.checkOutAt, settings.business.timeZone)}.`,
      );
    }
    const location = checkLocation(
      reported,
      record.site,
      { ...settings.location, required: false },
      { enforce: false },
    );
    const workedHours =
      (now.getTime() - record.checkInAt.getTime()) / 3_600_000;
    const row = await this.prisma.attendance.update({
      where: { id: record.id },
      data: {
        status:
          workedHours < settings.attendance.halfDayMinHours
            ? 'HALF_DAY'
            : record.status,
        checkOutAt: now,
        checkOutLatitude: location.latitude,
        checkOutLongitude: location.longitude,
        checkOutAccuracyM: location.accuracyM,
        checkOutLocationFlag: location.flag,
      },
      include: VIEW_INCLUDE,
    });
    return toView(row);
  }

  async today(staffId: string, date: string): Promise<AttendanceView | null> {
    const row = await this.prisma.attendance.findUnique({
      where: { staffId_workDate: { staffId, workDate: toDbDate(date) } },
      include: VIEW_INCLUDE,
    });
    return row ? toView(row) : null;
  }

  async list(
    user: AuthUser,
    query: AttendanceQueryDto,
  ): Promise<Paginated<AttendanceView>> {
    const where: Prisma.AttendanceWhereInput = {
      AND: [
        staffRecordScope(user),
        query.date ? { workDate: toDbDate(query.date) } : {},
        query.from ? { workDate: { gte: toDbDate(query.from) } } : {},
        query.to ? { workDate: { lte: toDbDate(query.to) } } : {},
        query.siteId ? { siteId: query.siteId } : {},
        query.staffId ? { staffId: query.staffId } : {},
        query.status ? { status: query.status } : {},
        query.search
          ? { staff: { name: { contains: query.search, mode: 'insensitive' } } }
          : {},
      ],
    };
    const [rows, total] = await Promise.all([
      this.prisma.attendance.findMany({
        where,
        include: VIEW_INCLUDE,
        orderBy: [{ workDate: 'desc' }, { staff: { name: 'asc' } }],
        skip: query.skip,
        take: query.limit,
      }),
      this.prisma.attendance.count({ where }),
    ]);
    return new Paginated(rows.map(toView), query.page, query.limit, total);
  }

  async correct(
    actor: AuthUser,
    id: string,
    dto: CorrectAttendanceDto,
  ): Promise<AttendanceView> {
    const record = await this.prisma.attendance.findUnique({ where: { id } });
    if (!record) throw notFound('attendance record');
    const checkInAt =
      dto.checkInAt === undefined
        ? record.checkInAt
        : dto.checkInAt
          ? new Date(dto.checkInAt)
          : null;
    const checkOutAt =
      dto.checkOutAt === undefined
        ? record.checkOutAt
        : dto.checkOutAt
          ? new Date(dto.checkOutAt)
          : null;
    checkTimes(checkInAt, checkOutAt);
    const row = await this.prisma.$transaction(async (tx) => {
      const updated = await tx.attendance.update({
        where: { id },
        data: {
          status: dto.status,
          checkInAt,
          checkOutAt,
          correctedById: actor.id,
          correctionNote: dto.note.trim(),
        },
        include: VIEW_INCLUDE,
      });
      await this.audit.record(
        {
          actorId: actor.id,
          action: 'attendance.corrected',
          entityType: 'Attendance',
          entityId: id,
          changes: {
            before: {
              status: record.status,
              checkInAt: record.checkInAt?.toISOString() ?? null,
              checkOutAt: record.checkOutAt?.toISOString() ?? null,
            },
            after: {
              status: updated.status,
              checkInAt: updated.checkInAt?.toISOString() ?? null,
              checkOutAt: updated.checkOutAt?.toISOString() ?? null,
            },
            note: dto.note.trim(),
          },
        },
        tx,
      );
      return updated;
    });
    return toView(row);
  }

  async mark(actor: AuthUser, dto: MarkAttendanceDto): Promise<AttendanceView> {
    const staff = await this.prisma.user.findFirst({
      where: { id: dto.staffId, role: 'STAFF' },
      select: { staffAssignment: { select: { siteId: true } } },
    });
    if (!staff) throw notFound('staff member');
    if (!staff.staffAssignment) {
      throw badRequest(
        ErrorCode.NOT_ASSIGNED_TO_SITE,
        'Assign them to a site before recording attendance.',
      );
    }
    const checkInAt = dto.checkInAt ? new Date(dto.checkInAt) : null;
    const checkOutAt = dto.checkOutAt ? new Date(dto.checkOutAt) : null;
    checkTimes(checkInAt, checkOutAt);
    try {
      const row = await this.prisma.$transaction(async (tx) => {
        const created = await tx.attendance.create({
          data: {
            staffId: dto.staffId,
            siteId: staff.staffAssignment!.siteId,
            workDate: toDbDate(dto.date),
            status: dto.status,
            checkInAt,
            checkOutAt,
            correctedById: actor.id,
            correctionNote: dto.note.trim(),
          },
          include: VIEW_INCLUDE,
        });
        await this.audit.record(
          {
            actorId: actor.id,
            action: 'attendance.marked',
            entityType: 'Attendance',
            entityId: created.id,
            changes: { ...dto, note: dto.note.trim() },
          },
          tx,
        );
        return created;
      });
      return toView(row);
    } catch (error) {
      if ((error as { code?: string }).code === 'P2002') {
        throw conflict(
          ErrorCode.CONFLICT,
          'There is already a record for that day. Edit it instead.',
        );
      }
      throw error;
    }
  }

  /**
   * End of a working day: assigned staff with no record are marked absent. Run by
   * a job; safe to run more than once.
   */
  async markAbsentees(date: string): Promise<number> {
    if (!(await this.calendar.isWorkingDay(date))) return 0;
    const workDate = toDbDate(date);
    const assignments = await this.prisma.staffAssignment.findMany({
      where: { staff: { isActive: true, attendance: { none: { workDate } } } },
      select: { staffId: true, siteId: true },
    });
    const { count } = await this.prisma.attendance.createMany({
      data: assignments.map((a) => ({
        staffId: a.staffId,
        siteId: a.siteId,
        workDate,
        status: 'ABSENT' as const,
      })),
      skipDuplicates: true,
    });
    return count;
  }
}

function checkTimes(checkInAt: Date | null, checkOutAt: Date | null): void {
  if (checkOutAt && !checkInAt) {
    throw badRequest(
      ErrorCode.VALIDATION_FAILED,
      'A check-out needs a check-in time.',
      'checkOutAt',
    );
  }
  if (checkInAt && checkOutAt && checkOutAt <= checkInAt) {
    throw badRequest(
      ErrorCode.VALIDATION_FAILED,
      'Check-out must be after check-in.',
      'checkOutAt',
    );
  }
}

export function toView(row: AttendanceRow): AttendanceView {
  return {
    id: row.id,
    workDate: fromDbDate(row.workDate),
    status: row.status,
    staff: row.staff,
    site: row.site,
    checkInAt: row.checkInAt?.toISOString() ?? null,
    checkInLocationFlag: row.checkInLocationFlag,
    checkOutAt: row.checkOutAt?.toISOString() ?? null,
    checkOutLocationFlag: row.checkOutLocationFlag,
    workedMinutes:
      row.checkInAt && row.checkOutAt
        ? Math.round(
            (row.checkOutAt.getTime() - row.checkInAt.getTime()) / 60_000,
          )
        : null,
    correctionNote: row.correctionNote,
  };
}
