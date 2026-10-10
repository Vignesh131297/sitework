import { Injectable } from '@nestjs/common';
import type { AuthUser } from '../auth/auth-user.js';
import { AuditService } from '../common/audit/audit.service.js';
import { ErrorCode } from '../common/errors/error-codes.js';
import {
  badRequest,
  conflict,
  notFound,
} from '../common/errors/http-errors.js';
import { fromPaise } from '../common/money/money.js';
import { fromMilli, toMilli } from '../common/quantity/quantity.js';
import { PrismaService } from '../prisma/prisma.service.js';
import type { CreateMaterialDto, UpdateMaterialDto } from './stock.dto.js';
import { holderIds, onHandAt, totalsFor } from './stock-ledger.js';
import { ledgerSums, purchaseRates } from './stock-queries.js';
import { toMaterialView, type MaterialDetail } from './stock-views.js';

/** The materials list (admins): names, units, minimum levels. Never deleted. */
@Injectable()
export class MaterialsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
  ) {}

  async create(
    actor: AuthUser,
    dto: CreateMaterialDto,
  ): Promise<MaterialDetail> {
    await this.ensureNameFree(dto.name);
    const created = await this.prisma.$transaction(async (tx) => {
      const material = await tx.material.create({
        data: {
          name: dto.name,
          unit: dto.unit,
          category: dto.category || null,
          minStock: dto.minStock ?? null,
        },
      });
      await this.audit.record(
        {
          actorId: actor.id,
          action: 'material.created',
          entityType: 'Material',
          entityId: material.id,
          changes: { ...dto },
        },
        tx,
      );
      return material;
    });
    return this.detail(created.id);
  }

  async update(
    actor: AuthUser,
    id: string,
    dto: UpdateMaterialDto,
  ): Promise<MaterialDetail> {
    const material = await this.prisma.material.findUnique({ where: { id } });
    if (!material) throw notFound('material');
    if (dto.name && dto.name.toLowerCase() !== material.name.toLowerCase())
      await this.ensureNameFree(dto.name, id);
    if (
      dto.unit &&
      dto.unit !== material.unit &&
      (await this.prisma.stockMovement.count({ where: { materialId: id } }))
    ) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        "The unit can't change once stock has been recorded. Add a new material instead.",
        'unit',
      );
    }
    await this.prisma.$transaction(async (tx) => {
      await tx.material.update({
        where: { id },
        data: {
          name: dto.name,
          unit: dto.unit,
          category:
            dto.category === undefined ? undefined : dto.category || null,
          minStock: dto.minStock,
          isActive: dto.isActive,
        },
      });
      await this.audit.record(
        {
          actorId: actor.id,
          action: 'material.updated',
          entityType: 'Material',
          entityId: id,
          changes: {
            before: {
              name: material.name,
              unit: material.unit,
              minStock: material.minStock?.toString() ?? null,
              isActive: material.isActive,
            },
            after: { ...dto },
          },
        },
        tx,
      );
    });
    return this.detail(id);
  }

  /** One material: its average price and how much each godown and site holds. */
  async detail(id: string): Promise<MaterialDetail> {
    const material = await this.prisma.material.findUnique({ where: { id } });
    if (!material) throw notFound('material');
    const [book, rates, transit] = await Promise.all([
      ledgerSums(
        this.prisma,
        { godowns: 'all', sites: 'all' },
        { materialIds: [id] },
      ),
      purchaseRates(this.prisma, { materialIds: [id] }),
      this.prisma.stockMovement.aggregate({
        where: { materialId: id, status: 'IN_TRANSIT' },
        _sum: { quantity: true },
      }),
    ]);
    const [godowns, sites] = await Promise.all([
      this.prisma.godown.findMany({
        where: { id: { in: holderIds(book, 'GODOWN') } },
        select: { id: true, name: true },
        orderBy: { name: 'asc' },
      }),
      this.prisma.site.findMany({
        where: { id: { in: holderIds(book, 'SITE') } },
        select: { id: true, code: true, name: true, status: true },
        orderBy: { name: 'asc' },
      }),
    ]);
    const held = <T extends { id: string }>(
      rows: T[],
      place: 'GODOWN' | 'SITE',
    ) =>
      rows
        .map((row) => ({
          row,
          onHand: totalsFor(book, { place, id: row.id }, id).onHand,
        }))
        .filter(({ onHand }) => onHand !== 0n);
    const rate = rates.get(id);
    return {
      material: toMaterialView(material),
      averageRate: rate === undefined ? null : fromPaise(rate),
      godowns: held(godowns, 'GODOWN').map(({ row, onHand }) => ({
        godown: row,
        onHand: fromMilli(onHand),
      })),
      sites: held(sites, 'SITE').map(({ row, onHand }) => ({
        site: row,
        onHand: fromMilli(onHand),
      })),
      inGodowns: fromMilli(onHandAt(book, 'GODOWN', id)),
      onSites: fromMilli(onHandAt(book, 'SITE', id)),
      inTransit: fromMilli(toMilli(transit._sum.quantity ?? 0)),
    };
  }

  private async ensureNameFree(name: string, exceptId?: string): Promise<void> {
    const taken = await this.prisma.material.findFirst({
      where: {
        name: { equals: name, mode: 'insensitive' },
        ...(exceptId && { id: { not: exceptId } }),
      },
      select: { id: true },
    });
    if (taken) {
      const message = 'A material with this name already exists.';
      throw conflict(ErrorCode.MATERIAL_NAME_IN_USE, message, [
        { field: 'name', message },
      ]);
    }
  }
}
