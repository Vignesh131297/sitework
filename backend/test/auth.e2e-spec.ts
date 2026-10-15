import { TokenService } from '../src/auth/token.service.js';
import {
  createSite,
  createUser,
  resetDatabase,
  TEST_PASSWORD,
} from './support/fixtures.js';
import { createTestApp, type TestApp } from './support/test-app.js';

describe('Authentication (e2e)', () => {
  let t: TestApp;

  beforeAll(async () => {
    t = await createTestApp();
  });

  beforeEach(async () => {
    await resetDatabase(t.prisma);
    t.mail.sent.length = 0;
  });

  afterAll(async () => {
    await t.close();
  });

  const login = (identifier: string, password = TEST_PASSWORD) =>
    t
      .http()
      .post('/api/v1/auth/login')
      .send({ identifier, password, deviceName: 'test' });

  const signIn = async (identifier: string, password = TEST_PASSWORD) => {
    const response = await login(identifier, password).expect(200);
    return response.body.data as {
      accessToken: string;
      refreshToken: string;
      user: { id: string; role: string; mustChangePassword: boolean };
    };
  };

  const me = (accessToken: string) =>
    t.http().get('/api/v1/me').set('authorization', `Bearer ${accessToken}`);

  describe('sign-in', () => {
    it('accepts a phone number in any common format, or an e-mail in any case', async () => {
      const user = await createUser(t.prisma, {
        role: 'ENGINEER',
        phone: '+919876543210',
        email: 'arun@sitework.test',
      });

      for (const identifier of [
        '9876543210',
        '+91 98765 43210',
        'ARUN@SiteWork.test',
      ]) {
        const session = await signIn(identifier);
        expect(session.user).toEqual({
          id: user.id,
          name: user.name,
          role: 'ENGINEER',
          mustChangePassword: false,
        });
        expect(session.refreshToken).toMatch(/^[0-9a-f-]{36}\.[\w-]{40,}$/);
        await me(session.accessToken).expect(200);
      }
    });

    it('gives the same answer for a wrong password and an unknown account', async () => {
      await createUser(t.prisma, { phone: '+919876543211' });
      const wrongPassword = await login('9876543211', 'Wrong1234').expect(401);
      const unknown = await login('9123456789').expect(401);
      for (const response of [wrongPassword, unknown]) {
        expect(response.body).toMatchObject({
          code: 'INVALID_CREDENTIALS',
          message: 'The mobile number/e-mail or password is incorrect.',
        });
      }
    });

    it('locks the account after 5 failures, even for the right password', async () => {
      await createUser(t.prisma, { phone: '+919876543212' });
      for (let attempt = 1; attempt <= 4; attempt += 1) {
        await login('9876543212', 'Wrong1234').expect(401);
      }
      const fifth = await login('9876543212', 'Wrong1234').expect(401);
      expect(fifth.body.code).toBe('ACCOUNT_LOCKED');
      const correct = await login('9876543212').expect(401);
      expect(correct.body).toMatchObject({ code: 'ACCOUNT_LOCKED' });
      expect(correct.body.message).toMatch(/Try again in 15 minutes/);
    });

    it('tells a deactivated user only after the right password, and ends their sessions', async () => {
      const user = await createUser(t.prisma, { phone: '+919876543213' });
      const session = await signIn('9876543213');

      await t.prisma.user.update({
        where: { id: user.id },
        data: { isActive: false },
      });

      expect(
        (await login('9876543213', 'Wrong1234').expect(401)).body.code,
      ).toBe('INVALID_CREDENTIALS');
      expect((await login('9876543213').expect(401)).body.code).toBe(
        'ACCOUNT_DISABLED',
      );
      expect((await me(session.accessToken).expect(401)).body.code).toBe(
        'ACCOUNT_DISABLED',
      );
    });

    it('limits sign-in attempts per identifier', async () => {
      for (let attempt = 0; attempt < 10; attempt += 1) {
        await login('9000011111', 'Wrong1234').expect(401);
      }
      const limited = await login('9000011111', 'Wrong1234').expect(429);
      expect(limited.body.code).toBe('RATE_LIMITED');
      // Another account from the same IP is unaffected.
      await login('9000022222', 'Wrong1234').expect(401);
    });
  });

  describe('access tokens', () => {
    it('rejects missing, malformed and expired tokens with distinct codes', async () => {
      expect((await t.http().get('/api/v1/me').expect(401)).body.code).toBe(
        'UNAUTHORIZED',
      );
      expect((await me('not.a.token').expect(401)).body.code).toBe(
        'TOKEN_INVALID',
      );

      const user = await createUser(t.prisma);
      const session = await signIn(user.phone);
      const sessionId = session.refreshToken.split('.')[0];
      const expired = await t.app
        .get(TokenService)
        .signAccessToken(user, sessionId, new Date(Date.now() - 60 * 60_000));
      expect((await me(expired.token).expect(401)).body.code).toBe(
        'TOKEN_EXPIRED',
      );
    });

    it('takes the role from the database, not from the token', async () => {
      const user = await createUser(t.prisma, { role: 'ADMIN' });
      const session = await signIn(user.phone);
      const target = await createUser(t.prisma);
      await t.prisma.user.update({
        where: { id: user.id },
        data: { role: 'ENGINEER' },
      });

      const response = await t
        .http()
        .post(`/api/v1/users/${target.id}/reset-password`)
        .set('authorization', `Bearer ${session.accessToken}`)
        .expect(403);
      expect(response.body.code).toBe('FORBIDDEN');
    });
  });

  describe('refresh and logout', () => {
    it('rotates refresh tokens and ends the session when an old one is reused', async () => {
      const user = await createUser(t.prisma);
      const first = await signIn(user.phone);

      const refreshed = await t
        .http()
        .post('/api/v1/auth/refresh')
        .send({ refreshToken: first.refreshToken })
        .expect(200);
      const second = refreshed.body.data as {
        accessToken: string;
        refreshToken: string;
      };
      expect(second.refreshToken).not.toBe(first.refreshToken);
      await me(second.accessToken).expect(200);

      // The first token was already used: treat it as stolen and end the session.
      const reuse = await t
        .http()
        .post('/api/v1/auth/refresh')
        .send({ refreshToken: first.refreshToken })
        .expect(401);
      expect(reuse.body.code).toBe('SESSION_REVOKED');
      expect((await me(second.accessToken).expect(401)).body.code).toBe(
        'SESSION_REVOKED',
      );
      await t
        .http()
        .post('/api/v1/auth/refresh')
        .send({ refreshToken: second.refreshToken })
        .expect(401);
    });

    it('logout ends only that session', async () => {
      const user = await createUser(t.prisma);
      const phone = await signIn(user.phone);
      const tablet = await signIn(user.phone);

      await t
        .http()
        .post('/api/v1/auth/logout')
        .set('authorization', `Bearer ${phone.accessToken}`)
        .expect(200);

      expect((await me(phone.accessToken).expect(401)).body.code).toBe(
        'SESSION_REVOKED',
      );
      await me(tablet.accessToken).expect(200);
    });
  });

  describe('passwords', () => {
    const changePassword = (
      accessToken: string,
      currentPassword: string,
      newPassword: string,
    ) =>
      t
        .http()
        .patch('/api/v1/auth/password')
        .set('authorization', `Bearer ${accessToken}`)
        .send({ currentPassword, newPassword });

    it('changes the password and signs out other devices', async () => {
      const user = await createUser(t.prisma);
      const current = await signIn(user.phone);
      const other = await signIn(user.phone);

      expect(
        (
          await changePassword(
            current.accessToken,
            'Wrong1234',
            'NewPass2026',
          ).expect(400)
        ).body.code,
      ).toBe('WRONG_CURRENT_PASSWORD');
      const weak = await changePassword(
        current.accessToken,
        TEST_PASSWORD,
        'short',
      ).expect(400);
      expect(weak.body).toMatchObject({
        code: 'WEAK_PASSWORD',
        message: 'Use at least 8 characters.',
      });
      expect(
        (
          await changePassword(
            current.accessToken,
            TEST_PASSWORD,
            TEST_PASSWORD,
          ).expect(400)
        ).body.code,
      ).toBe('SAME_PASSWORD');

      await changePassword(
        current.accessToken,
        TEST_PASSWORD,
        'NewPass2026',
      ).expect(200);

      await me(current.accessToken).expect(200);
      await me(other.accessToken).expect(401);
      await login(user.phone).expect(401);
      await login(user.phone, 'NewPass2026').expect(200);
    });

    it('admin reset: temporary password, forced change, then full access', async () => {
      const admin = await createUser(t.prisma, { role: 'ADMIN' });
      const engineer = await createUser(t.prisma, { role: 'ENGINEER' });
      const target = await createUser(t.prisma, { role: 'ADMIN' });
      const adminSession = await signIn(admin.phone);
      const engineerSession = await signIn(engineer.phone);
      const targetOldSession = await signIn(target.phone);

      const resetBy = (accessToken: string, userId: string) =>
        t
          .http()
          .post(`/api/v1/users/${userId}/reset-password`)
          .set('authorization', `Bearer ${accessToken}`);

      expect(
        (await resetBy(engineerSession.accessToken, target.id).expect(403)).body
          .code,
      ).toBe('FORBIDDEN');
      await resetBy(
        adminSession.accessToken,
        '00000000-0000-0000-0000-000000000000',
      ).expect(404);
      await resetBy(adminSession.accessToken, 'not-an-id').expect(404);

      const reset = await resetBy(adminSession.accessToken, target.id).expect(
        200,
      );
      const temporaryPassword = reset.body.data.temporaryPassword as string;
      await me(targetOldSession.accessToken).expect(401);

      const withTemporary = await signIn(target.phone, temporaryPassword);
      expect(withTemporary.user.mustChangePassword).toBe(true);
      // Only the profile, logout and password change work until the password is replaced.
      await me(withTemporary.accessToken).expect(200);
      const blocked = await resetBy(
        withTemporary.accessToken,
        engineer.id,
      ).expect(403);
      expect(blocked.body.code).toBe('PASSWORD_CHANGE_REQUIRED');

      await changePassword(
        withTemporary.accessToken,
        temporaryPassword,
        'Fresh2026pass',
      ).expect(200);
      await resetBy(withTemporary.accessToken, engineer.id).expect(200);

      const audit = await t.prisma.auditLog.findMany({
        where: { entityId: target.id },
      });
      expect(audit.map((entry) => entry.action).sort()).toEqual([
        'user.password_changed',
        'user.password_reset_by_admin',
      ]);
    });

    it('e-mail reset code: one use, limited attempts, same reply for unknown accounts', async () => {
      const user = await createUser(t.prisma, {
        role: 'ENGINEER',
        email: 'eng@sitework.test',
      });
      const oldSession = await signIn('eng@sitework.test');

      const unknown = await t
        .http()
        .post('/api/v1/auth/forgot-password')
        .send({ identifier: 'nobody@sitework.test' })
        .expect(200);
      const known = await t
        .http()
        .post('/api/v1/auth/forgot-password')
        .send({ identifier: 'ENG@sitework.test' })
        .expect(200);
      expect(known.body).toEqual(unknown.body);
      expect(t.mail.sent).toHaveLength(1);
      const code = /Your code is (\d{6})/.exec(t.mail.sent[0].text)?.[1];
      expect(code).toBeDefined();

      const reset = (codeValue: string, newPassword = 'Reset2026pass') =>
        t.http().post('/api/v1/auth/reset-password').send({
          identifier: 'eng@sitework.test',
          code: codeValue,
          newPassword,
        });

      const wrong = code === '000000' ? '111111' : '000000';
      expect((await reset(wrong).expect(400)).body.code).toBe(
        'INVALID_RESET_CODE',
      );
      await reset(code!).expect(200);
      expect((await reset(code!).expect(400)).body.code).toBe(
        'INVALID_RESET_CODE',
      );

      await me(oldSession.accessToken).expect(401);
      await login('eng@sitework.test', 'Reset2026pass').expect(200);
      const stored = await t.prisma.passwordResetCode.findFirstOrThrow({
        where: { userId: user.id },
      });
      expect(stored.codeHash).not.toContain(code);
    });

    it('stops accepting a reset code after 5 wrong attempts', async () => {
      await createUser(t.prisma, {
        role: 'ENGINEER',
        email: 'eng2@sitework.test',
      });
      await t
        .http()
        .post('/api/v1/auth/forgot-password')
        .send({ identifier: 'eng2@sitework.test' })
        .expect(200);
      const code = /Your code is (\d{6})/.exec(t.mail.sent[0].text)![1];
      const wrong = code === '000000' ? '111111' : '000000';

      for (let attempt = 0; attempt < 5; attempt += 1) {
        await t
          .http()
          .post('/api/v1/auth/reset-password')
          .send({
            identifier: 'eng2@sitework.test',
            code: wrong,
            newPassword: 'Reset2026pass',
          })
          .expect(400);
      }
      await t
        .http()
        .post('/api/v1/auth/reset-password')
        .send({
          identifier: 'eng2@sitework.test',
          code,
          newPassword: 'Reset2026pass',
        })
        .expect(400);
    });

    it("an owner-locked account's password can't be changed or reset in any way", async () => {
      // Listed in PASSWORD_LOCKED_PHONES (vitest.config.e2e.ts).
      const locked = await createUser(t.prisma, {
        role: 'ADMIN',
        phone: '+919999999901',
        email: 'locked@sitework.test',
      });
      const admin = await createUser(t.prisma, { role: 'ADMIN' });
      const own = await signIn(locked.phone);
      const other = await signIn(admin.phone);
      const asOther = `Bearer ${other.accessToken}`;

      const changed = await changePassword(
        own.accessToken,
        TEST_PASSWORD,
        'NewPass2026',
      ).expect(403);
      expect(changed.body.code).toBe('PASSWORD_LOCKED');

      const reset = await t
        .http()
        .post(`/api/v1/users/${locked.id}/reset-password`)
        .set('authorization', asOther)
        .expect(403);
      expect(reset.body.code).toBe('PASSWORD_LOCKED');

      // A new number would lift the lock, so it can't be given one.
      const renumbered = await t
        .http()
        .patch(`/api/v1/admins/${locked.id}`)
        .set('authorization', asOther)
        .send({ phone: '+919876500001' })
        .expect(403);
      expect(renumbered.body.code).toBe('PASSWORD_LOCKED');
      await t
        .http()
        .patch(`/api/v1/admins/${locked.id}`)
        .set('authorization', asOther)
        .send({ name: 'Owner' })
        .expect(200);

      // Same reply as for any account, but no code is sent.
      await t
        .http()
        .post('/api/v1/auth/forgot-password')
        .send({ identifier: 'locked@sitework.test' })
        .expect(200);
      expect(t.mail.sent).toHaveLength(0);

      await login(locked.phone).expect(200);
      await me(own.accessToken).expect(200);
    });
  });

  describe('GET /me', () => {
    it("returns a staff member's site and engineer, and an engineer's sites", async () => {
      const admin = await createUser(t.prisma, { role: 'ADMIN' });
      const engineer = await createUser(t.prisma, {
        role: 'ENGINEER',
        name: 'Arun Kumar',
      });
      const staff = await createUser(t.prisma, {
        role: 'STAFF',
        name: 'Ravi',
        designation: 'MASON',
      });
      const site = await createSite(t.prisma, {
        name: 'ABC Apartment',
        createdById: admin.id,
        engineerIds: [engineer.id],
        staffIds: [staff.id],
      });

      const staffProfile = (
        await me((await signIn(staff.phone)).accessToken).expect(200)
      ).body.data;
      expect(staffProfile).toMatchObject({
        name: 'Ravi',
        role: 'STAFF',
        designation: 'MASON',
        assignment: {
          site: { id: site.id, name: 'ABC Apartment' },
          engineer: { id: engineer.id, name: 'Arun Kumar' },
        },
        sites: [],
      });
      expect(staffProfile).not.toHaveProperty('passwordHash');

      const engineerProfile = (
        await me((await signIn(engineer.phone)).accessToken).expect(200)
      ).body.data;
      expect(engineerProfile).toMatchObject({
        role: 'ENGINEER',
        assignment: null,
        sites: [{ id: site.id }],
      });
    });
  });
});
