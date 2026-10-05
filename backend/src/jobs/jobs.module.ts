import { Injectable, Logger, Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Cron, ScheduleModule } from '@nestjs/schedule';
import { AttendanceModule } from '../attendance/attendance.module.js';
import { AttendanceService } from '../attendance/attendance.service.js';
import {
  addDays,
  businessDate,
  zonedInstant,
} from '../common/time/business-time.js';
import { Clock } from '../common/time/clock.js';
import type { Env } from '../config/env.js';
import { PaymentsModule } from '../payments/payments.module.js';
import { PaymentsService } from '../payments/payments.service.js';
import { PushDispatcher } from '../push/push-dispatcher.service.js';
import { SettingsService } from '../settings/settings.service.js';
import { ImageCleanupService } from '../staff-updates/image-cleanup.service.js';
import { MissedUpdatesService } from '../staff-updates/missed-updates.service.js';
import { StaffUpdatesModule } from '../staff-updates/staff-updates.module.js';
import { JobRunner } from './job-runner.js';

/** Business-time hour after which the day's absentees are recorded. */
const DAY_END = '23:30';
/** After midnight, yesterday is caught up until this hour (e.g. after downtime). */
/** Overdue-payment alerts wait for office hours. */
const OVERDUE_FROM = '09:30';
const CATCH_UP_UNTIL = '06:00';

/**
 * The scheduled work. Each job takes a database lock, so with several API
 * instances it still runs once; JOBS_ENABLED=false turns them all off.
 */
@Injectable()
export class JobsScheduler {
  private readonly logger = new Logger('Jobs');
  private readonly enabled: boolean;

  constructor(
    config: ConfigService<Env, true>,
    private readonly runner: JobRunner,
    private readonly settings: SettingsService,
    private readonly missed: MissedUpdatesService,
    private readonly images: ImageCleanupService,
    private readonly attendance: AttendanceService,
    private readonly push: PushDispatcher,
    private readonly payments: PaymentsService,
    private readonly clock: Clock,
  ) {
    this.enabled = config.get('JOBS_ENABLED', { infer: true });
  }

  /** Reminders before a window ends, misses right after it closes. */
  @Cron('0 * * * * *', { name: 'slots' })
  async slots(): Promise<void> {
    await this.run('slots', async () => {
      const reminded = await this.missed.remind();
      const missed = await this.missed.detect();
      if (reminded || missed)
        this.logger.log(
          `Slots: ${reminded} reminders, ${missed} missed updates`,
        );
    });
  }

  /** Notification rows waiting to go out as pushes. */
  @Cron('*/15 * * * * *', { name: 'push' })
  async pushes(): Promise<void> {
    await this.run('push', async () => {
      const result = await this.push.dispatch();
      if (result.sent || result.failed) {
        this.logger.log(
          `Push: ${result.sent} sent, ${result.failed} failed, ${result.noDevice} without a device`,
        );
      }
    });
  }

  /** Hourly from the morning; each overdue milestone is announced once. */
  @Cron('0 5 * * * *', { name: 'overdue' })
  async overdue(): Promise<void> {
    await this.run('overdue', async () => {
      const { timeZone } = (await this.settings.getAll()).business;
      const now = this.clock.now();
      if (
        now < zonedInstant(businessDate(now, timeZone), OVERDUE_FROM, timeZone)
      )
        return;
      const sent = await this.payments.notifyOverdue(now);
      if (sent) this.logger.log(`Payments: ${sent} overdue alerts`);
    });
  }

  @Cron('30 */5 * * * *', { name: 'photos' })
  async photos(): Promise<void> {
    await this.run('photos', async () => {
      const deleted = await this.images.deleteDue();
      if (deleted) this.logger.log(`Photos: deleted ${deleted}`);
    });
  }

  @Cron('0 17 3 * * *', { name: 'orphans' })
  async orphans(): Promise<void> {
    await this.run('orphans', async () => {
      const removed = await this.images.sweepOrphans();
      if (removed) this.logger.log(`Photos: removed ${removed} orphaned files`);
    });
  }

  @Cron('0 */15 * * * *', { name: 'absentees' })
  async absentees(): Promise<void> {
    await this.run('absentees', async () => {
      const settings = await this.settings.getAll();
      if (!settings.attendance.autoAbsentAtDayEnd) return;
      const zone = settings.business.timeZone;
      const now = this.clock.now();
      const today = businessDate(now, zone);
      let marked = 0;
      if (now >= zonedInstant(today, DAY_END, zone))
        marked += await this.attendance.markAbsentees(today);
      if (now < zonedInstant(today, CATCH_UP_UNTIL, zone))
        marked += await this.attendance.markAbsentees(addDays(today, -1));
      if (marked) this.logger.log(`Attendance: marked ${marked} absent`);
    });
  }

  private async run(name: string, job: () => Promise<void>): Promise<void> {
    if (this.enabled) await this.runner.exclusive(name, job);
  }
}

@Module({
  imports: [
    ScheduleModule.forRoot(),
    StaffUpdatesModule,
    AttendanceModule,
    PaymentsModule,
  ],
  providers: [JobRunner, JobsScheduler],
  exports: [JobRunner],
})
export class JobsModule {}
