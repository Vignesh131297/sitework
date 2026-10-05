import { HttpStatus, Injectable } from '@nestjs/common';
import type { AuthUser } from '../auth/auth-user.js';
import { AuditService } from '../common/audit/audit.service.js';
import { AppException } from '../common/errors/app.exception.js';
import { ErrorCode } from '../common/errors/error-codes.js';
import { badRequest, notFound } from '../common/errors/http-errors.js';
import {
  formatInr,
  sumPaise,
  toPaise,
  type Paise,
} from '../common/money/money.js';
import { Paginated } from '../common/pagination/paginated.js';
import { fromDbDate, toDbDate } from '../common/time/business-time.js';
import { Clock } from '../common/time/clock.js';
import type { Prisma } from '../generated/prisma/client.js';
import type { PaymentMethod, SiteStatus } from '../generated/prisma/enums.js';
import { milestoneOverdue } from '../notifications/notification-messages.js';
import { NotificationsService } from '../notifications/notifications.service.js';
import { PrismaService } from '../prisma/prisma.service.js';
import { CalendarService } from '../settings/calendar.service.js';
import type {
  CreateMilestoneDto,
  CreatePaymentDto,
  PaymentQueryDto,
  UpdateMilestoneDto,
} from './payments.dto.js';
import {
  siteFinancials,
  totalFinancials,
  type MilestoneView,
  type SiteFinancials,
} from './site-financials.js';

export interface PaymentView {
  id: string;
  amount: string;
  paidOn: string;
  method: PaymentMethod;
  reference: string | null;
  remarks: string | null;
  site: { id: string; code: string; name: string };
  client: { id: string; name: string };
  recordedBy: { id: string; name: string };
  createdAt: string;
  voidedAt: string | null;
  voidedBy: { id: string; name: string } | null;
  voidReason: string | null;
}

export interface SiteMoney {
  site: { id: string; code: string; name: string; status: SiteStatus };
  client: { id: string; name: string };
  financials: SiteFinancials;
}

export interface SiteMoneyRow extends Omit<SiteMoney, 'financials'> {
  financials: Omit<SiteFinancials, 'milestones'>;
  /** The earliest milestone not fully paid. */
  nextDue: MilestoneView | null;
}

export interface PaymentsSummary {
  totals: Omit<SiteFinancials, 'milestones'>;
  sites: SiteMoneyRow[];
}

const PAYMENT_INCLUDE = {
  site: {
    select: {
      id: true,
      code: true,
      name: true,
      client: { select: { id: true, name: true } },
    },
  },
  recordedBy: { select: { id: true, name: true } },
  voidedBy: { select: { id: true, name: true } },
} as const satisfies Prisma.PaymentInclude;

type PaymentRow = Prisma.PaymentGetPayload<{ include: typeof PAYMENT_INCLUDE }>;

const MONEY_SELECT = {
  id: true,
  code: true,
  name: true,
  status: true,
  contractAmount: true,
  client: { select: { id: true, name: true } },
  payments: { select: { amount: true, voidedAt: true } },
  paymentMilestones: {
    select: { id: true, title: true, amount: true, dueDate: true },
  },
} as const satisfies Prisma.SiteSelect;

type MoneySite = Prisma.SiteGetPayload<{ select: typeof MONEY_SELECT }>;

/**
 * Contract money for admins: the payment schedule (milestones) and what was
 * received. Received money is applied to milestones oldest-first by the server;
 * totals are always computed, never stored or taken from the app.
 */
@Injectable()
export class PaymentsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
    private readonly calendar: CalendarService,
    private readonly notifications: NotificationsService,
    private readonly clock: Clock,
  ) {}

  async siteMoney(siteId: string, now = this.clock.now()): Promise<SiteMoney> {
    const site = await this.prisma.site.findUnique({
      where: { id: siteId },
      select: MONEY_SELECT,
    });
    if (!site) throw notFound('site');
    return toSiteMoney(site, await this.calendar.today(now));
  }

  async summary(now = this.clock.now()): Promise<PaymentsSummary> {
    const today = await this.calendar.today(now);
    const sites = await this.prisma.site.findMany({
      select: MONEY_SELECT,
      orderBy: { name: 'asc' },
    });
    const rows = sites.map((site) => {
      const { financials, ...rest } = toSiteMoney(site, today);
      const { milestones, ...totals } = financials;
      return {
        ...rest,
        financials: totals,
        nextDue: milestones.find((m) => m.status !== 'PAID') ?? null,
      };
    });
    // Most urgent first: overdue money, then pending money.
    rows.sort(
      (a, b) =>
        Number(toPaise(b.financials.overdue) - toPaise(a.financials.overdue)) ||
        Number(toPaise(b.financials.pending) - toPaise(a.financials.pending)),
    );
    return {
      totals: totalFinancials(
        sites.map((site) => toSiteMoney(site, today).financials),
      ),
      sites: rows,
    };
  }

  async addMilestone(
    actor: AuthUser,
    siteId: string,
    dto: CreateMilestoneDto,
  ): Promise<SiteMoney> {
    const amount = positive(dto.amount, 'amount');
    await this.prisma.$transaction(async (tx) => {
      const site = await lockSite(tx, siteId);
      checkSchedule(
        site,
        sumPaise(site.paymentMilestones.map((m) => toPaise(m.amount))) + amount,
      );
      const created = await tx.paymentMilestone.create({
        data: {
          siteId,
          title: dto.title,
          amount: dto.amount,
          dueDate: toDbDate(dto.dueDate),
          notes: dto.notes || null,
          createdById: actor.id,
        },
      });
      await this.audit.record(
        {
          actorId: actor.id,
          action: 'milestone.created',
          entityType: 'PaymentMilestone',
          entityId: created.id,
          changes: { ...dto },
        },
        tx,
      );
    });
    return this.siteMoney(siteId);
  }

  async updateMilestone(
    actor: AuthUser,
    id: string,
    dto: UpdateMilestoneDto,
  ): Promise<SiteMoney> {
    const milestone = await this.prisma.paymentMilestone.findUnique({
      where: { id },
    });
    if (!milestone) throw notFound('milestone');
    const amount =
      dto.amount === undefined
        ? toPaise(milestone.amount)
        : positive(dto.amount, 'amount');
    await this.prisma.$transaction(async (tx) => {
      const site = await lockSite(tx, milestone.siteId);
      const others = site.paymentMilestones
        .filter((m) => m.id !== id)
        .map((m) => toPaise(m.amount));
      checkSchedule(site, sumPaise(others) + amount);
      await tx.paymentMilestone.update({
        where: { id },
        data: {
          title: dto.title,
          amount: dto.amount,
          dueDate: dto.dueDate ? toDbDate(dto.dueDate) : undefined,
          notes: dto.notes === undefined ? undefined : dto.notes || null,
        },
      });
      await this.audit.record(
        {
          actorId: actor.id,
          action: 'milestone.updated',
          entityType: 'PaymentMilestone',
          entityId: id,
          changes: {
            before: {
              title: milestone.title,
              amount: milestone.amount.toFixed(2),
              dueDate: fromDbDate(milestone.dueDate),
            },
            after: { ...dto },
          },
        },
        tx,
      );
    });
    return this.siteMoney(milestone.siteId);
  }

  async deleteMilestone(actor: AuthUser, id: string): Promise<SiteMoney> {
    const milestone = await this.prisma.paymentMilestone.findUnique({
      where: { id },
    });
    if (!milestone) throw notFound('milestone');
    await this.prisma.$transaction(async (tx) => {
      await tx.paymentMilestone.delete({ where: { id } });
      await this.audit.record(
        {
          actorId: actor.id,
          action: 'milestone.deleted',
          entityType: 'PaymentMilestone',
          entityId: id,
          changes: {
            title: milestone.title,
            amount: milestone.amount.toFixed(2),
            dueDate: fromDbDate(milestone.dueDate),
          },
        },
        tx,
      );
    });
    return this.siteMoney(milestone.siteId);
  }

  async recordPayment(
    actor: AuthUser,
    siteId: string,
    dto: CreatePaymentDto,
    now = this.clock.now(),
  ): Promise<PaymentView> {
    const amount = positive(dto.amount, 'amount');
    if (dto.paidOn > (await this.calendar.today(now))) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'A payment cannot be dated in the future.',
        'paidOn',
      );
    }
    const row = await this.prisma.$transaction(async (tx) => {
      // Locked, so two payments entered at once can't together exceed the contract.
      const site = await lockSite(tx, siteId);
      const received = sumPaise(
        site.payments.filter((p) => !p.voidedAt).map((p) => toPaise(p.amount)),
      );
      const contract = toPaise(site.contractAmount);
      if (received + amount > contract) {
        throw badRequest(
          ErrorCode.PAYMENT_EXCEEDS_CONTRACT,
          `This is more than the ${formatInr(contract - received)} left on the contract.`,
          'amount',
        );
      }
      const created = await tx.payment.create({
        data: {
          siteId,
          amount: dto.amount,
          paidOn: toDbDate(dto.paidOn),
          method: dto.method,
          reference: dto.reference || null,
          remarks: dto.remarks || null,
          recordedById: actor.id,
        },
        include: PAYMENT_INCLUDE,
      });
      await this.audit.record(
        {
          actorId: actor.id,
          action: 'payment.recorded',
          entityType: 'Payment',
          entityId: created.id,
          changes: { ...dto },
        },
        tx,
      );
      return created;
    });
    return toPaymentView(row);
  }

  /** Payments are never deleted: a mistaken one is voided, with the reason kept. */
  async voidPayment(
    actor: AuthUser,
    id: string,
    reason: string,
    now = this.clock.now(),
  ): Promise<PaymentView> {
    const payment = await this.prisma.payment.findUnique({
      where: { id },
      select: { id: true, voidedAt: true },
    });
    if (!payment) throw notFound('payment');
    const row = await this.prisma.$transaction(async (tx) => {
      const { count } = await tx.payment.updateMany({
        where: { id, voidedAt: null },
        data: { voidedAt: now, voidedById: actor.id, voidReason: reason },
      });
      if (count === 0) {
        throw new AppException(
          ErrorCode.PAYMENT_ALREADY_VOIDED,
          'This payment was already voided.',
          HttpStatus.CONFLICT,
        );
      }
      await this.audit.record(
        {
          actorId: actor.id,
          action: 'payment.voided',
          entityType: 'Payment',
          entityId: id,
          changes: { reason },
        },
        tx,
      );
      return tx.payment.findUniqueOrThrow({
        where: { id },
        include: PAYMENT_INCLUDE,
      });
    });
    return toPaymentView(row);
  }

  async list(query: PaymentQueryDto): Promise<Paginated<PaymentView>> {
    const term = query.search;
    const where: Prisma.PaymentWhereInput = {
      AND: [
        query.includeVoided ? {} : { voidedAt: null },
        query.siteId ? { siteId: query.siteId } : {},
        query.clientId ? { site: { clientId: query.clientId } } : {},
        query.from ? { paidOn: { gte: toDbDate(query.from) } } : {},
        query.to ? { paidOn: { lte: toDbDate(query.to) } } : {},
        query.method ? { method: query.method } : {},
        term
          ? {
              OR: [
                { reference: { contains: term, mode: 'insensitive' } },
                { remarks: { contains: term, mode: 'insensitive' } },
                { site: { name: { contains: term, mode: 'insensitive' } } },
              ],
            }
          : {},
      ],
    };
    const [rows, total] = await Promise.all([
      this.prisma.payment.findMany({
        where,
        include: PAYMENT_INCLUDE,
        orderBy: [{ paidOn: 'desc' }, { createdAt: 'desc' }],
        skip: query.skip,
        take: query.limit,
      }),
      this.prisma.payment.count({ where }),
    ]);
    return new Paginated(
      rows.map(toPaymentView),
      query.page,
      query.limit,
      total,
    );
  }

  /** Tells admins about each milestone the day it becomes overdue (once per due date). */
  async notifyOverdue(now = this.clock.now()): Promise<number> {
    const today = await this.calendar.today(now);
    const sites = await this.prisma.site.findMany({ select: MONEY_SELECT });
    const admins = await this.notifications.adminIds();
    const inputs = sites.flatMap((site) =>
      toSiteMoney(site, today)
        .financials.milestones.filter((m) => m.status === 'OVERDUE')
        .map((m) => ({
          recipientIds: admins,
          type: 'PAYMENT' as const,
          ...milestoneOverdue({
            milestoneTitle: m.title,
            siteName: site.name,
            outstanding: toPaise(m.outstanding),
            dueDate: m.dueDate,
          }),
          referenceType: 'PAYMENT_MILESTONE' as const,
          referenceId: m.id,
          data: { siteId: site.id },
          dedupeKey: `milestone-overdue:${m.id}:${m.dueDate}`,
        })),
    );
    return this.notifications.notify(inputs);
  }
}

async function lockSite(
  tx: Prisma.TransactionClient,
  siteId: string,
): Promise<MoneySite> {
  await tx.$queryRaw`SELECT id FROM sites WHERE id = ${siteId}::uuid FOR UPDATE`;
  const site = await tx.site.findUnique({
    where: { id: siteId },
    select: MONEY_SELECT,
  });
  if (!site) throw notFound('site');
  return site;
}

function checkSchedule(site: MoneySite, schedule: Paise): void {
  const contract = toPaise(site.contractAmount);
  if (schedule > contract) {
    throw badRequest(
      ErrorCode.SCHEDULE_EXCEEDS_CONTRACT,
      `The payment schedule would come to ${formatInr(schedule)}, more than the ${formatInr(contract)} contract.`,
      'amount',
    );
  }
}

function positive(amount: string, field: string): Paise {
  const paise = toPaise(amount);
  if (paise <= 0n)
    throw badRequest(
      ErrorCode.VALIDATION_FAILED,
      'Enter an amount above zero.',
      field,
    );
  return paise;
}

function toSiteMoney(site: MoneySite, today: string): SiteMoney {
  return {
    site: {
      id: site.id,
      code: site.code,
      name: site.name,
      status: site.status,
    },
    client: site.client,
    financials: siteFinancials(
      {
        contractAmount: site.contractAmount,
        payments: site.payments,
        milestones: site.paymentMilestones,
      },
      today,
    ),
  };
}

function toPaymentView(row: PaymentRow): PaymentView {
  return {
    id: row.id,
    amount: row.amount.toFixed(2),
    paidOn: fromDbDate(row.paidOn),
    method: row.method,
    reference: row.reference,
    remarks: row.remarks,
    site: { id: row.site.id, code: row.site.code, name: row.site.name },
    client: row.site.client,
    recordedBy: row.recordedBy,
    createdAt: row.createdAt.toISOString(),
    voidedAt: row.voidedAt?.toISOString() ?? null,
    voidedBy: row.voidedBy,
    voidReason: row.voidReason,
  };
}
