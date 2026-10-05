import { HttpStatus, Injectable, Logger } from '@nestjs/common';
import { randomUUID } from 'node:crypto';
import type { AuthUser } from '../auth/auth-user.js';
import { staffRecordScope } from '../common/access/access-scope.js';
import { AppException } from '../common/errors/app.exception.js';
import { ErrorCode } from '../common/errors/error-codes.js';
import {
  badRequest,
  conflict,
  notFound,
} from '../common/errors/http-errors.js';
import { checkLocation } from '../common/location/geo.js';
import { Paginated } from '../common/pagination/paginated.js';
import {
  addMinutes,
  businessDate,
  formatTime,
  fromDbDate,
  toDbDate,
} from '../common/time/business-time.js';
import { Clock } from '../common/time/clock.js';
import type { Prisma } from '../generated/prisma/client.js';
import type {
  Designation,
  ImageDeleteReason,
  ImageStatus,
  LocationFlag,
  PhotoSource,
  TimeSlot,
} from '../generated/prisma/enums.js';
import { processPhoto } from '../images/image-processor.js';
import {
  SLOT_LABEL,
  staffUpdateSubmitted,
} from '../notifications/notification-messages.js';
import { NotificationsService } from '../notifications/notifications.service.js';
import { PrismaService } from '../prisma/prisma.service.js';
import { CalendarService } from '../settings/calendar.service.js';
import type { Settings } from '../settings/settings.schema.js';
import { SettingsService } from '../settings/settings.service.js';
import {
  StorageProvider,
  staffPhotoFolder,
} from '../storage/storage.provider.js';
import { slotWindows } from './slot-status.js';
import type {
  CreateStaffUpdateDto,
  StaffUpdateQueryDto,
  UploadedPhoto,
} from './staff-updates.dto.js';

export interface StaffUpdateView {
  id: string;
  workDate: string;
  slot: TimeSlot;
  description: string;
  staff: { id: string; name: string; designation: Designation | null };
  site: { id: string; name: string };
  engineer: { id: string; name: string };
  /** Server time of arrival: the time that counts. */
  submittedAt: string;
  /** Phone time the photo was taken (informational). */
  capturedAt: string;
  submittedOffline: boolean;
  location: { flag: LocationFlag; distanceFromSiteM: number | null };
  photoSource: PhotoSource;
  image: {
    status: ImageStatus;
    /** When the photo will be deleted if nothing else happens first. */
    expiresAt: string;
    deletedAt: string | null;
    deleteReason: ImageDeleteReason | null;
  };
  engineerViewedAt: string | null;
  adminViewedAt: string | null;
}

const VIEW_INCLUDE = {
  staff: { select: { id: true, name: true, designation: true } },
  site: { select: { id: true, name: true } },
  engineer: { select: { id: true, name: true } },
} as const satisfies Prisma.StaffUpdateInclude;

type StaffUpdateRow = Prisma.StaffUpdateGetPayload<{
  include: typeof VIEW_INCLUDE;
}>;

/** Phone clocks may run a little fast; anything later than this is refused. */
const CLOCK_SKEW_MINUTES = 2;
/** Arriving later than this after capture marks an update as sent offline. */
const OFFLINE_AFTER_MINUTES = 5;
/** Signed photo links are short-lived; the viewer asks again if needed. */
const IMAGE_URL_TTL_SECONDS = 300;

@Injectable()
export class StaffUpdatesService {
  private readonly logger = new Logger(StaffUpdatesService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly settings: SettingsService,
    private readonly calendar: CalendarService,
    private readonly storage: StorageProvider,
    private readonly notifications: NotificationsService,
    private readonly clock: Clock,
  ) {}

  /**
   * A staff member's photo update for one slot. Every rule is judged on the
   * server: the slot window (server clock, business time zone), check-in,
   * assignment and location. A retry with the same clientSubmissionId returns
   * the update already saved instead of failing.
   */
  async submit(
    user: AuthUser,
    dto: CreateStaffUpdateDto,
    photo: UploadedPhoto | undefined,
    now = this.clock.now(),
  ): Promise<{ update: StaffUpdateView; created: boolean }> {
    const earlier = await this.findRetry(user, dto.clientSubmissionId);
    if (earlier) return { update: earlier, created: false };

    const settings = await this.settings.getAll();
    const zone = settings.business.timeZone;
    const capturedAt = captureTime(dto.capturedAt, now);
    const date = businessDate(capturedAt, zone);
    const label = SLOT_LABEL[dto.slot];
    const window = slotWindows(date, settings).find(
      (w) => w.slot === dto.slot,
    )!;
    if (capturedAt < window.start) {
      throw badRequest(
        ErrorCode.SLOT_NOT_OPEN,
        `The ${label} update opens at ${formatTime(window.start, zone)}.`,
      );
    }
    if (capturedAt > window.closesAt) {
      throw badRequest(
        ErrorCode.SLOT_CLOSED,
        `The ${label} update closed at ${formatTime(window.end, zone)}.`,
      );
    }
    // An offline capture taken inside the window is accepted for a while after it.
    if (
      now >
      addMinutes(window.closesAt, settings.updates.offlineAcceptanceMinutes)
    ) {
      throw badRequest(
        ErrorCode.SLOT_CLOSED,
        `This ${label} update arrived too late to be accepted.`,
      );
    }
    if (!(await this.calendar.isWorkingDay(date))) {
      throw badRequest(
        ErrorCode.NOT_A_WORKING_DAY,
        'No updates are needed on a holiday or day off.',
      );
    }

    const assignment = await this.prisma.staffAssignment.findUnique({
      where: { staffId: user.id },
      select: {
        staff: { select: { name: true } },
        site: {
          select: {
            id: true,
            name: true,
            latitude: true,
            longitude: true,
            geofenceRadiusM: true,
          },
        },
        engineerId: true,
      },
    });
    if (!assignment) {
      throw badRequest(
        ErrorCode.NOT_ASSIGNED_TO_SITE,
        'You are not assigned to a site yet. Please contact your engineer.',
      );
    }
    const workDate = toDbDate(date);
    if (settings.updates.requireCheckIn) {
      const attendance = await this.prisma.attendance.findUnique({
        where: { staffId_workDate: { staffId: user.id, workDate } },
        select: { checkInAt: true },
      });
      if (!attendance?.checkInAt)
        throw badRequest(
          ErrorCode.NOT_CHECKED_IN,
          'Check in first, then send your update.',
        );
    }
    const photoSource = dto.photoSource ?? 'CAMERA';
    if (photoSource === 'GALLERY' && !settings.updates.allowGallery) {
      throw badRequest(
        ErrorCode.GALLERY_NOT_ALLOWED,
        'Please take the photo with the camera.',
      );
    }
    const duplicate = await this.prisma.staffUpdate.findUnique({
      where: {
        staffId_siteId_workDate_slot: {
          staffId: user.id,
          siteId: assignment.site.id,
          workDate,
          slot: dto.slot,
        },
      },
      select: { id: true },
    });
    if (duplicate)
      throw conflict(
        ErrorCode.UPDATE_ALREADY_SUBMITTED,
        `You have already sent the ${label} update.`,
      );

    const location = checkLocation(dto, assignment.site, settings.location);
    if (!photo)
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Add a photo of the work.',
        'photo',
      );
    if (photo.size > settings.images.maxUploadMb * 1024 * 1024) {
      throw new AppException(
        ErrorCode.PAYLOAD_TOO_LARGE,
        `The photo is larger than ${settings.images.maxUploadMb} MB.`,
        HttpStatus.PAYLOAD_TOO_LARGE,
      );
    }
    const image = await processPhoto(photo.buffer);

    const key = `${staffPhotoFolder(date)}/${randomUUID()}.jpg`;
    await this.storage.put(key, image.buffer, image.mime);
    try {
      const row = await this.prisma.$transaction(async (tx) => {
        const created = await tx.staffUpdate.create({
          data: {
            clientSubmissionId: dto.clientSubmissionId,
            staffId: user.id,
            siteId: assignment.site.id,
            engineerId: assignment.engineerId,
            workDate,
            slot: dto.slot,
            description: dto.description,
            latitude: location.latitude,
            longitude: location.longitude,
            accuracyM: location.accuracyM,
            locationFlag: location.flag,
            distanceFromSiteM: location.distanceM,
            photoSource,
            capturedAt,
            submittedAt: now,
            submittedOffline:
              now > window.closesAt ||
              now.getTime() - capturedAt.getTime() >
                OFFLINE_AFTER_MINUTES * 60_000,
            imageKey: key,
            imageBytes: image.buffer.length,
            imageMime: image.mime,
            imageExpiresAt: addMinutes(now, settings.images.ttlHours * 60),
          },
          include: VIEW_INCLUDE,
        });
        // A late (offline) arrival clears a miss recorded meanwhile.
        await tx.missedUpdate.updateMany({
          where: {
            staffId: user.id,
            workDate,
            slot: dto.slot,
            resolvedAt: null,
          },
          data: { resolvedAt: now, resolvedByUpdateId: created.id },
        });
        await this.notifySubmitted(created, settings, tx);
        return created;
      });
      return { update: toView(row), created: true };
    } catch (error) {
      // Nothing points at the photo now; remove it (the orphan sweep is the backstop).
      await this.storage
        .delete([key])
        .catch((cleanup: Error) =>
          this.logger.warn(`Orphan photo ${key}: ${cleanup.message}`),
        );
      if ((error as { code?: string }).code === 'P2002') {
        const raced = await this.findRetry(user, dto.clientSubmissionId);
        if (raced) return { update: raced, created: false };
        throw conflict(
          ErrorCode.UPDATE_ALREADY_SUBMITTED,
          `You have already sent the ${label} update.`,
        );
      }
      throw error;
    }
  }

  async list(
    user: AuthUser,
    query: StaffUpdateQueryDto,
  ): Promise<Paginated<StaffUpdateView>> {
    const term = query.search;
    const where: Prisma.StaffUpdateWhereInput = {
      AND: [
        staffRecordScope(user),
        query.date ? { workDate: toDbDate(query.date) } : {},
        query.from ? { workDate: { gte: toDbDate(query.from) } } : {},
        query.to ? { workDate: { lte: toDbDate(query.to) } } : {},
        query.siteId ? { siteId: query.siteId } : {},
        query.staffId ? { staffId: query.staffId } : {},
        query.slot ? { slot: query.slot } : {},
        query.pendingReview ? pendingReview(user) : {},
        term
          ? {
              OR: [
                { description: { contains: term, mode: 'insensitive' } },
                { staff: { name: { contains: term, mode: 'insensitive' } } },
              ],
            }
          : {},
      ],
    };
    const [rows, total] = await Promise.all([
      this.prisma.staffUpdate.findMany({
        where,
        include: VIEW_INCLUDE,
        orderBy: [{ submittedAt: 'desc' }],
        skip: query.skip,
        take: query.limit,
      }),
      this.prisma.staffUpdate.count({ where }),
    ]);
    return new Paginated(rows.map(toView), query.page, query.limit, total);
  }

  async get(user: AuthUser, id: string): Promise<StaffUpdateView> {
    return toView(await this.findVisible(user, id));
  }

  /** A short-lived link to the photo. Reading it does not count as a review. */
  async imageUrl(
    user: AuthUser,
    id: string,
    now = this.clock.now(),
  ): Promise<{ url: string; expiresAt: string }> {
    const update = await this.findVisible(user, id);
    if (!update.imageKey || update.imageStatus === 'DELETED') {
      throw new AppException(
        ErrorCode.IMAGE_DELETED,
        'This photo has been deleted. Photos are removed once reviewed, or after a day.',
        HttpStatus.GONE,
      );
    }
    return {
      url: await this.storage.signedUrl(update.imageKey, IMAGE_URL_TTL_SECONDS),
      expiresAt: new Date(
        now.getTime() + IMAGE_URL_TTL_SECONDS * 1000,
      ).toISOString(),
    };
  }

  /**
   * Records that the photo was shown to a reviewer. Any admin counts as "the
   * admin"; only the engineer responsible when it was sent counts as "the
   * engineer". Once both have seen it, it is deleted after a short grace period.
   * Each step is a conditional update, so concurrent views cannot clash.
   */
  async recordView(
    user: AuthUser,
    id: string,
    now = this.clock.now(),
  ): Promise<StaffUpdateView> {
    const update = await this.findVisible(user, id);
    const settings = await this.settings.getAll();
    if (user.role === 'ADMIN') {
      await this.prisma.staffUpdate.updateMany({
        where: { id, adminViewedAt: null },
        data: { adminViewedAt: now, adminViewedById: user.id },
      });
    } else if (user.id === update.engineerId) {
      await this.prisma.staffUpdate.updateMany({
        where: { id, engineerViewedAt: null },
        data: { engineerViewedAt: now },
      });
    }
    await this.prisma.staffUpdate.updateMany({
      where: {
        id,
        imageStatus: 'AVAILABLE',
        engineerViewedAt: { not: null },
        adminViewedAt: { not: null },
      },
      data: {
        imageStatus: 'READY_FOR_DELETION',
        imageReadyAt: now,
        imageExpiresAt: addMinutes(now, settings.images.deleteGraceMinutes),
      },
    });
    return this.get(user, id);
  }

  private async findVisible(
    user: AuthUser,
    id: string,
  ): Promise<StaffUpdateRow> {
    const row = await this.prisma.staffUpdate.findFirst({
      where: { id, ...staffRecordScope(user) },
      include: VIEW_INCLUDE,
    });
    if (!row) throw notFound('update');
    return row;
  }

  private async findRetry(
    user: AuthUser,
    clientSubmissionId: string,
  ): Promise<StaffUpdateView | null> {
    const row = await this.prisma.staffUpdate.findUnique({
      where: { clientSubmissionId },
      include: VIEW_INCLUDE,
    });
    if (!row) return null;
    if (row.staffId !== user.id)
      throw conflict(
        ErrorCode.CONFLICT,
        'This submission id has already been used.',
      );
    return toView(row);
  }

  private async notifySubmitted(
    update: StaffUpdateRow,
    settings: Settings,
    db: Prisma.TransactionClient,
  ): Promise<void> {
    const recipients = [update.engineerId];
    if (settings.notifications.adminStaffUpdatePush === 'EACH')
      recipients.push(...(await this.notifications.adminIds(db)));
    await this.notifications.notify(
      [
        {
          recipientIds: recipients,
          type: 'STAFF_UPDATE',
          ...staffUpdateSubmitted({
            staffName: update.staff.name,
            slot: update.slot,
            siteName: update.site.name,
            submittedAt: update.submittedAt,
            timeZone: settings.business.timeZone,
          }),
          referenceType: 'STAFF_UPDATE',
          referenceId: update.id,
          data: {
            siteId: update.siteId,
            staffId: update.staffId,
            slot: update.slot,
          },
          dedupeKey: `staff-update:${update.id}`,
        },
      ],
      db,
    );
  }
}

/** Photos the caller still has to look at; their view is the one that counts. */
function pendingReview(user: AuthUser): Prisma.StaffUpdateWhereInput {
  switch (user.role) {
    case 'ADMIN':
      return { adminViewedAt: null, imageStatus: 'AVAILABLE' };
    case 'ENGINEER':
      return {
        engineerId: user.id,
        engineerViewedAt: null,
        imageStatus: 'AVAILABLE',
      };
    case 'STAFF':
      return {};
  }
}

/** The phone's capture time, refused when it is in the future; now when absent. */
function captureTime(value: string | undefined, now: Date): Date {
  if (!value) return now;
  const captured = new Date(value);
  if (captured.getTime() > now.getTime() + CLOCK_SKEW_MINUTES * 60_000) {
    throw badRequest(
      ErrorCode.VALIDATION_FAILED,
      "Your phone's clock is ahead of the correct time. Set it to automatic and try again.",
      'capturedAt',
    );
  }
  return captured > now ? now : captured;
}

export function toView(row: StaffUpdateRow): StaffUpdateView {
  return {
    id: row.id,
    workDate: fromDbDate(row.workDate),
    slot: row.slot,
    description: row.description,
    staff: row.staff,
    site: row.site,
    engineer: row.engineer,
    submittedAt: row.submittedAt.toISOString(),
    capturedAt: row.capturedAt.toISOString(),
    submittedOffline: row.submittedOffline,
    location: {
      flag: row.locationFlag,
      distanceFromSiteM: row.distanceFromSiteM,
    },
    photoSource: row.photoSource,
    image: {
      status: row.imageStatus,
      expiresAt: row.imageExpiresAt.toISOString(),
      deletedAt: row.imageDeletedAt?.toISOString() ?? null,
      deleteReason: row.imageDeleteReason,
    },
    engineerViewedAt: row.engineerViewedAt?.toISOString() ?? null,
    adminViewedAt: row.adminViewedAt?.toISOString() ?? null,
  };
}
