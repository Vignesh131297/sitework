import { Injectable } from '@nestjs/common';
import type { AuthUser } from '../auth/auth-user.js';
import { AuditService } from '../common/audit/audit.service.js';
import { notFound } from '../common/errors/http-errors.js';
import {
  optionalEmail,
  optionalText,
  requirePhone,
} from '../common/identity/contact.js';
import { Paginated } from '../common/pagination/paginated.js';
import {
  contains,
  type PageQueryDto,
} from '../common/pagination/page-query.dto.js';
import type { SiteStatus } from '../generated/prisma/enums.js';
import { PrismaService } from '../prisma/prisma.service.js';
import type { CreateClientDto, UpdateClientDto } from './clients.controller.js';

export interface ClientSummary {
  id: string;
  name: string;
  company: string | null;
  phone: string;
  email: string | null;
  address: string | null;
  notes: string | null;
  siteCount: number;
}

export interface ClientDetail extends ClientSummary {
  sites: {
    id: string;
    code: string;
    name: string;
    status: SiteStatus;
    contractAmount: string;
  }[];
}

const SUMMARY_SELECT = {
  id: true,
  name: true,
  company: true,
  phone: true,
  email: true,
  address: true,
  notes: true,
  _count: { select: { sites: true } },
} as const;

@Injectable()
export class ClientsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
  ) {}

  async list(query: PageQueryDto): Promise<Paginated<ClientSummary>> {
    const term = query.search;
    const where = term
      ? {
          OR: [
            { name: contains(term) },
            { company: contains(term) },
            { phone: contains(term) },
          ],
        }
      : {};
    const [rows, total] = await Promise.all([
      this.prisma.client.findMany({
        where,
        select: SUMMARY_SELECT,
        orderBy: { name: 'asc' },
        skip: query.skip,
        take: query.limit,
      }),
      this.prisma.client.count({ where }),
    ]);
    return new Paginated(rows.map(toSummary), query.page, query.limit, total);
  }

  async get(id: string): Promise<ClientDetail> {
    const client = await this.prisma.client.findUnique({
      where: { id },
      select: {
        ...SUMMARY_SELECT,
        sites: {
          select: {
            id: true,
            code: true,
            name: true,
            status: true,
            contractAmount: true,
          },
          orderBy: { name: 'asc' },
        },
      },
    });
    if (!client) throw notFound('client');
    return {
      ...toSummary(client),
      sites: client.sites.map((site) => ({
        ...site,
        contractAmount: site.contractAmount.toFixed(2),
      })),
    };
  }

  async create(actor: AuthUser, dto: CreateClientDto): Promise<ClientDetail> {
    const client = await this.prisma.client.create({
      data: {
        name: dto.name.trim(),
        company: optionalText(dto.company) ?? null,
        phone: requirePhone(dto.phone),
        email: optionalEmail(dto.email) ?? null,
        address: optionalText(dto.address) ?? null,
        notes: optionalText(dto.notes) ?? null,
      },
    });
    await this.audit.record({
      actorId: actor.id,
      action: 'client.created',
      entityType: 'Client',
      entityId: client.id,
    });
    return this.get(client.id);
  }

  async update(
    actor: AuthUser,
    id: string,
    dto: UpdateClientDto,
  ): Promise<ClientDetail> {
    const { count } = await this.prisma.client.updateMany({
      where: { id },
      data: {
        name: dto.name?.trim(),
        company: optionalText(dto.company),
        phone: dto.phone === undefined ? undefined : requirePhone(dto.phone),
        email: optionalEmail(dto.email),
        address: optionalText(dto.address),
        notes: optionalText(dto.notes),
      },
    });
    if (count === 0) throw notFound('client');
    await this.audit.record({
      actorId: actor.id,
      action: 'client.updated',
      entityType: 'Client',
      entityId: id,
      changes: JSON.parse(JSON.stringify(dto)),
    });
    return this.get(id);
  }
}

function toSummary(row: {
  id: string;
  name: string;
  company: string | null;
  phone: string;
  email: string | null;
  address: string | null;
  notes: string | null;
  _count: { sites: number };
}): ClientSummary {
  const { _count, ...client } = row;
  return { ...client, siteCount: _count.sites };
}
