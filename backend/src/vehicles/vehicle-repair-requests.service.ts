import { Injectable } from '@nestjs/common';
import { AuditService } from '../common/audit/audit.service.js';
import { ErrorCode } from '../common/errors/error-codes.js';
import { badRequest, notFound } from '../common/errors/http-errors.js';
import { fromPaise, toPaise } from '../common/money/money.js';
import { contains } from '../common/pagination/page-query.dto.js';
import { Paginated } from '../common/pagination/paginated.js';
import { Clock } from '../common/time/clock.js';
import type { Prisma } from '../generated/prisma/client.js';
import type { ApprovalStatus } from '../generated/prisma/enums.js';
import {
  repairMoneyDecided,
  repairMoneyRequested,
} from '../notifications/notification-messages.js';
import { NotificationsService } from '../notifications/notifications.service.js';
import { PrismaService } from '../prisma/prisma.service.js';
import {
  alreadyDecided,
  forbidden,
  formTaken,
  type Caller,
  type Person,
} from '../requests/request-common.js';
import type { ApproveDto } from '../requests/requests.dto.js';
import { SettingsService } from '../settings/settings.service.js';
import {
  PERSON_SELECT,
  repairCode,
  vehicleCode,
  vehicleLabel,
  type VehiclePerson,
  type VehicleRef,
} from './vehicle-common.js';
import type {
  CreateRepairRequestDto,
  RepairRequestQueryDto,
} from './vehicles.dto.js';

export interface RepairRequestView {
  id: string;
  /** "VR-0012" */
  code: string;
  vehicle: VehicleRef;
  user: VehiclePerson;
  /** Rupees as a decimal string ("800.00"). */
  amount: string;
  /** What needs repair. */
  note: string;
  status: ApprovalStatus;
  reviewedBy: Person | null;
  reviewedAt: string | null;
  reviewNote: string | null;
  createdAt: string;
  /** What the caller may do with it now. */
  canApprove: boolean;
  canCancel: boolean;
}

const INCLUDE = {
  user: { select: PERSON_SELECT },
  vehicle: {
    select: {
      id: true,
      number: true,
      type: true,
      registrationNo: true,
      makeModel: true,
    },
  },
  reviewedBy: { select: { id: true, name: true } },
} as const satisfies Prisma.VehicleRepairRequestInclude;

type RequestRow = Prisma.VehicleRepairRequestGetPayload<{
  include: typeof INCLUDE;
}>;

const NONE: Prisma.VehicleRepairRequestWhereInput = { id: { in: [] } };

/** Admins: all. Everyone else: their own. */
function requestScope(user: Caller): Prisma.VehicleRepairRequestWhereInput {
  switch (user.role) {
    case 'ADMIN':
      return {};
    case 'ENGINEER':
    case 'STAFF':
      return { userId: user.id };
    default:
      return NONE;
  }
}

function reviewScope(user: Caller): Prisma.VehicleRepairRequestWhereInput {
  return user.role === 'ADMIN' ? { status: 'PENDING' } : NONE;
}

/**
 * Money for a repair, asked for by the staff member or engineer who holds a
 * company vehicle. Only an admin approves or rejects it; the person who asked
 * may withdraw it while it waits.
 */
@Injectable()
export class VehicleRepairRequestsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly settings: SettingsService,
    private readonly notifications: NotificationsService,
    private readonly audit: AuditService,
    private readonly clock: Clock,
  ) {}

  async create(
    user: Caller,
    dto: CreateRepairRequestDto,
    now = this.clock.now(),
  ): Promise<RepairRequestView> {
    const existing = await this.prisma.vehicleRepairRequest.findUnique({
      where: { requestId: dto.requestId },
      select: { id: true, userId: true },
    });
    if (existing) {
      if (existing.userId !== user.id) throw formTaken();
      return this.get(user, existing.id);
    }
    const amount = toPaise(dto.amount);
    if (amount <= 0n) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Enter an amount above zero.',
        'amount',
      );
    }
    const { maxRepairRupees } = await this.settings.get('vehicles');
    if (amount > BigInt(maxRepairRupees) * 100n) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        `Ask for at most ₹${maxRepairRupees.toLocaleString('en-IN')} at a time.`,
        'amount',
      );
    }
    const held = await this.prisma.vehicleAssignment.findFirst({
      where: { userId: user.id, returnedOn: null },
      select: {
        vehicle: {
          select: {
            id: true,
            number: true,
            makeModel: true,
            registrationNo: true,
          },
        },
      },
    });
    if (!held) {
      throw badRequest(
        ErrorCode.NO_VEHICLE,
        'You do not have a company vehicle now.',
      );
    }
    const { vehicle } = held;

    try {
      const created = await this.prisma.$transaction(async (tx) => {
        const row = await tx.vehicleRepairRequest.create({
          data: {
            requestId: dto.requestId,
            vehicleId: vehicle.id,
            userId: user.id,
            amount: fromPaise(amount),
            note: dto.note,
            createdAt: now,
          },
          select: { id: true, number: true },
        });
        await this.audit.record(
          {
            actorId: user.id,
            action: 'vehicle_repair_request.created',
            entityType: 'VehicleRepairRequest',
            entityId: row.id,
            changes: {
              vehicleId: vehicle.id,
              amount: fromPaise(amount),
              note: dto.note,
            },
          },
          tx,
        );
        await this.notifications.notify(
          [
            {
              recipientIds: await this.notifications.adminIds(tx),
              type: 'VEHICLE',
              ...repairMoneyRequested({
                code: repairCode(row.number),
                name: user.name,
                amount,
                label: vehicleLabel(vehicle),
              }),
              referenceType: 'VEHICLE_REPAIR_REQUEST',
              referenceId: row.id,
              data: { repairRequestId: row.id, vehicleId: vehicle.id },
              dedupeKey: `vehicle-repair:${row.id}`,
            },
          ],
          tx,
        );
        return row;
      });
      return this.get(user, created.id);
    } catch (error) {
      if ((error as { code?: string }).code === 'P2002') {
        const again = await this.prisma.vehicleRepairRequest.findUnique({
          where: { requestId: dto.requestId },
          select: { id: true, userId: true },
        });
        if (again?.userId === user.id) return this.get(user, again.id);
      }
      throw error;
    }
  }

  async list(
    user: Caller,
    query: RepairRequestQueryDto,
  ): Promise<Paginated<RepairRequestView>> {
    const term = query.search;
    const where: Prisma.VehicleRepairRequestWhereInput = {
      AND: [
        requestScope(user),
        query.mine ? { userId: user.id } : {},
        query.toReview ? reviewScope(user) : {},
        query.status ? { status: query.status } : {},
        query.vehicleId ? { vehicleId: query.vehicleId } : {},
        query.userId ? { userId: query.userId } : {},
        term
          ? {
              OR: [
                { user: { name: contains(term) } },
                { note: contains(term) },
                { vehicle: { makeModel: contains(term) } },
                { vehicle: { registrationNo: contains(term) } },
              ],
            }
          : {},
      ],
    };
    const [rows, total] = await Promise.all([
      this.prisma.vehicleRepairRequest.findMany({
        where,
        include: INCLUDE,
        // Waiting first, newest first.
        orderBy: [{ status: 'asc' }, { createdAt: 'desc' }],
        skip: query.skip,
        take: query.limit,
      }),
      this.prisma.vehicleRepairRequest.count({ where }),
    ]);
    return new Paginated(
      rows.map((row) => toView(row, user)),
      query.page,
      query.limit,
      total,
    );
  }

  async get(user: Caller, id: string): Promise<RepairRequestView> {
    return toView(await this.find(user, id), user);
  }

  async approve(
    user: Caller,
    id: string,
    dto: ApproveDto,
    now = this.clock.now(),
  ): Promise<RepairRequestView> {
    return this.decide(user, id, 'APPROVED', dto.note || null, now);
  }

  async reject(
    user: Caller,
    id: string,
    reason: string,
    now = this.clock.now(),
  ): Promise<RepairRequestView> {
    return this.decide(user, id, 'REJECTED', reason, now);
  }

  /** Withdrawn by the person who asked, while it waits. */
  async cancel(user: Caller, id: string): Promise<RepairRequestView> {
    const row = await this.find(user, id);
    const code = repairCode(row.number);
    if (row.status === 'CANCELLED' && row.userId === user.id)
      return toView(row, user);
    if (!toView(row, user).canCancel) {
      if (row.userId !== user.id)
        throw forbidden('Only the person who asked can withdraw this request.');
      throw alreadyDecided(code);
    }
    await this.prisma.$transaction(async (tx) => {
      const { count } = await tx.vehicleRepairRequest.updateMany({
        where: { id, status: 'PENDING' },
        data: { status: 'CANCELLED' },
      });
      if (count === 0) throw alreadyDecided(code);
      await this.audit.record(
        {
          actorId: user.id,
          action: 'vehicle_repair_request.cancelled',
          entityType: 'VehicleRepairRequest',
          entityId: id,
        },
        tx,
      );
    });
    return this.get(user, id);
  }

  private async decide(
    user: Caller,
    id: string,
    status: 'APPROVED' | 'REJECTED',
    note: string | null,
    now: Date,
  ): Promise<RepairRequestView> {
    const row = await this.find(user, id);
    const code = repairCode(row.number);
    if (row.status !== 'PENDING') throw alreadyDecided(code);
    if (!toView(row, user).canApprove)
      throw forbidden('Only an admin can decide this request.');
    const approved = status === 'APPROVED';
    await this.prisma.$transaction(async (tx) => {
      const { count } = await tx.vehicleRepairRequest.updateMany({
        where: { id, status: 'PENDING' },
        data: {
          status,
          reviewedById: user.id,
          reviewedAt: now,
          reviewNote: note,
        },
      });
      if (count === 0) throw alreadyDecided(code);
      await this.audit.record(
        {
          actorId: user.id,
          action: approved
            ? 'vehicle_repair_request.approved'
            : 'vehicle_repair_request.rejected',
          entityType: 'VehicleRepairRequest',
          entityId: id,
          changes: note ? { [approved ? 'note' : 'reason']: note } : {},
        },
        tx,
      );
      await this.notifications.notify(
        [
          {
            recipientIds: [row.userId],
            type: 'VEHICLE',
            ...repairMoneyDecided({
              code,
              amount: toPaise(row.amount),
              approved,
              byName: user.name,
              note,
            }),
            referenceType: 'VEHICLE_REPAIR_REQUEST',
            referenceId: id,
            data: { repairRequestId: id, vehicleId: row.vehicleId },
            dedupeKey: `vehicle-repair-decided:${id}`,
          },
        ],
        tx,
      );
    });
    return this.get(user, id);
  }

  private async find(user: Caller, id: string): Promise<RequestRow> {
    const row = await this.prisma.vehicleRepairRequest.findFirst({
      where: { id, ...requestScope(user) },
      include: INCLUDE,
    });
    if (!row) throw notFound('request');
    return row;
  }
}

/** Admins decide; the person who asked may withdraw while it waits. */
function toView(row: RequestRow, user: Caller): RepairRequestView {
  const pending = row.status === 'PENDING';
  return {
    id: row.id,
    code: repairCode(row.number),
    vehicle: {
      id: row.vehicle.id,
      code: vehicleCode(row.vehicle.number),
      type: row.vehicle.type,
      registrationNo: row.vehicle.registrationNo,
      makeModel: row.vehicle.makeModel,
    },
    user: row.user,
    amount: fromPaise(toPaise(row.amount)),
    note: row.note,
    status: row.status,
    reviewedBy: row.reviewedBy,
    reviewedAt: row.reviewedAt?.toISOString() ?? null,
    reviewNote: row.reviewNote,
    createdAt: row.createdAt.toISOString(),
    canApprove: pending && user.role === 'ADMIN',
    canCancel: pending && row.userId === user.id,
  };
}
