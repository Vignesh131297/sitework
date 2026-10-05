import { randomBytes } from 'node:crypto';
import { HttpStatus, Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AuditService } from '../common/audit/audit.service.js';
import { AppException } from '../common/errors/app.exception.js';
import { ErrorCode } from '../common/errors/error-codes.js';
import { parseLoginIdentifier } from '../common/identity/phone.js';
import type { Env } from '../config/env.js';
import type { Role } from '../generated/prisma/enums.js';
import { MailSender } from '../mail/mail.module.js';
import { PrismaService } from '../prisma/prisma.service.js';
import {
  UsersRepository,
  type AuthUserRecord,
} from '../users/users.repository.js';
import {
  accountDisabled,
  accountLocked,
  invalidCredentials,
  invalidResetCode,
  samePassword,
  sessionRevoked,
  tokenInvalid,
  weakPassword,
  wrongCurrentPassword,
} from './auth.errors.js';
import type { AuthUser } from './auth-user.js';
import { hashPassword, verifyPassword } from './password-hasher.js';
import {
  afterFailedLogin,
  generateResetCode,
  generateTemporaryPassword,
  lockMinutesLeft,
  passwordProblem,
  RESET_CODE_MAX_ATTEMPTS,
  RESET_CODE_TTL_MINUTES,
} from './password-rules.js';
import { SessionsRepository } from './sessions.repository.js';
import {
  formatRefreshToken,
  parseRefreshToken,
  TokenService,
} from './token.service.js';

export interface ClientContext {
  ip: string | null;
  deviceName: string | null;
}

export interface SessionUser {
  id: string;
  name: string;
  role: Role;
  mustChangePassword: boolean;
}

export interface AuthResult {
  accessToken: string;
  accessTokenExpiresAt: string;
  refreshToken: string;
  user: SessionUser;
}

const RESET_REQUESTED_MESSAGE =
  "If your account has an e-mail address, we've sent it a 6-digit code. Otherwise, ask your admin to reset your password.";

@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);
  private dummyHash?: Promise<string>;

  constructor(
    private readonly prisma: PrismaService,
    private readonly users: UsersRepository,
    private readonly sessions: SessionsRepository,
    private readonly tokens: TokenService,
    private readonly config: ConfigService<Env, true>,
    private readonly mail: MailSender,
    private readonly audit: AuditService,
  ) {}

  async login(
    identifierText: string,
    password: string,
    client: ClientContext,
  ): Promise<AuthResult> {
    const now = new Date();
    const identifier = parseLoginIdentifier(identifierText);
    const user = identifier ? await this.users.findForLogin(identifier) : null;
    if (!user) {
      // Same work as a real check, so response time doesn't reveal which accounts exist.
      await this.burnPasswordCheck(password);
      throw invalidCredentials();
    }

    const lockedMinutes = lockMinutesLeft(user.lockedUntil, now);
    if (lockedMinutes > 0) throw accountLocked(lockedMinutes);

    if (!(await verifyPassword(user.passwordHash, password))) {
      const next = afterFailedLogin(user.failedLoginCount, now);
      await this.users.recordFailedLogin(user.id, next);
      if (next.lockedUntil)
        throw accountLocked(lockMinutesLeft(next.lockedUntil, now));
      throw invalidCredentials();
    }
    // Checked after the password, so only the account owner learns it is disabled.
    if (!user.isActive) throw accountDisabled();

    await this.users.recordSuccessfulLogin(user.id, now);
    const secret = this.tokens.newSecret();
    const session = await this.sessions.create({
      userId: user.id,
      refreshTokenHash: this.tokens.hash('refresh', secret),
      deviceName: client.deviceName,
      ipAddress: client.ip,
      expiresAt: this.refreshExpiry(now),
    });
    return this.issue(user, session.id, secret, now);
  }

  async refresh(
    refreshToken: string,
    client: ClientContext,
  ): Promise<AuthResult> {
    const now = new Date();
    const parsed = parseRefreshToken(refreshToken);
    if (!parsed) throw tokenInvalid();
    const session = await this.sessions.findWithUser(parsed.sessionId);
    if (!session || session.revokedAt || session.expiresAt <= now)
      throw sessionRevoked();

    if (
      !this.tokens.matches('refresh', parsed.secret, session.refreshTokenHash)
    ) {
      // An already-rotated token came back: it may have been copied. End the session.
      await this.sessions.revoke(session.id, now);
      this.logger.warn(
        { sessionId: session.id, userId: session.userId },
        'Refresh token reuse; session revoked',
      );
      throw sessionRevoked();
    }
    if (!session.user.isActive) {
      await this.sessions.revoke(session.id, now);
      throw accountDisabled();
    }

    const secret = this.tokens.newSecret();
    const rotated = await this.sessions.rotate(
      session.id,
      session.refreshTokenHash,
      {
        refreshTokenHash: this.tokens.hash('refresh', secret),
        expiresAt: this.refreshExpiry(now),
        lastUsedAt: now,
        ipAddress: client.ip,
      },
    );
    // Lost a race with a concurrent refresh of the same token.
    if (!rotated) throw tokenInvalid();
    return this.issue(session.user, session.id, secret, now);
  }

  async logout(user: AuthUser): Promise<void> {
    await this.sessions.revoke(user.sessionId);
  }

  async changePassword(
    user: AuthUser,
    currentPassword: string,
    newPassword: string,
  ): Promise<void> {
    const record = await this.requireUser(user.id);
    if (!(await verifyPassword(record.passwordHash, currentPassword)))
      throw wrongCurrentPassword();
    this.assertAcceptable(newPassword, record);
    if (await verifyPassword(record.passwordHash, newPassword))
      throw samePassword();

    const passwordHash = await hashPassword(newPassword);
    await this.prisma.$transaction(async (tx) => {
      await this.users.setPassword(user.id, passwordHash, false, tx);
      // Other devices must sign in again with the new password.
      await this.sessions.revokeAllForUser(user.id, {
        except: user.sessionId,
        db: tx,
      });
      await this.audit.record(
        {
          actorId: user.id,
          action: 'user.password_changed',
          entityType: 'User',
          entityId: user.id,
        },
        tx,
      );
    });
  }

  /** Always answers the same way, so it can't be used to discover accounts. */
  async requestPasswordReset(
    identifierText: string,
  ): Promise<{ message: string }> {
    const identifier = parseLoginIdentifier(identifierText);
    const user = identifier ? await this.users.findForLogin(identifier) : null;
    if (user?.isActive && user.email && this.mail.enabled) {
      const code = generateResetCode();
      const now = new Date();
      await this.prisma.$transaction([
        this.prisma.passwordResetCode.updateMany({
          where: { userId: user.id, usedAt: null },
          data: { usedAt: now },
        }),
        this.prisma.passwordResetCode.create({
          data: {
            userId: user.id,
            codeHash: this.tokens.hash('reset', `${user.id}:${code}`),
            expiresAt: new Date(
              now.getTime() + RESET_CODE_TTL_MINUTES * 60_000,
            ),
          },
        }),
      ]);
      // Not awaited: sending time must not reveal that the account exists.
      void this.mail
        .send({
          to: user.email,
          subject: 'Your SiteWork password reset code',
          text: `Your code is ${code}. It expires in ${RESET_CODE_TTL_MINUTES} minutes.\n\nIf you didn't ask to reset your password, you can ignore this e-mail.`,
        })
        .catch((error: unknown) =>
          this.logger.error(
            { err: error, userId: user.id },
            'Could not send password reset e-mail',
          ),
        );
    }
    return { message: RESET_REQUESTED_MESSAGE };
  }

  async resetPassword(
    identifierText: string,
    code: string,
    newPassword: string,
  ): Promise<void> {
    const now = new Date();
    const identifier = parseLoginIdentifier(identifierText);
    const user = identifier ? await this.users.findForLogin(identifier) : null;
    if (!user?.isActive) throw invalidResetCode();

    const record = await this.prisma.passwordResetCode.findFirst({
      where: { userId: user.id, usedAt: null, expiresAt: { gt: now } },
      orderBy: { createdAt: 'desc' },
    });
    if (!record || record.attempts >= RESET_CODE_MAX_ATTEMPTS)
      throw invalidResetCode();
    if (!this.tokens.matches('reset', `${user.id}:${code}`, record.codeHash)) {
      await this.prisma.passwordResetCode.update({
        where: { id: record.id },
        data: { attempts: { increment: 1 } },
      });
      throw invalidResetCode();
    }
    this.assertAcceptable(newPassword, user);

    const passwordHash = await hashPassword(newPassword);
    await this.prisma.$transaction(async (tx) => {
      await tx.passwordResetCode.update({
        where: { id: record.id },
        data: { usedAt: now },
      });
      await this.users.setPassword(user.id, passwordHash, false, tx);
      await this.sessions.revokeAllForUser(user.id, { db: tx, now });
      await this.audit.record(
        {
          actorId: user.id,
          action: 'user.password_reset_by_code',
          entityType: 'User',
          entityId: user.id,
        },
        tx,
      );
    });
  }

  /** Admin-assisted reset: returns a temporary password the user must replace at next sign-in. */
  async resetPasswordAsAdmin(
    actor: AuthUser,
    targetUserId: string,
  ): Promise<{ temporaryPassword: string }> {
    await this.requireUser(targetUserId);
    const temporaryPassword = generateTemporaryPassword();
    const passwordHash = await hashPassword(temporaryPassword);
    await this.prisma.$transaction(async (tx) => {
      await this.users.setPassword(targetUserId, passwordHash, true, tx);
      await this.sessions.revokeAllForUser(targetUserId, { db: tx });
      await this.audit.record(
        {
          actorId: actor.id,
          action: 'user.password_reset_by_admin',
          entityType: 'User',
          entityId: targetUserId,
        },
        tx,
      );
    });
    return { temporaryPassword };
  }

  private async issue(
    user: Pick<AuthUserRecord, 'id' | 'name' | 'role' | 'mustChangePassword'>,
    sessionId: string,
    secret: string,
    now: Date,
  ): Promise<AuthResult> {
    const access = await this.tokens.signAccessToken(user, sessionId, now);
    return {
      accessToken: access.token,
      accessTokenExpiresAt: access.expiresAt.toISOString(),
      refreshToken: formatRefreshToken(sessionId, secret),
      user: {
        id: user.id,
        name: user.name,
        role: user.role,
        mustChangePassword: user.mustChangePassword,
      },
    };
  }

  private refreshExpiry(now: Date): Date {
    const days = this.config.get('REFRESH_TOKEN_TTL_DAYS', { infer: true });
    return new Date(now.getTime() + days * 86_400_000);
  }

  private assertAcceptable(password: string, user: { phone: string }): void {
    const problem = passwordProblem(password, { phone: user.phone });
    if (problem) throw weakPassword(problem);
  }

  private async requireUser(id: string): Promise<AuthUserRecord> {
    const user = await this.users.findForAuth(id);
    if (!user) {
      throw new AppException(
        ErrorCode.NOT_FOUND,
        'That user was not found.',
        HttpStatus.NOT_FOUND,
      );
    }
    return user;
  }

  private async burnPasswordCheck(password: string): Promise<void> {
    this.dummyHash ??= hashPassword(randomBytes(16).toString('hex'));
    await verifyPassword(await this.dummyHash, password).catch(() => false);
  }
}
