import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import type { Env } from '../config/env.js';
import {
  formatRefreshToken,
  parseRefreshToken,
  TokenService,
} from './token.service.js';

const config = new ConfigService<Env, true>({
  JWT_SECRET: 'a'.repeat(40),
  JWT_REFRESH_SECRET: 'b'.repeat(40),
  JWT_ACCESS_TTL_MINUTES: 15,
});
const tokens = new TokenService(
  new JwtService({ secret: 'a'.repeat(40) }),
  config,
);
const user = {
  id: '0192a1b2-c3d4-7e5f-8a9b-0c1d2e3f4a5b',
  role: 'STAFF' as const,
};
const sessionId = '0192a1b2-c3d4-7e5f-8a9b-111111111111';

describe('TokenService', () => {
  it('issues access tokens that expire after the configured minutes', async () => {
    const now = new Date();
    const { token, expiresAt } = await tokens.signAccessToken(
      user,
      sessionId,
      now,
    );
    expect(expiresAt.getTime() - Math.floor(now.getTime() / 1000) * 1000).toBe(
      15 * 60_000,
    );

    const claims = await tokens.verifyAccessToken(token);
    expect(claims).toMatchObject({
      sub: user.id,
      role: 'STAFF',
      sid: sessionId,
    });
  });

  it('rejects expired tokens with TOKEN_EXPIRED', async () => {
    const { token } = await tokens.signAccessToken(
      user,
      sessionId,
      new Date(Date.now() - 60 * 60_000),
    );
    await expect(tokens.verifyAccessToken(token)).rejects.toMatchObject({
      code: 'TOKEN_EXPIRED',
    });
  });

  it('rejects tampered or foreign tokens with TOKEN_INVALID', async () => {
    const { token } = await tokens.signAccessToken(user, sessionId);
    const [header, , signature] = token.split('.');
    const forged = `${header}.${Buffer.from(JSON.stringify({ sub: 'x', role: 'ADMIN' })).toString('base64url')}.${signature}`;
    await expect(tokens.verifyAccessToken(forged)).rejects.toMatchObject({
      code: 'TOKEN_INVALID',
    });

    const foreign = await new JwtService({ secret: 'c'.repeat(40) }).signAsync({
      sub: user.id,
    });
    await expect(tokens.verifyAccessToken(foreign)).rejects.toMatchObject({
      code: 'TOKEN_INVALID',
    });
  });

  it('hashes secrets per purpose and compares them safely', () => {
    const secret = tokens.newSecret();
    const hash = tokens.hash('refresh', secret);
    expect(tokens.matches('refresh', secret, hash)).toBe(true);
    expect(tokens.matches('reset', secret, hash)).toBe(false);
    expect(tokens.matches('refresh', `${secret}x`, hash)).toBe(false);
  });

  it('formats and parses refresh tokens', () => {
    const secret = tokens.newSecret();
    expect(parseRefreshToken(formatRefreshToken(sessionId, secret))).toEqual({
      sessionId,
      secret,
    });
    expect(parseRefreshToken('not-a-token')).toBeNull();
    expect(parseRefreshToken(`${'-'.repeat(36)}.${secret}`)).toBeNull();
  });
});
