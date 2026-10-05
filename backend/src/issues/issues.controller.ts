import {
  Body,
  Controller,
  Get,
  Param,
  Patch,
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
import { MAX_FILE_BYTES } from '../engineer-updates/engineer-updates.controller.js';
import type { UploadedPhoto } from '../staff-updates/staff-updates.dto.js';
import { CreateIssueDto, IssueQueryDto, UpdateIssueDto } from './issues.dto.js';
import { IssuesService, type IssueView } from './issues.service.js';

/** Admins: every site. Engineers: their sites. */
@ApiTags('issues')
@ApiBearerAuth()
@Roles('ADMIN', 'ENGINEER')
@Controller('issues')
export class IssuesController {
  constructor(private readonly issues: IssuesService) {}

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
    @Body() dto: CreateIssueDto,
    @UploadedFiles() photos: UploadedPhoto[] | undefined,
  ): Promise<IssueView> {
    return this.issues.create(user, dto, photos ?? []);
  }

  @Get()
  list(
    @CurrentUser() user: AuthUser,
    @Query() query: IssueQueryDto,
  ): Promise<Paginated<IssueView>> {
    return this.issues.list(user, query);
  }

  @Get(':id')
  get(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
  ): Promise<IssueView> {
    return this.issues.get(user, id);
  }

  @Patch(':id')
  update(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: UpdateIssueDto,
  ): Promise<IssueView> {
    return this.issues.update(user, id, dto);
  }
}
