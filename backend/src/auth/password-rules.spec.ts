import {
  afterFailedLogin,
  generateResetCode,
  generateTemporaryPassword,
  lockMinutesLeft,
  LOCKOUT_MINUTES,
  MAX_FAILED_LOGINS,
  passwordProblem,
} from './password-rules.js';

describe('passwordProblem', () => {
  it('accepts 8+ characters with letters and numbers', () => {
    expect(passwordProblem('site2026')).toBeNull();
  });

  it('explains what is wrong', () => {
    expect(passwordProblem('ab12')).toBe('Use at least 8 characters.');
    expect(passwordProblem('onlyletters')).toBe(
      'Use both letters and numbers.',
    );
    expect(passwordProblem('12345678')).toBe('Use both letters and numbers.');
    expect(passwordProblem('x'.repeat(127) + '1a')).toBe(
      'Use at most 128 characters.',
    );
  });

  it("rejects the user's own phone number", () => {
    expect(
      passwordProblem('ravi9876543210', { phone: '+919876543210' }),
    ).toMatch(/phone number/);
  });
});

describe('login lockout', () => {
  const now = new Date('2026-10-05T04:30:00Z');

  it(`locks for ${LOCKOUT_MINUTES} minutes on the ${MAX_FAILED_LOGINS}th consecutive failure`, () => {
    expect(afterFailedLogin(MAX_FAILED_LOGINS - 2, now)).toEqual({
      failedLoginCount: MAX_FAILED_LOGINS - 1,
      lockedUntil: null,
    });
    const locked = afterFailedLogin(MAX_FAILED_LOGINS - 1, now);
    expect(locked.failedLoginCount).toBe(0);
    expect(lockMinutesLeft(locked.lockedUntil, now)).toBe(LOCKOUT_MINUTES);
  });

  it('reports whole minutes left, and 0 once the lock has passed', () => {
    const until = new Date(now.getTime() + 30_000);
    expect(lockMinutesLeft(until, now)).toBe(1);
    expect(lockMinutesLeft(until, new Date(until.getTime() + 1))).toBe(0);
    expect(lockMinutesLeft(null, now)).toBe(0);
  });
});

describe('generated secrets', () => {
  it('temporary passwords are readable and always acceptable', () => {
    for (let i = 0; i < 50; i += 1) {
      const password = generateTemporaryPassword();
      expect(password).toMatch(
        /^[A-Za-z2-9]{4}-[A-Za-z2-9]{4}-[A-Za-z2-9]{4}$/,
      );
      expect(password).not.toMatch(/[0O1lI]/);
      expect(passwordProblem(password)).toBeNull();
    }
  });

  it('reset codes are six digits', () => {
    expect(generateResetCode()).toMatch(/^\d{6}$/);
  });
});
