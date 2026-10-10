import { formatQuantity, fromMilli, sumMilli, toMilli } from './quantity.js';

describe('quantity', () => {
  it('reads decimal strings, numbers and decimals exactly', () => {
    expect(toMilli('60')).toBe(60_000n);
    expect(toMilli('12.5')).toBe(12_500n);
    expect(toMilli('0.125')).toBe(125n);
    expect(toMilli(' 7.25 ')).toBe(7_250n);
    expect(toMilli('-3')).toBe(-3_000n);
    expect(toMilli(2.5)).toBe(2_500n);
    expect(toMilli({ toString: () => '58.000' })).toBe(58_000n);
  });

  it('refuses anything that is not a quantity', () => {
    for (const bad of ['', 'abc', '1.2345', '1,000', '1e3', '.5'])
      expect(() => toMilli(bad)).toThrow();
  });

  it('writes the shortest decimal', () => {
    expect(fromMilli(60_000n)).toBe('60');
    expect(fromMilli(12_500n)).toBe('12.5');
    expect(fromMilli(125n)).toBe('0.125');
    expect(fromMilli(0n)).toBe('0');
    expect(fromMilli(-2_050n)).toBe('-2.05');
  });

  it('adds without floating-point drift', () => {
    expect(fromMilli(sumMilli([toMilli('0.1'), toMilli('0.2')]))).toBe('0.3');
    expect(sumMilli([])).toBe(0n);
  });

  it('formats for people, with Indian digit grouping', () => {
    expect(formatQuantity(1_250_000n, 'bag')).toBe('1,250 bag');
    expect(formatQuantity(150_000_500n, 'kg')).toBe('1,50,000.5 kg');
    expect(formatQuantity(58_000n)).toBe('58');
  });
});
