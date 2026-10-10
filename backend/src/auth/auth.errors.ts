import { HttpStatus } from '@nestjs/common';
import { AppException } from '../common/errors/app.exception.js';
import { ErrorCode } from '../common/errors/error-codes.js';

// User-facing messages for authentication failures, in one place.

export const invalidCredentials = () =>
  new AppException(
    ErrorCode.INVALID_CREDENTIALS,
    'The mobile number/e-mail or password is incorrect.',
    HttpStatus.UNAUTHORIZED,
  );

export const accountLocked = (minutes: number) =>
  new AppException(
    ErrorCode.ACCOUNT_LOCKED,
    `Too many failed attempts. Try again in ${minutes} minute${minutes === 1 ? '' : 's'}, or ask your admin to reset your password.`,
    HttpStatus.UNAUTHORIZED,
  );

export const accountDisabled = () =>
  new AppException(
    ErrorCode.ACCOUNT_DISABLED,
    'Your account is disabled. Please contact your admin.',
    HttpStatus.UNAUTHORIZED,
  );

export const signInRequired = () =>
  new AppException(
    ErrorCode.UNAUTHORIZED,
    'Please sign in to continue.',
    HttpStatus.UNAUTHORIZED,
  );

export const tokenExpired = () =>
  new AppException(
    ErrorCode.TOKEN_EXPIRED,
    'Your session has expired.',
    HttpStatus.UNAUTHORIZED,
  );

export const tokenInvalid = () =>
  new AppException(
    ErrorCode.TOKEN_INVALID,
    'Your session has ended. Please sign in again.',
    HttpStatus.UNAUTHORIZED,
  );

export const sessionRevoked = () =>
  new AppException(
    ErrorCode.SESSION_REVOKED,
    'Your session has ended. Please sign in again.',
    HttpStatus.UNAUTHORIZED,
  );

export const passwordChangeRequired = () =>
  new AppException(
    ErrorCode.PASSWORD_CHANGE_REQUIRED,
    'Please set a new password to continue.',
    HttpStatus.FORBIDDEN,
  );

export const forbidden = () =>
  new AppException(
    ErrorCode.FORBIDDEN,
    "You don't have permission to do that.",
    HttpStatus.FORBIDDEN,
  );

export const wrongCurrentPassword = () =>
  new AppException(
    ErrorCode.WRONG_CURRENT_PASSWORD,
    'Your current password is incorrect.',
    HttpStatus.BAD_REQUEST,
  );

export const weakPassword = (reason: string) =>
  new AppException(ErrorCode.WEAK_PASSWORD, reason, HttpStatus.BAD_REQUEST, [
    { field: 'newPassword', message: reason },
  ]);

export const samePassword = () =>
  new AppException(
    ErrorCode.SAME_PASSWORD,
    'Choose a password different from your current one.',
    HttpStatus.BAD_REQUEST,
  );

export const invalidResetCode = () =>
  new AppException(
    ErrorCode.INVALID_RESET_CODE,
    'The code is incorrect or has expired. Request a new one.',
    HttpStatus.BAD_REQUEST,
  );

export const signupClosed = () =>
  new AppException(
    ErrorCode.SIGNUP_CLOSED,
    'This app is already set up. Ask your admin to create your account.',
    HttpStatus.FORBIDDEN,
  );
