/**
 * Phone numbers are stored in E.164 (+91XXXXXXXXXX). Indian numbers are accepted
 * as typed by people: with or without +91, spaces, dashes or a leading 0.
 */
export function normalizePhone(raw: string): string | null {
  const compact = raw.trim().replace(/[\s().-]/g, '');
  if (/^\+[1-9]\d{9,14}$/.test(compact)) return compact;
  if (/^0?[6-9]\d{9}$/.test(compact)) return `+91${compact.slice(-10)}`;
  if (/^91[6-9]\d{9}$/.test(compact)) return `+${compact}`;
  return null;
}

const EMAIL = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

export function normalizeEmail(raw: string): string | null {
  const email = raw.trim().toLowerCase();
  return EMAIL.test(email) && email.length <= 254 ? email : null;
}

export type LoginIdentifier =
  { kind: 'email'; email: string } | { kind: 'phone'; phone: string };

/** A sign-in identifier is an e-mail if it contains "@", otherwise a phone number. */
export function parseLoginIdentifier(raw: string): LoginIdentifier | null {
  if (raw.includes('@')) {
    const email = normalizeEmail(raw);
    return email ? { kind: 'email', email } : null;
  }
  const phone = normalizePhone(raw);
  return phone ? { kind: 'phone', phone } : null;
}
