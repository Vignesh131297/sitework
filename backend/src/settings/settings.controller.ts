import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
  Query,
} from '@nestjs/common';
import { IsString, Length, Matches } from 'class-validator';
import type { AuthUser } from '../auth/auth-user.js';
import { CurrentUser, Roles } from '../common/decorators/auth.decorators.js';
import { ErrorCode } from '../common/errors/error-codes.js';
import { conflict, notFound } from '../common/errors/http-errors.js';
import { ParseIdPipe } from '../common/pipes/parse-id.pipe.js';
import { fromDbDate, toDbDate } from '../common/time/business-time.js';
import { PrismaService } from '../prisma/prisma.service.js';
import { CalendarService } from './calendar.service.js';
import type { Settings } from './settings.schema.js';
import { SettingsService } from './settings.service.js';

/** Business rules. Everyone can read them (the app needs slot windows etc.). */
@Controller('settings')
export class SettingsController {
  constructor(private readonly settings: SettingsService) {}

  @Get()
  getAll(): Promise<Settings> {
    return this.settings.getAll();
  }

  @Roles('ADMIN')
  @Patch(':key')
  update(
    @CurrentUser() actor: AuthUser,
    @Param('key') key: string,
    @Body() patch: Record<string, unknown>,
  ): Promise<unknown> {
    return this.settings.update(key, patch, actor.id);
  }
}

class HolidayDto {
  @Matches(/^\d{4}-\d{2}-\d{2}$/, { message: 'date must be YYYY-MM-DD' })
  date: string;

  @IsString()
  @Length(2, 80)
  name: string;
}

@Controller('holidays')
export class HolidaysController {
  constructor(
    private readonly prisma: PrismaService,
    private readonly calendar: CalendarService,
  ) {}

  @Get()
  async list(@Query('year') year?: string) {
    const y = Number(year) || Number((await this.calendar.today()).slice(0, 4));
    const rows = await this.prisma.holiday.findMany({
      where: {
        date: { gte: toDbDate(`${y}-01-01`), lte: toDbDate(`${y}-12-31`) },
      },
      orderBy: { date: 'asc' },
    });
    return rows.map((row) => ({
      id: row.id,
      date: fromDbDate(row.date),
      name: row.name,
    }));
  }

  @Roles('ADMIN')
  @Post()
  async create(@Body() dto: HolidayDto) {
    const date = toDbDate(dto.date);
    if (await this.prisma.holiday.findUnique({ where: { date } })) {
      throw conflict(
        ErrorCode.CONFLICT,
        'There is already a holiday on that date.',
      );
    }
    const row = await this.prisma.holiday.create({
      data: { date, name: dto.name.trim() },
    });
    this.calendar.invalidate();
    return { id: row.id, date: fromDbDate(row.date), name: row.name };
  }

  @Roles('ADMIN')
  @Delete(':id')
  async remove(@Param('id', ParseIdPipe) id: string): Promise<null> {
    const { count } = await this.prisma.holiday.deleteMany({ where: { id } });
    if (count === 0) throw notFound('holiday');
    this.calendar.invalidate();
    return null;
  }
}
