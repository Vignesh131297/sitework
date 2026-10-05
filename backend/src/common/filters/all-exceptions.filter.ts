import {
  Catch,
  HttpStatus,
  Logger,
  type ArgumentsHost,
  type ExceptionFilter,
} from '@nestjs/common';
import type { Request, Response } from 'express';
import { toApiError } from '../errors/api-error.js';

/** Every error leaves the API as `{ success: false, code, message, details?, requestId }`. */
@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
  private readonly logger = new Logger('ExceptionFilter');

  catch(exception: unknown, host: ArgumentsHost): void {
    const http = host.switchToHttp();
    const request = http.getRequest<Request & { id?: string }>();
    const response = http.getResponse<Response>();
    const error = toApiError(exception);

    if (error.status >= HttpStatus.INTERNAL_SERVER_ERROR) {
      this.logger.error(
        { err: exception, requestId: request.id },
        `Unhandled error on ${request.method} ${request.url}`,
      );
    }

    response.status(error.status).json({
      success: false,
      code: error.code,
      message: error.message,
      ...(error.details?.length ? { details: error.details } : {}),
      requestId: request.id,
    });
  }
}
