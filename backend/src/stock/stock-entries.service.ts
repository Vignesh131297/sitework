import { HttpStatus, Injectable } from '@nestjs/common';
import {
  AttachmentsService,
  type StoredAttachment,
} from '../attachments/attachments.service.js';
import type { AuthUser } from '../auth/auth-user.js';
import { AuditService } from '../common/audit/audit.service.js';
import { AppException } from '../common/errors/app.exception.js';
import { ErrorCode } from '../common/errors/error-codes.js';
import {
  badRequest,
  conflict,
  notFound,
} from '../common/errors/http-errors.js';
import { fromPaise, toPaise, type Paise } from '../common/money/money.js';
import {
  formatQuantity,
  fromMilli,
  toMilli,
  type Milli,
} from '../common/quantity/quantity.js';
import { businessDate, toDbDate } from '../common/time/business-time.js';
import { Clock } from '../common/time/clock.js';
import type { Material, Prisma } from '../generated/prisma/client.js';
import type {
  StockMovementStatus,
  StockPlace,
} from '../generated/prisma/enums.js';
import {
  stockLow,
  stockSent,
  stockShort,
  stockWrittenOff,
  type NotificationText,
} from '../notifications/notification-messages.js';
import {
  NotificationsService,
  type NotificationInput,
} from '../notifications/notifications.service.js';
import { PrismaService } from '../prisma/prisma.service.js';
import { SettingsService } from '../settings/settings.service.js';
import type { UploadedPhoto } from '../staff-updates/staff-updates.dto.js';
import type {
  CountDto,
  PurchaseDto,
  ReceiveStockDto,
  TransferDto,
  UsageDto,
  WriteOffDto,
} from './stock.dto.js';
import {
  crossedBelowMinimum,
  isHolder,
  onHandAt,
  totalsFor,
  type Holder,
  type Ledger,
} from './stock-ledger.js';
import {
  ENTRY_INCLUDE,
  entryScope,
  findGodown,
  findSite,
  inTransitToGodowns,
  ledgerSums,
  lockMaterials,
  runsGodown,
  SITE_SELECT,
  type EntryRow,
  type GodownRow,
  type HolderFilter,
  type SiteRow,
} from './stock-queries.js';
import {
  allowedActions,
  toEntryView,
  viewContext,
  type StockEntryView,
} from './stock-views.js';
import { requestCode } from './request-progress.js';

type Outside = Exclude<StockPlace, 'GODOWN' | 'SITE'>;
type GodownEnd = { place: 'GODOWN'; id: string; godown: GodownRow; site: null };
type SiteEnd = { place: 'SITE'; id: string; site: SiteRow; godown: null };
type HolderEnd = GodownEnd | SiteEnd;
/** Where stock comes from or goes, with the godown or site resolved. */
type Endpoint =
  HolderEnd | { place: Outside; id: null; site: null; godown: null };

interface Line {
  materialId: string;
  quantity: Milli;
  /** Purchases: paise per unit. */
  rate?: Paise;
  /** Counts: each line's own direction (otherwise the entry's). */
  from?: Endpoint;
  to?: Endpoint;
}

interface Entry {
  requestId: string;
  movedOn: string;
  from: Endpoint;
  to: Endpoint;
  lines: Line[];
  dcNumber?: string | null;
  supplier?: string | null;
  billNo?: string | null;
  note?: string | null;
  /** Deliveries to a site (and returns when a request closes). */
  materialRequestId?: string;
  /** Audit action, e.g. "stock.sent". */
  action: string;
  /** More writes that stand or fall with this entry (closing a request). */
  alongside?: (tx: Prisma.TransactionClient) => Promise<void>;
}

const outside = (place: Outside): Endpoint => ({
  place,
  id: null,
  site: null,
  godown: null,
});

/**
 * Recording stock: bought into godowns, sent between godowns and sites, used,
 * written off and counted; deliveries confirmed with photos, and mistakes
 * cancelled. Nothing is ever deleted.
 */
@Injectable()
export class StockEntriesService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly attachments: AttachmentsService,
    private readonly audit: AuditService,
    private readonly notifications: NotificationsService,
    private readonly settings: SettingsService,
    private readonly clock: Clock,
  ) {}

  /** Stock bought into a godown, at a price per unit, with optional bill photos. */
  async purchase(
    user: AuthUser,
    dto: PurchaseDto,
    photos: readonly UploadedPhoto[],
    now = this.clock.now(),
  ): Promise<StockEntryView> {
    const replay = await this.replay(user, dto.requestId, now);
    if (replay) return replay;
    const godown = await this.godownEnd(dto.godownId, 'godownId');
    await this.requireRunsGodown(user, godown.id);
    return this.record(
      user,
      {
        requestId: dto.requestId,
        movedOn: dto.movedOn,
        from: outside('SUPPLIER'),
        to: godown,
        lines: parseLines(dto.lines),
        supplier: dto.supplier || null,
        billNo: dto.billNo || null,
        note: dto.note || null,
        action: 'stock.purchased',
      },
      photos,
      now,
    );
  }

  /**
   * Stock between godowns and sites; the receiver confirms. A site gets stock
   * only from a godown, against an approved material request, sent by that
   * godown's manager or an admin (with a DC photo). Sites never send to each
   * other: engineers return what is left to a godown.
   */
  async transfer(
    user: AuthUser,
    dto: TransferDto,
    photos: readonly UploadedPhoto[],
    now = this.clock.now(),
    alongside?: Entry['alongside'],
  ): Promise<StockEntryView> {
    if (!dto.fromGodownId === !dto.fromSiteId) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Choose where the stock leaves from.',
        'fromSiteId',
      );
    }
    if (!dto.toGodownId === !dto.toSiteId) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Choose where the stock goes.',
        'toSiteId',
      );
    }
    if (dto.fromSiteId && dto.toSiteId) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        "Stock can't go straight from one site to another. Send it back to a godown; the other site can request it.",
        'toSiteId',
      );
    }
    if (dto.toSiteId && !dto.materialRequestId) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Stock goes to a site against an approved material request.',
        'materialRequestId',
      );
    }
    if (user.role === 'ENGINEER' && !dto.fromSiteId) {
      throw forbidden('Engineers can send stock from their own sites only.');
    }
    if (user.role === 'GODOWN_MANAGER' && !dto.fromGodownId) {
      throw forbidden('Godown managers send stock from their own godowns.');
    }
    const replay = await this.replay(user, dto.requestId, now);
    if (replay) return replay;
    const from = dto.fromSiteId
      ? await this.siteEnd(user, dto.fromSiteId)
      : await this.godownEnd(dto.fromGodownId!, 'fromGodownId');
    if (
      from.place === 'GODOWN' &&
      !(await runsGodown(this.prisma, user, from.id))
    ) {
      throw forbidden(
        "Only this godown's manager or an admin can send from it.",
      );
    }
    const to = dto.toSiteId
      ? await this.anySiteEnd(dto.toSiteId)
      : await this.godownEnd(dto.toGodownId!, 'toGodownId');
    if (from.id === to.id) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Choose a different place to send it to.',
        dto.toSiteId ? 'toSiteId' : 'toGodownId',
      );
    }
    if (to.place === 'SITE' && to.site.status === 'COMPLETED') {
      throw badRequest(
        ErrorCode.SITE_CLOSED,
        'This site is completed. Choose an active site.',
        'toSiteId',
      );
    }
    if (from.place === 'GODOWN' && photos.length === 0) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Add a photo of the delivery challan.',
        'photos',
      );
    }
    if (dto.materialRequestId)
      await this.checkRequestRoute(dto.materialRequestId, from, to);
    return this.record(
      user,
      {
        requestId: dto.requestId,
        movedOn: dto.movedOn,
        from,
        to,
        lines: parseLines(dto.lines),
        dcNumber: dto.dcNumber || null,
        note: dto.note || null,
        materialRequestId: dto.materialRequestId,
        action: 'stock.sent',
        alongside,
      },
      photos,
      now,
    );
  }

  /** A day's usage at a site, by its engineers, its staff or an admin. */
  async use(
    user: AuthUser,
    dto: UsageDto,
    now = this.clock.now(),
  ): Promise<StockEntryView> {
    const replay = await this.replay(user, dto.requestId, now);
    if (replay) return replay;
    return this.record(
      user,
      {
        requestId: dto.requestId,
        movedOn: dto.movedOn,
        from: await this.siteEnd(user, dto.siteId),
        to: outside('USED'),
        lines: parseLines(dto.lines),
        note: dto.note || null,
        action: 'stock.used',
      },
      [],
      now,
    );
  }

  /** Wasted, damaged or lost stock. Engineers write off at their own sites. */
  async writeOff(
    user: AuthUser,
    dto: WriteOffDto,
    now = this.clock.now(),
  ): Promise<StockEntryView> {
    requireOnePlace(dto);
    if (user.role === 'ENGINEER' && !dto.siteId) {
      throw forbidden('Engineers can write off stock at their own sites only.');
    }
    if (user.role === 'GODOWN_MANAGER' && !dto.godownId) {
      throw forbidden('Godown managers write off stock at their own godowns.');
    }
    const replay = await this.replay(user, dto.requestId, now);
    if (replay) return replay;
    const from = dto.siteId
      ? await this.siteEnd(user, dto.siteId)
      : await this.godownEnd(dto.godownId!, 'godownId');
    if (from.place === 'GODOWN') await this.requireRunsGodown(user, from.id);
    return this.record(
      user,
      {
        requestId: dto.requestId,
        movedOn: dto.movedOn,
        from,
        to: outside('WASTE'),
        lines: parseLines(dto.lines),
        note: dto.note,
        action: 'stock.written_off',
      },
      [],
      now,
    );
  }

  /**
   * A physical count (admins): each difference from the books is recorded as
   * a correction, up or down. A count that matches is kept with no lines.
   */
  async count(
    user: AuthUser,
    dto: CountDto,
    now = this.clock.now(),
  ): Promise<StockEntryView> {
    requireOnePlace(dto);
    const replay = await this.replay(user, dto.requestId, now);
    if (replay) return replay;
    await this.checkDate(dto.movedOn, now);
    const counted = parseLines(
      dto.lines.map((l) => ({
        materialId: l.materialId,
        quantity: l.countedQuantity,
      })),
      { allowZero: true },
    );
    if (dto.siteId && user.role !== 'ADMIN') {
      throw forbidden("Only an admin can count a site's stock.");
    }
    const holder: HolderEnd = dto.siteId
      ? await this.siteEnd(user, dto.siteId)
      : await this.godownEnd(dto.godownId!, 'godownId');
    if (holder.place === 'GODOWN')
      await this.requireRunsGodown(user, holder.id);
    const ctx = await viewContext(this.settings, user, now);
    const { row } = await this.writeOnce(user, dto.requestId, async (tx) => {
      const materials = await lockMaterials(
        tx,
        counted.map((l) => l.materialId),
      );
      requireAll(materials, counted);
      // Godowns: all of them, for the low-stock check too.
      const book = await ledgerSums(
        tx,
        holder.place === 'GODOWN'
          ? { godowns: 'all', sites: [] }
          : filterFor(holder),
        { materialIds: counted.map((l) => l.materialId) },
      );
      const lines: Line[] = [];
      for (const line of counted) {
        const difference =
          line.quantity - totalsFor(book, holder, line.materialId).onHand;
        if (difference > 0n)
          lines.push({
            materialId: line.materialId,
            quantity: difference,
            from: outside('ADJUSTMENT'),
            to: holder,
          });
        if (difference < 0n)
          lines.push({
            materialId: line.materialId,
            quantity: -difference,
            from: holder,
            to: outside('ADJUSTMENT'),
          });
      }
      const entry: Entry = {
        requestId: dto.requestId,
        movedOn: dto.movedOn,
        from: holder,
        to: outside('ADJUSTMENT'),
        lines,
        note: dto.note,
        action: 'stock.counted',
      };
      const created = await this.create(tx, user, entry, [], now);
      await this.auditEntry(tx, user, created.id, entry, {
        counted: dto.lines.map((l) => ({ ...l })),
      });
      if (holder.place === 'GODOWN') {
        const down = lines.filter((l) => l.to?.place === 'ADJUSTMENT');
        await this.alertLowStock(tx, created.id, materials, book, down, true);
      }
      return created;
    });
    return toEntryView(row, ctx);
  }

  /**
   * The receiver confirms a delivery: what arrived of each material, with at
   * least one photo. Anything short needs a note, and admins hear about it.
   */
  async receive(
    user: AuthUser,
    id: string,
    dto: ReceiveStockDto,
    photos: readonly UploadedPhoto[],
    now = this.clock.now(),
  ): Promise<StockEntryView> {
    const ctx = await viewContext(this.settings, user, now);
    const row = await this.prisma.stockEntry.findFirst({
      where: { id, ...entryScope(user) },
      include: ENTRY_INCLUDE,
    });
    if (!row) throw notFound('stock entry');
    if (row.status === 'VOIDED') throw alreadyVoided();
    if (row.status === 'DONE') throw alreadyReceived();
    if (!allowedActions(row, ctx).canReceive) {
      throw forbidden(
        "Only an admin or the receiving site's engineer can confirm this.",
      );
    }
    if (photos.length === 0) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Add a photo of what arrived.',
        'photos',
      );
    }
    const answers = new Map(dto.lines.map((l) => [l.materialId, l]));
    if (
      answers.size !== dto.lines.length ||
      answers.size !== row.lines.length ||
      row.lines.some((line) => !answers.has(line.materialId))
    ) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Say what arrived of each material on this delivery.',
        'lines',
      );
    }
    const received = row.lines.map((line) => ({
      line,
      sent: toMilli(line.quantity),
      got: toMilli(answers.get(line.materialId)!.receivedQuantity),
    }));
    const tooMuch = received.findIndex(({ sent, got }) => got > sent);
    if (tooMuch >= 0) {
      const { line, sent } = received[tooMuch];
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        `Only ${formatQuantity(sent, line.material.unit)} of ${line.material.name} was sent.`,
        `lines.${dto.lines.findIndex((l) => l.materialId === line.materialId)}.receivedQuantity`,
      );
    }
    const short = received.filter(({ sent, got }) => got < sent);
    const note = dto.note || null;
    if (short.length && !note) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Say what happened to what is missing.',
        'note',
      );
    }
    const stored = await this.attachments.store(photos, now);
    try {
      const updated = await this.prisma.$transaction(async (tx) => {
        const receivedOn = toDbDate(ctx.today);
        const { count } = await tx.stockEntry.updateMany({
          where: { id, status: 'IN_TRANSIT' },
          data: {
            status: 'DONE',
            receivedOn,
            receivedAt: now,
            receivedById: user.id,
            receiveNote: note,
          },
        });
        if (count === 0) throw alreadyReceived();
        for (const { line, got } of received) {
          await tx.stockMovement.update({
            where: { id: line.id },
            data: {
              status: 'DONE',
              receivedQuantity: fromMilli(got),
              receivedOn,
            },
          });
        }
        await tx.attachment.createMany({
          data: stored.map((s) => ({
            ...s,
            stockEntryId: id,
            stockStage: 'RECEIVED' as const,
            uploadedById: user.id,
          })),
        });
        await this.audit.record(
          {
            actorId: user.id,
            action: 'stock.received',
            entityType: 'StockEntry',
            entityId: id,
            changes: {
              lines: received.map(({ line, sent, got }) => ({
                materialId: line.materialId,
                sent: fromMilli(sent),
                received: fromMilli(got),
              })),
              ...(note && { note }),
            },
          },
          tx,
        );
        if (short.length) {
          const recipients = [
            ...(await this.notifications.adminIds(tx)),
            ...(row.fromGodownId
              ? await godownManagerIds(tx, row.fromGodownId)
              : []),
          ].filter((id) => id !== user.id);
          await this.notifications.notify(
            [
              {
                recipientIds: recipients,
                type: 'STOCK',
                ...stockShort({
                  placeName: placeName(row.toPlace, row.toSite, row.toGodown),
                  items: short.map(
                    ({ line, sent, got }) =>
                      `${line.material.name}: ${formatQuantity(got)} of ${formatQuantity(sent, line.material.unit)}`,
                  ),
                }),
                referenceType: 'STOCK_ENTRY',
                referenceId: id,
                data: routeData(row),
                dedupeKey: `stock-short:${id}`,
              },
            ],
            tx,
          );
        }
        return tx.stockEntry.findUniqueOrThrow({
          where: { id },
          include: ENTRY_INCLUDE,
        });
      });
      return toEntryView(updated, ctx);
    } catch (error) {
      await this.attachments.discard(stored);
      throw error;
    }
  }

  /**
   * Cancels an entry: stock on the way goes back to the sender; a finished
   * one is reversed. Refused when a receiver no longer has what it got.
   */
  async void(
    user: AuthUser,
    id: string,
    reason: string,
    now = this.clock.now(),
  ): Promise<StockEntryView> {
    const ctx = await viewContext(this.settings, user, now);
    const row = await this.prisma.stockEntry.findFirst({
      where: { id, ...entryScope(user) },
      include: ENTRY_INCLUDE,
    });
    if (!row) throw notFound('stock entry');
    if (row.status === 'VOIDED') throw alreadyVoided();
    if (!allowedActions(row, ctx).canVoid) {
      throw forbidden(
        row.status === 'IN_TRANSIT'
          ? 'Only an admin or the sending site can cancel this.'
          : 'Only an admin can cancel this entry. You can cancel your own usage and write-offs on the day you record them.',
      );
    }
    const updated = await this.prisma.$transaction(async (tx) => {
      await lockMaterials(
        tx,
        row.lines.map((l) => l.materialId),
      );
      if (row.status === 'DONE') await this.checkReversible(tx, row);
      const { count } = await tx.stockEntry.updateMany({
        where: { id, status: row.status },
        data: {
          status: 'VOIDED',
          voidedAt: now,
          voidedById: user.id,
          voidReason: reason,
        },
      });
      if (count === 0) {
        throw conflict(
          ErrorCode.CONFLICT,
          'This entry changed in the meantime. Reload it and try again.',
        );
      }
      await tx.stockMovement.updateMany({
        where: { entryId: id },
        data: { status: 'VOIDED' },
      });
      await this.audit.record(
        {
          actorId: user.id,
          action: 'stock.voided',
          entityType: 'StockEntry',
          entityId: id,
          changes: { reason, previousStatus: row.status },
        },
        tx,
      );
      return tx.stockEntry.findUniqueOrThrow({
        where: { id },
        include: ENTRY_INCLUDE,
      });
    });
    return toEntryView(updated, ctx);
  }

  // ────────────────────────────── Internals ─────────────────────────────

  /**
   * Records one form (callers check for a retry first). Photos are stored
   * first; then, in one transaction, the materials are locked, the source is
   * checked to hold enough, and the entry, its lines, the audit entry and the
   * notifications are written together.
   */
  private async record(
    user: AuthUser,
    entry: Entry,
    photos: readonly UploadedPhoto[],
    now: Date,
  ): Promise<StockEntryView> {
    await this.checkDate(entry.movedOn, now);
    const ctx = await viewContext(this.settings, user, now);
    const ids = entry.lines.map((l) => l.materialId);
    const stored = await this.attachments.store(photos, now);
    try {
      const { row, replayed } = await this.writeOnce(
        user,
        entry.requestId,
        async (tx) => {
          const materials = await lockMaterials(tx, ids);
          requireAll(materials, entry.lines);
          const from = entry.from;
          if (
            from.place === 'SUPPLIER' ||
            (from.place === 'GODOWN' && entry.to.place === 'SITE')
          ) {
            const inactive = materials.find((m) => !m.isActive);
            if (inactive) {
              throw badRequest(
                ErrorCode.MATERIAL_INACTIVE,
                `${inactive.name} is no longer in use. Turn it back on to ${from.place === 'SUPPLIER' ? 'buy' : 'send'} it.`,
                'lines',
              );
            }
          }
          if (
            entry.materialRequestId &&
            from.place === 'GODOWN' &&
            entry.to.place === 'SITE'
          )
            await checkRequestAllowance(
              tx,
              entry.materialRequestId,
              entry.lines,
              materials,
            );
          let before: Ledger | null = null;
          if (from.place === 'GODOWN' || from.place === 'SITE') {
            // Godowns: all of them, for the low-stock check too.
            before = await ledgerSums(
              tx,
              from.place === 'GODOWN'
                ? { godowns: 'all', sites: [] }
                : filterFor(from),
              { materialIds: ids },
            );
            checkEnough(before, from, entry.lines, materials);
          }
          const created = await this.create(tx, user, entry, stored, now);
          await this.auditEntry(tx, user, created.id, entry);
          await entry.alongside?.(tx);
          if (before && from.place === 'GODOWN' && entry.to.place !== 'GODOWN')
            await this.alertLowStock(
              tx,
              created.id,
              materials,
              before,
              entry.lines,
              false,
            );
          await this.announce(tx, user, created, entry, materials);
          return created;
        },
      );
      if (replayed) await this.attachments.discard(stored);
      return toEntryView(row, ctx);
    } catch (error) {
      await this.attachments.discard(stored);
      throw error;
    }
  }

  /** Creates the entry, its lines and the sender's photos. */
  private create(
    tx: Prisma.TransactionClient,
    user: AuthUser,
    entry: Entry,
    stored: readonly StoredAttachment[],
    now: Date,
  ): Promise<EntryRow> {
    // Two steps only between godowns and sites; everything else is done at once.
    const twoStep = isHolder(entry.from.place) && isHolder(entry.to.place);
    const status: StockMovementStatus = twoStep ? 'IN_TRANSIT' : 'DONE';
    const movedOn = toDbDate(entry.movedOn);
    const receivedOn = twoStep ? null : movedOn;
    return tx.stockEntry.create({
      data: {
        requestId: entry.requestId,
        ...placeColumns(entry.from, entry.to),
        status,
        movedOn,
        receivedOn,
        dcNumber: entry.dcNumber ?? null,
        supplier: entry.supplier ?? null,
        billNo: entry.billNo ?? null,
        note: entry.note ?? null,
        materialRequestId: entry.materialRequestId ?? null,
        createdById: user.id,
        createdAt: now,
        lines: {
          create: entry.lines.map((line) => {
            const quantity = fromMilli(line.quantity);
            return {
              materialId: line.materialId,
              quantity,
              rate: line.rate === undefined ? null : fromPaise(line.rate),
              ...placeColumns(line.from ?? entry.from, line.to ?? entry.to),
              status,
              movedOn,
              receivedOn,
              receivedQuantity: twoStep ? null : quantity,
            };
          }),
        },
        photos: {
          create: stored.map((s) => ({
            ...s,
            stockStage: 'SENT' as const,
            uploadedById: user.id,
          })),
        },
      },
      include: ENTRY_INCLUDE,
    });
  }

  private auditEntry(
    tx: Prisma.TransactionClient,
    user: AuthUser,
    entryId: string,
    entry: Entry,
    extra: Prisma.InputJsonObject = {},
  ): Promise<void> {
    return this.audit.record(
      {
        actorId: user.id,
        action: entry.action,
        entityType: 'StockEntry',
        entityId: entryId,
        changes: {
          from: entry.from.place,
          fromId: entry.from.id,
          to: entry.to.place,
          toId: entry.to.id,
          movedOn: entry.movedOn,
          lines: entry.lines.map((l) => ({
            materialId: l.materialId,
            quantity: fromMilli(l.quantity),
            ...(l.rate !== undefined && { rate: fromPaise(l.rate) }),
          })),
          ...(entry.dcNumber && { dcNumber: entry.dcNumber }),
          ...(entry.supplier && { supplier: entry.supplier }),
          ...(entry.billNo && { billNo: entry.billNo }),
          ...(entry.note && { note: entry.note }),
          ...extra,
        },
      },
      tx,
    );
  }

  /**
   * Stock on the way: whoever confirms at the other end hears about it (a
   * site's engineers; a godown's managers, or admins if it has none). Admins
   * hear about write-offs by anyone else.
   */
  private async announce(
    tx: Prisma.TransactionClient,
    user: AuthUser,
    created: EntryRow,
    entry: Entry,
    materials: Material[],
  ): Promise<void> {
    const items = entry.lines.map((line) => {
      const material = materials.find((m) => m.id === line.materialId)!;
      return `${material.name}: ${formatQuantity(line.quantity, material.unit)}`;
    });
    const recipients = new Set<string>();
    const admins = async () => {
      for (const id of await this.notifications.adminIds(tx))
        recipients.add(id);
    };
    let text: NotificationText;
    if (isHolder(entry.from.place) && isHolder(entry.to.place)) {
      if (entry.to.place === 'SITE')
        for (const a of entry.to.site.engineerAssignments)
          recipients.add(a.engineerId);
      if (entry.to.place === 'GODOWN') {
        const managers = await godownManagerIds(tx, entry.to.id);
        if (managers.length) for (const id of managers) recipients.add(id);
        else await admins();
      }
      text = stockSent({
        toName: endpointName(entry.to),
        fromName: endpointName(entry.from),
        items,
        byName: user.name,
      });
    } else if (entry.to.place === 'WASTE' && user.role !== 'ADMIN') {
      await admins();
      text = stockWrittenOff({
        placeName: endpointName(entry.from),
        items,
        note: entry.note ?? '',
        byName: user.name,
      });
    } else {
      return;
    }
    recipients.delete(user.id);
    await this.notifications.notify(
      [
        {
          recipientIds: [...recipients],
          type: 'STOCK',
          ...text,
          referenceType: 'STOCK_ENTRY',
          referenceId: created.id,
          data: routeData(created),
          dedupeKey: `stock:${created.id}`,
        },
      ],
      tx,
    );
  }

  /**
   * Alerts admins about each material this drop takes below its minimum,
   * counting all godowns together ([before] holds all of them) and what is on
   * its way to them. Only called for stock leaving the godowns.
   */
  private async alertLowStock(
    tx: Prisma.TransactionClient,
    entryId: string,
    materials: Material[],
    before: Ledger,
    taken: readonly Line[],
    inGodownsOnly: boolean,
  ): Promise<void> {
    const inputs: NotificationInput[] = [];
    const transit = await inTransitToGodowns(
      tx,
      taken.map((l) => l.materialId),
    );
    for (const line of taken) {
      if (inGodownsOnly && line.from?.place !== 'GODOWN') continue;
      const material = materials.find((m) => m.id === line.materialId)!;
      const minimum =
        material.minStock === null ? null : toMilli(material.minStock);
      const had =
        onHandAt(before, 'GODOWN', material.id) +
        (transit.get(material.id) ?? 0n);
      const left = had - line.quantity;
      if (!material.isActive || !crossedBelowMinimum(minimum, had, left))
        continue;
      inputs.push({
        recipientIds: await this.notifications.adminIds(tx),
        type: 'STOCK',
        ...stockLow({
          material: material.name,
          left: formatQuantity(left, material.unit),
          minimum: formatQuantity(minimum!, material.unit),
        }),
        data: { materialId: material.id },
        dedupeKey: `stock-low:${material.id}:${entryId}`,
      });
    }
    await this.notifications.notify(inputs, tx);
  }

  /** A finished entry can be undone only while each receiver still has what it got. */
  private async checkReversible(
    tx: Prisma.TransactionClient,
    row: EntryRow,
  ): Promise<void> {
    const arrivals = row.lines.filter((l) => isHolder(l.toPlace));
    if (!arrivals.length) return;
    const book = await ledgerSums(
      tx,
      {
        godowns: arrivals.flatMap((l) => (l.toGodownId ? [l.toGodownId] : [])),
        sites: arrivals.flatMap((l) => (l.toSiteId ? [l.toSiteId] : [])),
      },
      { materialIds: arrivals.map((l) => l.materialId) },
    );
    for (const line of arrivals) {
      const holder: Holder = {
        place: line.toPlace as Holder['place'],
        id: (line.toGodownId ?? line.toSiteId)!,
      };
      const left = totalsFor(book, holder, line.materialId).onHand;
      if (left < toMilli(line.receivedQuantity!)) {
        const where =
          row.toPlace === line.toPlace
            ? placeName(row.toPlace, row.toSite, row.toGodown)
            : placeName(row.fromPlace, row.fromSite, row.fromGodown);
        throw conflict(
          ErrorCode.STOCK_NOT_ENOUGH,
          `This can't be cancelled: only ${formatQuantity(left, line.material.unit)} of ${line.material.name} is left at ${where}.`,
        );
      }
    }
  }

  /**
   * Runs [write] in a transaction. A retry that loses the race to its first
   * attempt (same request id) gets the first attempt's entry.
   */
  private async writeOnce(
    user: AuthUser,
    requestId: string,
    write: (tx: Prisma.TransactionClient) => Promise<EntryRow>,
  ): Promise<{ row: EntryRow; replayed: boolean }> {
    try {
      return { row: await this.prisma.$transaction(write), replayed: false };
    } catch (error) {
      if ((error as { code?: string }).code === 'P2002') {
        const row = await this.replayRow(user, requestId);
        if (row) return { row, replayed: true };
      }
      throw error;
    }
  }

  /** The form's entry if this user already sent it (a retry). */
  private async replay(
    user: AuthUser,
    requestId: string,
    now: Date,
  ): Promise<StockEntryView | null> {
    const row = await this.replayRow(user, requestId);
    if (!row) return null;
    return toEntryView(row, await viewContext(this.settings, user, now));
  }

  private async replayRow(
    user: AuthUser,
    requestId: string,
  ): Promise<EntryRow | null> {
    const row = await this.prisma.stockEntry.findUnique({
      where: { requestId },
      include: ENTRY_INCLUDE,
    });
    if (row && row.createdById !== user.id) {
      throw conflict(
        ErrorCode.CONFLICT,
        'This form was already sent by someone else. Start a new one.',
      );
    }
    return row;
  }

  private async requireRunsGodown(
    user: AuthUser,
    godownId: string,
  ): Promise<void> {
    if (!(await runsGodown(this.prisma, user, godownId)))
      throw forbidden("Only this godown's manager or an admin can do this.");
  }

  /**
   * A delivery against a request goes from the request's godown to its site;
   * a return goes from its site. The request must still be approved.
   */
  private async checkRequestRoute(
    materialRequestId: string,
    from: Endpoint,
    to: Endpoint,
  ): Promise<void> {
    const request = await this.prisma.materialRequest.findUnique({
      where: { id: materialRequestId },
      select: { status: true, siteId: true, godownId: true, number: true },
    });
    if (!request) throw notFound('material request');
    if (request.status !== 'APPROVED') {
      throw conflict(
        ErrorCode.REQUEST_NOT_OPEN,
        `${requestCode(request.number)} is not open for sending.`,
      );
    }
    const delivery = to.place === 'SITE';
    const fits = delivery
      ? to.id === request.siteId && from.id === request.godownId
      : from.id === request.siteId;
    if (!fits) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        delivery
          ? `${requestCode(request.number)} is for another site or godown.`
          : `${requestCode(request.number)} is for another site.`,
        'materialRequestId',
      );
    }
  }

  /** A site the caller works on (staff: their own site). */
  private async siteEnd(user: AuthUser, siteId: string): Promise<SiteEnd> {
    const site = await findSite(this.prisma, user, siteId);
    return { place: 'SITE', id: site.id, site, godown: null };
  }

  /** Any site, as a destination: the request it goes against is checked. */
  private async anySiteEnd(siteId: string): Promise<SiteEnd> {
    const site = await this.prisma.site.findUnique({
      where: { id: siteId },
      select: SITE_SELECT,
    });
    if (!site) throw notFound('site');
    return { place: 'SITE', id: site.id, site, godown: null };
  }

  private async godownEnd(godownId: string, field: string): Promise<GodownEnd> {
    const godown = await findGodown(this.prisma, godownId);
    if (!godown.isActive) {
      throw badRequest(
        ErrorCode.GODOWN_INACTIVE,
        `${godown.name} is closed. Choose another godown.`,
        field,
      );
    }
    return { place: 'GODOWN', id: godown.id, godown, site: null };
  }

  private async checkDate(movedOn: string, now: Date): Promise<void> {
    const { timeZone } = await this.settings.get('business');
    if (movedOn > businessDate(now, timeZone)) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Stock cannot be recorded for a future date.',
        'movedOn',
      );
    }
  }
}

/** Quantities (and prices) parsed exactly; each material once, above zero (or zero for counts). */
function parseLines(
  lines: readonly { materialId: string; quantity: string; rate?: string }[],
  { allowZero = false } = {},
): Line[] {
  const seen = new Set<string>();
  return lines.map((line, index) => {
    if (seen.has(line.materialId)) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Each material can appear only once in a form.',
        `lines.${index}.materialId`,
      );
    }
    seen.add(line.materialId);
    const quantity = toMilli(line.quantity);
    if (!allowZero && quantity <= 0n) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Enter a quantity above zero.',
        `lines.${index}.quantity`,
      );
    }
    return {
      materialId: line.materialId,
      quantity,
      ...(line.rate !== undefined && { rate: toPaise(line.rate) }),
    };
  });
}

function requireAll(
  materials: readonly Material[],
  lines: readonly { materialId: string }[],
): void {
  const index = lines.findIndex(
    (line) => !materials.some((m) => m.id === line.materialId),
  );
  if (index >= 0) {
    throw badRequest(
      ErrorCode.VALIDATION_FAILED,
      'Choose a material from the list.',
      `lines.${index}.materialId`,
    );
  }
}

function requireOnePlace(dto: { siteId?: string; godownId?: string }): void {
  if (!dto.siteId === !dto.godownId) {
    throw badRequest(
      ErrorCode.VALIDATION_FAILED,
      'Choose a site or a godown.',
      'siteId',
    );
  }
}

function checkEnough(
  book: Ledger,
  from: HolderEnd,
  lines: readonly Line[],
  materials: readonly Material[],
): void {
  lines.forEach((line, index) => {
    const available = totalsFor(book, from, line.materialId).onHand;
    if (line.quantity <= available) return;
    const material = materials.find((m) => m.id === line.materialId)!;
    const where = endpointName(from);
    throw badRequest(
      ErrorCode.STOCK_NOT_ENOUGH,
      available > 0n
        ? `Only ${formatQuantity(available, material.unit)} of ${material.name} is at ${where}.`
        : `There is no ${material.name} at ${where}.`,
      `lines.${index}.quantity`,
    );
  });
}

function filterFor(holder: HolderEnd): HolderFilter {
  return holder.place === 'GODOWN'
    ? { godowns: [holder.id], sites: [] }
    : { godowns: [], sites: [holder.id] };
}

function placeColumns(from: Endpoint, to: Endpoint) {
  return {
    fromPlace: from.place,
    fromGodownId: from.place === 'GODOWN' ? from.id : null,
    fromSiteId: from.place === 'SITE' ? from.id : null,
    toPlace: to.place,
    toGodownId: to.place === 'GODOWN' ? to.id : null,
    toSiteId: to.place === 'SITE' ? to.id : null,
  };
}

/** A godown's or site's name, for messages. */
function endpointName(end: Endpoint): string {
  return end.site?.name ?? end.godown?.name ?? '';
}

function placeName(
  place: StockPlace,
  site: { name: string } | null,
  godown: { name: string } | null,
): string {
  return place === 'SITE' ? (site?.name ?? '') : (godown?.name ?? '');
}

/**
 * Lets the app open the right screen from a notification: the site's Stock
 * tab, or (admins) the godown's page.
 */
function routeData(row: {
  toPlace: StockPlace;
  fromSiteId: string | null;
  toSiteId: string | null;
  fromGodownId: string | null;
  toGodownId: string | null;
}): Record<string, string> {
  const siteId = row.toSiteId ?? row.fromSiteId;
  const godownId = row.toGodownId ?? row.fromGodownId;
  return {
    to: row.toPlace,
    ...(siteId && { siteId }),
    ...(godownId && { godownId }),
  };
}

const forbidden = (message: string) =>
  new AppException(ErrorCode.FORBIDDEN, message, HttpStatus.FORBIDDEN);

const alreadyReceived = () =>
  conflict(
    ErrorCode.STOCK_ALREADY_RECEIVED,
    'This stock was already received.',
  );

const alreadyVoided = () =>
  conflict(ErrorCode.STOCK_ALREADY_VOIDED, 'This entry was already cancelled.');

/**
 * A delivery may not send more of a material than the request's approved
 * quantity minus what earlier deliveries (not cancelled) already sent. The
 * request's row is locked so two deliveries can't both use the same allowance.
 */
async function checkRequestAllowance(
  tx: Prisma.TransactionClient,
  materialRequestId: string,
  lines: readonly Line[],
  materials: readonly Material[],
): Promise<void> {
  await tx.$queryRaw`SELECT id FROM material_requests WHERE id = ${materialRequestId}::uuid FOR UPDATE`;
  const request = await tx.materialRequest.findUniqueOrThrow({
    where: { id: materialRequestId },
    select: {
      number: true,
      status: true,
      lines: { select: { materialId: true, approvedQuantity: true } },
    },
  });
  if (request.status !== 'APPROVED') {
    throw conflict(
      ErrorCode.REQUEST_NOT_OPEN,
      `${requestCode(request.number)} is not open for sending.`,
    );
  }
  const sent = await tx.stockMovement.groupBy({
    by: ['materialId'],
    where: {
      entry: { materialRequestId },
      fromPlace: 'GODOWN',
      toPlace: 'SITE',
      status: { not: 'VOIDED' },
    },
    _sum: { quantity: true },
  });
  const sentOf = new Map(
    sent.map((s) => [s.materialId, toMilli(s._sum.quantity ?? 0)]),
  );
  lines.forEach((line, index) => {
    const approved = request.lines.find(
      (l) => l.materialId === line.materialId,
    )?.approvedQuantity;
    const left =
      (approved == null ? 0n : toMilli(approved)) -
      (sentOf.get(line.materialId) ?? 0n);
    if (line.quantity <= left) return;
    const material = materials.find((m) => m.id === line.materialId)!;
    throw badRequest(
      ErrorCode.REQUEST_EXCEEDED,
      left > 0n
        ? `Only ${formatQuantity(left, material.unit)} of ${material.name} is left to send on ${requestCode(request.number)}.`
        : `${requestCode(request.number)} has no ${material.name} left to send.`,
      `lines.${index}.quantity`,
    );
  });
}

/** The active managers of a godown. */
export async function godownManagerIds(
  db: Prisma.TransactionClient,
  godownId: string,
): Promise<string[]> {
  const rows = await db.godownAssignment.findMany({
    where: { godownId, manager: { isActive: true } },
    select: { userId: true },
  });
  return rows.map((r) => r.userId);
}
