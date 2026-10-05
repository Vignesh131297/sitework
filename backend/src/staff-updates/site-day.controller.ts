import { Controller, Get, Param, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { IsOptional, Matches } from 'class-validator';
import type { AuthUser } from '../auth/auth-user.js';
import { siteScope } from '../common/access/access-scope.js';
import { CurrentUser, Roles } from '../common/decorators/auth.decorators.js';
import { notFound } from '../common/errors/http-errors.js';
import { ParseIdPipe } from '../common/pipes/parse-id.pipe.js';
import { Clock } from '../common/time/clock.js';
import { DATE_PATTERN } from '../common/validation/patterns.js';
import { PrismaService } from '../prisma/prisma.service.js';
import { CalendarService } from '../settings/calendar.service.js';
import {
  DayActivityService,
  type DayActivity,
} from './day-activity.service.js';

class DayQueryDto {
  @IsOptional()
  @Matches(DATE_PATTERN, { message: 'date must be YYYY-MM-DD' })
  date?: string;
}

@ApiTags('staff-updates')
@ApiBearerAuth()
@Roles('ADMIN', 'ENGINEER')
@Controller('sites')
export class SiteDayController {
  constructor(
    private readonly prisma: PrismaService,
    private readonly activity: DayActivityService,
    private readonly calendar: CalendarService,
    private readonly clock: Clock,
  ) {}

  /** The site's staff board: everyone's attendance and slots for a date (default today). */
  @Get(':id/day')
  async day(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Query() query: DayQueryDto,
  ): Promise<DayActivity> {
    const site = await this.prisma.site.findFirst({
      where: { id, ...siteScope(user) },
      select: { id: true },
    });
    if (!site) throw notFound('site');
    const now = this.clock.now();
    const date = query.date ?? (await this.calendar.today(now));
    return this.activity.forDate(date, { siteId: id }, now);
  }
}
