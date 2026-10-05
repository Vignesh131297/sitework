import { Module } from '@nestjs/common';
import { AttendanceModule } from '../attendance/attendance.module.js';
import { DayActivityService } from './day-activity.service.js';
import { ImageCleanupService } from './image-cleanup.service.js';
import { MissedUpdatesService } from './missed-updates.service.js';
import { SiteDayController } from './site-day.controller.js';
import { StaffTodayService } from './staff-today.service.js';
import {
  StaffTodayController,
  StaffUpdatesController,
} from './staff-updates.controller.js';
import { StaffUpdatesService } from './staff-updates.service.js';

@Module({
  imports: [AttendanceModule],
  controllers: [
    StaffUpdatesController,
    StaffTodayController,
    SiteDayController,
  ],
  providers: [
    DayActivityService,
    StaffUpdatesService,
    StaffTodayService,
    MissedUpdatesService,
    ImageCleanupService,
  ],
  exports: [
    DayActivityService,
    StaffUpdatesService,
    MissedUpdatesService,
    ImageCleanupService,
  ],
})
export class StaffUpdatesModule {}
