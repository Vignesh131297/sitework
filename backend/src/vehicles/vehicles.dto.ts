import { Transform } from 'class-transformer';
import {
  IsBoolean,
  IsEnum,
  IsIn,
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
import { ApprovalStatus, VehicleType } from '../generated/prisma/enums.js';

const trim = ({ value }: { value: unknown }) =>
  typeof value === 'string' ? value.trim() : value;

const toBoolean = ({ value }: { value: unknown }) =>
  value === 'true' || value === true;

export class CreateVehicleDto {
  @IsEnum(VehicleType, { message: 'Choose the kind of vehicle.' })
  type: VehicleType;

  /** As on the number plate; spaces and dashes are ignored. */
  @Transform(trim)
  @IsString()
  @Length(4, 20, { message: 'Enter the registration number.' })
  registrationNo: string;

  @Transform(trim)
  @IsString()
  @Length(2, 80, { message: 'Enter the make and model.' })
  makeModel: string;

  @IsOptional()
  @Transform(trim)
  @IsString()
  @MaxLength(500)
  note?: string | null;
}

export class UpdateVehicleDto {
  @IsOptional()
  @IsEnum(VehicleType, { message: 'Choose the kind of vehicle.' })
  type?: VehicleType;

  @IsOptional()
  @Transform(trim)
  @IsString()
  @Length(4, 20, { message: 'Enter the registration number.' })
  registrationNo?: string;

  @IsOptional()
  @Transform(trim)
  @IsString()
  @Length(2, 80, { message: 'Enter the make and model.' })
  makeModel?: string;

  @IsOptional()
  @Transform(trim)
  @IsString()
  @MaxLength(500)
  note?: string | null;

  /** False takes the vehicle out of use (refused while someone holds it). */
  @IsOptional()
  @IsBoolean()
  isActive?: boolean;
}

export class AssignVehicleDto {
  /** A staff member or an engineer. */
  @Matches(UUID_PATTERN, { message: 'Choose who gets the vehicle.' })
  userId: string;

  @Matches(DATE_PATTERN, { message: 'Choose the day it was given.' })
  givenOn: string;

  @IsOptional()
  @Transform(trim)
  @IsString()
  @MaxLength(500)
  note?: string | null;
}

export class ReturnVehicleDto {
  @Matches(DATE_PATTERN, { message: 'Choose the day it came back.' })
  returnedOn: string;

  @IsOptional()
  @Transform(trim)
  @IsString()
  @MaxLength(500)
  note?: string | null;
}

export const VEHICLE_FILTERS = ['GIVEN', 'FREE', 'INACTIVE'] as const;
export type VehicleFilter = (typeof VEHICLE_FILTERS)[number];

export class VehicleQueryDto extends PageQueryDto {
  /** GIVEN: someone holds it. FREE: in use but with nobody. INACTIVE: out of use. */
  @IsOptional()
  @IsIn(VEHICLE_FILTERS)
  status?: VehicleFilter;
}

export class CreateRepairRequestDto {
  /** Generated on the phone, so a retry never creates a second request. */
  @Matches(UUID_PATTERN, { message: 'requestId must be an id' })
  requestId: string;

  /** Rupees, e.g. "800" or "800.50". */
  @Matches(MONEY_PATTERN, { message: 'Enter an amount in rupees.' })
  amount: string;

  @Transform(trim)
  @IsString()
  @Length(3, 500, {
    message: 'Say what needs repair, in 3 to 500 characters.',
  })
  note: string;
}

export class RepairRequestQueryDto extends PageQueryDto {
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
  vehicleId?: string;

  @IsOptional()
  @Matches(UUID_PATTERN)
  userId?: string;
}
