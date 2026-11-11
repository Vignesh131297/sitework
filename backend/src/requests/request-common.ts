import { HttpStatus } from '@nestjs/common';
import type { AuthUser } from '../auth/auth-user.js';
import { AppException } from '../common/errors/app.exception.js';
import { ErrorCode } from '../common/errors/error-codes.js';
import { conflict } from '../common/errors/http-errors.js';
import { toDbDate } from '../common/time/business-time.js';
import type { Prisma } from '../generated/prisma/client.js';

type Db = Prisma.TransactionClient;

/** "LV-0007" (leave) or "RQ-0012" (money and food). */
export function leaveCode(number: number): string {
  return `LV-${String(number).padStart(4, '0')}`;
}

export function staffRequestCode(number: number): string {
  return `RQ-${String(number).padStart(4, '0')}`;
}

/** Engineers on a site: they may decide its staff's leave and requests. */
export async function siteEngineerIds(
  db: Db,
  siteId: string,
): Promise<string[]> {
  const rows = await db.engineerAssignment.findMany({
    where: { siteId },
    select: { engineerId: true },
  });
  return rows.map((row) => row.engineerId);
}

/**
 * Staff (of these) on approved leave that day. Their absence is expected: they
 * are marked ON_LEAVE and owe no photo updates.
 */
export async function staffOnLeave(
  db: Pick<Db, 'leaveRequest'>,
  staffIds: readonly string[],
  date: string,
): Promise<Set<string>> {
  if (staffIds.length === 0) return new Set();
  const day = toDbDate(date);
  const rows = await db.leaveRequest.findMany({
    where: {
      userId: { in: [...staffIds] },
      status: 'APPROVED',
      fromDate: { lte: day },
      toDate: { gte: day },
    },
    select: { userId: true },
  });
  return new Set(rows.map((row) => row.userId));
}

export const forbidden = (message: string) =>
  new AppException(ErrorCode.FORBIDDEN, message, HttpStatus.FORBIDDEN);

export const alreadyDecided = (code: string) =>
  conflict(
    ErrorCode.REQUEST_ALREADY_DECIDED,
    `${code} has already been dealt with. Reload it to see where it is.`,
  );

export const formTaken = () =>
  conflict(
    ErrorCode.CONFLICT,
    'This form was already sent by someone else. Start a new one.',
  );

/** Who decided, as the views show it. */
export type Person = { id: string; name: string };

export type Caller = Pick<AuthUser, 'id' | 'role' | 'name'>;
