import {
  IsEnum,
  IsISO8601,
  IsOptional,
  IsString,
  Length,
  Matches,
} from 'class-validator';
import { PageQueryDto } from '../common/pagination/page-query.dto.js';
import { DATE_PATTERN, UUID_PATTERN } from '../common/validation/patterns.js';
import { AttendanceStatus } from '../generated/prisma/enums.js';

export class AttendanceQueryDto extends PageQueryDto {
  /** One business date (YYYY-MM-DD). */
  @IsOptional()
  @Matches(DATE_PATTERN, { message: 'date must be YYYY-MM-DD' })
  date?: string;

  @IsOptional()
  @Matches(DATE_PATTERN, { message: 'from must be YYYY-MM-DD' })
  from?: string;

  @IsOptional()
  @Matches(DATE_PATTERN, { message: 'to must be YYYY-MM-DD' })
  to?: string;

  @IsOptional()
  @Matches(UUID_PATTERN)
  siteId?: string;

  @IsOptional()
  @Matches(UUID_PATTERN)
  staffId?: string;

  @IsOptional()
  @IsEnum(AttendanceStatus)
  status?: AttendanceStatus;
}

/** Admin correction of a day's record; the note says why (kept in the audit log). */
export class CorrectAttendanceDto {
  @IsOptional()
  @IsEnum(AttendanceStatus)
  status?: AttendanceStatus;

  @IsOptional()
  @IsISO8601({ strict: true })
  checkInAt?: string | null;

  @IsOptional()
  @IsISO8601({ strict: true })
  checkOutAt?: string | null;

  @IsString()
  @Length(3, 500)
  note: string;
}

/** Admin records a day for someone who could not (e.g. phone lost, on leave). */
export class MarkAttendanceDto {
  @Matches(UUID_PATTERN, { message: 'staffId must be an id' })
  staffId: string;

  @Matches(DATE_PATTERN, { message: 'date must be YYYY-MM-DD' })
  date: string;

  @IsEnum(AttendanceStatus)
  status: AttendanceStatus;

  @IsOptional()
  @IsISO8601({ strict: true })
  checkInAt?: string;

  @IsOptional()
  @IsISO8601({ strict: true })
  checkOutAt?: string;

  @IsString()
  @Length(3, 500)
  note: string;
}
