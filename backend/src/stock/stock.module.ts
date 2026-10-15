import { Module } from '@nestjs/common';
import { GodownsService } from './godowns.service.js';
import { MaterialRequestsController } from './material-requests.controller.js';
import { MaterialRequestsService } from './material-requests.service.js';
import { MaterialsService } from './materials.service.js';
import { StockController } from './stock.controller.js';
import { StockService } from './stock.service.js';
import { StockEntriesService } from './stock-entries.service.js';

@Module({
  controllers: [StockController, MaterialRequestsController],
  providers: [
    StockService,
    StockEntriesService,
    MaterialsService,
    GodownsService,
    MaterialRequestsService,
  ],
  exports: [StockService, MaterialRequestsService],
})
export class StockModule {}
