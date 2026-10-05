import { Transform } from 'class-transformer';
import {
  IsBoolean,
  IsEnum,
  IsISO8601,
  IsOptional,
  IsString,
  Length,
  Matches,
} from 'class-validator';
import { LocationDto } from '../common/location/location.dto.js';
import { PageQueryDto } from '../common/pagination/page-query.dto.js';
import { DATE_PATTERN, UUID_PATTERN } from '../common/validation/patterns.js';
import { PhotoSource, TimeSlot } from '../generated/prisma/enums.js';

/** Multipart form fields sent with the `photo` file. */
export class CreateStaffUpdateDto extends LocationDto {
  @IsEnum(TimeSlot)
  slot: TimeSlot;

  @Transform(({ value }: { value: unknown }) =>
    typeof value === 'string' ? value.trim() : value,
  )
  @IsString()
  @Length(3, 1000, { message: 'Describe the work in 3 to 1000 characters.' })
  description: string;

  /** Made on the phone when the photo is taken; retries reuse it, so nothing is saved twice. */
  @Matches(UUID_PATTERN, { message: 'clientSubmissionId must be a UUID' })
  clientSubmissionId: string;

  /** When the photo was taken, for updates sent later from the offline queue. */
  @IsOptional()
  @IsISO8601({ strict: true })
  capturedAt?: string;

  @IsOptional()
  @IsEnum(PhotoSource)
  photoSource?: PhotoSource;
}

export class StaffUpdateQueryDto extends PageQueryDto {
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
  @IsEnum(TimeSlot)
  slot?: TimeSlot;

  /** Photos still waiting for the caller's review (engineer: their own staff). */
  @IsOptional()
  @Transform(
    ({ value }: { value: unknown }) => value === 'true' || value === true,
  )
  @IsBoolean()
  pendingReview?: boolean;
}

/** The parts of an uploaded file the service uses (from multer's memory storage). */
export interface UploadedPhoto {
  buffer: Buffer;
  size: number;
  mimetype: string;
}
