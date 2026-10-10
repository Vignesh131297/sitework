import { Injectable } from '@nestjs/common';
import type { AuthUser } from '../auth/auth-user.js';
import { AuditService } from '../common/audit/audit.service.js';
import { ErrorCode } from '../common/errors/error-codes.js';
import {
  badRequest,
  conflict,
  notFound,
} from '../common/errors/http-errors.js';
import { PrismaService } from '../prisma/prisma.service.js';
import type { CreateGodownDto, UpdateGodownDto } from './stock.dto.js';
import { GODOWN_SELECT, ledgerSums } from './stock-queries.js';
import { toGodownView, type GodownView } from './stock-views.js';

/** Godowns (admins): where the company keeps stock. Never deleted. */
@Injectable()
export class GodownsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
  ) {}

  async create(actor: AuthUser, dto: CreateGodownDto): Promise<GodownView> {
    await this.ensureNameFree(dto.name);
    const godown = await this.prisma.$transaction(async (tx) => {
      const created = await tx.godown.create({
        data: { name: dto.name, address: dto.address || null },
        select: GODOWN_SELECT,
      });
      await this.audit.record(
        {
          actorId: actor.id,
          action: 'godown.created',
          entityType: 'Godown',
          entityId: created.id,
          changes: { ...dto },
        },
        tx,
      );
      return created;
    });
    return toGodownView(godown);
  }

  /** A godown is closed (deactivated) only once its stock has moved out. */
  async update(
    actor: AuthUser,
    id: string,
    dto: UpdateGodownDto,
  ): Promise<GodownView> {
    const godown = await this.prisma.godown.findUnique({ where: { id } });
    if (!godown) throw notFound('godown');
    if (dto.name && dto.name.toLowerCase() !== godown.name.toLowerCase())
      await this.ensureNameFree(dto.name, id);
    if (dto.isActive === false && godown.isActive) {
      const book = await ledgerSums(this.prisma, { godowns: [id], sites: [] });
      const holding = [...(book.get(`GODOWN:${id}`)?.values() ?? [])].some(
        (t) => t.onHand !== 0n,
      );
      const onTheWay = await this.prisma.stockEntry.count({
        where: {
          status: 'IN_TRANSIT',
          OR: [{ fromGodownId: id }, { toGodownId: id }],
        },
      });
      if (holding || onTheWay) {
        throw badRequest(
          ErrorCode.VALIDATION_FAILED,
          'Move the stock out of this godown before closing it.',
          'isActive',
        );
      }
    }
    const updated = await this.prisma.$transaction(async (tx) => {
      const saved = await tx.godown.update({
        where: { id },
        data: {
          name: dto.name,
          address: dto.address === undefined ? undefined : dto.address || null,
          isActive: dto.isActive,
        },
        select: GODOWN_SELECT,
      });
      await this.audit.record(
        {
          actorId: actor.id,
          action: 'godown.updated',
          entityType: 'Godown',
          entityId: id,
          changes: {
            before: {
              name: godown.name,
              address: godown.address,
              isActive: godown.isActive,
            },
            after: { ...dto },
          },
        },
        tx,
      );
      return saved;
    });
    return toGodownView(updated);
  }

  private async ensureNameFree(name: string, exceptId?: string): Promise<void> {
    const taken = await this.prisma.godown.findFirst({
      where: {
        name: { equals: name, mode: 'insensitive' },
        ...(exceptId && { id: { not: exceptId } }),
      },
      select: { id: true },
    });
    if (taken) {
      const message = 'A godown with this name already exists.';
      throw conflict(ErrorCode.GODOWN_NAME_IN_USE, message, [
        { field: 'name', message },
      ]);
    }
  }
}
