import { HttpException, HttpStatus } from '@nestjs/common';
import { AppException, type ErrorDetail } from './app.exception.js';
import { ErrorCode } from './error-codes.js';

export interface ApiError {
  status: number;
  code: ErrorCode;
  message: string;
  details?: ErrorDetail[];
}

const codeByStatus: Partial<Record<number, ErrorCode>> = {
  [HttpStatus.BAD_REQUEST]: ErrorCode.BAD_REQUEST,
  [HttpStatus.UNAUTHORIZED]: ErrorCode.UNAUTHORIZED,
  [HttpStatus.FORBIDDEN]: ErrorCode.FORBIDDEN,
  [HttpStatus.NOT_FOUND]: ErrorCode.NOT_FOUND,
  [HttpStatus.CONFLICT]: ErrorCode.CONFLICT,
  [HttpStatus.PAYLOAD_TOO_LARGE]: ErrorCode.PAYLOAD_TOO_LARGE,
  [HttpStatus.TOO_MANY_REQUESTS]: ErrorCode.RATE_LIMITED,
  [HttpStatus.SERVICE_UNAVAILABLE]: ErrorCode.SERVICE_UNAVAILABLE,
};

const INTERNAL_ERROR: ApiError = {
  status: HttpStatus.INTERNAL_SERVER_ERROR,
  code: ErrorCode.INTERNAL_ERROR,
  message: 'Something went wrong. Please try again.',
};

/**
 * Converts anything thrown while handling a request into the public error shape.
 * Details of unexpected errors never leave the server; they are logged instead.
 */
export function toApiError(exception: unknown): ApiError {
  if (exception instanceof AppException) {
    return {
      status: exception.getStatus(),
      code: exception.code,
      message: exception.message,
      details: exception.details,
    };
  }

  if (exception instanceof HttpException) {
    const status = exception.getStatus();
    if (status >= 500) return { ...INTERNAL_ERROR, status };
    return {
      status,
      code: codeByStatus[status] ?? ErrorCode.BAD_REQUEST,
      message: httpExceptionMessage(exception),
    };
  }

  const prismaError = asPrismaKnownError(exception);
  if (prismaError) return fromPrismaError(prismaError);

  // Errors raised by Express middleware before Nest (e.g. malformed JSON body).
  const middlewareStatus = clientErrorStatus(exception);
  if (middlewareStatus === HttpStatus.PAYLOAD_TOO_LARGE) {
    return {
      status: middlewareStatus,
      code: ErrorCode.PAYLOAD_TOO_LARGE,
      message: 'The request is too large.',
    };
  }
  if (middlewareStatus) {
    return {
      status: middlewareStatus,
      code: codeByStatus[middlewareStatus] ?? ErrorCode.BAD_REQUEST,
      message: 'The request could not be understood.',
    };
  }

  return INTERNAL_ERROR;
}

function httpExceptionMessage(exception: HttpException): string {
  const response = exception.getResponse();
  if (typeof response === 'string') return response;
  if (response && typeof response === 'object' && 'message' in response) {
    const message = (response as { message: unknown }).message;
    if (typeof message === 'string') return message;
    if (Array.isArray(message)) return message.join(', ');
  }
  return exception.message;
}

interface PrismaKnownError {
  code: string;
  meta?: Record<string, unknown>;
}

// Duck-typed so this module does not depend on the generated Prisma client.
function asPrismaKnownError(error: unknown): PrismaKnownError | undefined {
  if (
    error instanceof Error &&
    error.name === 'PrismaClientKnownRequestError' &&
    typeof (error as { code?: unknown }).code === 'string'
  ) {
    return error as unknown as PrismaKnownError;
  }
  return undefined;
}

function fromPrismaError(error: PrismaKnownError): ApiError {
  switch (error.code) {
    case 'P2002':
      return {
        status: HttpStatus.CONFLICT,
        code: ErrorCode.CONFLICT,
        message: 'A record with the same details already exists.',
        details: uniqueFields(error.meta).map((field) => ({
          field,
          message: 'must be unique',
        })),
      };
    case 'P2003':
      return {
        status: HttpStatus.CONFLICT,
        code: ErrorCode.CONFLICT,
        message:
          'This record is linked to other records and cannot be changed.',
      };
    case 'P2025':
      return {
        status: HttpStatus.NOT_FOUND,
        code: ErrorCode.NOT_FOUND,
        message: 'The requested record was not found.',
      };
    default:
      return INTERNAL_ERROR;
  }
}

/**
 * Field names of a unique violation, when Prisma reports them: `meta.target` (classic
 * engine) or `meta.driverAdapterError.cause.constraint.fields` (driver adapters). When
 * only an index name is known, no details are returned rather than leaking it.
 */
function uniqueFields(meta: Record<string, unknown> | undefined): string[] {
  const target = meta?.target;
  const adapterFields = (
    meta?.driverAdapterError as
      { cause?: { constraint?: { fields?: unknown } } } | undefined
  )?.cause?.constraint?.fields;
  const fields = Array.isArray(target)
    ? target
    : typeof target === 'string'
      ? [target]
      : Array.isArray(adapterFields)
        ? adapterFields
        : [];
  return fields.map((field) => camelCase(String(field)));
}

function camelCase(name: string): string {
  return name.replace(/_([a-z])/g, (_, letter: string) => letter.toUpperCase());
}

function clientErrorStatus(error: unknown): number | undefined {
  if (!error || typeof error !== 'object') return undefined;
  const { status, statusCode } = error as {
    status?: unknown;
    statusCode?: unknown;
  };
  const value = typeof status === 'number' ? status : statusCode;
  return typeof value === 'number' && value >= 400 && value < 500
    ? value
    : undefined;
}
