import type { AttachmentView } from '../attachments/attachments.service.js';
import type { AuthUser } from '../auth/auth-user.js';
import {
  fromPaise,
  sumPaise,
  toPaise,
  type Paise,
} from '../common/money/money.js';
import { fromMilli, toMilli, type Milli } from '../common/quantity/quantity.js';
import { businessDate, fromDbDate } from '../common/time/business-time.js';
import type { Material } from '../generated/prisma/client.js';
import type {
  SiteStatus,
  StockMovementStatus,
  StockPhotoStage,
  StockPlace,
} from '../generated/prisma/enums.js';
import type { SettingsService } from '../settings/settings.service.js';
import {
  movementKind,
  valueOf,
  type HolderTotals,
  type StockKind,
} from './stock-ledger.js';
import { requestCode } from './request-progress.js';
import type { EntryRow, GodownRow } from './stock-queries.js';

// What the stock endpoints return, and who may do what with an entry. Prices
// and values are for admins only: everyone else gets null.

export interface MaterialView {
  id: string;
  name: string;
  unit: string;
  category: string | null;
  /** Admins are alerted when all godowns together drop below this. */
  minStock: string | null;
  isActive: boolean;
}

export interface SiteRef {
  id: string;
  code: string;
  name: string;
}

export interface GodownView {
  id: string;
  name: string;
  address: string | null;
  isActive: boolean;
}

export interface StockPlaceView {
  place: StockPlace;
  /** Set when the place is a site. */
  site: SiteRef | null;
  /** Set when the place is a godown. */
  godown: { id: string; name: string } | null;
}

export interface StockLineView {
  id: string;
  material: { id: string; name: string; unit: string };
  quantity: string;
  receivedQuantity: string | null;
  /** Sent but never arrived, on a delivery that came up short. */
  shortQuantity: string | null;
  /** Purchases, admins only: price per unit and the line's amount. */
  rate: string | null;
  amount: string | null;
}

export interface StockPhotoView extends AttachmentView {
  /** Taken by the sender (DC, bill) or by the receiver. */
  stage: StockPhotoStage;
}

export interface StockEntryView {
  id: string;
  requestId: string;
  kind: StockKind;
  from: StockPlaceView;
  to: StockPlaceView;
  status: StockMovementStatus;
  movedOn: string;
  dcNumber: string | null;
  supplier: string | null;
  billNo: string | null;
  note: string | null;
  lines: StockLineView[];
  /** Purchases, admins only. */
  totalAmount: string | null;
  receivedOn: string | null;
  receivedAt: string | null;
  receivedBy: { id: string; name: string } | null;
  receiveNote: string | null;
  createdBy: { id: string; name: string };
  createdAt: string;
  voidedAt: string | null;
  voidedBy: { id: string; name: string } | null;
  voidReason: string | null;
  photoCount: number;
  /** The material request it was sent against (or returned on). */
  request: { id: string; code: string } | null;
  /** Detail responses only. */
  photos?: StockPhotoView[];
  /** What the caller may do with it now. */
  canReceive: boolean;
  canVoid: boolean;
}

/** One material at a godown or site. Values are admins' only. */
export interface HolderStockRow {
  material: MaterialView;
  onHand: string;
  received: string;
  used: string;
  sentOut: string;
  wasted: string;
  adjusted: string;
  usedValue: string | null;
  onHandValue: string | null;
}

export interface SiteStock {
  site: SiteRef & { status: SiteStatus };
  /** Every material the site has held, those on hand first. */
  items: HolderStockRow[];
  /** Deliveries on the way, waiting for the site to confirm. */
  arriving: StockEntryView[];
  /** Sent from the site, not yet confirmed by the receiver. */
  leaving: StockEntryView[];
  /** Whether any usage was recorded for today. */
  usedToday: boolean;
  /** Admins only: totals of the rows' values. */
  value: { used: string; onHand: string } | null;
}

export interface GodownStock {
  godown: GodownView;
  /** Who runs it, to call about a delivery. */
  managers: { id: string; name: string; phone: string }[];
  items: HolderStockRow[];
  arriving: StockEntryView[];
  leaving: StockEntryView[];
  value: { onHand: string } | null;
}

export interface StockOverview {
  godowns: { godown: GodownView; arriving: number }[];
  materials: {
    material: MaterialView;
    inGodowns: string;
    onSites: string;
    /** All godowns together are below the material's minimum. */
    low: boolean;
  }[];
  /** Entries on the way that the caller can confirm. */
  toReceive: number;
  /** Sites stock can be sent to (not completed), engineers' or not. */
  sites: SiteRef[];
}

export interface MaterialDetail {
  material: MaterialView;
  /** Admins only: weighted average purchase price. */
  averageRate: string | null;
  godowns: { godown: { id: string; name: string }; onHand: string }[];
  sites: { site: SiteRef & { status: SiteStatus }; onHand: string }[];
  inGodowns: string;
  onSites: string;
  inTransit: string;
}

export interface ViewContext {
  user: AuthUser;
  today: string;
  timeZone: string;
}

export async function viewContext(
  settings: SettingsService,
  user: AuthUser,
  now: Date,
): Promise<ViewContext> {
  const { timeZone } = await settings.get('business');
  return { user, timeZone, today: businessDate(now, timeZone) };
}

/**
 * Admins may receive anything on the way and cancel anything. Engineers
 * confirm deliveries to their sites and godown managers arrivals at their
 * godowns; each may cancel what their site or godown sent while it is on the
 * way. Engineers and godown managers may cancel their own entries (usage,
 * write-offs; purchases and counts for godown managers) on the day they
 * recorded them; staff their own usage.
 */
export function allowedActions(
  row: EntryRow,
  ctx: ViewContext,
): { canReceive: boolean; canVoid: boolean } {
  if (row.status === 'VOIDED') return { canReceive: false, canVoid: false };
  const { user } = ctx;
  if (user.role === 'ADMIN')
    return { canReceive: row.status === 'IN_TRANSIT', canVoid: true };
  const mySite = (
    site: { engineerAssignments: { engineerId: string }[] } | null,
  ) =>
    user.role === 'ENGINEER' &&
    (site?.engineerAssignments.some((a) => a.engineerId === user.id) ?? false);
  const myGodown = (godown: { managers: { userId: string }[] } | null) =>
    user.role === 'GODOWN_MANAGER' &&
    (godown?.managers.some((m) => m.userId === user.id) ?? false);
  if (row.status === 'IN_TRANSIT') {
    return {
      canReceive:
        (row.toPlace === 'SITE' && mySite(row.toSite)) ||
        (row.toPlace === 'GODOWN' && myGodown(row.toGodown)),
      canVoid:
        (row.fromPlace === 'SITE' && mySite(row.fromSite)) ||
        (row.fromPlace === 'GODOWN' && myGodown(row.fromGodown)),
    };
  }
  const kind = movementKind(row.fromPlace, row.toPlace);
  const ownToday =
    row.createdById === user.id &&
    businessDate(row.createdAt, ctx.timeZone) === ctx.today;
  const theirs =
    user.role === 'GODOWN_MANAGER'
      ? kind === 'PURCHASE' || kind === 'WRITE_OFF' || kind === 'ADJUSTMENT'
      : kind === 'USAGE' || (kind === 'WRITE_OFF' && user.role === 'ENGINEER');
  return { canReceive: false, canVoid: ownToday && theirs };
}

export function toMaterialView(material: Material): MaterialView {
  return {
    id: material.id,
    name: material.name,
    unit: material.unit,
    category: material.category,
    minStock:
      material.minStock === null ? null : fromMilli(toMilli(material.minStock)),
    isActive: material.isActive,
  };
}

export function toGodownView(godown: GodownRow): GodownView {
  return {
    id: godown.id,
    name: godown.name,
    address: godown.address,
    isActive: godown.isActive,
  };
}

function placeView(
  place: StockPlace,
  site: SiteRef | null,
  godown: { id: string; name: string } | null,
): StockPlaceView {
  return {
    place,
    site: site && { id: site.id, code: site.code, name: site.name },
    godown: godown && { id: godown.id, name: godown.name },
  };
}

export function toEntryView(
  row: EntryRow,
  ctx: ViewContext,
  photos?: StockPhotoView[],
): StockEntryView {
  const kind = movementKind(row.fromPlace, row.toPlace);
  // Prices are admins'; a godown manager also sees those on purchases they entered.
  const pricesShown =
    ctx.user.role === 'ADMIN' ||
    (kind === 'PURCHASE' && row.createdById === ctx.user.id);
  const amounts: Paise[] = [];
  const lines = row.lines.map((line): StockLineView => {
    const quantity = toMilli(line.quantity);
    const received =
      line.receivedQuantity === null ? null : toMilli(line.receivedQuantity);
    const rate = pricesShown && line.rate !== null ? toPaise(line.rate) : null;
    const amount = rate === null ? null : valueOf(quantity, rate);
    if (amount !== null) amounts.push(amount);
    return {
      id: line.id,
      material: line.material,
      quantity: fromMilli(quantity),
      receivedQuantity: received === null ? null : fromMilli(received),
      shortQuantity:
        kind === 'TRANSFER' && received !== null && received < quantity
          ? fromMilli(quantity - received)
          : null,
      rate: rate === null ? null : fromPaise(rate),
      amount: amount === null ? null : fromPaise(amount),
    };
  });
  return {
    id: row.id,
    requestId: row.requestId,
    kind,
    from: placeView(row.fromPlace, row.fromSite, row.fromGodown),
    to: placeView(row.toPlace, row.toSite, row.toGodown),
    status: row.status,
    movedOn: fromDbDate(row.movedOn),
    dcNumber: row.dcNumber,
    supplier: row.supplier,
    billNo: row.billNo,
    note: row.note,
    lines,
    totalAmount: amounts.length ? fromPaise(sumPaise(amounts)) : null,
    receivedOn: row.receivedOn && fromDbDate(row.receivedOn),
    receivedAt: row.receivedAt?.toISOString() ?? null,
    receivedBy: row.receivedBy,
    receiveNote: row.receiveNote,
    createdBy: row.createdBy,
    createdAt: row.createdAt.toISOString(),
    voidedAt: row.voidedAt?.toISOString() ?? null,
    voidedBy: row.voidedBy,
    voidReason: row.voidReason,
    photoCount: row._count.photos,
    request: row.materialRequest && {
      id: row.materialRequest.id,
      code: requestCode(row.materialRequest.number),
    },
    ...(photos && { photos }),
    ...allowedActions(row, ctx),
  };
}

/** A godown's or site's row for one material, valued at [rate] for admins. */
export function toHolderRow(
  material: Material,
  totals: HolderTotals,
  rate: Paise | undefined,
  admin: boolean,
): HolderStockRow {
  const value = (quantity: Milli) =>
    admin && rate !== undefined ? fromPaise(valueOf(quantity, rate)) : null;
  return {
    material: toMaterialView(material),
    onHand: fromMilli(totals.onHand),
    received: fromMilli(totals.received),
    used: fromMilli(totals.used),
    sentOut: fromMilli(totals.sentOut),
    wasted: fromMilli(totals.wasted),
    adjusted: fromMilli(totals.adjusted),
    usedValue: value(totals.used),
    onHandValue: value(totals.onHand),
  };
}
