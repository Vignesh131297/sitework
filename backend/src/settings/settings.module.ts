import { Global, Module } from '@nestjs/common';
import { CalendarService } from './calendar.service.js';
import {
  HolidaysController,
  SettingsController,
} from './settings.controller.js';
import { SettingsService } from './settings.service.js';

@Global()
@Module({
  controllers: [SettingsController, HolidaysController],
  providers: [SettingsService, CalendarService],
  exports: [SettingsService, CalendarService],
})
export class SettingsModule {}
