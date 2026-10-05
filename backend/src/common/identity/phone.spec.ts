import {
  normalizeEmail,
  normalizePhone,
  parseLoginIdentifier,
} from './phone.js';

describe('normalizePhone', () => {
  it('accepts Indian mobile numbers as people type them', () => {
    for (const typed of [
      '9876543210',
      '09876543210',
      '+91 98765 43210',
      '91-98765-43210',
      '(+91) 98765.43210',
    ]) {
      expect(normalizePhone(typed)).toBe('+919876543210');
    }
  });

  it('keeps other E.164 numbers', () => {
    expect(normalizePhone('+14155550123')).toBe('+14155550123');
  });

  it('rejects things that are not mobile numbers', () => {
    for (const bad of ['', '12345', '1234567890', 'abc', '+0123456789']) {
      expect(normalizePhone(bad)).toBeNull();
    }
  });
});

describe('parseLoginIdentifier', () => {
  it('treats anything with @ as an e-mail, lower-cased', () => {
    expect(parseLoginIdentifier('  Admin@SiteWork.test ')).toEqual({
      kind: 'email',
      email: 'admin@sitework.test',
    });
    expect(normalizeEmail('not-an-email@')).toBeNull();
  });

  it('treats everything else as a phone number', () => {
    expect(parseLoginIdentifier('98765 43210')).toEqual({
      kind: 'phone',
      phone: '+919876543210',
    });
    expect(parseLoginIdentifier('ravi')).toBeNull();
  });
});
