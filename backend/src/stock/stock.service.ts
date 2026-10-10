import { Injectable } from '@nestjs/common';
import { AttachmentsService } from '../attachments/attachments.service.js';
import type { AuthUser } from '../auth/auth-user.js';
import { godownScope, siteScope } from '../common/access/access-scope.js';
import { notFound } from '../common/errors/http-errors.js';
import { fromPaise, sumPaise, type Paise } from '../common/money/money.js';
import { Paginated } from '../common/pagination/paginated.js';
import { contains } from '../common/pagination/page-query.dto.js';
import { fromMilli, toMilli, type Milli } from '../common/quantity/quantity.js';
import {
  businessDate,
  toDbDate,
  zonedInstant,
} from '../common/time/business-time.js';
import { Clock } from '../common/time/clock.js';
import type { Material, Prisma } from '../generated/prisma/client.js';
import { stockUsageReminder } from '../notifications/notification-messages.js';
import {
  NotificationsService,
  type NotificationInput,
} from '../notifications/notifications.service.js';
import { PrismaService } from '../prisma/prisma.service.js';
import { CalendarService } from '../settings/calendar.service.js';
import { SettingsService } from '../settings/settings.service.js';
import type { EntryQueryDto } from './stock.dto.js';
import {
  holderKey,
  onHandAt,
  totalsFor,
  valueOf,
  type Holder,
  type Ledger,
} from './stock-ledger.js';
import {
  ENTRY_INCLUDE,
  entryScope,
  findGodown,
  findSite,
  GODOWN_SELECT,
  inTransitToGodowns,
  ledgerSums,
  purchaseRates,
  receivableScope,
  runsGodown,
} from './stock-queries.js';
import {
  toEntryView,
  toGodownView,
  toHolderRow,
  toMaterialView,
  viewContext,
  type GodownStock,
  type GodownView,
  type HolderStockRow,
  type SiteStock,
  type StockEntryView,
  type StockOverview,
  type ViewContext,
} from './stock-views.js';

/**
 * What is where: every godown and site, the entries between them, and the
 * daily usage reminder. Balances are always derived from the entries' lines
 * (see stock-ledger.ts).
 */
@Injectable()
export class StockService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly attachments: AttachmentsService,
    private readonly notifications: NotificationsService,
    private readonly settings: SettingsService,
    private readonly calendar: CalendarService,
    private readonly clock: Clock,
  ) {}

  /** Godowns, every material's totals, and what the caller can confirm. */
  async overview(user: AuthUser): Promise<StockOverview> {
    const admin = user.role === 'ADMIN';
    const manager = user.role === 'GODOWN_MANAGER';
    const [godowns, materials, book, transit, arriving, toReceive, sites] =
      await Promise.all([
        this.prisma.godown.findMany({
          where: admin
            ? {}
            : manager
              ? { ...godownScope(user), isActive: true }
              : { isActive: true },
          select: GODOWN_SELECT,
          orderBy: [{ isActive: 'desc' }, { name: 'asc' }],
        }),
        this.prisma.material.findMany({
          where: admin ? {} : { isActive: true },
          orderBy: { name: 'asc' },
        }),
        ledgerSums(this.prisma, { godowns: 'all', sites: 'all' }),
        inTransitToGodowns(this.prisma),
        this.prisma.stockEntry.groupBy({
          by: ['toGodownId'],
          where: { status: 'IN_TRANSIT', toPlace: 'GODOWN' },
          _count: { _all: true },
        }),
        this.prisma.stockEntry.count({ where: receivableScope(user) }),
        manager
          ? []
          : this.prisma.site.findMany({
              // Engineers request material for their own sites only.
              where: { ...siteScope(user), status: { not: 'COMPLETED' } },
              select: { id: true, code: true, name: true },
              orderBy: { name: 'asc' },
            }),
      ]);
    // Godown managers see what their own godowns hold.
    const mine = manager ? godowns.map((g) => g.id) : null;
    const arrivingAt = new Map(
      arriving.map((row) => [row.toGodownId, row._count._all]),
    );
    return {
      godowns: godowns.map((godown) => ({
        godown: toGodownView(godown),
        arriving: arrivingAt.get(godown.id) ?? 0,
      })),
      materials: materials.map((material) => {
        const inGodowns = onHandAt(book, 'GODOWN', material.id);
        const shown = mine
          ? mine.reduce(
              (sum, id) =>
                sum +
                totalsFor(book, { place: 'GODOWN', id }, material.id).onHand,
              0n,
            )
          : inGodowns;
        return {
          material: toMaterialView(material),
          inGodowns: fromMilli(shown),
          onSites: fromMilli(onHandAt(book, 'SITE', material.id)),
          low: isLow(material, inGodowns + (transit.get(material.id) ?? 0n)),
        };
      }),
      toReceive,
      sites,
    };
  }

  /** A site's stock: what it holds and has used, and what is on the way. */
  async site(user: AuthUser, siteId: string): Promise<SiteStock> {
    const ctx = await viewContext(this.settings, user, this.clock.now());
    const site = await findSite(this.prisma, user, siteId);
    const [held, arriving, leaving, usedToday] = await Promise.all([
      this.holdings({ place: 'SITE', id: site.id }, user.role === 'ADMIN'),
      this.onTheWay({ toSiteId: site.id }, ctx),
      this.onTheWay({ fromSiteId: site.id }, ctx),
      this.prisma.stockEntry.count({
        where: {
          fromSiteId: site.id,
          toPlace: 'USED',
          status: { not: 'VOIDED' },
          movedOn: toDbDate(ctx.today),
        },
      }),
    ]);
    return {
      site: {
        id: site.id,
        code: site.code,
        name: site.name,
        status: site.status,
      },
      items: held.items,
      arriving,
      leaving,
      usedToday: usedToday > 0,
      value: held.value,
    };
  }

  /** A godown's stock (admins and engineers; values for admins). */
  async godown(user: AuthUser, godownId: string): Promise<GodownStock> {
    const ctx = await viewContext(this.settings, user, this.clock.now());
    const godown = await findGodown(this.prisma, godownId);
    if (!godown.isActive && user.role !== 'ADMIN') throw notFound('godown');
    if (
      user.role === 'GODOWN_MANAGER' &&
      !(await runsGodown(this.prisma, user, godown.id))
    )
      throw notFound('godown');
    const [held, arriving, leaving, managers] = await Promise.all([
      this.holdings({ place: 'GODOWN', id: godown.id }, user.role === 'ADMIN'),
      this.onTheWay({ toGodownId: godown.id }, ctx),
      this.onTheWay({ fromGodownId: godown.id }, ctx),
      this.prisma.godownAssignment.findMany({
        where: { godownId: godown.id, manager: { isActive: true } },
        select: { manager: { select: { id: true, name: true, phone: true } } },
        orderBy: { manager: { name: 'asc' } },
      }),
    ]);
    return {
      godown: toGodownView(godown),
      managers: managers.map((m) => m.manager),
      items: held.items,
      arriving,
      leaving,
      value: held.value && { onHand: held.value.onHand },
    };
  }

  async entries(
    user: AuthUser,
    query: EntryQueryDto,
  ): Promise<Paginated<StockEntryView>> {
    const ctx = await viewContext(this.settings, user, this.clock.now());
    const term = query.search;
    const where: Prisma.StockEntryWhereInput = {
      AND: [
        entryScope(user),
        query.siteId
          ? { OR: [{ fromSiteId: query.siteId }, { toSiteId: query.siteId }] }
          : {},
        query.godownId
          ? {
              OR: [
                { fromGodownId: query.godownId },
                { toGodownId: query.godownId },
              ],
            }
          : {},
        query.materialId
          ? { lines: { some: { materialId: query.materialId } } }
          : {},
        query.status ? { status: query.status } : {},
        query.receivable ? receivableScope(user) : {},
        query.from ? { movedOn: { gte: toDbDate(query.from) } } : {},
        query.to ? { movedOn: { lte: toDbDate(query.to) } } : {},
        term
          ? {
              OR: [
                { lines: { some: { material: { name: contains(term) } } } },
                { note: contains(term) },
                { supplier: contains(term) },
                { billNo: contains(term) },
                { dcNumber: contains(term) },
              ],
            }
          : {},
      ],
    };
    const [rows, total] = await Promise.all([
      this.prisma.stockEntry.findMany({
        where,
        include: ENTRY_INCLUDE,
        orderBy: [{ createdAt: 'desc' }, { id: 'asc' }],
        skip: query.skip,
        take: query.limit,
      }),
      this.prisma.stockEntry.count({ where }),
    ]);
    return new Paginated(
      rows.map((row) => toEntryView(row, ctx)),
      query.page,
      query.limit,
      total,
    );
  }

  /** One entry in full, with signed links to its photos. */
  async entry(user: AuthUser, id: string): Promise<StockEntryView> {
    const now = this.clock.now();
    const ctx = await viewContext(this.settings, user, now);
    const row = await this.prisma.stockEntry.findFirst({
      where: { id, ...entryScope(user) },
      include: ENTRY_INCLUDE,
    });
    if (!row) throw notFound('stock entry');
    const photos = await this.prisma.attachment.findMany({
      where: { stockEntryId: id },
      select: { id: true, mime: true, objectKey: true, stockStage: true },
      orderBy: { createdAt: 'asc' },
    });
    const views = await this.attachments.views(photos, now);
    return toEntryView(
      row,
      ctx,
      views.map((view, index) => ({
        ...view,
        stage: photos[index].stockStage!,
      })),
    );
  }

  async adminCounts(): Promise<{
    lowStock: number;
    toReceive: number;
    requestsToApprove: number;
  }> {
    const [materials, book, transit, toReceive] = await Promise.all([
      this.prisma.material.findMany({
        where: { isActive: true, minStock: { not: null } },
      }),
      ledgerSums(this.prisma, { godowns: 'all', sites: [] }),
      inTransitToGodowns(this.prisma),
      this.prisma.stockEntry.count({
        where: { status: 'IN_TRANSIT', toPlace: 'GODOWN' },
      }),
    ]);
    const lowStock = materials.filter((m) =>
      isLow(m, onHandAt(book, 'GODOWN', m.id) + (transit.get(m.id) ?? 0n)),
    ).length;
    const requestsToApprove = await this.prisma.materialRequest.count({
      where: { status: 'PENDING' },
    });
    return { lowStock, toReceive, requestsToApprove };
  }

  async engineerCounts(
    user: AuthUser,
  ): Promise<{ toReceive: number; openRequests: number }> {
    const [toReceive, openRequests] = await Promise.all([
      this.prisma.stockEntry.count({ where: receivableScope(user) }),
      this.prisma.materialRequest.count({
        where: {
          status: { in: ['PENDING', 'APPROVED'] },
          site: siteScope(user),
        },
      }),
    ]);
    return { toReceive, openRequests };
  }

  /** A godown manager's godowns and what is arriving at each. */
  async managerGodowns(user: AuthUser): Promise<{
    godowns: { godown: GodownView; arriving: number }[];
    toReceive: number;
  }> {
    const godowns = await this.prisma.godown.findMany({
      where: { ...godownScope(user), isActive: true },
      select: GODOWN_SELECT,
      orderBy: { name: 'asc' },
    });
    const arriving = await this.prisma.stockEntry.groupBy({
      by: ['toGodownId'],
      where: {
        status: 'IN_TRANSIT',
        toGodownId: { in: godowns.map((g) => g.id) },
      },
      _count: { _all: true },
    });
    const at = new Map(arriving.map((r) => [r.toGodownId, r._count._all]));
    return {
      godowns: godowns.map((godown) => ({
        godown: toGodownView(godown),
        arriving: at.get(godown.id) ?? 0,
      })),
      toReceive: [...at.values()].reduce((a, b) => a + b, 0),
    };
  }

  /**
   * Evening reminder on working days: the engineers of each running site that
   * holds stock but has no usage recorded today. Once per site and day.
   */
  async remindUsage(now = this.clock.now()): Promise<number> {
    const settings = await this.settings.getAll();
    if (!settings.stock.usageReminders) return 0;
    const timeZone = settings.business.timeZone;
    const today = businessDate(now, timeZone);
    if (now < zonedInstant(today, settings.stock.usageReminderAt, timeZone))
      return 0;
    if (!(await this.calendar.isWorkingDay(today))) return 0;
    const sites = await this.prisma.site.findMany({
      where: { status: 'IN_PROGRESS' },
      select: {
        id: true,
        name: true,
        engineerAssignments: { select: { engineerId: true } },
      },
    });
    const [book, used] = await Promise.all([
      ledgerSums(this.prisma, { godowns: [], sites: sites.map((s) => s.id) }),
      this.prisma.stockEntry.findMany({
        where: {
          toPlace: 'USED',
          status: { not: 'VOIDED' },
          movedOn: toDbDate(today),
        },
        select: { fromSiteId: true },
        distinct: ['fromSiteId'],
      }),
    ]);
    const usedAt = new Set(used.map((entry) => entry.fromSiteId));
    const inputs: NotificationInput[] = sites
      .filter((site) => !usedAt.has(site.id) && holdsStock(book, site.id))
      .map((site) => ({
        recipientIds: site.engineerAssignments.map((a) => a.engineerId),
        type: 'STOCK',
        ...stockUsageReminder({ siteName: site.name }),
        data: { to: 'SITE', siteId: site.id },
        dedupeKey: `stock-usage:${site.id}:${today}`,
      }));
    return this.notifications.notify(inputs);
  }

  /** Every material a godown or site has held, those on hand first. */
  private async holdings(
    holder: Holder,
    admin: boolean,
  ): Promise<{
    items: HolderStockRow[];
    value: { used: string; onHand: string } | null;
  }> {
    const book = await ledgerSums(
      this.prisma,
      holder.place === 'GODOWN'
        ? { godowns: [holder.id], sites: [] }
        : { godowns: [], sites: [holder.id] },
    );
    const ids = [
      ...(book.get(holderKey(holder.place, holder.id))?.keys() ?? []),
    ];
    const [materials, rates] = await Promise.all([
      this.prisma.material.findMany({
        where: { id: { in: ids } },
        orderBy: { name: 'asc' },
      }),
      admin
        ? purchaseRates(this.prisma, { materialIds: ids })
        : new Map<string, Paise>(),
    ]);
    const used: Paise[] = [];
    const onHand: Paise[] = [];
    const items = materials.map((material) => {
      const totals = totalsFor(book, holder, material.id);
      const rate = rates.get(material.id);
      if (rate !== undefined) {
        used.push(valueOf(totals.used, rate));
        onHand.push(valueOf(totals.onHand, rate));
      }
      return toHolderRow(material, totals, rate, admin);
    });
    // Stable sort: what is held now first, each group by name.
    items.sort((a, b) => Number(a.onHand === '0') - Number(b.onHand === '0'));
    return {
      items,
      value: admin
        ? {
            used: fromPaise(sumPaise(used)),
            onHand: fromPaise(sumPaise(onHand)),
          }
        : null,
    };
  }

  private async onTheWay(
    where: Prisma.StockEntryWhereInput,
    ctx: ViewContext,
  ): Promise<StockEntryView[]> {
    const rows = await this.prisma.stockEntry.findMany({
      where: { ...where, status: 'IN_TRANSIT' },
      include: ENTRY_INCLUDE,
      orderBy: { createdAt: 'asc' },
    });
    return rows.map((row) => toEntryView(row, ctx));
  }
}

/** All godowns together (with what is on its way to them) are below the material's minimum. */
export function isLow(material: Material, inGodowns: Milli): boolean {
  return (
    material.isActive &&
    material.minStock !== null &&
    inGodowns < toMilli(material.minStock)
  );
}

function holdsStock(book: Ledger, siteId: string): boolean {
  return [...(book.get(holderKey('SITE', siteId))?.values() ?? [])].some(
    (totals) => totals.onHand > 0n,
  );
}
