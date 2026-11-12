import { Injectable } from '@nestjs/common';
import { AuditService } from '../common/audit/audit.service.js';
import { ErrorCode } from '../common/errors/error-codes.js';
import {
  badRequest,
  conflict,
  notFound,
} from '../common/errors/http-errors.js';
import { contains } from '../common/pagination/page-query.dto.js';
import { Paginated } from '../common/pagination/paginated.js';
import { fromDbDate, toDbDate } from '../common/time/business-time.js';
import { Clock } from '../common/time/clock.js';
import type { Prisma } from '../generated/prisma/client.js';
import type { VehicleType } from '../generated/prisma/enums.js';
import {
  vehicleGiven,
  vehicleTakenBack,
} from '../notifications/notification-messages.js';
import { NotificationsService } from '../notifications/notifications.service.js';
import { PrismaService } from '../prisma/prisma.service.js';
import type { Caller, Person } from '../requests/request-common.js';
import { CalendarService } from '../settings/calendar.service.js';
import {
  normalizeRegistration,
  PERSON_SELECT,
  personHasVehicle,
  vehicleAlreadyGiven,
  vehicleCode,
  vehicleLabel,
  type VehiclePerson,
} from './vehicle-common.js';
import type {
  AssignVehicleDto,
  CreateVehicleDto,
  ReturnVehicleDto,
  UpdateVehicleDto,
  VehicleQueryDto,
} from './vehicles.dto.js';

export interface VehicleHolder {
  user: VehiclePerson;
  givenOn: string;
  note: string | null;
}

export interface VehicleView {
  id: string;
  /** "VH-0003" */
  code: string;
  type: VehicleType;
  registrationNo: string;
  makeModel: string;
  note: string | null;
  isActive: boolean;
  /** Who has it now. */
  holder: VehicleHolder | null;
  createdAt: string;
}

/** One time the vehicle was with someone; the open one has no returnedOn. */
export interface VehicleHandover {
  id: string;
  user: VehiclePerson;
  givenOn: string;
  returnedOn: string | null;
  note: string | null;
  returnNote: string | null;
  givenBy: Person;
  returnedBy: Person | null;
}

export interface VehicleDetail extends VehicleView {
  /** Newest first. */
  history: VehicleHandover[];
}

const OPEN = { returnedOn: null } as const;

const INCLUDE = {
  assignments: {
    where: OPEN,
    select: {
      givenOn: true,
      note: true,
      user: { select: PERSON_SELECT },
    },
  },
} as const satisfies Prisma.VehicleInclude;

type VehicleRow = Prisma.VehicleGetPayload<{ include: typeof INCLUDE }>;

const HISTORY_SELECT = {
  id: true,
  givenOn: true,
  returnedOn: true,
  note: true,
  returnNote: true,
  user: { select: PERSON_SELECT },
  givenBy: { select: { id: true, name: true } },
  returnedBy: { select: { id: true, name: true } },
} as const satisfies Prisma.VehicleAssignmentSelect;

type Db = Prisma.TransactionClient;

/**
 * Company vehicles and who holds them. Admins add vehicles, give them to a
 * staff member or an engineer, and take them back; every hand-over is kept.
 */
@Injectable()
export class VehiclesService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly calendar: CalendarService,
    private readonly notifications: NotificationsService,
    private readonly audit: AuditService,
    private readonly clock: Clock,
  ) {}

  async create(user: Caller, dto: CreateVehicleDto): Promise<VehicleDetail> {
    const registrationNo = registrationOf(dto.registrationNo);
    await this.ensureRegistrationFree(registrationNo);
    try {
      const created = await this.prisma.$transaction(async (tx) => {
        const row = await tx.vehicle.create({
          data: {
            type: dto.type,
            registrationNo,
            makeModel: dto.makeModel,
            note: dto.note || null,
            createdById: user.id,
          },
          select: { id: true },
        });
        await this.audit.record(
          {
            actorId: user.id,
            action: 'vehicle.created',
            entityType: 'Vehicle',
            entityId: row.id,
            changes: {
              type: dto.type,
              registrationNo,
              makeModel: dto.makeModel,
            },
          },
          tx,
        );
        return row;
      });
      return this.get(created.id);
    } catch (error) {
      if (isUniqueViolation(error)) throw registrationInUse(registrationNo);
      throw error;
    }
  }

  async list(query: VehicleQueryDto): Promise<Paginated<VehicleView>> {
    const term = query.search;
    const where: Prisma.VehicleWhereInput = {
      AND: [
        query.status === 'GIVEN'
          ? { isActive: true, assignments: { some: OPEN } }
          : {},
        query.status === 'FREE'
          ? { isActive: true, assignments: { none: OPEN } }
          : {},
        query.status === 'INACTIVE' ? { isActive: false } : {},
        term
          ? {
              OR: [
                { makeModel: contains(term) },
                {
                  registrationNo: contains(normalizeRegistration(term) || term),
                },
                {
                  assignments: {
                    some: { ...OPEN, user: { name: contains(term) } },
                  },
                },
              ],
            }
          : {},
      ],
    };
    const [rows, total] = await Promise.all([
      this.prisma.vehicle.findMany({
        where,
        include: INCLUDE,
        // In use first, then by number.
        orderBy: [{ isActive: 'desc' }, { number: 'asc' }],
        skip: query.skip,
        take: query.limit,
      }),
      this.prisma.vehicle.count({ where }),
    ]);
    return new Paginated(rows.map(toView), query.page, query.limit, total);
  }

  async get(id: string): Promise<VehicleDetail> {
    const row = await this.prisma.vehicle.findUnique({
      where: { id },
      include: {
        assignments: {
          select: HISTORY_SELECT,
          orderBy: [{ givenOn: 'desc' }, { createdAt: 'desc' }],
        },
      },
    });
    if (!row) throw notFound('vehicle');
    const open = row.assignments.find((a) => a.returnedOn === null);
    return {
      ...toView({
        ...row,
        assignments: open
          ? [{ givenOn: open.givenOn, note: open.note, user: open.user }]
          : [],
      }),
      history: row.assignments.map((a) => ({
        id: a.id,
        user: a.user,
        givenOn: fromDbDate(a.givenOn),
        returnedOn: a.returnedOn && fromDbDate(a.returnedOn),
        note: a.note,
        returnNote: a.returnNote,
        givenBy: a.givenBy,
        returnedBy: a.returnedBy,
      })),
    };
  }

  /** The vehicle the caller holds now, if any. */
  async mine(user: Caller): Promise<{ vehicle: VehicleView | null }> {
    const row = await this.prisma.vehicle.findFirst({
      where: { assignments: { some: { ...OPEN, userId: user.id } } },
      include: INCLUDE,
    });
    return { vehicle: row ? toView(row) : null };
  }

  async update(
    user: Caller,
    id: string,
    dto: UpdateVehicleDto,
  ): Promise<VehicleDetail> {
    const existing = await this.prisma.vehicle.findUnique({
      where: { id },
      include: INCLUDE,
    });
    if (!existing) throw notFound('vehicle');
    const registrationNo =
      dto.registrationNo === undefined
        ? undefined
        : registrationOf(dto.registrationNo);
    if (registrationNo && registrationNo !== existing.registrationNo)
      await this.ensureRegistrationFree(registrationNo, id);
    const holder = existing.assignments[0];
    if (dto.isActive === false && existing.isActive && holder) {
      throw vehicleAlreadyGiven(vehicleLabel(existing), holder.user.name);
    }
    const changes = {
      ...(dto.type !== undefined && { type: dto.type }),
      ...(registrationNo !== undefined && { registrationNo }),
      ...(dto.makeModel !== undefined && { makeModel: dto.makeModel }),
      ...(dto.note !== undefined && { note: dto.note || null }),
      ...(dto.isActive !== undefined && { isActive: dto.isActive }),
    };
    try {
      await this.prisma.$transaction(async (tx) => {
        await tx.vehicle.update({ where: { id }, data: changes });
        await this.audit.record(
          {
            actorId: user.id,
            action:
              dto.isActive === undefined || dto.isActive === existing.isActive
                ? 'vehicle.updated'
                : dto.isActive
                  ? 'vehicle.activated'
                  : 'vehicle.deactivated',
            entityType: 'Vehicle',
            entityId: id,
            changes,
          },
          tx,
        );
      });
    } catch (error) {
      if (isUniqueViolation(error) && registrationNo)
        throw registrationInUse(registrationNo);
      throw error;
    }
    return this.get(id);
  }

  /** Gives the vehicle to a staff member or an engineer. */
  async assign(
    user: Caller,
    id: string,
    dto: AssignVehicleDto,
    now = this.clock.now(),
  ): Promise<VehicleDetail> {
    const today = await this.calendar.today(now);
    if (dto.givenOn > today) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Choose today or an earlier day.',
        'givenOn',
      );
    }
    const person = await this.prisma.user.findUnique({
      where: { id: dto.userId },
      select: { id: true, name: true, role: true, isActive: true },
    });
    if (!person || (person.role !== 'STAFF' && person.role !== 'ENGINEER')) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Choose a staff member or an engineer.',
        'userId',
      );
    }
    if (!person.isActive) {
      throw badRequest(
        ErrorCode.USER_INACTIVE,
        `${person.name} is no longer active.`,
        'userId',
      );
    }
    try {
      await this.prisma.$transaction(async (tx) => {
        const vehicle = await lockVehicle(tx, id);
        const label = vehicleLabel(vehicle);
        if (!vehicle.isActive) {
          throw conflict(
            ErrorCode.VEHICLE_INACTIVE,
            `${label} is out of use. Bring it back into use first.`,
          );
        }
        const holder = vehicle.assignments[0];
        if (holder) throw vehicleAlreadyGiven(label, holder.user.name);
        const held = await tx.vehicleAssignment.findFirst({
          where: { ...OPEN, userId: person.id },
          select: {
            vehicle: { select: { makeModel: true, registrationNo: true } },
          },
        });
        if (held)
          throw personHasVehicle(person.name, vehicleLabel(held.vehicle));
        const last = await tx.vehicleAssignment.findFirst({
          where: { vehicleId: id },
          orderBy: { returnedOn: 'desc' },
          select: { returnedOn: true },
        });
        if (last?.returnedOn && dto.givenOn < fromDbDate(last.returnedOn)) {
          throw badRequest(
            ErrorCode.VALIDATION_FAILED,
            'It came back after that day. Choose a later day.',
            'givenOn',
          );
        }
        const row = await tx.vehicleAssignment.create({
          data: {
            vehicleId: id,
            userId: person.id,
            givenOn: toDbDate(dto.givenOn),
            note: dto.note || null,
            givenById: user.id,
          },
          select: { id: true },
        });
        await this.audit.record(
          {
            actorId: user.id,
            action: 'vehicle.given',
            entityType: 'Vehicle',
            entityId: id,
            changes: {
              userId: person.id,
              givenOn: dto.givenOn,
              ...(dto.note && { note: dto.note }),
            },
          },
          tx,
        );
        await this.notifications.notify(
          [
            {
              recipientIds: [person.id],
              type: 'VEHICLE',
              ...vehicleGiven({
                code: vehicleCode(vehicle.number),
                label,
                byName: user.name,
              }),
              referenceType: 'VEHICLE',
              referenceId: id,
              data: { vehicleId: id },
              dedupeKey: `vehicle-given:${row.id}`,
            },
          ],
          tx,
        );
      });
    } catch (error) {
      // Two admins at once: the partial unique indexes let only one through.
      if (isUniqueViolation(error)) {
        throw conflict(
          ErrorCode.VEHICLE_ALREADY_GIVEN,
          'This was just given by someone else. Reload to see who has it.',
        );
      }
      throw error;
    }
    return this.get(id);
  }

  /** Takes the vehicle back from whoever holds it. */
  async takeBack(
    user: Caller,
    id: string,
    dto: ReturnVehicleDto,
    now = this.clock.now(),
  ): Promise<VehicleDetail> {
    const today = await this.calendar.today(now);
    if (dto.returnedOn > today) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Choose today or an earlier day.',
        'returnedOn',
      );
    }
    await this.prisma.$transaction(async (tx) => {
      const vehicle = await lockVehicle(tx, id);
      const label = vehicleLabel(vehicle);
      const open = await tx.vehicleAssignment.findFirst({
        where: { ...OPEN, vehicleId: id },
        select: { id: true, userId: true, givenOn: true },
      });
      if (!open) {
        throw conflict(
          ErrorCode.VEHICLE_NOT_GIVEN,
          `${label} is not with anyone now.`,
        );
      }
      if (dto.returnedOn < fromDbDate(open.givenOn)) {
        throw badRequest(
          ErrorCode.VALIDATION_FAILED,
          'It was given after that day. Choose a later day.',
          'returnedOn',
        );
      }
      await tx.vehicleAssignment.update({
        where: { id: open.id },
        data: {
          returnedOn: toDbDate(dto.returnedOn),
          returnNote: dto.note || null,
          returnedById: user.id,
        },
      });
      await this.audit.record(
        {
          actorId: user.id,
          action: 'vehicle.taken_back',
          entityType: 'Vehicle',
          entityId: id,
          changes: {
            userId: open.userId,
            returnedOn: dto.returnedOn,
            ...(dto.note && { note: dto.note }),
          },
        },
        tx,
      );
      await this.notifications.notify(
        [
          {
            recipientIds: [open.userId],
            type: 'VEHICLE',
            ...vehicleTakenBack({
              code: vehicleCode(vehicle.number),
              label,
              byName: user.name,
            }),
            referenceType: 'VEHICLE',
            referenceId: id,
            data: { vehicleId: id },
            dedupeKey: `vehicle-taken-back:${open.id}`,
          },
        ],
        tx,
      );
    });
    return this.get(id);
  }

  /**
   * When a person is deactivated: the vehicle they hold is free again from
   * today. Runs inside the caller's transaction.
   */
  async releaseHolder(
    actorId: string,
    userId: string,
    tx: Db,
    now = this.clock.now(),
  ): Promise<void> {
    const open = await tx.vehicleAssignment.findFirst({
      where: { ...OPEN, userId },
      select: { id: true, vehicleId: true, givenOn: true },
    });
    if (!open) return;
    const today = await this.calendar.today(now);
    const givenOn = fromDbDate(open.givenOn);
    const returnedOn = today < givenOn ? givenOn : today;
    await tx.vehicleAssignment.update({
      where: { id: open.id },
      data: {
        returnedOn: toDbDate(returnedOn),
        returnNote: 'Account deactivated',
        returnedById: actorId,
      },
    });
    await this.audit.record(
      {
        actorId,
        action: 'vehicle.taken_back',
        entityType: 'Vehicle',
        entityId: open.vehicleId,
        changes: { userId, returnedOn, reason: 'user.deactivated' },
      },
      tx,
    );
  }

  private async ensureRegistrationFree(
    registrationNo: string,
    exceptId?: string,
  ): Promise<void> {
    const taken = await this.prisma.vehicle.findFirst({
      where: { registrationNo, ...(exceptId && { id: { not: exceptId } }) },
      select: { id: true },
    });
    if (taken) throw registrationInUse(registrationNo);
  }
}

/** Serialises hand-overs of one vehicle, so two admins can't give it at once. */
async function lockVehicle(tx: Db, id: string): Promise<VehicleRow> {
  await tx.$queryRaw`SELECT id FROM vehicles WHERE id = ${id}::uuid FOR UPDATE`;
  const vehicle = await tx.vehicle.findUnique({
    where: { id },
    include: INCLUDE,
  });
  if (!vehicle) throw notFound('vehicle');
  return vehicle;
}

function registrationOf(value: string): string {
  const registrationNo = normalizeRegistration(value);
  if (registrationNo.length < 4) {
    throw badRequest(
      ErrorCode.VALIDATION_FAILED,
      'Enter the registration number.',
      'registrationNo',
    );
  }
  return registrationNo;
}

const registrationInUse = (registrationNo: string) =>
  conflict(
    ErrorCode.VEHICLE_REGISTRATION_IN_USE,
    `${registrationNo} is already in the list.`,
    [{ field: 'registrationNo', message: 'already used' }],
  );

const isUniqueViolation = (error: unknown) =>
  (error as { code?: string }).code === 'P2002';

type OpenAssignment = VehicleRow['assignments'][number];

function toView(
  row: Omit<VehicleRow, 'assignments'> & { assignments: OpenAssignment[] },
): VehicleView {
  const open = row.assignments[0];
  return {
    id: row.id,
    code: vehicleCode(row.number),
    type: row.type,
    registrationNo: row.registrationNo,
    makeModel: row.makeModel,
    note: row.note,
    isActive: row.isActive,
    holder: open
      ? {
          user: open.user,
          givenOn: fromDbDate(open.givenOn),
          note: open.note,
        }
      : null,
    createdAt: row.createdAt.toISOString(),
  };
}
