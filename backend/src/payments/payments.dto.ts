import { PartialType } from '@nestjs/swagger';
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
import { PaymentMethod } from '../generated/prisma/enums.js';

const trim = ({ value }: { value: unknown }) =>
  typeof value === 'string' ? value.trim() : value;

export class CreateMilestoneDto {
  @Transform(trim)
  @IsString()
  @Length(2, 120)
  title: string;

  @Matches(MONEY_PATTERN, {
    message: 'amount must be an amount like 500000 or 500000.50',
  })
  amount: string;

  @Matches(DATE_PATTERN, { message: 'dueDate must be YYYY-MM-DD' })
  dueDate: string;

  @IsOptional()
  @Transform(trim)
  @IsString()
  @MaxLength(500)
  notes?: string | null;
}

export class UpdateMilestoneDto extends PartialType(CreateMilestoneDto) {}

export class CreatePaymentDto {
  @Matches(MONEY_PATTERN, {
    message: 'amount must be an amount like 250000 or 250000.50',
  })
  amount: string;

  @Matches(DATE_PATTERN, { message: 'paidOn must be YYYY-MM-DD' })
  paidOn: string;

  @IsEnum(PaymentMethod)
  method: PaymentMethod;

  /** Cheque number, UPI or bank reference. */
  @IsOptional()
  @Transform(trim)
  @IsString()
  @MaxLength(80)
  reference?: string | null;

  @IsOptional()
  @Transform(trim)
  @IsString()
  @MaxLength(500)
  remarks?: string | null;
}

export class VoidPaymentDto {
  @Transform(trim)
  @IsString()
  @Length(3, 300, { message: 'Say why the payment is being voided.' })
  reason: string;
}

export class PaymentQueryDto extends PageQueryDto {
  @IsOptional()
  @Matches(UUID_PATTERN)
  siteId?: string;

  @IsOptional()
  @Matches(UUID_PATTERN)
  clientId?: string;

  @IsOptional()
  @Matches(DATE_PATTERN, { message: 'from must be YYYY-MM-DD' })
  from?: string;

  @IsOptional()
  @Matches(DATE_PATTERN, { message: 'to must be YYYY-MM-DD' })
  to?: string;

  @IsOptional()
  @IsEnum(PaymentMethod)
  method?: PaymentMethod;

  /** Voided payments are hidden unless asked for. */
  @IsOptional()
  @Transform(
    ({ value }: { value: unknown }) => value === 'true' || value === true,
  )
  @IsBoolean()
  includeVoided?: boolean;
}
