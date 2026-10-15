import {
  Body,
  Controller,
  Get,
  HttpCode,
  Param,
  Patch,
  Post,
  Req,
} from '@nestjs/common';
import { Throttle } from '@nestjs/throttler';
import type { Request } from 'express';
import {
  AllowPendingPasswordChange,
  CurrentUser,
  Public,
  Roles,
} from '../common/decorators/auth.decorators.js';
import { ParseIdPipe } from '../common/pipes/parse-id.pipe.js';
import type { AuthUser } from './auth-user.js';
import {
  ChangePasswordDto,
  ForgotPasswordDto,
  LoginDto,
  RefreshDto,
  ResetPasswordDto,
  SignUpDto,
} from './auth.dto.js';
import {
  AuthService,
  type AuthResult,
  type ClientContext,
} from './auth.service.js';

const SIGN_IN_LIMIT = { default: { limit: 10, ttl: 60_000 } };
const FORGOT_LIMIT = { default: { limit: 5, ttl: 60_000 } };
// Each code also allows only 5 wrong attempts (enforced in the database).
const RESET_CODE_LIMIT = { default: { limit: 10, ttl: 60_000 } };

function clientContext(req: Request, deviceName?: string): ClientContext {
  return {
    ip: req.ip ?? null,
    deviceName:
      (deviceName ?? req.headers['user-agent'] ?? '').slice(0, 100) || null,
  };
}

@Controller('auth')
export class AuthController {
  constructor(private readonly auth: AuthService) {}

  @Public()
  @Throttle(SIGN_IN_LIMIT)
  @Post('login')
  @HttpCode(200)
  login(@Body() dto: LoginDto, @Req() req: Request): Promise<AuthResult> {
    return this.auth.login(
      dto.identifier,
      dto.password,
      clientContext(req, dto.deviceName),
    );
  }

  /** Whether the first admin can still sign up (the app shows the option). */
  @Public()
  @Get('signup')
  async signupStatus(): Promise<{ open: boolean }> {
    return { open: await this.auth.signupOpen() };
  }

  /** The first admin's own account; closed once any admin exists. */
  @Public()
  @Throttle(FORGOT_LIMIT)
  @Post('signup')
  signUp(@Body() dto: SignUpDto, @Req() req: Request): Promise<AuthResult> {
    return this.auth.signUpFirstAdmin(dto, clientContext(req, dto.deviceName));
  }

  @Public()
  @Throttle(SIGN_IN_LIMIT)
  @Post('refresh')
  @HttpCode(200)
  refresh(@Body() dto: RefreshDto, @Req() req: Request): Promise<AuthResult> {
    return this.auth.refresh(dto.refreshToken, clientContext(req));
  }

  @AllowPendingPasswordChange()
  @Post('logout')
  @HttpCode(200)
  async logout(@CurrentUser() user: AuthUser): Promise<null> {
    await this.auth.logout(user);
    return null;
  }

  @AllowPendingPasswordChange()
  @Patch('password')
  async changePassword(
    @CurrentUser() user: AuthUser,
    @Body() dto: ChangePasswordDto,
  ): Promise<null> {
    await this.auth.changePassword(user, dto.currentPassword, dto.newPassword);
    return null;
  }

  @Public()
  @Throttle(FORGOT_LIMIT)
  @Post('forgot-password')
  @HttpCode(200)
  forgotPassword(@Body() dto: ForgotPasswordDto): Promise<{ message: string }> {
    return this.auth.requestPasswordReset(dto.identifier);
  }

  @Public()
  @Throttle(RESET_CODE_LIMIT)
  @Post('reset-password')
  @HttpCode(200)
  async resetPassword(@Body() dto: ResetPasswordDto): Promise<null> {
    await this.auth.resetPassword(dto.identifier, dto.code, dto.newPassword);
    return null;
  }
}

/** Admin-assisted password reset for any user (engineer, staff or another admin). */
@Controller('users')
export class UserCredentialsController {
  constructor(private readonly auth: AuthService) {}

  @Roles('ADMIN')
  @Post(':id/reset-password')
  @HttpCode(200)
  resetPassword(
    @CurrentUser() actor: AuthUser,
    @Param('id', ParseIdPipe) userId: string,
  ): Promise<{ temporaryPassword: string }> {
    return this.auth.resetPasswordAsAdmin(actor, userId);
  }
}
