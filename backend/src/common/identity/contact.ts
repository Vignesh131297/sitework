import { ErrorCode } from '../errors/error-codes.js';
import { badRequest } from '../errors/http-errors.js';
import { normalizeEmail, normalizePhone } from './phone.js';

/** Normalizes a phone number from user input or rejects it with a field error. */
export function requirePhone(value: string, field = 'phone'): string {
  const phone = normalizePhone(value);
  if (!phone)
    throw badRequest(
      ErrorCode.INVALID_PHONE,
      'Enter a valid mobile number.',
      field,
    );
  return phone;
}

/**
 * For optional e-mail fields: undefined = unchanged, null/"" = clear,
 * anything else must be a valid address.
 */
export function optionalEmail(
  value: string | null | undefined,
  field = 'email',
): string | null | undefined {
  if (value === undefined) return undefined;
  if (value === null || value.trim() === '') return null;
  const email = normalizeEmail(value);
  if (!email)
    throw badRequest(
      ErrorCode.INVALID_EMAIL,
      'Enter a valid e-mail address.',
      field,
    );
  return email;
}

/** Optional free text: undefined = unchanged, blank = cleared. */
export function optionalText(
  value: string | null | undefined,
): string | null | undefined {
  if (value === undefined) return undefined;
  const text = value?.trim();
  return text ? text : null;
}
