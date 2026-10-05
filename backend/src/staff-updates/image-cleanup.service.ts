import { Injectable, Logger } from '@nestjs/common';
import { addDays, businessDate } from '../common/time/business-time.js';
import { Clock } from '../common/time/clock.js';
import type { ImageStatus } from '../generated/prisma/enums.js';
import { PrismaService } from '../prisma/prisma.service.js';
import { SettingsService } from '../settings/settings.service.js';
import {
  StorageProvider,
  staffPhotoFolder,
} from '../storage/storage.provider.js';

const BATCH = 100;
/** After this many failed deletes a photo is left for someone to look at. */
const MAX_ATTEMPTS = 10;
/** Files younger than this may belong to an upload still being saved. */
const ORPHAN_MIN_AGE_MS = 60 * 60_000;

/**
 * Deletes staff photos from storage, server-side (decision 7): photos both
 * reviewers have seen, once the grace period ends, and photos past their
 * expiry. The update record stays; only the image goes.
 */
@Injectable()
export class ImageCleanupService {
  private readonly logger = new Logger(ImageCleanupService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly settings: SettingsService,
    private readonly storage: StorageProvider,
    private readonly clock: Clock,
  ) {}

  async deleteDue(now = this.clock.now()): Promise<number> {
    const settings = await this.settings.getAll();
    const statuses: ImageStatus[] =
      settings.images.expiryAction === 'DELETE'
        ? ['READY_FOR_DELETION', 'AVAILABLE']
        : ['READY_FOR_DELETION'];
    let deleted = 0;
    for (;;) {
      const due = await this.prisma.staffUpdate.findMany({
        where: {
          imageStatus: { in: statuses },
          imageExpiresAt: { lte: now },
          imageKey: { not: null },
          imageDeleteAttempts: { lt: MAX_ATTEMPTS },
        },
        select: { id: true, imageKey: true, imageStatus: true },
        orderBy: { imageExpiresAt: 'asc' },
        take: BATCH,
      });
      if (due.length === 0) return deleted;
      const ids = due.map((d) => d.id);
      try {
        await this.storage.delete(due.map((d) => d.imageKey!));
      } catch (error) {
        this.logger.warn(
          `Could not delete ${due.length} photos: ${(error as Error).message}`,
        );
        await this.prisma.staffUpdate.updateMany({
          where: { id: { in: ids } },
          data: { imageDeleteAttempts: { increment: 1 } },
        });
        return deleted;
      }
      const viewed = due
        .filter((d) => d.imageStatus === 'READY_FOR_DELETION')
        .map((d) => d.id);
      const expired = due
        .filter((d) => d.imageStatus === 'AVAILABLE')
        .map((d) => d.id);
      const gone = {
        imageStatus: 'DELETED' as const,
        imageDeletedAt: now,
        imageKey: null,
      };
      await this.prisma.$transaction([
        this.prisma.staffUpdate.updateMany({
          where: { id: { in: viewed } },
          data: { ...gone, imageDeleteReason: 'ALL_VIEWED' },
        }),
        this.prisma.staffUpdate.updateMany({
          where: { id: { in: expired } },
          data: { ...gone, imageDeleteReason: 'EXPIRED' },
        }),
      ]);
      deleted += due.length;
      if (due.length < BATCH) return deleted;
    }
  }

  /** Files in storage that no update points at (e.g. a crash mid-upload). */
  async sweepOrphans(now = this.clock.now(), days = 3): Promise<number> {
    const settings = await this.settings.getAll();
    const today = businessDate(now, settings.business.timeZone);
    let removed = 0;
    for (let back = 0; back <= days; back += 1) {
      const objects = await this.storage.list(
        staffPhotoFolder(addDays(today, -back)),
      );
      const old = objects.filter(
        (o) => now.getTime() - o.createdAt.getTime() > ORPHAN_MIN_AGE_MS,
      );
      if (old.length === 0) continue;
      const referenced = new Set(
        (
          await this.prisma.staffUpdate.findMany({
            where: { imageKey: { in: old.map((o) => o.key) } },
            select: { imageKey: true },
          })
        ).map((u) => u.imageKey),
      );
      const orphans = old
        .filter((o) => !referenced.has(o.key))
        .map((o) => o.key);
      if (orphans.length > 0) {
        await this.storage.delete(orphans);
        removed += orphans.length;
      }
    }
    return removed;
  }
}
