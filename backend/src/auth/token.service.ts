import { createHmac, randomBytes, timingSafeEqual } from 'node:crypto';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import type { Env } from '../config/env.js';
import type { Role } from '../generated/prisma/enums.js';
import { tokenExpired, tokenInvalid } from './auth.errors.js';

export const TOKEN_ISSUER = 'sitework-api';
export const TOKEN_AUDIENCE = 'sitework-app';

export interface AccessTokenClaims {
  sub: string;
  role: Role;
  /** Session id: lets the server revoke tokens before they expire. */
  sid: string;
  iat: number;
  exp: number;
}

/** Refresh tokens look like "<sessionId>.<secret>"; only an HMAC of the secret is stored. */
export function formatRefreshToken(sessionId: string, secret: string): string {
  return `${sessionId}.${secret}`;
}

export function parseRefreshToken(
  token: string,
): { sessionId: string; secret: string } | null {
  const match =
    /^([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})\.([\w-]{40,})$/i.exec(
      token.trim(),
    );
  return match ? { sessionId: match[1], secret: match[2] } : null;
}

@Injectable()
export class TokenService {
  constructor(
    private readonly jwt: JwtService,
    private readonly config: ConfigService<Env, true>,
  ) {}

  async signAccessToken(
    user: { id: string; role: Role },
    sessionId: string,
    now: Date = new Date(),
  ): Promise<{ token: string; expiresAt: Date }> {
    const iat = Math.floor(now.getTime() / 1000);
    const exp =
      iat + this.config.get('JWT_ACCESS_TTL_MINUTES', { infer: true }) * 60;
    const claims: AccessTokenClaims = {
      sub: user.id,
      role: user.role,
      sid: sessionId,
      iat,
      exp,
    };
    const token = await this.jwt.signAsync(claims, {
      algorithm: 'HS256',
      issuer: TOKEN_ISSUER,
      audience: TOKEN_AUDIENCE,
    });
    return { token, expiresAt: new Date(exp * 1000) };
  }

  async verifyAccessToken(token: string): Promise<AccessTokenClaims> {
    try {
      return await this.jwt.verifyAsync<AccessTokenClaims>(token, {
        algorithms: ['HS256'],
        issuer: TOKEN_ISSUER,
        audience: TOKEN_AUDIENCE,
      });
    } catch (error) {
      if (error instanceof Error && error.name === 'TokenExpiredError')
        throw tokenExpired();
      throw tokenInvalid();
    }
  }

  newSecret(): string {
    return randomBytes(32).toString('base64url');
  }

  /** Peppered hash; the purpose prefix keeps refresh tokens and reset codes apart. */
  hash(purpose: 'refresh' | 'reset', value: string): string {
    return createHmac(
      'sha256',
      this.config.get('JWT_REFRESH_SECRET', { infer: true }),
    )
      .update(`${purpose}:${value}`)
      .digest('base64url');
  }

  matches(
    purpose: 'refresh' | 'reset',
    value: string,
    expectedHash: string,
  ): boolean {
    const actual = Buffer.from(this.hash(purpose, value));
    const expected = Buffer.from(expectedHash);
    return (
      actual.length === expected.length && timingSafeEqual(actual, expected)
    );
  }
}
