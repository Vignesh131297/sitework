import { Transform, Type } from 'class-transformer';
import {
  IsEnum,
  IsInt,
  IsOptional,
  IsString,
  Length,
  Matches,
  Max,
  MaxLength,
  Min,
} from 'class-validator';
import { PageQueryDto } from '../common/pagination/page-query.dto.js';
import { DATE_PATTERN, UUID_PATTERN } from '../common/validation/patterns.js';
import { EngineerUpdateType, Priority } from '../generated/prisma/enums.js';

const trim = ({ value }: { value: unknown }) =>
  typeof value === 'string' ? value.trim() : value;

/** Multipart fields; photos come in the `photos` file field. */
export class CreateEngineerUpdateDto {
  @Matches(UUID_PATTERN, { message: 'siteId must be an id' })
  siteId: string;

  @IsEnum(EngineerUpdateType)
  type: EngineerUpdateType;

  @IsOptional()
  @IsEnum(Priority)
  priority?: Priority;

  @IsOptional()
  @Transform(trim)
  @IsString()
  @MaxLength(120)
  title?: string;

  @Transform(trim)
  @IsString()
  @Length(3, 2000, { message: 'Describe the update in 3 to 2000 characters.' })
  description: string;

  /** PROGRESS updates: the site's overall progress now. */
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  @Max(100)
  progressPercent?: number;
}

export class EngineerUpdateQueryDto extends PageQueryDto {
  @IsOptional()
  @Matches(UUID_PATTERN)
  siteId?: string;

  @IsOptional()
  @Matches(UUID_PATTERN)
  engineerId?: string;

  @IsOptional()
  @IsEnum(EngineerUpdateType)
  type?: EngineerUpdateType;

  @IsOptional()
  @Matches(DATE_PATTERN, { message: 'from must be YYYY-MM-DD' })
  from?: string;

  @IsOptional()
  @Matches(DATE_PATTERN, { message: 'to must be YYYY-MM-DD' })
  to?: string;
}
