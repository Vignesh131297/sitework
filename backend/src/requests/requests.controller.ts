import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Post,
  Query,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import type { AuthUser } from '../auth/auth-user.js';
import { CurrentUser, Roles } from '../common/decorators/auth.decorators.js';
import type { Paginated } from '../common/pagination/paginated.js';
import { ParseIdPipe } from '../common/pipes/parse-id.pipe.js';
import {
  LeaveRequestsService,
  type LeaveRequestView,
} from './leave-requests.service.js';
import {
  ApproveDto,
  CreateLeaveRequestDto,
  CreateStaffRequestDto,
  LeaveQueryDto,
  RejectDto,
  StaffRequestQueryDto,
} from './requests.dto.js';
import {
  StaffRequestsService,
  type StaffRequestView,
} from './staff-requests.service.js';

/**
 * Leave. Staff and engineers ask; an engineer on the staff member's site or an
 * admin decides staff leave, and only an admin decides an engineer's leave.
 */
@ApiTags('leave')
@ApiBearerAuth()
@Controller('leave-requests')
export class LeaveRequestsController {
  constructor(private readonly leave: LeaveRequestsService) {}

  @Roles('STAFF', 'ENGINEER')
  @Post()
  create(
    @CurrentUser() user: AuthUser,
    @Body() dto: CreateLeaveRequestDto,
  ): Promise<LeaveRequestView> {
    return this.leave.create(user, dto);
  }

  @Roles('ADMIN', 'ENGINEER', 'STAFF')
  @Get()
  list(
    @CurrentUser() user: AuthUser,
    @Query() query: LeaveQueryDto,
  ): Promise<Paginated<LeaveRequestView>> {
    return this.leave.list(user, query);
  }

  @Roles('ADMIN', 'ENGINEER', 'STAFF')
  @Get(':id')
  get(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
  ): Promise<LeaveRequestView> {
    return this.leave.get(user, id);
  }

  @Roles('ADMIN', 'ENGINEER')
  @Post(':id/approve')
  @HttpCode(HttpStatus.OK)
  approve(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: ApproveDto,
  ): Promise<LeaveRequestView> {
    return this.leave.approve(user, id, dto);
  }

  @Roles('ADMIN', 'ENGINEER')
  @Post(':id/reject')
  @HttpCode(HttpStatus.OK)
  reject(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: RejectDto,
  ): Promise<LeaveRequestView> {
    return this.leave.reject(user, id, dto.reason);
  }

  @Roles('STAFF', 'ENGINEER')
  @Post(':id/cancel')
  @HttpCode(HttpStatus.OK)
  cancel(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
  ): Promise<LeaveRequestView> {
    return this.leave.cancel(user, id);
  }
}

/**
 * Money (advance) and food requests. Staff ask for themselves; an engineer on
 * their site or an admin decides.
 */
@ApiTags('staff-requests')
@ApiBearerAuth()
@Controller('staff-requests')
export class StaffRequestsController {
  constructor(private readonly requests: StaffRequestsService) {}

  @Roles('STAFF')
  @Post()
  create(
    @CurrentUser() user: AuthUser,
    @Body() dto: CreateStaffRequestDto,
  ): Promise<StaffRequestView> {
    return this.requests.create(user, dto);
  }

  @Roles('ADMIN', 'ENGINEER', 'STAFF')
  @Get()
  list(
    @CurrentUser() user: AuthUser,
    @Query() query: StaffRequestQueryDto,
  ): Promise<Paginated<StaffRequestView>> {
    return this.requests.list(user, query);
  }

  @Roles('ADMIN', 'ENGINEER', 'STAFF')
  @Get(':id')
  get(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
  ): Promise<StaffRequestView> {
    return this.requests.get(user, id);
  }

  @Roles('ADMIN', 'ENGINEER')
  @Post(':id/approve')
  @HttpCode(HttpStatus.OK)
  approve(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: ApproveDto,
  ): Promise<StaffRequestView> {
    return this.requests.approve(user, id, dto);
  }

  @Roles('ADMIN', 'ENGINEER')
  @Post(':id/reject')
  @HttpCode(HttpStatus.OK)
  reject(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: RejectDto,
  ): Promise<StaffRequestView> {
    return this.requests.reject(user, id, dto.reason);
  }

  @Roles('STAFF')
  @Post(':id/cancel')
  @HttpCode(HttpStatus.OK)
  cancel(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
  ): Promise<StaffRequestView> {
    return this.requests.cancel(user, id);
  }
}
