import type { AuthUser } from '../auth/auth-user.js';
import { godownScope, siteScope } from '../common/access/access-scope.js';
import { notFound } from '../common/errors/http-errors.js';
import { toPaise } from '../common/money/money.js';
import { toMilli } from '../common/quantity/quantity.js';
import type { Prisma } from '../generated/prisma/client.js';
import type { PrismaService } from '../prisma/prisma.service.js';
import {
  averageRates,
  ledger,
  type Ledger,
  type PricedLine,
} from './stock-ledger.js';

type Db = PrismaService | Prisma.TransactionClient;

/** Which holders to sum: all godowns (or sites), or only some. */
export interface HolderFilter {
  godowns: 'all' | readonly string[];
  sites: 'all' | readonly string[];
}

/**
 * Departures and arrivals summed in the database, folded into a ledger. A
 * departure counts from the day stock left (any status but VOIDED); an arrival
 * from the day it was received (DONE only), at the quantity that arrived.
 */
export async function ledgerSums(
  db: Db,
  holders: HolderFilter,
  options: {
    materialIds?: readonly string[];
    dates?: { gte?: Date; lte?: Date; lt?: Date };
  } = {},
): Promise<Ledger> {
  const leaving: Prisma.StockMovementWhereInput[] = [];
  const arriving: Prisma.StockMovementWhereInput[] = [];
  if (holders.godowns === 'all') {
    leaving.push({ fromPlace: 'GODOWN' });
    arriving.push({ toPlace: 'GODOWN' });
  } else if (holders.godowns.length) {
    leaving.push({ fromGodownId: { in: [...holders.godowns] } });
    arriving.push({ toGodownId: { in: [...holders.godowns] } });
  }
  if (holders.sites === 'all') {
    leaving.push({ fromPlace: 'SITE' });
    arriving.push({ toPlace: 'SITE' });
  } else if (holders.sites.length) {
    leaving.push({ fromSiteId: { in: [...holders.sites] } });
    arriving.push({ toSiteId: { in: [...holders.sites] } });
  }
  if (!leaving.length) return new Map();
  const material = options.materialIds
    ? { materialId: { in: [...options.materialIds] } }
    : {};

  // Sequential on purpose: this often runs inside a transaction.
  const departures = await db.stockMovement.groupBy({
    by: ['materialId', 'fromPlace', 'fromGodownId', 'fromSiteId', 'toPlace'],
    where: {
      ...material,
      status: { not: 'VOIDED' },
      OR: leaving,
      ...(options.dates && { movedOn: options.dates }),
    },
    _sum: { quantity: true },
  });
  const arrivals = await db.stockMovement.groupBy({
    by: ['materialId', 'toPlace', 'toGodownId', 'toSiteId', 'fromPlace'],
    where: {
      ...material,
      status: 'DONE',
      OR: arriving,
      ...(options.dates && { receivedOn: options.dates }),
    },
    _sum: { receivedQuantity: true },
  });
  return ledger(
    departures.map((d) => ({
      materialId: d.materialId,
      fromPlace: d.fromPlace,
      fromId: d.fromGodownId ?? d.fromSiteId,
      toPlace: d.toPlace,
      quantity: toMilli(d._sum.quantity ?? 0),
    })),
    arrivals.map((a) => ({
      materialId: a.materialId,
      toPlace: a.toPlace,
      toId: a.toGodownId ?? a.toSiteId,
      fromPlace: a.fromPlace,
      quantity: toMilli(a._sum.receivedQuantity ?? 0),
    })),
  );
}

/**
 * Stock on its way to a godown, per material. It is still the company's, so
 * it counts towards the godowns' minimum: moving stock between godowns never
 * looks like a drop.
 */
export async function inTransitToGodowns(
  db: Db,
  materialIds?: readonly string[],
): Promise<Map<string, bigint>> {
  const rows = await db.stockMovement.groupBy({
    by: ['materialId'],
    where: {
      status: 'IN_TRANSIT',
      toPlace: 'GODOWN',
      ...(materialIds && { materialId: { in: [...materialIds] } }),
    },
    _sum: { quantity: true },
  });
  return new Map(
    rows.map((row) => [row.materialId, toMilli(row._sum.quantity ?? 0)]),
  );
}

/** Weighted average purchase price per material, from purchases up to [until]. */
export async function purchaseRates(
  db: Db,
  options: { materialIds?: readonly string[]; until?: Date } = {},
): Promise<Map<string, bigint>> {
  const lines = await db.stockMovement.findMany({
    where: {
      fromPlace: 'SUPPLIER',
      status: { not: 'VOIDED' },
      rate: { not: null },
      ...(options.materialIds && {
        materialId: { in: [...options.materialIds] },
      }),
      ...(options.until && { movedOn: { lte: options.until } }),
    },
    select: { materialId: true, quantity: true, rate: true },
  });
  return averageRates(
    lines.map((line): PricedLine => ({
      materialId: line.materialId,
      quantity: toMilli(line.quantity),
      rate: toPaise(line.rate!),
    })),
  );
}

/**
 * Locks the materials' rows until the transaction ends, so two forms taking the
 * same stock can't both pass the balance check. Locked in id order, which
 * keeps concurrent forms from deadlocking.
 */
export async function lockMaterials(
  tx: Prisma.TransactionClient,
  ids: readonly string[],
) {
  const sorted = [...new Set(ids)].sort();
  await tx.$queryRaw`SELECT id FROM materials WHERE id = ANY(${sorted}::uuid[]) ORDER BY id FOR UPDATE`;
  return tx.material.findMany({ where: { id: { in: sorted } } });
}

/**
 * Admins see every entry; engineers and staff those from or to their sites
 * (staff: their own site); godown managers those from or to their godowns.
 */
export function entryScope(user: AuthUser): Prisma.StockEntryWhereInput {
  if (user.role === 'ADMIN') return {};
  if (user.role === 'GODOWN_MANAGER') {
    const mine = godownScope(user);
    return { OR: [{ fromGodown: mine }, { toGodown: mine }] };
  }
  const mine = siteScope(user);
  return { OR: [{ fromSite: mine }, { toSite: mine }] };
}

/**
 * On the way and for the caller to confirm: arrivals at godowns for admins and
 * godown managers (theirs), deliveries to their sites for engineers.
 */
export function receivableScope(user: AuthUser): Prisma.StockEntryWhereInput {
  switch (user.role) {
    case 'ADMIN':
      return { status: 'IN_TRANSIT', toPlace: 'GODOWN' };
    case 'GODOWN_MANAGER':
      return { status: 'IN_TRANSIT', toGodown: godownScope(user) };
    default:
      return { status: 'IN_TRANSIT', toSite: siteScope(user) };
  }
}

/**
 * Material requests the caller may see: admins all; engineers their sites';
 * godown managers the approved (and closed) ones their godowns supply.
 */
export function requestScope(user: AuthUser): Prisma.MaterialRequestWhereInput {
  switch (user.role) {
    case 'ADMIN':
      return {};
    case 'GODOWN_MANAGER':
      return {
        godown: godownScope(user),
        status: { in: ['APPROVED', 'CLOSED'] },
      };
    default:
      return { site: siteScope(user) };
  }
}

/** Whether the user runs the godown: admins run them all. */
export async function runsGodown(
  db: Db,
  user: AuthUser,
  godownId: string,
): Promise<boolean> {
  if (user.role === 'ADMIN') return true;
  if (user.role !== 'GODOWN_MANAGER') return false;
  return (
    (await db.godownAssignment.count({
      where: { godownId, userId: user.id },
    })) > 0
  );
}

export const SITE_SELECT = {
  id: true,
  code: true,
  name: true,
  status: true,
  engineerAssignments: { select: { engineerId: true } },
} as const satisfies Prisma.SiteSelect;

export type SiteRow = Prisma.SiteGetPayload<{ select: typeof SITE_SELECT }>;

export const GODOWN_SELECT = {
  id: true,
  name: true,
  address: true,
  isActive: true,
} as const satisfies Prisma.GodownSelect;

export type GodownRow = Prisma.GodownGetPayload<{
  select: typeof GODOWN_SELECT;
}>;

/** A site the caller may see, with its engineers; any other looks missing. */
export async function findSite(
  db: Db,
  user: AuthUser,
  siteId: string,
): Promise<SiteRow> {
  const site = await db.site.findFirst({
    where: { id: siteId, ...siteScope(user) },
    select: SITE_SELECT,
  });
  if (!site) throw notFound('site');
  return site;
}

export async function findGodown(db: Db, godownId: string): Promise<GodownRow> {
  const godown = await db.godown.findUnique({
    where: { id: godownId },
    select: GODOWN_SELECT,
  });
  if (!godown) throw notFound('godown');
  return godown;
}

/** A godown with its managers, for deciding who may confirm or cancel. */
const ENTRY_GODOWN_SELECT = {
  ...GODOWN_SELECT,
  managers: { select: { userId: true } },
} as const satisfies Prisma.GodownSelect;

export const ENTRY_INCLUDE = {
  fromGodown: { select: ENTRY_GODOWN_SELECT },
  toGodown: { select: ENTRY_GODOWN_SELECT },
  fromSite: { select: SITE_SELECT },
  toSite: { select: SITE_SELECT },
  createdBy: { select: { id: true, name: true } },
  receivedBy: { select: { id: true, name: true } },
  voidedBy: { select: { id: true, name: true } },
  materialRequest: { select: { id: true, number: true } },
  lines: {
    include: { material: { select: { id: true, name: true, unit: true } } },
    orderBy: { material: { name: 'asc' } },
  },
  _count: { select: { photos: true } },
} as const satisfies Prisma.StockEntryInclude;

export type EntryRow = Prisma.StockEntryGetPayload<{
  include: typeof ENTRY_INCLUDE;
}>;
