import { Injectable } from '@nestjs/common';
import {
  businessDate,
  fromDbDate,
  isWorkingDay,
  toDbDate,
} from '../common/time/business-time.js';
import { Clock } from '../common/time/clock.js';
import { PrismaService } from '../prisma/prisma.service.js';
import { SettingsService } from './settings.service.js';

const CACHE_TTL_MS = 60_000;

/** Today's business date and working days (configured weekdays minus holidays). */
@Injectable()
export class CalendarService {
  private holidays?: { dates: Set<string>; expiresAt: number };

  constructor(
    private readonly prisma: PrismaService,
    private readonly settings: SettingsService,
    private readonly clock: Clock,
  ) {}

  async today(now: Date = this.clock.now()): Promise<string> {
    const { timeZone } = await this.settings.get('business');
    return businessDate(now, timeZone);
  }

  async isWorkingDay(date: string): Promise<boolean> {
    const { workingDays } = await this.settings.get('business');
    return isWorkingDay(date, workingDays, await this.holidayDates());
  }

  async holidayName(date: string): Promise<string | null> {
    const holiday = await this.prisma.holiday.findUnique({
      where: { date: toDbDate(date) },
    });
    return holiday?.name ?? null;
  }

  /** Call after holidays change. */
  invalidate(): void {
    this.holidays = undefined;
  }

  private async holidayDates(): Promise<Set<string>> {
    if (this.holidays && this.holidays.expiresAt > Date.now())
      return this.holidays.dates;
    const rows = await this.prisma.holiday.findMany({ select: { date: true } });
    const dates = new Set(rows.map((row) => fromDbDate(row.date)));
    this.holidays = { dates, expiresAt: Date.now() + CACHE_TTL_MS };
    return dates;
  }
}
