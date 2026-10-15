import type { Milli } from '../common/quantity/quantity.js';
import type {
  StockMovementStatus,
  StockPlace,
} from '../generated/prisma/enums.js';

/** "MR-0012": how people refer to a request. */
export function requestCode(number: number): string {
  return `MR-${String(number).padStart(4, '0')}`;
}

/**
 * How far a material request has got, worked out from the deliveries made
 * against it (never stored). A delivery counts as sent unless cancelled, and
 * as received once the site confirmed it.
 */

export interface RequestedLine {
  materialId: string;
  /** Null until approved. */
  approved: Milli | null;
}

export interface DeliveredLine {
  materialId: string;
  fromPlace: StockPlace;
  toPlace: StockPlace;
  status: StockMovementStatus;
  quantity: Milli;
  receivedQuantity: Milli | null;
}

export interface LineProgress {
  sent: Milli;
  received: Milli;
  onTheWay: Milli;
  /** Approved and not yet sent; null until approved. */
  leftToSend: Milli | null;
}

export function requestProgress(
  lines: readonly RequestedLine[],
  delivered: readonly DeliveredLine[],
): Map<string, LineProgress> {
  const progress = new Map<string, LineProgress>();
  for (const line of lines) {
    const deliveries = delivered.filter(
      (d) =>
        d.materialId === line.materialId &&
        d.fromPlace === 'GODOWN' &&
        d.toPlace === 'SITE' &&
        d.status !== 'VOIDED',
    );
    let sent = 0n;
    let received = 0n;
    let onTheWay = 0n;
    for (const d of deliveries) {
      sent += d.quantity;
      if (d.status === 'DONE') received += d.receivedQuantity ?? 0n;
      if (d.status === 'IN_TRANSIT') onTheWay += d.quantity;
    }
    const left = line.approved === null ? null : line.approved - sent;
    progress.set(line.materialId, {
      sent,
      received,
      onTheWay,
      leftToSend: left === null ? null : left > 0n ? left : 0n,
    });
  }
  return progress;
}

/** Everything approved has been sent (nothing left to send). */
export function sentInFull(progress: Map<string, LineProgress>): boolean {
  return [...progress.values()].every(
    (p) => p.leftToSend !== null && p.leftToSend === 0n,
  );
}

/** Some delivery for the request is still on its way. */
export function anythingOnTheWay(progress: Map<string, LineProgress>): boolean {
  return [...progress.values()].some((p) => p.onTheWay > 0n);
}
