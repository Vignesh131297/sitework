import { HttpStatus, Injectable, type PipeTransform } from '@nestjs/common';
import { AppException } from '../errors/app.exception.js';
import { ErrorCode } from '../errors/error-codes.js';

const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

export function isUuid(value: string): boolean {
  return UUID.test(value);
}

/**
 * Route ids are UUIDs (any version: the database uses v7). A malformed id can't
 * match a record, so it gets the same 404 as one that doesn't exist.
 */
@Injectable()
export class ParseIdPipe implements PipeTransform<string, string> {
  transform(value: string): string {
    if (!isUuid(value)) {
      throw new AppException(
        ErrorCode.NOT_FOUND,
        'The requested record was not found.',
        HttpStatus.NOT_FOUND,
      );
    }
    return value.toLowerCase();
  }
}
