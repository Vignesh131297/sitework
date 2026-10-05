import {
  Injectable,
  type CanActivate,
  type ExecutionContext,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import {
  ALLOW_PENDING_PASSWORD_KEY,
  IS_PUBLIC_KEY,
} from '../../common/decorators/auth.decorators.js';
import {
  accountDisabled,
  passwordChangeRequired,
  sessionRevoked,
  signInRequired,
} from '../auth.errors.js';
import type { AuthenticatedRequest } from '../auth-user.js';
import { SessionsRepository } from '../sessions.repository.js';
import { TokenService } from '../token.service.js';

/**
 * Global guard: every route needs a valid access token unless marked @Public().
 * The session and user are re-read from the database on each request, so logout,
 * password changes, deactivation and role changes take effect immediately. The
 * role comes from the database, never from the client.
 */
@Injectable()
export class JwtAuthGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly tokens: TokenService,
    private readonly sessions: SessionsRepository,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const targets = [context.getHandler(), context.getClass()];
    if (this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, targets))
      return true;

    const request = context.switchToHttp().getRequest<AuthenticatedRequest>();
    const token = /^Bearer\s+(\S+)$/i.exec(
      request.headers.authorization ?? '',
    )?.[1];
    if (!token) throw signInRequired();

    const claims = await this.tokens.verifyAccessToken(token);
    const session = await this.sessions.findWithUser(claims.sid);
    if (
      !session ||
      session.userId !== claims.sub ||
      session.revokedAt ||
      session.expiresAt <= new Date()
    ) {
      throw sessionRevoked();
    }
    if (!session.user.isActive) throw accountDisabled();

    request.user = {
      id: session.user.id,
      role: session.user.role,
      name: session.user.name,
      sessionId: session.id,
      mustChangePassword: session.user.mustChangePassword,
    };
    if (
      session.user.mustChangePassword &&
      !this.reflector.getAllAndOverride<boolean>(
        ALLOW_PENDING_PASSWORD_KEY,
        targets,
      )
    ) {
      throw passwordChangeRequired();
    }
    return true;
  }
}
