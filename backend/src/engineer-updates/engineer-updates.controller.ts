import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Post,
  Query,
  UploadedFiles,
  UseInterceptors,
} from '@nestjs/common';
import { FilesInterceptor } from '@nestjs/platform-express';
import { ApiBearerAuth, ApiConsumes, ApiTags } from '@nestjs/swagger';
import { MAX_ATTACHMENTS } from '../attachments/attachments.service.js';
import type { AuthUser } from '../auth/auth-user.js';
import { CurrentUser, Roles } from '../common/decorators/auth.decorators.js';
import type { Paginated } from '../common/pagination/paginated.js';
import { ParseIdPipe } from '../common/pipes/parse-id.pipe.js';
import type { UploadedPhoto } from '../staff-updates/staff-updates.dto.js';
import {
  CreateEngineerUpdateDto,
  EngineerUpdateQueryDto,
} from './engineer-updates.dto.js';
import {
  EngineerUpdatesService,
  type EngineerUpdateView,
} from './engineer-updates.service.js';

/** Upload ceiling per file; the configurable size limit is checked after. */
export const MAX_FILE_BYTES = 20 * 1024 * 1024;

@ApiTags('engineer-updates')
@ApiBearerAuth()
@Roles('ADMIN', 'ENGINEER')
@Controller('engineer-updates')
export class EngineerUpdatesController {
  constructor(private readonly updates: EngineerUpdatesService) {}

  @Roles('ENGINEER')
  @Post()
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(
    FilesInterceptor('photos', MAX_ATTACHMENTS, {
      limits: {
        fileSize: MAX_FILE_BYTES,
        files: MAX_ATTACHMENTS,
        fields: 20,
        fieldSize: 16_384,
      },
    }),
  )
  create(
    @CurrentUser() user: AuthUser,
    @Body() dto: CreateEngineerUpdateDto,
    @UploadedFiles() photos: UploadedPhoto[] | undefined,
  ): Promise<EngineerUpdateView> {
    return this.updates.create(user, dto, photos ?? []);
  }

  /** Admin: all. Engineer: updates on their sites. */
  @Get()
  list(
    @CurrentUser() user: AuthUser,
    @Query() query: EngineerUpdateQueryDto,
  ): Promise<Paginated<EngineerUpdateView>> {
    return this.updates.list(user, query);
  }

  @Get(':id')
  get(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
  ): Promise<EngineerUpdateView> {
    return this.updates.get(user, id);
  }

  @Roles('ADMIN')
  @Post(':id/views')
  @HttpCode(HttpStatus.OK)
  view(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
  ): Promise<EngineerUpdateView> {
    return this.updates.markViewed(user, id);
  }
}
