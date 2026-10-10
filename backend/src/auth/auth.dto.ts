import {
  IsOptional,
  IsString,
  Length,
  Matches,
  MaxLength,
} from 'class-validator';

export class LoginDto {
  /** Mobile number (any common Indian format) or e-mail. */
  @IsString()
  @Length(3, 254)
  identifier: string;

  @IsString()
  @Length(1, 128)
  password: string;

  @IsOptional()
  @IsString()
  @MaxLength(100)
  deviceName?: string;
}

export class RefreshDto {
  @IsString()
  @Length(40, 200)
  refreshToken: string;
}

export class ChangePasswordDto {
  @IsString()
  @Length(1, 128)
  currentPassword: string;

  @IsString()
  @Length(1, 128)
  newPassword: string;
}

export class ForgotPasswordDto {
  @IsString()
  @Length(3, 254)
  identifier: string;
}

export class ResetPasswordDto {
  @IsString()
  @Length(3, 254)
  identifier: string;

  @Matches(/^\d{6}$/, { message: 'code must be 6 digits' })
  code: string;

  @IsString()
  @Length(1, 128)
  newPassword: string;
}

/** The first admin's own account (only while no admin exists). */
export class SignUpDto {
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

  @IsString()
  @Length(1, 128)
  password: string;

  @IsOptional()
  @IsString()
  @MaxLength(100)
  deviceName?: string;
}
