import {
  HttpStatus,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import { toApiError } from './api-error.js';
import { AppException } from './app.exception.js';
import { ErrorCode } from './error-codes.js';

const prismaError = (code: string, meta?: Record<string, unknown>) =>
  Object.assign(new Error(`Prisma error ${code}`), {
    name: 'PrismaClientKnownRequestError',
    code,
    meta,
  });

describe('toApiError', () => {
  it('passes business errors through with their user-facing message', () => {
    const error = new AppException(
      ErrorCode.CONFLICT,
      'Morning update has already been submitted.',
      HttpStatus.CONFLICT,
      [{ field: 'slot', message: 'already submitted' }],
    );
    expect(toApiError(error)).toEqual({
      status: 409,
      code: 'CONFLICT',
      message: 'Morning update has already been submitted.',
      details: [{ field: 'slot', message: 'already submitted' }],
    });
  });

  it('maps framework HTTP errors to a code by status', () => {
    expect(toApiError(new NotFoundException('Cannot GET /api/v1/x'))).toEqual({
      status: 404,
      code: 'NOT_FOUND',
      message: 'Cannot GET /api/v1/x',
    });
  });

  it('never exposes the message of a server error', () => {
    expect(
      toApiError(new InternalServerErrorException('db password is wrong')),
    ).toEqual({
      status: 500,
      code: 'INTERNAL_ERROR',
      message: 'Something went wrong. Please try again.',
    });
    expect(toApiError(new TypeError('x is undefined'))).toMatchObject({
      status: 500,
      code: 'INTERNAL_ERROR',
    });
  });

  it('maps unique violations to CONFLICT, naming fields when Prisma reports them', () => {
    expect(
      toApiError(prismaError('P2002', { target: ['employee_code'] })),
    ).toMatchObject({
      status: 409,
      code: 'CONFLICT',
      details: [{ field: 'employeeCode', message: 'must be unique' }],
    });
    expect(
      toApiError(
        prismaError('P2002', {
          driverAdapterError: { cause: { constraint: { fields: ['phone'] } } },
        }),
      ),
    ).toMatchObject({
      details: [{ field: 'phone', message: 'must be unique' }],
    });
  });

  it('does not leak index names when fields are unknown', () => {
    const error = prismaError('P2002', {
      driverAdapterError: {
        cause: { constraint: { index: 'users_phone_key' } },
      },
    });
    expect(toApiError(error)).toEqual({
      status: 409,
      code: 'CONFLICT',
      message: 'A record with the same details already exists.',
      details: [],
    });
  });

  it('maps missing records and foreign-key conflicts', () => {
    expect(toApiError(prismaError('P2025'))).toMatchObject({
      status: 404,
      code: 'NOT_FOUND',
    });
    expect(toApiError(prismaError('P2003'))).toMatchObject({
      status: 409,
      code: 'CONFLICT',
    });
    expect(toApiError(prismaError('P1001'))).toMatchObject({
      status: 500,
      code: 'INTERNAL_ERROR',
    });
  });

  it('maps body-parser failures without echoing parser internals', () => {
    const malformed = Object.assign(
      new SyntaxError('Unexpected token } in JSON'),
      {
        status: 400,
        type: 'entity.parse.failed',
      },
    );
    expect(toApiError(malformed)).toEqual({
      status: 400,
      code: 'BAD_REQUEST',
      message: 'The request could not be understood.',
    });
    const tooLarge = Object.assign(new Error('request entity too large'), {
      status: 413,
    });
    expect(toApiError(tooLarge)).toMatchObject({
      status: 413,
      code: 'PAYLOAD_TOO_LARGE',
    });
  });
});
