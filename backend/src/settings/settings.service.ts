import { HttpStatus, Injectable, Logger } from '@nestjs/common';
import { AuditService } from '../common/audit/audit.service.js';
import { AppException } from '../common/errors/app.exception.js';
import { ErrorCode } from '../common/errors/error-codes.js';
import { notFound } from '../common/errors/http-errors.js';
import type { Prisma } from '../generated/prisma/client.js';
import { PrismaService } from '../prisma/prisma.service.js';
import {
  resolveSettings,
  SETTINGS_KEYS,
  settingsSchemas,
  type Settings,
  type SettingsKey,
} from './settings.schema.js';

/** Short cache so every request doesn't hit the table; other instances catch up within it. */
const CACHE_TTL_MS = 30_000;

@Injectable()
export class SettingsService {
  private readonly logger = new Logger(SettingsService.name);
  private cached?: { settings: Settings; expiresAt: number };

  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
  ) {}

  /** Merges `patch` into one group, validates the result and stores it. */
  async update(key: string, patch: unknown, actorId: string): Promise<unknown> {
    if (!(SETTINGS_KEYS as string[]).includes(key)) throw notFound('setting');
    const settingsKey = key as SettingsKey;
    const current = (await this.getAll())[settingsKey];
    const merged =
      patch && typeof patch === 'object' && !Array.isArray(patch)
        ? { ...current, ...(patch as Record<string, unknown>) }
        : patch;
    const parsed = settingsSchemas[settingsKey].safeParse(merged);
    if (!parsed.success) {
      throw new AppException(
        ErrorCode.VALIDATION_FAILED,
        'Some of the settings are not valid.',
        HttpStatus.BAD_REQUEST,
        parsed.error.issues.map((issue) => ({
          field: issue.path.join('.'),
          message: issue.message,
        })),
      );
    }
    const value = parsed.data as Prisma.InputJsonValue;
    await this.prisma.$transaction(async (tx) => {
      await tx.appSetting.upsert({
        where: { key: settingsKey },
        create: { key: settingsKey, value, updatedById: actorId },
        update: { value, updatedById: actorId },
      });
      await this.audit.record(
        {
          actorId,
          action: 'settings.updated',
          entityType: 'AppSetting',
          entityId: settingsKey,
          changes: { before: current as Prisma.InputJsonValue, after: value },
        },
        tx,
      );
    });
    this.invalidate();
    return parsed.data;
  }

  async get<K extends SettingsKey>(key: K): Promise<Settings[K]> {
    return (await this.getAll())[key];
  }

  async getAll(): Promise<Settings> {
    if (this.cached && this.cached.expiresAt > Date.now()) {
      return this.cached.settings;
    }
    const rows = await this.prisma.appSetting.findMany();
    const { settings, invalidKeys } = resolveSettings(rows);
    if (invalidKeys.length > 0) {
      this.logger.warn(
        `Ignoring invalid stored settings (defaults used): ${invalidKeys.join(', ')}`,
      );
    }
    this.cached = { settings, expiresAt: Date.now() + CACHE_TTL_MS };
    return settings;
  }

  /** Call after changing settings so this instance sees the change immediately. */
  invalidate(): void {
    this.cached = undefined;
  }
}
