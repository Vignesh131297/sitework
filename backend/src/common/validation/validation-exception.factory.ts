import { HttpStatus, type ValidationError } from '@nestjs/common';
import { AppException, type ErrorDetail } from '../errors/app.exception.js';
import { ErrorCode } from '../errors/error-codes.js';

/** Turns class-validator errors into one VALIDATION_FAILED error with per-field details. */
export function validationExceptionFactory(
  errors: ValidationError[],
): AppException {
  return new AppException(
    ErrorCode.VALIDATION_FAILED,
    'Some of the details entered are not valid.',
    HttpStatus.BAD_REQUEST,
    flatten(errors),
  );
}

function flatten(errors: ValidationError[], parent?: string): ErrorDetail[] {
  return errors.flatMap((error) => {
    const field = parent ? `${parent}.${error.property}` : error.property;
    const own = Object.values(error.constraints ?? {}).map((message) => ({
      field,
      message,
    }));
    return [...own, ...flatten(error.children ?? [], field)];
  });
}
