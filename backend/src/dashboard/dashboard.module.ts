import { Module } from '@nestjs/common';
import { StaffUpdatesModule } from '../staff-updates/staff-updates.module.js';
import { StockModule } from '../stock/stock.module.js';
import { DashboardController } from './dashboard.controller.js';
import { DashboardService } from './dashboard.service.js';

@Module({
  imports: [StaffUpdatesModule, StockModule],
  controllers: [DashboardController],
  providers: [DashboardService],
})
export class DashboardModule {}
