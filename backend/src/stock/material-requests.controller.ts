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
  ApproveRequestDto,
  CloseRequestDto,
  CreateMaterialRequestDto,
  RejectRequestDto,
  RequestQueryDto,
} from './material-requests.dto.js';
import {
  MaterialRequestsService,
  type MaterialRequestView,
} from './material-requests.service.js';

/**
 * Engineers (and admins) request material for a site; admins approve or
 * reject; godown managers see what they have to send; the site closes it.
 * Sending itself is a transfer: POST /stock/transfers with materialRequestId.
 */
@ApiTags('material-requests')
@ApiBearerAuth()
@Controller('material-requests')
export class MaterialRequestsController {
  constructor(private readonly requests: MaterialRequestsService) {}

  @Roles('ADMIN', 'ENGINEER')
  @Post()
  create(
    @CurrentUser() user: AuthUser,
    @Body() dto: CreateMaterialRequestDto,
  ): Promise<MaterialRequestView> {
    return this.requests.create(user, dto);
  }

  @Roles('ADMIN', 'ENGINEER', 'GODOWN_MANAGER')
  @Get()
  list(
    @CurrentUser() user: AuthUser,
    @Query() query: RequestQueryDto,
  ): Promise<Paginated<MaterialRequestView>> {
    return this.requests.list(user, query);
  }

  @Roles('ADMIN', 'ENGINEER', 'GODOWN_MANAGER')
  @Get(':id')
  get(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
  ): Promise<MaterialRequestView> {
    return this.requests.get(user, id);
  }

  @Roles('ADMIN')
  @Post(':id/approve')
  @HttpCode(HttpStatus.OK)
  approve(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: ApproveRequestDto,
  ): Promise<MaterialRequestView> {
    return this.requests.approve(user, id, dto);
  }

  @Roles('ADMIN')
  @Post(':id/reject')
  @HttpCode(HttpStatus.OK)
  reject(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: RejectRequestDto,
  ): Promise<MaterialRequestView> {
    return this.requests.reject(user, id, dto.reason);
  }

  @Roles('ADMIN', 'ENGINEER')
  @Post(':id/cancel')
  @HttpCode(HttpStatus.OK)
  cancel(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
  ): Promise<MaterialRequestView> {
    return this.requests.cancel(user, id);
  }

  @Roles('ADMIN', 'ENGINEER')
  @Post(':id/close')
  @HttpCode(HttpStatus.OK)
  close(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: CloseRequestDto,
  ): Promise<MaterialRequestView> {
    return this.requests.close(user, id, dto);
  }
}
