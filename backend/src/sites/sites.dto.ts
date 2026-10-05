import { OmitType, PartialType } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  IsArray,
  IsEnum,
  IsInt,
  IsLatitude,
  IsLongitude,
  IsOptional,
  IsString,
  Length,
  Matches,
  Max,
  MaxLength,
  Min,
} from 'class-validator';
import { PageQueryDto } from '../common/pagination/page-query.dto.js';
import {
  DATE_PATTERN,
  MONEY_PATTERN,
  UUID_PATTERN,
} from '../common/validation/patterns.js';
import { SiteStatus } from '../generated/prisma/enums.js';

export class CreateSiteDto {
  @IsString()
  @Length(2, 120)
  name: string;

  /** Left out: the next SITE-### code is used. */
  @IsOptional()
  @Matches(/^[A-Za-z0-9-]{3,20}$/, {
    message: 'code must be 3-20 letters, digits or dashes',
  })
  code?: string;

  @Matches(UUID_PATTERN, { message: 'clientId must be an id' })
  clientId: string;

  @IsOptional()
  @IsString()
  @MaxLength(120)
  contactName?: string | null;

  @IsOptional()
  @IsString()
  @MaxLength(20)
  contactPhone?: string | null;

  @IsString()
  @Length(3, 300)
  address: string;

  @IsOptional()
  @IsLatitude()
  latitude?: number | null;

  @IsOptional()
  @IsLongitude()
  longitude?: number | null;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(25)
  @Max(5000)
  geofenceRadiusM?: number | null;

  @Matches(DATE_PATTERN, { message: 'startDate must be YYYY-MM-DD' })
  startDate: string;

  @IsOptional()
  @Matches(DATE_PATTERN, {
    message: 'expectedCompletionDate must be YYYY-MM-DD',
  })
  expectedCompletionDate?: string | null;

  @Matches(MONEY_PATTERN, {
    message: 'contractAmount must be an amount like 1500000 or 1500000.50',
  })
  contractAmount: string;

  @IsOptional()
  @IsEnum(SiteStatus)
  status?: SiteStatus;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  @Max(100)
  progressPercent?: number;

  @IsOptional()
  @IsArray()
  @ArrayMaxSize(20)
  @Matches(UUID_PATTERN, { each: true, message: 'engineerIds must be ids' })
  engineerIds?: string[];
}

export class UpdateSiteDto extends PartialType(
  OmitType(CreateSiteDto, ['engineerIds'] as const),
) {}

export class SetEngineersDto {
  @IsArray()
  @ArrayMaxSize(20)
  @Matches(UUID_PATTERN, { each: true, message: 'engineerIds must be ids' })
  engineerIds: string[];
}

export class SiteQueryDto extends PageQueryDto {
  @IsOptional()
  @IsEnum(SiteStatus)
  status?: SiteStatus;

  @IsOptional()
  @Matches(UUID_PATTERN)
  clientId?: string;

  @IsOptional()
  @Matches(UUID_PATTERN)
  engineerId?: string;
}
