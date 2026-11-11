import { Module } from '@nestjs/common';
import { LeaveRequestsService } from './leave-requests.service.js';
import {
  LeaveRequestsController,
  StaffRequestsController,
} from './requests.controller.js';
import { StaffRequestsService } from './staff-requests.service.js';

/** Leave, and staff members' money and food requests. */
@Module({
  controllers: [LeaveRequestsController, StaffRequestsController],
  providers: [LeaveRequestsService, StaffRequestsService],
  exports: [LeaveRequestsService, StaffRequestsService],
})
export class RequestsModule {}
