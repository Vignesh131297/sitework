import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Post,
  Query,
  Res,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiBearerAuth, ApiConsumes, ApiTags } from '@nestjs/swagger';
import type { Response } from 'express';
import type { AuthUser } from '../auth/auth-user.js';
import { CurrentUser, Roles } from '../common/decorators/auth.decorators.js';
import type { Paginated } from '../common/pagination/paginated.js';
import { ParseIdPipe } from '../common/pipes/parse-id.pipe.js';
import { StaffTodayService, type StaffToday } from './staff-today.service.js';
import {
  CreateStaffUpdateDto,
  StaffUpdateQueryDto,
  type UploadedPhoto,
} from './staff-updates.dto.js';
import {
  StaffUpdatesService,
  type StaffUpdateView,
} from './staff-updates.service.js';

/** Hard ceiling for the upload itself; the configurable limit is checked after. */
const MAX_UPLOAD_BYTES = 20 * 1024 * 1024;

@ApiTags('staff-updates')
@ApiBearerAuth()
@Controller('staff-updates')
export class StaffUpdatesController {
  constructor(private readonly updates: StaffUpdatesService) {}

  /** 201 when saved now; 200 when this clientSubmissionId was already saved (a retry). */
  @Roles('STAFF')
  @Post()
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(
    FileInterceptor('photo', {
      limits: {
        fileSize: MAX_UPLOAD_BYTES,
        files: 1,
        fields: 20,
        fieldSize: 16_384,
      },
    }),
  )
  async submit(
    @CurrentUser() user: AuthUser,
    @Body() dto: CreateStaffUpdateDto,
    @UploadedFile() photo: UploadedPhoto | undefined,
    @Res({ passthrough: true }) res: Response,
  ): Promise<StaffUpdateView> {
    const { update, created } = await this.updates.submit(user, dto, photo);
    res.status(created ? HttpStatus.CREATED : HttpStatus.OK);
    return update;
  }

  /** Admin: all. Engineer: their sites. Staff: their own. */
  @Get()
  list(
    @CurrentUser() user: AuthUser,
    @Query() query: StaffUpdateQueryDto,
  ): Promise<Paginated<StaffUpdateView>> {
    return this.updates.list(user, query);
  }

  @Get(':id')
  get(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
  ): Promise<StaffUpdateView> {
    return this.updates.get(user, id);
  }

  /** A short-lived link to the photo; 410 IMAGE_DELETED once it is gone. */
  @Get(':id/image')
  image(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
  ): Promise<{ url: string; expiresAt: string }> {
    return this.updates.imageUrl(user, id);
  }

  /** Called by the photo viewer once the photo has been shown. */
  @Roles('ADMIN', 'ENGINEER')
  @Post(':id/views')
  @HttpCode(HttpStatus.OK)
  view(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
  ): Promise<StaffUpdateView> {
    return this.updates.recordView(user, id);
  }
}

@ApiTags('staff-updates')
@ApiBearerAuth()
@Controller('me')
export class StaffTodayController {
  constructor(private readonly today: StaffTodayService) {}

  /** The staff home screen: site, attendance and today's three slots. */
  @Roles('STAFF')
  @Get('today')
  get(@CurrentUser() user: AuthUser): Promise<StaffToday> {
    return this.today.today(user);
  }
}
