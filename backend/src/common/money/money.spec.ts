import { formatInr, fromPaise, sumPaise, toPaise } from './money.js';

describe('money', () => {
  it('parses amounts into exact paise', () => {
    expect(toPaise('850000')).toBe(85_000_000n);
    expect(toPaise('850000.5')).toBe(85_000_050n);
    expect(toPaise('0.05')).toBe(5n);
    expect(toPaise(1234.56)).toBe(123_456n);
    expect(toPaise({ toString: () => '99.99' })).toBe(9_999n); // e.g. a Prisma Decimal
    expect(toPaise('-10.00')).toBe(-1_000n);
  });

  it('rejects malformed amounts', () => {
    for (const bad of ['', '12.345', '1,000', 'abc', '1e5']) {
      expect(() => toPaise(bad)).toThrow(/Not a valid amount/);
    }
  });

  it('formats paise as API decimal strings', () => {
    expect(fromPaise(85_000_050n)).toBe('850000.50');
    expect(fromPaise(5n)).toBe('0.05');
    expect(fromPaise(-1_000n)).toBe('-10.00');
  });

  it('adds without floating-point drift', () => {
    expect(sumPaise([toPaise('0.10'), toPaise('0.20')])).toBe(toPaise('0.30'));
  });

  it('formats rupees with Indian digit grouping', () => {
    expect(formatInr(toPaise('850000'))).toBe('₹8,50,000');
    expect(formatInr(toPaise('2450000'))).toBe('₹24,50,000');
    expect(formatInr(toPaise('1234.5'))).toBe('₹1,234.50');
  });
});
