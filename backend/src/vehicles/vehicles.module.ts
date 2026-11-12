import { Global, Module } from '@nestjs/common';
import { VehicleRepairRequestsService } from './vehicle-repair-requests.service.js';
import {
  VehicleRepairRequestsController,
  VehiclesController,
} from './vehicles.controller.js';
import { VehiclesService } from './vehicles.service.js';

/**
 * Company vehicles, who holds them, and money asked for their repair. Global so
 * the people module can free a vehicle when its holder is deactivated.
 */
@Global()
@Module({
  controllers: [VehiclesController, VehicleRepairRequestsController],
  providers: [VehiclesService, VehicleRepairRequestsService],
  exports: [VehiclesService, VehicleRepairRequestsService],
})
export class VehiclesModule {}
