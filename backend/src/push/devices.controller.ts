import {
  Body,
  Controller,
  Delete,
  HttpCode,
  HttpStatus,
  Post,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { IsIn, IsOptional, IsString, Length, MaxLength } from 'class-validator';
import type { AuthUser } from '../auth/auth-user.js';
import { CurrentUser } from '../common/decorators/auth.decorators.js';
import { Clock } from '../common/time/clock.js';
import { PrismaService } from '../prisma/prisma.service.js';

class RegisterDeviceDto {
  @IsString()
  @Length(20, 4096)
  fcmToken: string;

  @IsOptional()
  @IsIn(['android', 'ios'])
  platform?: string;

  @IsOptional()
  @IsString()
  @MaxLength(40)
  appVersion?: string;
}

class RemoveDeviceDto {
  @IsString()
  @Length(20, 4096)
  fcmToken: string;
}

/** The phones that receive the signed-in user's push notifications. */
@ApiTags('notifications')
@ApiBearerAuth()
@Controller('me/devices')
export class DevicesController {
  constructor(
    private readonly prisma: PrismaService,
    private readonly clock: Clock,
  ) {}

  /** Called after sign-in and whenever FCM issues a new token. A token moves to whoever signed in last. */
  @Post()
  @HttpCode(HttpStatus.OK)
  async register(
    @CurrentUser() user: AuthUser,
    @Body() dto: RegisterDeviceDto,
  ): Promise<{ registered: true }> {
    const now = this.clock.now();
    await this.prisma.deviceToken.upsert({
      where: { fcmToken: dto.fcmToken },
      create: {
        userId: user.id,
        fcmToken: dto.fcmToken,
        platform: dto.platform ?? 'android',
        appVersion: dto.appVersion,
        lastSeenAt: now,
      },
      update: { userId: user.id, appVersion: dto.appVersion, lastSeenAt: now },
    });
    return { registered: true };
  }

  /** Called on sign-out, so the phone stops getting this user's notifications. */
  @Delete()
  async remove(
    @CurrentUser() user: AuthUser,
    @Body() dto: RemoveDeviceDto,
  ): Promise<{ removed: number }> {
    const { count } = await this.prisma.deviceToken.deleteMany({
      where: { fcmToken: dto.fcmToken, userId: user.id },
    });
    return { removed: count };
  }
}
