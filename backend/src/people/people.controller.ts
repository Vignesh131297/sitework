import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
  Put,
  Query,
} from '@nestjs/common';
import type { AuthUser } from '../auth/auth-user.js';
import { CurrentUser, Roles } from '../common/decorators/auth.decorators.js';
import { Paginated } from '../common/pagination/paginated.js';
import { ParseIdPipe } from '../common/pipes/parse-id.pipe.js';
import {
  AssignStaffDto,
  CreateEngineerDto,
  CreateStaffDto,
  PeopleQueryDto,
  SetStatusDto,
  UpdateEngineerDto,
  UpdateStaffDto,
} from './people.dto.js';
import {
  PeopleService,
  type PersonDetail,
  type PersonSummary,
} from './people.service.js';

type Created = { person: PersonDetail; temporaryPassword: string };

@Roles('ADMIN')
@Controller('engineers')
export class EngineersController {
  constructor(private readonly people: PeopleService) {}

  @Get()
  list(
    @CurrentUser() user: AuthUser,
    @Query() query: PeopleQueryDto,
  ): Promise<Paginated<PersonSummary>> {
    return this.people.list(user, 'ENGINEER', query);
  }

  /** Returns the temporary password once; the engineer must change it at first sign-in. */
  @Post()
  create(
    @CurrentUser() actor: AuthUser,
    @Body() dto: CreateEngineerDto,
  ): Promise<Created> {
    return this.people.createEngineer(actor, dto);
  }

  @Get(':id')
  get(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
  ): Promise<PersonDetail> {
    return this.people.get(user, 'ENGINEER', id);
  }

  @Patch(':id')
  update(
    @CurrentUser() actor: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: UpdateEngineerDto,
  ): Promise<PersonDetail> {
    return this.people.update(actor, 'ENGINEER', id, dto);
  }

  @Patch(':id/status')
  setStatus(
    @CurrentUser() actor: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: SetStatusDto,
  ): Promise<PersonDetail> {
    return this.people.setStatus(actor, 'ENGINEER', id, dto.isActive);
  }
}

@Controller('staff')
export class StaffController {
  constructor(private readonly people: PeopleService) {}

  /** Admin: all staff. Engineer: staff on their sites. */
  @Roles('ADMIN', 'ENGINEER')
  @Get()
  list(
    @CurrentUser() user: AuthUser,
    @Query() query: PeopleQueryDto,
  ): Promise<Paginated<PersonSummary>> {
    return this.people.list(user, 'STAFF', query);
  }

  @Roles('ADMIN')
  @Post()
  create(
    @CurrentUser() actor: AuthUser,
    @Body() dto: CreateStaffDto,
  ): Promise<Created> {
    return this.people.createStaff(actor, dto);
  }

  @Roles('ADMIN', 'ENGINEER')
  @Get(':id')
  get(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
  ): Promise<PersonDetail> {
    return this.people.get(user, 'STAFF', id);
  }

  @Roles('ADMIN')
  @Patch(':id')
  update(
    @CurrentUser() actor: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: UpdateStaffDto,
  ): Promise<PersonDetail> {
    return this.people.update(actor, 'STAFF', id, dto);
  }

  @Roles('ADMIN')
  @Patch(':id/status')
  setStatus(
    @CurrentUser() actor: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: SetStatusDto,
  ): Promise<PersonDetail> {
    return this.people.setStatus(actor, 'STAFF', id, dto.isActive);
  }

  @Roles('ADMIN')
  @Put(':id/assignment')
  assign(
    @CurrentUser() actor: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: AssignStaffDto,
  ): Promise<PersonDetail> {
    return this.people.assignStaff(actor, id, dto.siteId, dto.engineerId);
  }

  @Roles('ADMIN')
  @Delete(':id/assignment')
  unassign(
    @CurrentUser() actor: AuthUser,
    @Param('id', ParseIdPipe) id: string,
  ): Promise<PersonDetail> {
    return this.people.unassignStaff(actor, id);
  }
}
