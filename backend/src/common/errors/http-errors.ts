import { HttpStatus } from '@nestjs/common';
import { AppException, type ErrorDetail } from './app.exception.js';
import { ErrorCode } from './error-codes.js';

// Shorthands for the common shapes of AppException.

export const notFound = (what = 'record') =>
  new AppException(
    ErrorCode.NOT_FOUND,
    `That ${what} was not found.`,
    HttpStatus.NOT_FOUND,
  );

export const conflict = (
  code: ErrorCode,
  message: string,
  details?: ErrorDetail[],
) => new AppException(code, message, HttpStatus.CONFLICT, details);

export const badRequest = (code: ErrorCode, message: string, field?: string) =>
  new AppException(
    code,
    message,
    HttpStatus.BAD_REQUEST,
    field ? [{ field, message }] : undefined,
  );
