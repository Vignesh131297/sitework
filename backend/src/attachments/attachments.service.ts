import { Global, HttpStatus, Injectable, Logger, Module } from '@nestjs/common';
import { randomUUID } from 'node:crypto';
import { AppException } from '../common/errors/app.exception.js';
import { ErrorCode } from '../common/errors/error-codes.js';
import { badRequest } from '../common/errors/http-errors.js';
import { processPhoto } from '../images/image-processor.js';
import { SettingsService } from '../settings/settings.service.js';
import type { UploadedPhoto } from '../staff-updates/staff-updates.dto.js';
import {
  StorageProvider,
  attachmentFolder,
} from '../storage/storage.provider.js';

/** Photos per engineer update or issue. */
export const MAX_ATTACHMENTS = 5;
/** Signed links in detail responses; the app reloads the detail for fresh ones. */
const URL_TTL_SECONDS = 15 * 60;

export interface StoredAttachment {
  objectKey: string;
  mime: string;
  bytes: number;
}

export interface AttachmentView {
  id: string;
  mime: string;
  url: string;
  expiresAt: string;
}

/**
 * Photos attached to engineer updates and issues. Unlike staff update photos
 * these are kept (decision 7 covers staff photos only), in their own folder.
 */
@Injectable()
export class AttachmentsService {
  private readonly logger = new Logger(AttachmentsService.name);

  constructor(
    private readonly storage: StorageProvider,
    private readonly settings: SettingsService,
  ) {}

  /** Checks, re-encodes and stores the photos. Call before the database write. */
  async store(
    files: readonly UploadedPhoto[],
    now: Date,
  ): Promise<StoredAttachment[]> {
    if (files.length > MAX_ATTACHMENTS) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        `Attach at most ${MAX_ATTACHMENTS} photos.`,
        'photos',
      );
    }
    const { maxUploadMb } = (await this.settings.getAll()).images;
    if (files.some((file) => file.size > maxUploadMb * 1024 * 1024)) {
      throw new AppException(
        ErrorCode.PAYLOAD_TOO_LARGE,
        `Each photo must be under ${maxUploadMb} MB.`,
        HttpStatus.PAYLOAD_TOO_LARGE,
      );
    }
    const images = await Promise.all(
      files.map((file) => processPhoto(file.buffer)),
    );
    const month = now.toISOString().slice(0, 7);
    const stored: StoredAttachment[] = [];
    try {
      for (const image of images) {
        const objectKey = `${attachmentFolder(month)}/${randomUUID()}.jpg`;
        await this.storage.put(objectKey, image.buffer, image.mime);
        stored.push({
          objectKey,
          mime: image.mime,
          bytes: image.buffer.length,
        });
      }
      return stored;
    } catch (error) {
      await this.discard(stored);
      throw error;
    }
  }

  /** Removes stored files whose database write failed. */
  async discard(stored: readonly StoredAttachment[]): Promise<void> {
    if (stored.length === 0) return;
    await this.storage
      .delete(stored.map((s) => s.objectKey))
      .catch((error: Error) =>
        this.logger.warn(`Orphan attachments: ${error.message}`),
      );
  }

  async views(
    rows: readonly { id: string; mime: string; objectKey: string }[],
    now: Date,
  ): Promise<AttachmentView[]> {
    const expiresAt = new Date(
      now.getTime() + URL_TTL_SECONDS * 1000,
    ).toISOString();
    return Promise.all(
      rows.map(async (row) => ({
        id: row.id,
        mime: row.mime,
        url: await this.storage.signedUrl(row.objectKey, URL_TTL_SECONDS),
        expiresAt,
      })),
    );
  }
}

@Global()
@Module({ providers: [AttachmentsService], exports: [AttachmentsService] })
export class AttachmentsModule {}
