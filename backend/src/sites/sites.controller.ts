import {
  Body,
  Controller,
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
  CreateSiteDto,
  SetEngineersDto,
  SiteQueryDto,
  UpdateSiteDto,
} from './sites.dto.js';
import {
  SitesService,
  type SiteDetail,
  type SiteSummary,
} from './sites.service.js';

@Controller('sites')
export class SitesController {
  constructor(private readonly sites: SitesService) {}

  /** Admin: all sites. Engineer: their sites. Staff: their site. */
  @Get()
  list(
    @CurrentUser() user: AuthUser,
    @Query() query: SiteQueryDto,
  ): Promise<Paginated<SiteSummary>> {
    return this.sites.list(user, query);
  }

  @Get(':id')
  get(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
  ): Promise<SiteDetail> {
    return this.sites.get(user, id);
  }

  @Roles('ADMIN')
  @Post()
  create(
    @CurrentUser() actor: AuthUser,
    @Body() dto: CreateSiteDto,
  ): Promise<SiteDetail> {
    return this.sites.create(actor, dto);
  }

  @Roles('ADMIN')
  @Patch(':id')
  update(
    @CurrentUser() actor: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: UpdateSiteDto,
  ): Promise<SiteDetail> {
    return this.sites.update(actor, id, dto);
  }

  @Roles('ADMIN')
  @Put(':id/engineers')
  setEngineers(
    @CurrentUser() actor: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: SetEngineersDto,
  ): Promise<SiteDetail> {
    return this.sites.setEngineers(actor, id, dto.engineerIds);
  }
}
