import { OmitType, PartialType } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  IsArray,
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
import { DATE_PATTERN, UUID_PATTERN } from '../common/validation/patterns.js';
import { Designation } from '../generated/prisma/enums.js';

class CreatePersonDto {
  @IsString()
  @Length(2, 120)
  name: string;

  @IsString()
  @Length(6, 20)
  phone: string;

  @IsOptional()
  @IsString()
  @MaxLength(254)
  email?: string | null;

  /** Left out: the next ENG-### / STF-### code is used. */
  @IsOptional()
  @Matches(/^[A-Za-z0-9-]{2,20}$/, {
    message: 'employeeCode must be 2-20 letters, digits or dashes',
  })
  employeeCode?: string;

  @IsOptional()
  @Matches(DATE_PATTERN, { message: 'joiningDate must be YYYY-MM-DD' })
  joiningDate?: string | null;
}

export class CreateEngineerDto extends CreatePersonDto {
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(20)
  @Matches(UUID_PATTERN, { each: true, message: 'siteIds must be ids' })
  siteIds?: string[];
}

export class CreateStaffDto extends CreatePersonDto {
  @IsEnum(Designation)
  designation: Designation;

  @IsOptional()
  @Matches(UUID_PATTERN, { message: 'siteId must be an id' })
  siteId?: string;

  @IsOptional()
  @Matches(UUID_PATTERN, { message: 'engineerId must be an id' })
  engineerId?: string;
}

export class UpdateEngineerDto extends PartialType(
  OmitType(CreateEngineerDto, ['siteIds'] as const),
) {}

export class UpdateStaffDto extends PartialType(
  OmitType(CreateStaffDto, ['siteId', 'engineerId'] as const),
) {}

export class SetStatusDto {
  @IsBoolean()
  isActive: boolean;
}

export class AssignStaffDto {
  @Matches(UUID_PATTERN, { message: 'siteId must be an id' })
  siteId: string;

  @Matches(UUID_PATTERN, { message: 'engineerId must be an id' })
  engineerId: string;
}

export class PeopleQueryDto extends PageQueryDto {
  @IsOptional()
  @IsIn(['active', 'inactive'])
  status?: 'active' | 'inactive';

  @IsOptional()
  @Matches(UUID_PATTERN)
  siteId?: string;

  @IsOptional()
  @Matches(UUID_PATTERN)
  engineerId?: string;

  @IsOptional()
  @IsEnum(Designation)
  designation?: Designation;

  /** Staff without a current assignment only. */
  @IsOptional()
  @IsIn(['true', 'false'])
  unassigned?: 'true' | 'false';
}
