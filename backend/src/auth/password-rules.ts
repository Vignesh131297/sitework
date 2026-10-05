import { randomInt } from 'node:crypto';

/** Consecutive failures before an account is locked, and for how long. */
export const MAX_FAILED_LOGINS = 5;
export const LOCKOUT_MINUTES = 15;

/** Password-reset codes sent by e-mail. */
export const RESET_CODE_TTL_MINUTES = 15;
export const RESET_CODE_MAX_ATTEMPTS = 5;

/**
 * Why a new password isn't acceptable, or null if it is. Kept simple on purpose:
 * many staff type on small phones, so length matters more than symbols.
 */
export function passwordProblem(
  password: string,
  context: { phone?: string | null } = {},
): string | null {
  if (password.length < 8) return 'Use at least 8 characters.';
  if (password.length > 128) return 'Use at most 128 characters.';
  if (!/[A-Za-z]/.test(password) || !/\d/.test(password)) {
    return 'Use both letters and numbers.';
  }
  const phoneDigits = context.phone?.replace(/\D/g, '').slice(-10);
  if (phoneDigits && password.includes(phoneDigits)) {
    return "Don't use your phone number in your password.";
  }
  return null;
}

/** State after a failed sign-in: the counter resets once the lock is applied. */
export function afterFailedLogin(
  failedLoginCount: number,
  now: Date,
): { failedLoginCount: number; lockedUntil: Date | null } {
  const failures = failedLoginCount + 1;
  if (failures >= MAX_FAILED_LOGINS) {
    return {
      failedLoginCount: 0,
      lockedUntil: new Date(now.getTime() + LOCKOUT_MINUTES * 60_000),
    };
  }
  return { failedLoginCount: failures, lockedUntil: null };
}

/** Whole minutes left on a lock (at least 1), or 0 when not locked. */
export function lockMinutesLeft(lockedUntil: Date | null, now: Date): number {
  if (!lockedUntil || lockedUntil <= now) return 0;
  return Math.max(
    1,
    Math.ceil((lockedUntil.getTime() - now.getTime()) / 60_000),
  );
}

// No 0/O, 1/l/I: temporary passwords are read out or copied by hand.
const ALPHABET = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789';

/** e.g. "Kq7m-Pz4x-Bn2c": readable, and always passes passwordProblem(). */
export function generateTemporaryPassword(): string {
  for (;;) {
    const groups = Array.from({ length: 3 }, () =>
      Array.from(
        { length: 4 },
        () => ALPHABET[randomInt(ALPHABET.length)],
      ).join(''),
    );
    const candidate = groups.join('-');
    if (passwordProblem(candidate) === null) return candidate;
  }
}

export function generateResetCode(): string {
  return randomInt(0, 1_000_000).toString().padStart(6, '0');
}
