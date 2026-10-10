/**
 * Stock quantities are handled as integer thousandths (bigint) so arithmetic is
 * exact. They enter and leave the API as decimal strings ("60", "12.5"),
 * matching numeric(12,3).
 */

export type Milli = bigint;

const DECIMAL_QUANTITY = /^(-)?(\d+)(?:\.(\d{1,3}))?$/;

/** Accepts "60", "12.5", "0.125", numbers, or a Prisma Decimal. */
export function toMilli(
  value: string | number | { toString(): string },
): Milli {
  const text =
    typeof value === 'number' ? value.toFixed(3) : value.toString().trim();
  const match = DECIMAL_QUANTITY.exec(text);
  if (!match) throw new Error(`Not a valid quantity: "${text}"`);
  const [, sign, whole, fraction = ''] = match;
  const milli = BigInt(whole) * 1000n + BigInt(fraction.padEnd(3, '0'));
  return sign ? -milli : milli;
}

/** 12500n → "12.5", 60000n → "60" (no trailing zeros). */
export function fromMilli(milli: Milli): string {
  const negative = milli < 0n;
  const absolute = negative ? -milli : milli;
  const whole = absolute / 1000n;
  const fraction = (absolute % 1000n)
    .toString()
    .padStart(3, '0')
    .replace(/0+$/, '');
  return `${negative ? '-' : ''}${whole}${fraction ? `.${fraction}` : ''}`;
}

export function sumMilli(values: readonly Milli[]): Milli {
  return values.reduce((total, value) => total + value, 0n);
}

const grouped = new Intl.NumberFormat('en-IN', { maximumFractionDigits: 3 });

/**
 * 1250000n, "bag" → "1,250 bag" (Indian digit grouping), for messages;
 * without a unit, just the number.
 */
export function formatQuantity(milli: Milli, unit?: string): string {
  const number = grouped.format(Number(milli) / 1000);
  return unit ? `${number} ${unit}` : number;
}
