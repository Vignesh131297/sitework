import { Controller, Get, HttpStatus } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { APP_VERSION } from '../common/app-info.js';
import { Public } from '../common/decorators/auth.decorators.js';
import { AppException } from '../common/errors/app.exception.js';
import { ErrorCode } from '../common/errors/error-codes.js';
import { businessDate } from '../common/time/business-time.js';
import type { Env } from '../config/env.js';
import { PrismaService } from '../prisma/prisma.service.js';
import { SettingsService } from '../settings/settings.service.js';

export interface HealthStatus {
  status: 'ok';
  database: 'up';
  environment: Env['NODE_ENV'];
  version: string;
  /** The server clock; the app uses it instead of the phone's clock. */
  serverTime: string;
  timeZone: string;
  businessDate: string;
}

@Public()
@Controller('health')
export class HealthController {
  constructor(
    private readonly prisma: PrismaService,
    private readonly settings: SettingsService,
    private readonly config: ConfigService<Env, true>,
  ) {}

  @Get()
  async check(): Promise<HealthStatus> {
    try {
      await this.prisma.$queryRaw`SELECT 1`;
    } catch {
      throw new AppException(
        ErrorCode.SERVICE_UNAVAILABLE,
        'The service is temporarily unavailable. Please try again shortly.',
        HttpStatus.SERVICE_UNAVAILABLE,
      );
    }

    const { timeZone } = await this.settings.get('business');
    const now = new Date();
    return {
      status: 'ok',
      database: 'up',
      environment: this.config.get('NODE_ENV', { infer: true }),
      version: APP_VERSION,
      serverTime: now.toISOString(),
      timeZone,
      businessDate: businessDate(now, timeZone),
    };
  }
}
