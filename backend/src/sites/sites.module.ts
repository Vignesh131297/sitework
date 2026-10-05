import { Module } from '@nestjs/common';
import { AssignmentsService } from './assignments.service.js';
import { SitesController } from './sites.controller.js';
import { SitesService } from './sites.service.js';

@Module({
  controllers: [SitesController],
  providers: [SitesService, AssignmentsService],
  exports: [SitesService, AssignmentsService],
})
export class SitesModule {}
