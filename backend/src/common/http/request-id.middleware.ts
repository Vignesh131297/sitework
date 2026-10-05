import { randomUUID } from 'node:crypto';
import type { NextFunction, Request, Response } from 'express';

export type RequestWithId = Request & { id?: string };

/**
 * Gives every request an id (the caller's x-request-id if sane, else a UUID) and echoes
 * it in the response. Registered before body parsing so even malformed-body errors
 * can be traced; the logger reuses the same id.
 */
export function requestIdMiddleware(
  req: RequestWithId,
  res: Response,
  next: NextFunction,
): void {
  const header = req.headers['x-request-id'];
  req.id =
    typeof header === 'string' && /^[\w.-]{1,64}$/.test(header)
      ? header
      : randomUUID();
  res.setHeader('x-request-id', req.id);
  next();
}
