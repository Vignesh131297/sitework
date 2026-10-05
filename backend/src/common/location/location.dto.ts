import { Transform, Type } from 'class-transformer';
import {
  IsBoolean,
  IsIn,
  IsLatitude,
  IsLongitude,
  IsNumber,
  IsOptional,
  Max,
  Min,
} from 'class-validator';

/** Fields the app sends with a check-in or update (JSON or multipart form). */
export class LocationDto {
  @IsOptional()
  @Type(() => Number)
  @IsLatitude()
  latitude?: number;

  @IsOptional()
  @Type(() => Number)
  @IsLongitude()
  longitude?: number;

  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  @Max(100_000)
  accuracyM?: number;

  @IsOptional()
  // Multipart fields arrive as strings.
  @Transform(({ value }: { value: unknown }) =>
    value === 'true' ? true : value === 'false' ? false : value,
  )
  @IsBoolean()
  isMocked?: boolean;

  @IsOptional()
  @IsIn(['PERMISSION_DENIED', 'UNAVAILABLE'])
  locationProblem?: 'PERMISSION_DENIED' | 'UNAVAILABLE';
}
