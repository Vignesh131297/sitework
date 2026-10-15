import {
  averageRates,
  crossedBelowMinimum,
  holderIds,
  ledger,
  movementKind,
  onHandAt,
  stockReportLines,
  summarizeLines,
  totalsFor,
  valueOf,
  type ArrivalSum,
  type DepartureSum,
} from './stock-ledger.js';

const CEMENT = 'cement';
const MAIN = { place: 'GODOWN' as const, id: 'main' };
const SITE_A = { place: 'SITE' as const, id: 'a' };

const out = (
  fromPlace: DepartureSum['fromPlace'],
  fromId: string | null,
  toPlace: DepartureSum['toPlace'],
  quantity: bigint,
): DepartureSum => ({
  materialId: CEMENT,
  fromPlace,
  fromId,
  toPlace,
  quantity,
});

const into = (
  toPlace: ArrivalSum['toPlace'],
  toId: string | null,
  fromPlace: ArrivalSum['fromPlace'],
  quantity: bigint,
): ArrivalSum => ({
  materialId: CEMENT,
  toPlace,
  toId,
  fromPlace,
  quantity,
});

describe('stock ledger', () => {
  it('names each kind of entry', () => {
    expect(movementKind('SUPPLIER', 'GODOWN')).toBe('PURCHASE');
    expect(movementKind('GODOWN', 'SITE')).toBe('TRANSFER');
    expect(movementKind('SITE', 'GODOWN')).toBe('TRANSFER');
    expect(movementKind('SITE', 'SITE')).toBe('TRANSFER');
    expect(movementKind('GODOWN', 'GODOWN')).toBe('TRANSFER');
    expect(movementKind('SITE', 'USED')).toBe('USAGE');
    expect(movementKind('GODOWN', 'WASTE')).toBe('WRITE_OFF');
    expect(movementKind('ADJUSTMENT', 'GODOWN')).toBe('ADJUSTMENT');
    expect(movementKind('SITE', 'ADJUSTMENT')).toBe('ADJUSTMENT');
  });

  // Buy 100 into Main → send 60 to site A → A confirms 58 → A uses 40 → A
  // returns 18 to the North godown; Main counts 1 bag less.
  const book = ledger(
    [
      out('GODOWN', 'main', 'SITE', 60_000n),
      out('SITE', 'a', 'USED', 40_000n),
      out('SITE', 'a', 'GODOWN', 18_000n),
      out('GODOWN', 'main', 'ADJUSTMENT', 1_000n),
    ],
    [
      into('GODOWN', 'main', 'SUPPLIER', 100_000n),
      into('SITE', 'a', 'GODOWN', 58_000n),
      into('GODOWN', 'north', 'SITE', 18_000n),
    ],
  );

  it('balances each holder as arrivals minus departures', () => {
    expect(totalsFor(book, MAIN, CEMENT)).toEqual({
      received: 100_000n,
      used: 0n,
      sentOut: 60_000n,
      wasted: 0n,
      adjusted: -1_000n,
      onHand: 39_000n,
    });
    expect(totalsFor(book, SITE_A, CEMENT)).toEqual({
      received: 58_000n,
      used: 40_000n,
      sentOut: 18_000n,
      wasted: 0n,
      adjusted: 0n,
      onHand: 0n,
    });
  });

  it('adds up godowns and sites, and lists who holds what', () => {
    expect(onHandAt(book, 'GODOWN', CEMENT)).toBe(57_000n);
    expect(onHandAt(book, 'SITE', CEMENT)).toBe(0n);
    expect(holderIds(book, 'GODOWN').sort()).toEqual(['main', 'north']);
    expect(holderIds(book, 'SITE')).toEqual(['a']);
    expect(totalsFor(book, { place: 'SITE', id: 'b' }, CEMENT).onHand).toBe(0n);
  });

  it('reports a range from an opening balance to a closing one', () => {
    const before = ledger([], [into('GODOWN', 'main', 'SUPPLIER', 50_000n)]);
    const during = ledger(
      [
        out('GODOWN', 'main', 'SITE', 20_000n),
        out('GODOWN', 'main', 'WASTE', 500n),
      ],
      [into('GODOWN', 'main', 'SUPPLIER', 10_000n)],
    );
    expect(stockReportLines(before, during)).toEqual([
      {
        holderKey: 'GODOWN:main',
        materialId: CEMENT,
        opening: 50_000n,
        received: 10_000n,
        used: 0n,
        sentOut: 20_000n,
        wasted: 500n,
        adjusted: 0n,
        closing: 39_500n,
      },
    ]);
  });

  it('leaves out lines where nothing was held or moved', () => {
    const empty = ledger(
      [out('SITE', 'a', 'USED', 5_000n)],
      [into('SITE', 'a', 'GODOWN', 5_000n)],
    );
    expect(stockReportLines(empty, ledger([], []))).toEqual([]);
  });

  it('spots the drop that takes stock below its minimum, once', () => {
    expect(crossedBelowMinimum(10_000n, 12_000n, 9_000n)).toBe(true);
    expect(crossedBelowMinimum(10_000n, 10_000n, 9_999n)).toBe(true);
    expect(crossedBelowMinimum(10_000n, 9_000n, 8_000n)).toBe(false);
    expect(crossedBelowMinimum(10_000n, 12_000n, 10_000n)).toBe(false);
    expect(crossedBelowMinimum(null, 12_000n, 0n)).toBe(false);
  });

  it('averages purchase prices by quantity, to the paisa', () => {
    const rates = averageRates([
      { materialId: CEMENT, quantity: 100_000n, rate: 38_000n }, // 100 bags at ₹380
      { materialId: CEMENT, quantity: 50_000n, rate: 41_000n }, // 50 bags at ₹410
      { materialId: 'sand', quantity: 3_000n, rate: 3_333n }, // 3 cft at ₹33.33
    ]);
    expect(rates.get(CEMENT)).toBe(39_000n); // ₹390
    expect(rates.get('sand')).toBe(3_333n);
    expect(averageRates([]).size).toBe(0);
  });

  it('values a quantity at a rate', () => {
    expect(valueOf(12_500n, 39_000n)).toBe(487_500n); // 12.5 bags × ₹390
    expect(valueOf(1n, 3_333n)).toBe(3n); // 0.001 cft × ₹33.33 → 3.333 paise
    expect(valueOf(-2_000n, 1_000n)).toBe(-2_000n);
  });

  it('summarizes long lists for notifications', () => {
    expect(summarizeLines(['a', 'b'])).toBe('a, b');
    expect(summarizeLines(['a', 'b', 'c', 'd', 'e'])).toBe(
      'a, b, c and 2 more',
    );
  });
});
