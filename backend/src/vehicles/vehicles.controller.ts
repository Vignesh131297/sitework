import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Patch,
  Post,
  Query,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import type { AuthUser } from '../auth/auth-user.js';
import { CurrentUser, Roles } from '../common/decorators/auth.decorators.js';
import type { Paginated } from '../common/pagination/paginated.js';
import { ParseIdPipe } from '../common/pipes/parse-id.pipe.js';
import { ApproveDto, RejectDto } from '../requests/requests.dto.js';
import {
  VehicleRepairRequestsService,
  type RepairRequestView,
} from './vehicle-repair-requests.service.js';
import {
  AssignVehicleDto,
  CreateRepairRequestDto,
  CreateVehicleDto,
  RepairRequestQueryDto,
  ReturnVehicleDto,
  UpdateVehicleDto,
  VehicleQueryDto,
} from './vehicles.dto.js';
import {
  VehiclesService,
  type VehicleDetail,
  type VehicleView,
} from './vehicles.service.js';

/**
 * Company vehicles. Admins keep the list, give a vehicle to a staff member or
 * an engineer and take it back; the holder sees only their own.
 */
@ApiTags('vehicles')
@ApiBearerAuth()
@Controller('vehicles')
export class VehiclesController {
  constructor(private readonly vehicles: VehiclesService) {}

  @Roles('ADMIN')
  @Post()
  create(
    @CurrentUser() user: AuthUser,
    @Body() dto: CreateVehicleDto,
  ): Promise<VehicleDetail> {
    return this.vehicles.create(user, dto);
  }

  @Roles('ADMIN')
  @Get()
  list(@Query() query: VehicleQueryDto): Promise<Paginated<VehicleView>> {
    return this.vehicles.list(query);
  }

  /** Declared before ":id" so "mine" is not read as an id. */
  @Roles('ENGINEER', 'STAFF')
  @Get('mine')
  mine(
    @CurrentUser() user: AuthUser,
  ): Promise<{ vehicle: VehicleView | null }> {
    return this.vehicles.mine(user);
  }

  @Roles('ADMIN')
  @Get(':id')
  get(@Param('id', ParseIdPipe) id: string): Promise<VehicleDetail> {
    return this.vehicles.get(id);
  }

  @Roles('ADMIN')
  @Patch(':id')
  update(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: UpdateVehicleDto,
  ): Promise<VehicleDetail> {
    return this.vehicles.update(user, id, dto);
  }

  @Roles('ADMIN')
  @Post(':id/assign')
  @HttpCode(HttpStatus.OK)
  assign(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: AssignVehicleDto,
  ): Promise<VehicleDetail> {
    return this.vehicles.assign(user, id, dto);
  }

  @Roles('ADMIN')
  @Post(':id/return')
  @HttpCode(HttpStatus.OK)
  takeBack(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: ReturnVehicleDto,
  ): Promise<VehicleDetail> {
    return this.vehicles.takeBack(user, id, dto);
  }
}

/**
 * Money for a vehicle repair. The staff member or engineer who holds the
 * vehicle asks; only an admin decides.
 */
@ApiTags('vehicle-repair-requests')
@ApiBearerAuth()
@Controller('vehicle-repair-requests')
export class VehicleRepairRequestsController {
  constructor(private readonly requests: VehicleRepairRequestsService) {}

  @Roles('ENGINEER', 'STAFF')
  @Post()
  create(
    @CurrentUser() user: AuthUser,
    @Body() dto: CreateRepairRequestDto,
  ): Promise<RepairRequestView> {
    return this.requests.create(user, dto);
  }

  @Roles('ADMIN', 'ENGINEER', 'STAFF')
  @Get()
  list(
    @CurrentUser() user: AuthUser,
    @Query() query: RepairRequestQueryDto,
  ): Promise<Paginated<RepairRequestView>> {
    return this.requests.list(user, query);
  }

  @Roles('ADMIN', 'ENGINEER', 'STAFF')
  @Get(':id')
  get(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
  ): Promise<RepairRequestView> {
    return this.requests.get(user, id);
  }

  @Roles('ADMIN')
  @Post(':id/approve')
  @HttpCode(HttpStatus.OK)
  approve(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: ApproveDto,
  ): Promise<RepairRequestView> {
    return this.requests.approve(user, id, dto);
  }

  @Roles('ADMIN')
  @Post(':id/reject')
  @HttpCode(HttpStatus.OK)
  reject(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: RejectDto,
  ): Promise<RepairRequestView> {
    return this.requests.reject(user, id, dto.reason);
  }

  @Roles('ENGINEER', 'STAFF')
  @Post(':id/cancel')
  @HttpCode(HttpStatus.OK)
  cancel(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
  ): Promise<RepairRequestView> {
    return this.requests.cancel(user, id);
  }
}
