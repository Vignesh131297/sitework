import { Transform } from 'class-transformer';
import {
  IsBoolean,
  IsEnum,
  IsOptional,
  IsString,
  Length,
  Matches,
  MaxLength,
} from 'class-validator';
import { PageQueryDto } from '../common/pagination/page-query.dto.js';
import {
  DATE_PATTERN,
  MONEY_PATTERN,
  UUID_PATTERN,
} from '../common/validation/patterns.js';
import {
  ApprovalStatus,
  LeaveType,
  Meal,
  StaffRequestKind,
} from '../generated/prisma/enums.js';

const trim = ({ value }: { value: unknown }) =>
  typeof value === 'string' ? value.trim() : value;

const toBoolean = ({ value }: { value: unknown }) =>
  value === 'true' || value === true;

export class CreateLeaveRequestDto {
  /** Generated on the phone, so a retry never creates a second request. */
  @Matches(UUID_PATTERN, { message: 'requestId must be an id' })
  requestId: string;

  @IsEnum(LeaveType, { message: 'Choose the kind of leave.' })
  type: LeaveType;

  @Matches(DATE_PATTERN, { message: 'Choose the first day of leave.' })
  fromDate: string;

  @Matches(DATE_PATTERN, { message: 'Choose the last day of leave.' })
  toDate: string;

  @Transform(trim)
  @IsString()
  @Length(3, 500, { message: 'Give a reason of 3 to 500 characters.' })
  reason: string;
}

export class CreateStaffRequestDto {
  /** Generated on the phone, so a retry never creates a second request. */
  @Matches(UUID_PATTERN, { message: 'requestId must be an id' })
  requestId: string;

  @IsEnum(StaffRequestKind, { message: 'Choose money or food.' })
  kind: StaffRequestKind;

  /** MONEY: rupees, e.g. "500" or "500.50". */
  @IsOptional()
  @Matches(MONEY_PATTERN, { message: 'Enter an amount in rupees.' })
  amount?: string;

  /** FOOD: the day the meal is for. */
  @IsOptional()
  @Matches(DATE_PATTERN, { message: 'forDate must be YYYY-MM-DD' })
  forDate?: string;

  /** FOOD: which meal. */
  @IsOptional()
  @IsEnum(Meal, { message: 'Choose a meal.' })
  meal?: Meal;

  @IsOptional()
  @Transform(trim)
  @IsString()
  @MaxLength(500)
  note?: string | null;
}

export class ApproveDto {
  @IsOptional()
  @Transform(trim)
  @IsString()
  @MaxLength(500)
  note?: string | null;
}

export class RejectDto {
  @Transform(trim)
  @IsString()
  @Length(3, 500, { message: 'Say why, in 3 to 500 characters.' })
  reason: string;
}

class RequestQueryDto extends PageQueryDto {
  @IsOptional()
  @IsEnum(ApprovalStatus)
  status?: ApprovalStatus;

  /** Only the caller's own requests. */
  @IsOptional()
  @Transform(toBoolean)
  @IsBoolean()
  mine?: boolean;

  /** Waiting requests the caller may decide. */
  @IsOptional()
  @Transform(toBoolean)
  @IsBoolean()
  toReview?: boolean;

  @IsOptional()
  @Matches(UUID_PATTERN)
  siteId?: string;
}

export class LeaveQueryDto extends RequestQueryDto {
  @IsOptional()
  @Matches(UUID_PATTERN)
  userId?: string;
}

export class StaffRequestQueryDto extends RequestQueryDto {
  @IsOptional()
  @IsEnum(StaffRequestKind)
  kind?: StaffRequestKind;

  @IsOptional()
  @Matches(UUID_PATTERN)
  staffId?: string;
}
