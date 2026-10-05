import { Injectable } from '@nestjs/common';
import { ThrottlerGuard } from '@nestjs/throttler';
import type { AuthUser } from '../../auth/auth-user.js';
import { parseLoginIdentifier } from '../identity/phone.js';

/**
 * Mobile carriers put many phones behind one IP address (CGNAT), so limits are
 * per account for signed-in users, and per IP *and* identifier for sign-in.
 * Identifiers are normalized so "98765 43210" and "+919876543210" share a limit.
 */
@Injectable()
export class AppThrottlerGuard extends ThrottlerGuard {
  protected override getTracker(req: Record<string, any>): Promise<string> {
    const user = req.user as AuthUser | undefined;
    if (user) return Promise.resolve(`user:${user.id}`);

    const ip = String(req.ip ?? 'unknown');
    const raw: unknown = req.body?.identifier;
    if (typeof raw !== 'string') return Promise.resolve(`ip:${ip}`);
    const identifier = parseLoginIdentifier(raw);
    const key =
      identifier?.kind === 'email'
        ? identifier.email
        : identifier?.kind === 'phone'
          ? identifier.phone
          : raw.trim().toLowerCase();
    return Promise.resolve(`ip:${ip}:id:${key}`);
  }
}
