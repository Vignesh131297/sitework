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
import { LocationDto } from '../common/location/location.dto.js';
import type { Paginated } from '../common/pagination/paginated.js';
import { ParseIdPipe } from '../common/pipes/parse-id.pipe.js';
import {
  AttendanceQueryDto,
  CorrectAttendanceDto,
  MarkAttendanceDto,
} from './attendance.dto.js';
import {
  AttendanceService,
  type AttendanceView,
} from './attendance.service.js';

@ApiTags('attendance')
@ApiBearerAuth()
@Controller('attendance')
export class AttendanceController {
  constructor(private readonly attendance: AttendanceService) {}

  @Roles('STAFF')
  @Post('check-in')
  @HttpCode(HttpStatus.OK)
  checkIn(
    @CurrentUser() user: AuthUser,
    @Body() location: LocationDto,
  ): Promise<AttendanceView> {
    return this.attendance.checkIn(user, location);
  }

  @Roles('STAFF')
  @Post('check-out')
  @HttpCode(HttpStatus.OK)
  checkOut(
    @CurrentUser() user: AuthUser,
    @Body() location: LocationDto,
  ): Promise<AttendanceView> {
    return this.attendance.checkOut(user, location);
  }

  /** Admin: everyone. Engineer: staff on their sites. Staff: their own days. */
  @Get()
  list(
    @CurrentUser() user: AuthUser,
    @Query() query: AttendanceQueryDto,
  ): Promise<Paginated<AttendanceView>> {
    return this.attendance.list(user, query);
  }

  @Roles('ADMIN')
  @Post()
  mark(
    @CurrentUser() user: AuthUser,
    @Body() dto: MarkAttendanceDto,
  ): Promise<AttendanceView> {
    return this.attendance.mark(user, dto);
  }

  @Roles('ADMIN')
  @Patch(':id')
  correct(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: CorrectAttendanceDto,
  ): Promise<AttendanceView> {
    return this.attendance.correct(user, id, dto);
  }
}
