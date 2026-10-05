import { Injectable } from '@nestjs/common';
import type { AuthUser } from '../auth/auth-user.js';
import { siteScope } from '../common/access/access-scope.js';
import { AuditService } from '../common/audit/audit.service.js';
import { ErrorCode } from '../common/errors/error-codes.js';
import {
  badRequest,
  conflict,
  notFound,
} from '../common/errors/http-errors.js';
import { optionalText, requirePhone } from '../common/identity/contact.js';
import { sumPaise, toPaise } from '../common/money/money.js';
import { Paginated } from '../common/pagination/paginated.js';
import { contains } from '../common/pagination/page-query.dto.js';
import { fromDbDate, toDbDate } from '../common/time/business-time.js';
import type { Prisma } from '../generated/prisma/client.js';
import type { Designation, SiteStatus } from '../generated/prisma/enums.js';
import {
  siteFinancials,
  type SiteFinancials,
} from '../payments/site-financials.js';
import { PrismaService } from '../prisma/prisma.service.js';
import { CalendarService } from '../settings/calendar.service.js';
import { SettingsService } from '../settings/settings.service.js';
import { AssignmentsService } from './assignments.service.js';
import type {
  CreateSiteDto,
  SiteQueryDto,
  UpdateSiteDto,
} from './sites.dto.js';

export interface SiteSummary {
  id: string;
  code: string;
  name: string;
  status: SiteStatus;
  progressPercent: number;
  address: string;
  client: { id: string; name: string };
  engineers: { id: string; name: string }[];
  staffCount: number;
  startDate: string;
  expectedCompletionDate: string | null;
  /** Hidden from staff, who never see money. */
  contractAmount: string | null;
}

export interface SiteDetail extends SiteSummary {
  contactName: string | null;
  contactPhone: string | null;
  latitude: number | null;
  longitude: number | null;
  geofenceRadiusM: number | null;
  /** Staff get the client's name only. */
  client: {
    id: string;
    name: string;
    phone: string | null;
    email: string | null;
  };
  staff: {
    id: string;
    name: string;
    phone: string;
    designation: Designation | null;
    engineer: { id: string; name: string };
  }[];
  /** Admin: full figures with milestones. Engineer: totals only. Staff: none. */
  financials: SiteFinancials | Omit<SiteFinancials, 'milestones'> | null;
  openIssues: number;
}

const SUMMARY_INCLUDE = {
  client: { select: { id: true, name: true, phone: true, email: true } },
  engineerAssignments: {
    select: { engineer: { select: { id: true, name: true } } },
    orderBy: { assignedAt: 'asc' },
  },
  _count: { select: { staffAssignments: true } },
} as const satisfies Prisma.SiteInclude;

type SiteWithSummary = Prisma.SiteGetPayload<{
  include: typeof SUMMARY_INCLUDE;
}>;

@Injectable()
export class SitesService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly assignments: AssignmentsService,
    private readonly audit: AuditService,
    private readonly calendar: CalendarService,
    private readonly settings: SettingsService,
  ) {}

  async list(
    user: AuthUser,
    query: SiteQueryDto,
  ): Promise<Paginated<SiteSummary>> {
    const term = query.search;
    const where: Prisma.SiteWhereInput = {
      AND: [
        siteScope(user),
        query.status ? { status: query.status } : {},
        query.clientId ? { clientId: query.clientId } : {},
        query.engineerId
          ? { engineerAssignments: { some: { engineerId: query.engineerId } } }
          : {},
        term
          ? {
              OR: [
                { name: contains(term) },
                { code: contains(term) },
                { address: contains(term) },
                { client: { name: contains(term) } },
              ],
            }
          : {},
      ],
    };
    const [rows, total] = await Promise.all([
      this.prisma.site.findMany({
        where,
        include: SUMMARY_INCLUDE,
        orderBy: [{ status: 'asc' }, { name: 'asc' }],
        skip: query.skip,
        take: query.limit,
      }),
      this.prisma.site.count({ where }),
    ]);
    return new Paginated(
      rows.map((row) => toSummary(row, user)),
      query.page,
      query.limit,
      total,
    );
  }

  async get(user: AuthUser, id: string): Promise<SiteDetail> {
    const site = await this.prisma.site.findFirst({
      where: { id, ...siteScope(user) },
      include: {
        ...SUMMARY_INCLUDE,
        staffAssignments: {
          select: {
            staff: {
              select: { id: true, name: true, phone: true, designation: true },
            },
            engineer: { select: { id: true, name: true } },
          },
          orderBy: { staff: { name: 'asc' } },
        },
        payments: { select: { amount: true, voidedAt: true } },
        paymentMilestones: {
          select: { id: true, title: true, amount: true, dueDate: true },
        },
        _count: {
          select: {
            staffAssignments: true,
            issues: { where: { status: { not: 'RESOLVED' } } },
          },
        },
      },
    });
    if (!site) throw notFound('site');

    let financials: SiteDetail['financials'] = null;
    if (user.role !== 'STAFF') {
      const full = siteFinancials(
        {
          contractAmount: site.contractAmount,
          payments: site.payments,
          milestones: site.paymentMilestones,
        },
        await this.calendar.today(),
      );
      financials = user.role === 'ADMIN' ? full : withoutMilestones(full);
    }
    return {
      ...toSummary(site, user),
      contactName: site.contactName,
      contactPhone: site.contactPhone,
      latitude: site.latitude,
      longitude: site.longitude,
      geofenceRadiusM: site.geofenceRadiusM,
      client:
        user.role === 'STAFF'
          ? { ...site.client, phone: null, email: null }
          : site.client,
      staff:
        user.role === 'STAFF'
          ? []
          : site.staffAssignments.map((a) => ({
              ...a.staff,
              engineer: a.engineer,
            })),
      financials,
      openIssues: site._count.issues,
    };
  }

  async create(actor: AuthUser, dto: CreateSiteDto): Promise<SiteDetail> {
    const client = await this.prisma.client.findUnique({
      where: { id: dto.clientId },
    });
    if (!client)
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Choose an existing client.',
        'clientId',
      );
    this.checkDates(dto.startDate, dto.expectedCompletionDate);
    const code = dto.code?.trim().toUpperCase() ?? (await this.nextSiteCode());
    await this.ensureCodeFree(code);
    const engineerIds = [...new Set(dto.engineerIds ?? [])];
    if (engineerIds.length)
      await this.assignments.requireActiveEngineers(engineerIds);
    const radius =
      dto.geofenceRadiusM ??
      (await this.settings.get('location')).defaultGeofenceRadiusM;

    const site = await this.prisma.$transaction(async (tx) => {
      const created = await tx.site.create({
        data: {
          code,
          name: dto.name.trim(),
          clientId: dto.clientId,
          contactName: optionalText(dto.contactName) ?? null,
          contactPhone: dto.contactPhone
            ? requirePhone(dto.contactPhone, 'contactPhone')
            : null,
          address: dto.address.trim(),
          latitude: dto.latitude ?? null,
          longitude: dto.longitude ?? null,
          geofenceRadiusM: radius,
          startDate: toDbDate(dto.startDate),
          expectedCompletionDate: dto.expectedCompletionDate
            ? toDbDate(dto.expectedCompletionDate)
            : null,
          contractAmount: dto.contractAmount,
          status: dto.status ?? 'NOT_STARTED',
          progressPercent: dto.progressPercent ?? 0,
          createdById: actor.id,
          engineerAssignments: {
            create: engineerIds.map((engineerId) => ({
              engineerId,
              assignedById: actor.id,
            })),
          },
        },
      });
      await this.audit.record(
        {
          actorId: actor.id,
          action: 'site.created',
          entityType: 'Site',
          entityId: created.id,
          changes: { code, contractAmount: dto.contractAmount },
        },
        tx,
      );
      return created;
    });
    return this.get(actor, site.id);
  }

  async update(
    actor: AuthUser,
    id: string,
    dto: UpdateSiteDto,
  ): Promise<SiteDetail> {
    const site = await this.prisma.site.findUnique({
      where: { id },
      include: {
        payments: { where: { voidedAt: null }, select: { amount: true } },
        paymentMilestones: { select: { amount: true } },
      },
    });
    if (!site) throw notFound('site');
    const startDate = dto.startDate ?? fromDbDate(site.startDate);
    const completion =
      dto.expectedCompletionDate === undefined
        ? site.expectedCompletionDate && fromDbDate(site.expectedCompletionDate)
        : dto.expectedCompletionDate;
    this.checkDates(startDate, completion);

    const code = dto.code?.trim().toUpperCase();
    if (code && code !== site.code) await this.ensureCodeFree(code);
    if (
      dto.clientId &&
      !(await this.prisma.client.findUnique({ where: { id: dto.clientId } }))
    ) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Choose an existing client.',
        'clientId',
      );
    }
    if (dto.contractAmount !== undefined) {
      // Money rules are checked here, never trusted from the app (Rule 12).
      const contract = toPaise(dto.contractAmount);
      if (contract < sumPaise(site.payments.map((p) => toPaise(p.amount)))) {
        throw badRequest(
          ErrorCode.CONTRACT_BELOW_RECEIVED,
          'The contract amount cannot be less than what has already been received.',
          'contractAmount',
        );
      }
      if (
        contract <
        sumPaise(site.paymentMilestones.map((m) => toPaise(m.amount)))
      ) {
        throw badRequest(
          ErrorCode.SCHEDULE_EXCEEDS_CONTRACT,
          'The contract amount cannot be less than the payment schedule. Adjust the milestones first.',
          'contractAmount',
        );
      }
    }

    await this.prisma.$transaction(async (tx) => {
      await tx.site.update({
        where: { id },
        data: {
          code,
          name: dto.name?.trim(),
          clientId: dto.clientId,
          contactName: optionalText(dto.contactName),
          contactPhone:
            dto.contactPhone === undefined
              ? undefined
              : dto.contactPhone
                ? requirePhone(dto.contactPhone, 'contactPhone')
                : null,
          address: dto.address?.trim(),
          latitude: dto.latitude,
          longitude: dto.longitude,
          geofenceRadiusM: dto.geofenceRadiusM,
          startDate: dto.startDate ? toDbDate(dto.startDate) : undefined,
          expectedCompletionDate:
            dto.expectedCompletionDate === undefined
              ? undefined
              : dto.expectedCompletionDate
                ? toDbDate(dto.expectedCompletionDate)
                : null,
          contractAmount: dto.contractAmount,
          status: dto.status,
          progressPercent: dto.progressPercent,
        },
      });
      await this.audit.record(
        {
          actorId: actor.id,
          action: 'site.updated',
          entityType: 'Site',
          entityId: id,
          changes: {
            ...JSON.parse(JSON.stringify(dto)),
            ...(dto.contractAmount !== undefined && {
              previousContractAmount: site.contractAmount.toFixed(2),
            }),
          },
        },
        tx,
      );
    });
    return this.get(actor, id);
  }

  async setEngineers(
    actor: AuthUser,
    id: string,
    engineerIds: string[],
  ): Promise<SiteDetail> {
    if (
      !(await this.prisma.site.findUnique({
        where: { id },
        select: { id: true },
      }))
    )
      throw notFound('site');
    await this.assignments.setSiteEngineers(actor.id, id, engineerIds);
    return this.get(actor, id);
  }

  private checkDates(
    start: string,
    completion: string | null | undefined,
  ): void {
    if (completion && completion < start) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'The expected completion date must be on or after the start date.',
        'expectedCompletionDate',
      );
    }
  }

  private async ensureCodeFree(code: string): Promise<void> {
    if (
      await this.prisma.site.findUnique({
        where: { code },
        select: { id: true },
      })
    ) {
      throw conflict(
        ErrorCode.SITE_CODE_IN_USE,
        `Site ID ${code} is already used.`,
        [{ field: 'code', message: 'already used' }],
      );
    }
  }

  private async nextSiteCode(): Promise<string> {
    const codes = await this.prisma.site.findMany({
      where: { code: { startsWith: 'SITE-' } },
      select: { code: true },
    });
    const highest = codes.reduce((max, { code }) => {
      const n = Number(code.slice(5));
      return Number.isInteger(n) && n > max ? n : max;
    }, 0);
    return `SITE-${String(highest + 1).padStart(3, '0')}`;
  }
}

function toSummary(site: SiteWithSummary, viewer: AuthUser): SiteSummary {
  return {
    id: site.id,
    code: site.code,
    name: site.name,
    status: site.status,
    progressPercent: site.progressPercent,
    address: site.address,
    client: { id: site.client.id, name: site.client.name },
    engineers: site.engineerAssignments.map((a) => a.engineer),
    staffCount: site._count.staffAssignments,
    startDate: fromDbDate(site.startDate),
    expectedCompletionDate: site.expectedCompletionDate
      ? fromDbDate(site.expectedCompletionDate)
      : null,
    contractAmount:
      viewer.role === 'STAFF' ? null : site.contractAmount.toFixed(2),
  };
}

function withoutMilestones(
  financials: SiteFinancials,
): Omit<SiteFinancials, 'milestones'> {
  const { milestones: _milestones, ...totals } = financials;
  return totals;
}
