import {
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Post,
  Query,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsBoolean, IsOptional } from 'class-validator';
import type { AuthUser } from '../auth/auth-user.js';
import { CurrentUser } from '../common/decorators/auth.decorators.js';
import { notFound } from '../common/errors/http-errors.js';
import { PageQueryDto } from '../common/pagination/page-query.dto.js';
import { Paginated } from '../common/pagination/paginated.js';
import { ParseIdPipe } from '../common/pipes/parse-id.pipe.js';
import {
  NotificationsService,
  type NotificationView,
} from './notifications.service.js';

class NotificationQueryDto extends PageQueryDto {
  @IsOptional()
  @Transform(
    ({ value }: { value: unknown }) => value === 'true' || value === true,
  )
  @IsBoolean()
  unreadOnly = false;
}

/** The signed-in user's own notifications (every role). */
@ApiTags('notifications')
@ApiBearerAuth()
@Controller('notifications')
export class NotificationsController {
  constructor(private readonly notifications: NotificationsService) {}

  @Get()
  async list(
    @CurrentUser() user: AuthUser,
    @Query() query: NotificationQueryDto,
  ): Promise<Paginated<NotificationView>> {
    const { items, total } = await this.notifications.list(user.id, {
      unreadOnly: query.unreadOnly,
      skip: query.skip,
      take: query.limit,
    });
    return new Paginated(items, query.page, query.limit, total);
  }

  @Get('unread-count')
  async unreadCount(@CurrentUser() user: AuthUser): Promise<{ count: number }> {
    return { count: await this.notifications.unreadCount(user.id) };
  }

  @Post('read-all')
  @HttpCode(HttpStatus.OK)
  async readAll(@CurrentUser() user: AuthUser): Promise<{ updated: number }> {
    return { updated: await this.notifications.markAllRead(user.id) };
  }

  @Post(':id/read')
  @HttpCode(HttpStatus.OK)
  async read(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
  ): Promise<{ id: string }> {
    if (!(await this.notifications.markRead(user.id, id)))
      throw notFound('notification');
    return { id };
  }
}
