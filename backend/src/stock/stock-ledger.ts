import type { Paise } from '../common/money/money.js';
import type { Milli } from '../common/quantity/quantity.js';
import type { StockPlace } from '../generated/prisma/enums.js';

/**
 * Stock rules as plain functions. Every stock change is a line moving a
 * quantity of one material from one place to another; a holder's balance (a
 * godown or a site) is what arrived there minus what left it. Nothing here
 * touches the database.
 */

export type StockKind =
  'PURCHASE' | 'TRANSFER' | 'USAGE' | 'WRITE_OFF' | 'ADJUSTMENT';

/** Places that hold stock. The others are the outside world, use and losses. */
export type HolderPlace = Extract<StockPlace, 'GODOWN' | 'SITE'>;

export interface Holder {
  place: HolderPlace;
  /** The godown's or the site's id. */
  id: string;
}

export function isHolder(place: StockPlace): place is HolderPlace {
  return place === 'GODOWN' || place === 'SITE';
}

/** "GODOWN:<id>" or "SITE:<id>": one key per holder, for maps. */
export function holderKey(place: HolderPlace, id: string): string {
  return `${place}:${id}`;
}

/** What an entry is, from where its stock comes from and goes to. */
export function movementKind(from: StockPlace, to: StockPlace): StockKind {
  if (from === 'SUPPLIER') return 'PURCHASE';
  if (to === 'USED') return 'USAGE';
  if (to === 'WASTE') return 'WRITE_OFF';
  if (from === 'ADJUSTMENT' || to === 'ADJUSTMENT') return 'ADJUSTMENT';
  return 'TRANSFER';
}

/** Quantity that left a place, summed per material and destination. */
export interface DepartureSum {
  materialId: string;
  fromPlace: StockPlace;
  /** The godown's or site's id; null for the other places. */
  fromId: string | null;
  toPlace: StockPlace;
  quantity: Milli;
}

/** Quantity that arrived at a place, summed per material and origin. */
export interface ArrivalSum {
  materialId: string;
  toPlace: StockPlace;
  toId: string | null;
  fromPlace: StockPlace;
  quantity: Milli;
}

export interface HolderTotals {
  /** Bought, or received from a godown or a site. */
  received: Milli;
  used: Milli;
  /** Sent to a godown or a site (counted from the day it left). */
  sentOut: Milli;
  wasted: Milli;
  /** Stock-count corrections, up or down. */
  adjusted: Milli;
  onHand: Milli;
}

const zero = (): HolderTotals => ({
  received: 0n,
  used: 0n,
  sentOut: 0n,
  wasted: 0n,
  adjusted: 0n,
  onHand: 0n,
});

/** holder key → material id → totals */
export type Ledger = Map<string, Map<string, HolderTotals>>;

/** Folds departure and arrival sums into totals per holder and material. */
export function ledger(
  departures: readonly DepartureSum[],
  arrivals: readonly ArrivalSum[],
): Ledger {
  const result: Ledger = new Map();
  const totals = (key: string, materialId: string) => {
    let byMaterial = result.get(key);
    if (!byMaterial) result.set(key, (byMaterial = new Map()));
    let row = byMaterial.get(materialId);
    if (!row) byMaterial.set(materialId, (row = zero()));
    return row;
  };
  for (const d of departures) {
    if (!isHolder(d.fromPlace) || d.fromId === null) continue;
    const row = totals(holderKey(d.fromPlace, d.fromId), d.materialId);
    if (d.toPlace === 'USED') row.used += d.quantity;
    else if (d.toPlace === 'WASTE') row.wasted += d.quantity;
    else if (d.toPlace === 'ADJUSTMENT') row.adjusted -= d.quantity;
    else row.sentOut += d.quantity;
    row.onHand -= d.quantity;
  }
  for (const a of arrivals) {
    if (!isHolder(a.toPlace) || a.toId === null) continue;
    const row = totals(holderKey(a.toPlace, a.toId), a.materialId);
    if (a.fromPlace === 'ADJUSTMENT') row.adjusted += a.quantity;
    else row.received += a.quantity;
    row.onHand += a.quantity;
  }
  return result;
}

export function totalsFor(
  book: Ledger,
  holder: Holder,
  materialId: string,
): HolderTotals {
  return (
    book.get(holderKey(holder.place, holder.id))?.get(materialId) ?? zero()
  );
}

/** What all godowns (or all sites) in the ledger hold of a material together. */
export function onHandAt(
  book: Ledger,
  place: HolderPlace,
  materialId: string,
): Milli {
  let total = 0n;
  for (const [key, byMaterial] of book)
    if (key.startsWith(`${place}:`))
      total += byMaterial.get(materialId)?.onHand ?? 0n;
  return total;
}

/** The holders in a ledger: godown or site ids, by place. */
export function holderIds(book: Ledger, place: HolderPlace): string[] {
  return [...book.keys()]
    .filter((key) => key.startsWith(`${place}:`))
    .map((key) => key.slice(place.length + 1));
}

export interface StockReportLine {
  holderKey: string;
  materialId: string;
  opening: Milli;
  received: Milli;
  used: Milli;
  sentOut: Milli;
  wasted: Milli;
  adjusted: Milli;
  closing: Milli;
}

/**
 * A date range per holder and material: [before] is everything up to the day
 * before the range, [during] the range itself. Lines where nothing was held or
 * moved are left out.
 */
export function stockReportLines(
  before: Ledger,
  during: Ledger,
): StockReportLine[] {
  const lines: StockReportLine[] = [];
  const keys = new Set([...before.keys(), ...during.keys()]);
  for (const key of keys) {
    const materials = new Set([
      ...(before.get(key)?.keys() ?? []),
      ...(during.get(key)?.keys() ?? []),
    ]);
    for (const materialId of materials) {
      const opening = before.get(key)?.get(materialId)?.onHand ?? 0n;
      const range = during.get(key)?.get(materialId) ?? zero();
      const line: StockReportLine = {
        holderKey: key,
        materialId,
        opening,
        received: range.received,
        used: range.used,
        sentOut: range.sentOut,
        wasted: range.wasted,
        adjusted: range.adjusted,
        closing: opening + range.onHand,
      };
      const figures = [
        line.opening,
        line.received,
        line.used,
        line.sentOut,
        line.wasted,
        line.adjusted,
        line.closing,
      ];
      if (figures.some((value) => value !== 0n)) lines.push(line);
    }
  }
  return lines;
}

/** True when a drop takes stock from at or above its minimum to below it. */
export function crossedBelowMinimum(
  minimum: Milli | null,
  before: Milli,
  after: Milli,
): boolean {
  return minimum !== null && before >= minimum && after < minimum;
}

/** "Cement 60 bag, Sand 100 cft and 2 more", for notifications. */
export function summarizeLines(lines: readonly string[], shown = 3): string {
  if (lines.length <= shown) return lines.join(', ');
  return `${lines.slice(0, shown).join(', ')} and ${lines.length - shown} more`;
}

export interface PricedLine {
  materialId: string;
  quantity: Milli;
  /** Paise per unit. */
  rate: Paise;
}

/**
 * Weighted average purchase price per material, in paise per unit (rounded to
 * the nearest paisa): everything paid divided by everything bought.
 */
export function averageRates(lines: readonly PricedLine[]): Map<string, Paise> {
  const sums = new Map<string, { cost: bigint; quantity: Milli }>();
  for (const line of lines) {
    const sum = sums.get(line.materialId) ?? { cost: 0n, quantity: 0n };
    sum.cost += line.rate * line.quantity;
    sum.quantity += line.quantity;
    sums.set(line.materialId, sum);
  }
  const rates = new Map<string, Paise>();
  for (const [materialId, { cost, quantity }] of sums)
    if (quantity > 0n) rates.set(materialId, roundDiv(cost, quantity));
  return rates;
}

/** What a quantity is worth at a rate, in paise (rounded to the nearest paisa). */
export function valueOf(quantity: Milli, rate: Paise): Paise {
  return roundDiv(quantity * rate, 1000n);
}

/** Integer division rounding halves away from zero. */
function roundDiv(numerator: bigint, denominator: bigint): bigint {
  const negative = numerator < 0n !== denominator < 0n;
  const n = numerator < 0n ? -numerator : numerator;
  const d = denominator < 0n ? -denominator : denominator;
  const result = (n * 2n + d) / (2n * d);
  return negative ? -result : result;
}
