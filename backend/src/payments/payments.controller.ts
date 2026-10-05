import {
  Body,
  Controller,
  Delete,
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
import {
  CreateMilestoneDto,
  CreatePaymentDto,
  PaymentQueryDto,
  UpdateMilestoneDto,
  VoidPaymentDto,
} from './payments.dto.js';
import {
  PaymentsService,
  type PaymentView,
  type PaymentsSummary,
  type SiteMoney,
} from './payments.service.js';

/** Money is for admins only; engineers see a site's totals on the site itself. */
@ApiTags('payments')
@ApiBearerAuth()
@Roles('ADMIN')
@Controller()
export class PaymentsController {
  constructor(private readonly payments: PaymentsService) {}

  @Get('payments/summary')
  summary(): Promise<PaymentsSummary> {
    return this.payments.summary();
  }

  @Get('payments')
  list(@Query() query: PaymentQueryDto): Promise<Paginated<PaymentView>> {
    return this.payments.list(query);
  }

  @Post('payments/:id/void')
  @HttpCode(HttpStatus.OK)
  void(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: VoidPaymentDto,
  ): Promise<PaymentView> {
    return this.payments.voidPayment(user, id, dto.reason);
  }

  @Get('sites/:id/money')
  siteMoney(@Param('id', ParseIdPipe) id: string): Promise<SiteMoney> {
    return this.payments.siteMoney(id);
  }

  @Post('sites/:id/payments')
  record(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: CreatePaymentDto,
  ): Promise<PaymentView> {
    return this.payments.recordPayment(user, id, dto);
  }

  @Post('sites/:id/milestones')
  addMilestone(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: CreateMilestoneDto,
  ): Promise<SiteMoney> {
    return this.payments.addMilestone(user, id, dto);
  }

  @Patch('milestones/:id')
  updateMilestone(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: UpdateMilestoneDto,
  ): Promise<SiteMoney> {
    return this.payments.updateMilestone(user, id, dto);
  }

  @Delete('milestones/:id')
  deleteMilestone(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
  ): Promise<SiteMoney> {
    return this.payments.deleteMilestone(user, id);
  }
}
