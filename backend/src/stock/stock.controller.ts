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
import { GodownsService } from './godowns.service.js';
import { MaterialsService } from './materials.service.js';
import {
  CountDto,
  CreateGodownDto,
  CreateMaterialDto,
  EntryQueryDto,
  PurchaseDto,
  ReceiveStockDto,
  TransferDto,
  UpdateGodownDto,
  UpdateMaterialDto,
  UsageDto,
  VoidStockDto,
  WriteOffDto,
} from './stock.dto.js';
import { StockService } from './stock.service.js';
import { StockEntriesService } from './stock-entries.service.js';
import type {
  GodownStock,
  GodownView,
  MaterialDetail,
  SiteStock,
  StockEntryView,
  StockOverview,
} from './stock-views.js';

/** Photos (DC, bill, what arrived) come in the `photos` field of a multipart form. */
const Photos = () =>
  UseInterceptors(
    FilesInterceptor('photos', MAX_ATTACHMENTS, {
      limits: {
        fileSize: MAX_FILE_BYTES,
        files: MAX_ATTACHMENTS,
        fields: 20,
        fieldSize: 65_536,
      },
    }),
  );

/**
 * Admins run everything and see prices. Godown managers run their godowns:
 * they buy stock in, send it to sites against approved requests, take returns,
 * write off and count. Engineers see godown stock and look after their sites'
 * stock: they confirm deliveries, record usage and write-offs, and return
 * leftovers to a godown. Site staff record their site's daily usage.
 */
@ApiTags('stock')
@ApiBearerAuth()
@Controller()
export class StockController {
  constructor(
    private readonly stock: StockService,
    private readonly entries: StockEntriesService,
    private readonly materials: MaterialsService,
    private readonly godowns: GodownsService,
  ) {}

  @Roles('ADMIN', 'GODOWN_MANAGER')
  @Post('materials')
  createMaterial(
    @CurrentUser() user: AuthUser,
    @Body() dto: CreateMaterialDto,
  ): Promise<MaterialDetail> {
    return this.materials.create(user, dto);
  }

  @Roles('ADMIN')
  @Get('materials/:id')
  material(@Param('id', ParseIdPipe) id: string): Promise<MaterialDetail> {
    return this.materials.detail(id);
  }

  @Roles('ADMIN')
  @Patch('materials/:id')
  updateMaterial(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: UpdateMaterialDto,
  ): Promise<MaterialDetail> {
    return this.materials.update(user, id, dto);
  }

  @Roles('ADMIN')
  @Post('godowns')
  createGodown(
    @CurrentUser() user: AuthUser,
    @Body() dto: CreateGodownDto,
  ): Promise<GodownView> {
    return this.godowns.create(user, dto);
  }

  @Roles('ADMIN')
  @Patch('godowns/:id')
  updateGodown(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: UpdateGodownDto,
  ): Promise<GodownView> {
    return this.godowns.update(user, id, dto);
  }

  @Roles('ADMIN', 'ENGINEER', 'GODOWN_MANAGER')
  @Get('stock/overview')
  overview(@CurrentUser() user: AuthUser): Promise<StockOverview> {
    return this.stock.overview(user);
  }

  @Roles('ADMIN', 'ENGINEER', 'GODOWN_MANAGER')
  @Get('stock/godowns/:id')
  godown(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
  ): Promise<GodownStock> {
    return this.stock.godown(user, id);
  }

  /** Staff: their own site only (so they can record its usage). */
  @Roles('ADMIN', 'ENGINEER', 'STAFF')
  @Get('sites/:id/stock')
  site(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
  ): Promise<SiteStock> {
    return this.stock.site(user, id);
  }

  @Roles('ADMIN', 'ENGINEER', 'GODOWN_MANAGER')
  @Get('stock/entries')
  list(
    @CurrentUser() user: AuthUser,
    @Query() query: EntryQueryDto,
  ): Promise<Paginated<StockEntryView>> {
    return this.stock.entries(user, query);
  }

  @Roles('ADMIN', 'ENGINEER', 'GODOWN_MANAGER')
  @Get('stock/entries/:id')
  entry(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
  ): Promise<StockEntryView> {
    return this.stock.entry(user, id);
  }

  @Roles('ADMIN', 'GODOWN_MANAGER')
  @Post('stock/purchases')
  @ApiConsumes('multipart/form-data')
  @Photos()
  purchase(
    @CurrentUser() user: AuthUser,
    @Body() dto: PurchaseDto,
    @UploadedFiles() photos: UploadedPhoto[] | undefined,
  ): Promise<StockEntryView> {
    return this.entries.purchase(user, dto, photos ?? []);
  }

  @Roles('ADMIN', 'ENGINEER', 'GODOWN_MANAGER')
  @Post('stock/transfers')
  @ApiConsumes('multipart/form-data')
  @Photos()
  transfer(
    @CurrentUser() user: AuthUser,
    @Body() dto: TransferDto,
    @UploadedFiles() photos: UploadedPhoto[] | undefined,
  ): Promise<StockEntryView> {
    return this.entries.transfer(user, dto, photos ?? []);
  }

  @Roles('ADMIN', 'ENGINEER', 'STAFF')
  @Post('stock/usage')
  use(
    @CurrentUser() user: AuthUser,
    @Body() dto: UsageDto,
  ): Promise<StockEntryView> {
    return this.entries.use(user, dto);
  }

  @Roles('ADMIN', 'ENGINEER', 'GODOWN_MANAGER')
  @Post('stock/write-offs')
  writeOff(
    @CurrentUser() user: AuthUser,
    @Body() dto: WriteOffDto,
  ): Promise<StockEntryView> {
    return this.entries.writeOff(user, dto);
  }

  @Roles('ADMIN', 'GODOWN_MANAGER')
  @Post('stock/counts')
  count(
    @CurrentUser() user: AuthUser,
    @Body() dto: CountDto,
  ): Promise<StockEntryView> {
    return this.entries.count(user, dto);
  }

  @Roles('ADMIN', 'ENGINEER', 'GODOWN_MANAGER')
  @Post('stock/entries/:id/receive')
  @HttpCode(HttpStatus.OK)
  @ApiConsumes('multipart/form-data')
  @Photos()
  receive(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: ReceiveStockDto,
    @UploadedFiles() photos: UploadedPhoto[] | undefined,
  ): Promise<StockEntryView> {
    return this.entries.receive(user, id, dto, photos ?? []);
  }

  @Roles('ADMIN', 'ENGINEER', 'STAFF', 'GODOWN_MANAGER')
  @Post('stock/entries/:id/void')
  @HttpCode(HttpStatus.OK)
  void(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseIdPipe) id: string,
    @Body() dto: VoidStockDto,
  ): Promise<StockEntryView> {
    return this.entries.void(user, id, dto.reason);
  }
}
