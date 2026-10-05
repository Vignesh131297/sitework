import { Module } from '@nestjs/common';
import { SitesModule } from '../sites/sites.module.js';
import { EngineersController, StaffController } from './people.controller.js';
import { PeopleService } from './people.service.js';

@Module({
  imports: [SitesModule],
  controllers: [EngineersController, StaffController],
  providers: [PeopleService],
})
export class PeopleModule {}
