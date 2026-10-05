/**
 * Money is handled as integer paise (bigint) so arithmetic is exact. Amounts enter
 * and leave the API as decimal strings ("850000.00"), matching numeric(14,2).
 */

export type Paise = bigint;

const DECIMAL_AMOUNT = /^(-)?(\d+)(?:\.(\d{1,2}))?$/;

/** Accepts "8500", "8500.5", "8500.50", numbers, or a Prisma Decimal. */
export function toPaise(
  value: string | number | { toString(): string },
): Paise {
  const text =
    typeof value === 'number' ? value.toFixed(2) : value.toString().trim();
  const match = DECIMAL_AMOUNT.exec(text);
  if (!match) throw new Error(`Not a valid amount: "${text}"`);
  const [, sign, rupees, fraction = ''] = match;
  const paise = BigInt(rupees) * 100n + BigInt(fraction.padEnd(2, '0'));
  return sign ? -paise : paise;
}

/** 85000050n → "850000.50" */
export function fromPaise(paise: Paise): string {
  const negative = paise < 0n;
  const absolute = negative ? -paise : paise;
  const rupees = absolute / 100n;
  const fraction = (absolute % 100n).toString().padStart(2, '0');
  return `${negative ? '-' : ''}${rupees}.${fraction}`;
}

export function sumPaise(values: readonly Paise[]): Paise {
  return values.reduce((total, value) => total + value, 0n);
}

const inr = (fractionDigits: number) =>
  new Intl.NumberFormat('en-IN', {
    style: 'currency',
    currency: 'INR',
    minimumFractionDigits: fractionDigits,
    maximumFractionDigits: fractionDigits,
  });
const wholeRupees = inr(0);
const withPaise = inr(2);

/** 85000000n → "₹8,50,000", 123450n → "₹1,234.50" (Indian digit grouping). */
export function formatInr(paise: Paise): string {
  const formatter = paise % 100n === 0n ? wholeRupees : withPaise;
  return formatter.format(Number(paise) / 100);
}
