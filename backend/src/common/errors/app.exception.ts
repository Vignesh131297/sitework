import { HttpException, HttpStatus } from '@nestjs/common';
import type { ErrorCode } from './error-codes.js';

export interface ErrorDetail {
  /** Dotted path of the offending input field, when the error is about one. */
  field?: string;
  message: string;
}

/**
 * The exception services throw for expected business failures. Its message is shown
 * to users, so write it as a complete, friendly sentence.
 */
export class AppException extends HttpException {
  constructor(
    readonly code: ErrorCode,
    message: string,
    status: HttpStatus = HttpStatus.BAD_REQUEST,
    readonly details?: ErrorDetail[],
  ) {
    super({ code, message, details }, status);
  }
}
