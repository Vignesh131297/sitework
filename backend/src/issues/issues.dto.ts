import { Transform } from 'class-transformer';
import {
  IsBoolean,
  IsEnum,
  IsOptional,
  IsString,
  Length,
  Matches,
} from 'class-validator';
import { PageQueryDto } from '../common/pagination/page-query.dto.js';
import { UUID_PATTERN } from '../common/validation/patterns.js';
import { IssueStatus, Priority } from '../generated/prisma/enums.js';

const trim = ({ value }: { value: unknown }) =>
  typeof value === 'string' ? value.trim() : value;

/** Multipart fields; photos come in the `photos` file field. */
export class CreateIssueDto {
  @Matches(UUID_PATTERN, { message: 'siteId must be an id' })
  siteId: string;

  @Transform(trim)
  @IsString()
  @Length(3, 120, { message: 'Give the issue a title of 3 to 120 characters.' })
  title: string;

  @Transform(trim)
  @IsString()
  @Length(3, 2000, { message: 'Describe the issue in 3 to 2000 characters.' })
  description: string;

  @IsOptional()
  @IsEnum(Priority)
  priority?: Priority;
}

export class UpdateIssueDto {
  @IsOptional()
  @IsEnum(IssueStatus)
  status?: IssueStatus;

  @IsOptional()
  @IsEnum(Priority)
  priority?: Priority;

  /** Required when resolving: what was done. */
  @IsOptional()
  @Transform(trim)
  @IsString()
  @Length(3, 1000, { message: 'Describe the fix in 3 to 1000 characters.' })
  resolutionNote?: string;
}

export class IssueQueryDto extends PageQueryDto {
  @IsOptional()
  @Matches(UUID_PATTERN)
  siteId?: string;

  @IsOptional()
  @IsEnum(IssueStatus)
  status?: IssueStatus;

  /** Open and in progress together. */
  @IsOptional()
  @Transform(
    ({ value }: { value: unknown }) => value === 'true' || value === true,
  )
  @IsBoolean()
  unresolved?: boolean;

  @IsOptional()
  @IsEnum(Priority)
  priority?: Priority;
}
