import { Module } from '@nestjs/common';
import { EngineerUpdatesController } from './engineer-updates.controller.js';
import { EngineerUpdatesService } from './engineer-updates.service.js';

@Module({
  controllers: [EngineerUpdatesController],
  providers: [EngineerUpdatesService],
})
export class EngineerUpdatesModule {}
