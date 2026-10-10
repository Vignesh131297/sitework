import { PartialType } from '@nestjs/swagger';
import { plainToInstance, Transform, Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsBoolean,
  IsEnum,
  IsOptional,
  IsString,
  Length,
  Matches,
  MaxLength,
  ValidateIf,
  ValidateNested,
} from 'class-validator';
import { PageQueryDto } from '../common/pagination/page-query.dto.js';
import {
  DATE_PATTERN,
  MONEY_PATTERN,
  QUANTITY_PATTERN,
  UUID_PATTERN,
} from '../common/validation/patterns.js';
import { StockMovementStatus } from '../generated/prisma/enums.js';

const trim = ({ value }: { value: unknown }) =>
  typeof value === 'string' ? value.trim() : value;

const toBoolean = ({ value }: { value: unknown }) =>
  value === 'true' || value === true;

/**
 * Lines arrive as an array in JSON requests, or as a JSON string in a
 * multipart field next to the photos. Anything unreadable is left for the
 * validators to reject.
 */
const linesOf =
  <T>(type: new () => T) =>
  ({ value }: { value: unknown }) => {
    if (typeof value !== 'string') return value;
    try {
      const parsed: unknown = JSON.parse(value);
      return Array.isArray(parsed) ? plainToInstance(type, parsed) : value;
    } catch {
      return value;
    }
  };

/** Most materials a single form can carry. */
export const MAX_STOCK_LINES = 50;

export class CreateMaterialDto {
  @Transform(trim)
  @IsString()
  @Length(2, 80, { message: 'Name the material in 2 to 80 characters.' })
  name: string;

  /** e.g. "bag", "kg", "cft", "nos". */
  @Transform(trim)
  @IsString()
  @Length(1, 20, { message: 'Give a unit of 1 to 20 characters, e.g. bag.' })
  unit: string;

  @IsOptional()
  @Transform(trim)
  @IsString()
  @MaxLength(40)
  category?: string | null;

  /** Admins are alerted when all godowns together drop below this. */
  @IsOptional()
  @ValidateIf((_, value) => value !== null)
  @Matches(QUANTITY_PATTERN, {
    message: 'minStock must be a quantity like 50 or 12.5',
  })
  minStock?: string | null;
}

export class UpdateMaterialDto extends PartialType(CreateMaterialDto) {
  @IsOptional()
  @IsBoolean()
  isActive?: boolean;
}

export class CreateGodownDto {
  @Transform(trim)
  @IsString()
  @Length(2, 80, { message: 'Name the godown in 2 to 80 characters.' })
  name: string;

  @IsOptional()
  @Transform(trim)
  @IsString()
  @MaxLength(300)
  address?: string | null;
}

export class UpdateGodownDto extends PartialType(CreateGodownDto) {
  @IsOptional()
  @IsBoolean()
  isActive?: boolean;
}

export class StockLineDto {
  @Matches(UUID_PATTERN, { message: 'Choose a material.' })
  materialId: string;

  @Matches(QUANTITY_PATTERN, { message: 'Enter a quantity like 60 or 12.5.' })
  quantity: string;
}

export class PurchaseLineDto extends StockLineDto {
  /** Price per unit in rupees, e.g. "385" or "385.50". */
  @Matches(MONEY_PATTERN, { message: 'Enter the price per unit, e.g. 385.' })
  rate: string;
}

export class CountLineDto {
  @Matches(UUID_PATTERN, { message: 'Choose a material.' })
  materialId: string;

  /** What is physically there; the server records the difference. */
  @Matches(QUANTITY_PATTERN, { message: 'Enter a quantity like 60 or 12.5.' })
  countedQuantity: string;
}

export class ReceiveLineDto {
  @Matches(UUID_PATTERN, { message: 'Choose a material.' })
  materialId: string;

  /** What actually arrived; at most what was sent. */
  @Matches(QUANTITY_PATTERN, { message: 'Enter a quantity like 60 or 12.5.' })
  receivedQuantity: string;
}

/** Shared by every stock form. */
class StockFormDto {
  /** Generated on the phone per form, so a retry never records twice. */
  @Matches(UUID_PATTERN, { message: 'requestId must be an id' })
  requestId: string;

  @Matches(DATE_PATTERN, { message: 'movedOn must be YYYY-MM-DD' })
  movedOn: string;
}

class StockLinesDto extends StockFormDto {
  @Transform(linesOf(StockLineDto))
  @IsArray({ message: 'Add at least one material.' })
  @ArrayMinSize(1, { message: 'Add at least one material.' })
  @ArrayMaxSize(MAX_STOCK_LINES)
  @ValidateNested({ each: true })
  @Type(() => StockLineDto)
  lines: StockLineDto[];
}

/** Stock bought into a godown (multipart; bill photos in `photos`). */
export class PurchaseDto extends StockFormDto {
  @Matches(UUID_PATTERN, { message: 'Choose a godown.' })
  godownId: string;

  @Transform(linesOf(PurchaseLineDto))
  @IsArray({ message: 'Add at least one material.' })
  @ArrayMinSize(1, { message: 'Add at least one material.' })
  @ArrayMaxSize(MAX_STOCK_LINES)
  @ValidateNested({ each: true })
  @Type(() => PurchaseLineDto)
  lines: PurchaseLineDto[];

  @IsOptional()
  @Transform(trim)
  @IsString()
  @MaxLength(120)
  supplier?: string | null;

  @IsOptional()
  @Transform(trim)
  @IsString()
  @MaxLength(60)
  billNo?: string | null;

  @IsOptional()
  @Transform(trim)
  @IsString()
  @MaxLength(500)
  note?: string | null;
}

/**
 * Stock sent between godowns and sites (multipart; the DC photo in `photos`,
 * required when it leaves a godown). Give one of each pair.
 */
export class TransferDto extends StockLinesDto {
  @IsOptional()
  @Matches(UUID_PATTERN, { message: 'fromGodownId must be an id' })
  fromGodownId?: string;

  @IsOptional()
  @Matches(UUID_PATTERN, { message: 'fromSiteId must be an id' })
  fromSiteId?: string;

  @IsOptional()
  @Matches(UUID_PATTERN, { message: 'toGodownId must be an id' })
  toGodownId?: string;

  @IsOptional()
  @Matches(UUID_PATTERN, { message: 'toSiteId must be an id' })
  toSiteId?: string;

  /** Required for deliveries to a site: the approved request they fill. */
  @IsOptional()
  @Matches(UUID_PATTERN, { message: 'materialRequestId must be an id' })
  materialRequestId?: string;

  /** Delivery challan number. */
  @IsOptional()
  @Transform(trim)
  @IsString()
  @MaxLength(60)
  dcNumber?: string | null;

  @IsOptional()
  @Transform(trim)
  @IsString()
  @MaxLength(500)
  note?: string | null;
}

/** Stock used up in the work at a site. */
export class UsageDto extends StockLinesDto {
  @Matches(UUID_PATTERN, { message: 'siteId must be an id' })
  siteId: string;

  /** What it was used for, e.g. "2nd floor slab". */
  @IsOptional()
  @Transform(trim)
  @IsString()
  @MaxLength(500)
  note?: string | null;
}

/** Wasted, damaged or lost stock, at a site or a godown (give one). */
export class WriteOffDto extends StockLinesDto {
  @IsOptional()
  @Matches(UUID_PATTERN, { message: 'siteId must be an id' })
  siteId?: string;

  @IsOptional()
  @Matches(UUID_PATTERN, { message: 'godownId must be an id' })
  godownId?: string;

  @Transform(trim)
  @IsString()
  @Length(3, 500, { message: 'Say what happened to it.' })
  note: string;
}

/** A physical count at a site or a godown (give one). */
export class CountDto extends StockFormDto {
  @IsOptional()
  @Matches(UUID_PATTERN, { message: 'siteId must be an id' })
  siteId?: string;

  @IsOptional()
  @Matches(UUID_PATTERN, { message: 'godownId must be an id' })
  godownId?: string;

  @Transform(trim)
  @IsString()
  @Length(3, 500, { message: 'Say why the count differs.' })
  note: string;

  @IsArray({ message: 'Add at least one material.' })
  @ArrayMinSize(1, { message: 'Add at least one material.' })
  @ArrayMaxSize(MAX_STOCK_LINES)
  @ValidateNested({ each: true })
  @Type(() => CountLineDto)
  lines: CountLineDto[];
}

/** Multipart: what arrived of each material, with photos in `photos`. */
export class ReceiveStockDto {
  @Transform(linesOf(ReceiveLineDto))
  @IsArray({ message: 'Say what arrived of each material.' })
  @ArrayMinSize(1, { message: 'Say what arrived of each material.' })
  @ArrayMaxSize(MAX_STOCK_LINES)
  @ValidateNested({ each: true })
  @Type(() => ReceiveLineDto)
  lines: ReceiveLineDto[];

  /** Required when less arrived than was sent. */
  @IsOptional()
  @Transform(trim)
  @IsString()
  @MaxLength(500)
  note?: string | null;
}

export class VoidStockDto {
  @Transform(trim)
  @IsString()
  @Length(3, 300, { message: 'Say why this entry is being cancelled.' })
  reason: string;
}

export class EntryQueryDto extends PageQueryDto {
  /** Entries from or to this site. */
  @IsOptional()
  @Matches(UUID_PATTERN)
  siteId?: string;

  /** Entries from or to this godown. */
  @IsOptional()
  @Matches(UUID_PATTERN)
  godownId?: string;

  @IsOptional()
  @Matches(UUID_PATTERN)
  materialId?: string;

  @IsOptional()
  @IsEnum(StockMovementStatus)
  status?: StockMovementStatus;

  /** Only what the caller can confirm now (deliveries or returns on the way). */
  @IsOptional()
  @Transform(toBoolean)
  @IsBoolean()
  receivable?: boolean;

  @IsOptional()
  @Matches(DATE_PATTERN, { message: 'from must be YYYY-MM-DD' })
  from?: string;

  @IsOptional()
  @Matches(DATE_PATTERN, { message: 'to must be YYYY-MM-DD' })
  to?: string;
}
