import { Transform, Type } from 'class-transformer';
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
  ValidateNested,
} from 'class-validator';
import { PageQueryDto } from '../common/pagination/page-query.dto.js';
import {
  DATE_PATTERN,
  QUANTITY_PATTERN,
  UUID_PATTERN,
} from '../common/validation/patterns.js';
import {
  MaterialRequestOutcome,
  MaterialRequestStatus,
} from '../generated/prisma/enums.js';
import { MAX_STOCK_LINES, StockLineDto } from './stock.dto.js';

const trim = ({ value }: { value: unknown }) =>
  typeof value === 'string' ? value.trim() : value;

export class CreateMaterialRequestDto {
  /** Generated on the phone, so a retry never creates a second request. */
  @Matches(UUID_PATTERN, { message: 'requestId must be an id' })
  requestId: string;

  @Matches(UUID_PATTERN, { message: 'Choose a site.' })
  siteId: string;

  @IsOptional()
  @Matches(DATE_PATTERN, { message: 'neededBy must be YYYY-MM-DD' })
  neededBy?: string | null;

  @IsOptional()
  @Transform(trim)
  @IsString()
  @MaxLength(500)
  note?: string | null;

  @IsArray({ message: 'Add at least one material.' })
  @ArrayMinSize(1, { message: 'Add at least one material.' })
  @ArrayMaxSize(MAX_STOCK_LINES)
  @ValidateNested({ each: true })
  @Type(() => StockLineDto)
  lines: StockLineDto[];
}

export class ApproveLineDto {
  @Matches(UUID_PATTERN, { message: 'Choose a material.' })
  materialId: string;

  /** Zero when this material won't be supplied. */
  @Matches(QUANTITY_PATTERN, { message: 'Enter a quantity like 60 or 12.5.' })
  approvedQuantity: string;
}

export class ApproveRequestDto {
  /** The godown that supplies it; its managers send it. */
  @Matches(UUID_PATTERN, { message: 'Choose a godown.' })
  godownId: string;

  @IsOptional()
  @Transform(trim)
  @IsString()
  @MaxLength(500)
  note?: string | null;

  /** One per requested material. */
  @IsArray()
  @ArrayMinSize(1)
  @ArrayMaxSize(MAX_STOCK_LINES)
  @ValidateNested({ each: true })
  @Type(() => ApproveLineDto)
  lines: ApproveLineDto[];
}

export class RejectRequestDto {
  @Transform(trim)
  @IsString()
  @Length(3, 300, { message: 'Say why it is rejected.' })
  reason: string;
}

/** The site is done with it: all used, or the leftover goes back to the godown. */
export class CloseRequestDto {
  @IsEnum(MaterialRequestOutcome)
  outcome: MaterialRequestOutcome;

  @IsOptional()
  @Transform(trim)
  @IsString()
  @MaxLength(500)
  note?: string | null;

  /** LEFTOVER_RETURNED: an id for the return, made on the phone. */
  @IsOptional()
  @Matches(UUID_PATTERN, { message: 'returnRequestId must be an id' })
  returnRequestId?: string;

  /** LEFTOVER_RETURNED: what goes back to the godown. */
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(MAX_STOCK_LINES)
  @ValidateNested({ each: true })
  @Type(() => StockLineDto)
  lines?: StockLineDto[];
}

export class RequestQueryDto extends PageQueryDto {
  @IsOptional()
  @IsEnum(MaterialRequestStatus)
  status?: MaterialRequestStatus;

  /** Waiting for approval or being sent (PENDING and APPROVED). */
  @IsOptional()
  @Transform(
    ({ value }: { value: unknown }) => value === 'true' || value === true,
  )
  @IsBoolean()
  open?: boolean;

  @IsOptional()
  @Matches(UUID_PATTERN)
  siteId?: string;

  @IsOptional()
  @Matches(UUID_PATTERN)
  godownId?: string;
}
