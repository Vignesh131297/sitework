import { Injectable } from '@nestjs/common';
import type { AuthUser } from '../auth/auth-user.js';
import { hashPassword } from '../auth/password-hasher.js';
import { generateTemporaryPassword } from '../auth/password-rules.js';
import { staffScope } from '../common/access/access-scope.js';
import { AuditService } from '../common/audit/audit.service.js';
import { ErrorCode } from '../common/errors/error-codes.js';
import {
  badRequest,
  conflict,
  notFound,
} from '../common/errors/http-errors.js';
import { optionalEmail, requirePhone } from '../common/identity/contact.js';
import { Paginated } from '../common/pagination/paginated.js';
import { contains } from '../common/pagination/page-query.dto.js';
import { fromDbDate, toDbDate } from '../common/time/business-time.js';
import type { Prisma } from '../generated/prisma/client.js';
import type { Designation, Role } from '../generated/prisma/enums.js';
import { PrismaService } from '../prisma/prisma.service.js';
import { AssignmentsService } from '../sites/assignments.service.js';
import { nextEmployeeCode } from './employee-codes.js';
import type {
  CreateEngineerDto,
  CreateStaffDto,
  PeopleQueryDto,
  UpdateEngineerDto,
  UpdateStaffDto,
} from './people.dto.js';

type PersonRole = Extract<Role, 'ENGINEER' | 'STAFF'>;

export interface PersonSummary {
  id: string;
  role: Role;
  name: string;
  phone: string;
  email: string | null;
  employeeCode: string;
  designation: Designation | null;
  joiningDate: string | null;
  isActive: boolean;
  lastLoginAt: string | null;
  /** Engineers: their sites. */
  sites: { id: string; code: string; name: string }[];
  /** Engineers: how many staff report to them. */
  staffCount: number;
  /** Staff: current site and responsible engineer. */
  assignment: {
    site: { id: string; code: string; name: string };
    engineer: { id: string; name: string };
  } | null;
}

export interface PersonDetail extends PersonSummary {
  mustChangePassword: boolean;
  supervisedStaff: {
    id: string;
    name: string;
    designation: Designation | null;
    site: { id: string; name: string };
  }[];
}

const PERSON_SELECT = {
  id: true,
  role: true,
  name: true,
  phone: true,
  email: true,
  employeeCode: true,
  designation: true,
  joiningDate: true,
  isActive: true,
  lastLoginAt: true,
  mustChangePassword: true,
  engineerAssignments: {
    select: { site: { select: { id: true, code: true, name: true } } },
    orderBy: { site: { name: 'asc' } },
  },
  staffAssignment: {
    select: {
      site: { select: { id: true, code: true, name: true } },
      engineer: { select: { id: true, name: true } },
    },
  },
  _count: { select: { supervisedStaff: true } },
} as const satisfies Prisma.UserSelect;

type PersonRow = Prisma.UserGetPayload<{ select: typeof PERSON_SELECT }>;

@Injectable()
export class PeopleService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly assignments: AssignmentsService,
    private readonly audit: AuditService,
  ) {}

  async list(
    user: AuthUser,
    role: PersonRole,
    query: PeopleQueryDto,
  ): Promise<Paginated<PersonSummary>> {
    const term = query.search;
    const where: Prisma.UserWhereInput = {
      AND: [
        role === 'STAFF' ? staffScope(user) : { role: 'ENGINEER' },
        query.status ? { isActive: query.status === 'active' } : {},
        query.designation ? { designation: query.designation } : {},
        query.siteId
          ? role === 'STAFF'
            ? { staffAssignment: { siteId: query.siteId } }
            : { engineerAssignments: { some: { siteId: query.siteId } } }
          : {},
        query.engineerId && role === 'STAFF'
          ? { staffAssignment: { engineerId: query.engineerId } }
          : {},
        query.unassigned === 'true' && role === 'STAFF'
          ? { staffAssignment: { is: null } }
          : {},
        term
          ? {
              OR: [
                { name: contains(term) },
                { phone: contains(term) },
                { email: contains(term) },
                { employeeCode: contains(term) },
              ],
            }
          : {},
      ],
    };
    const [rows, total] = await Promise.all([
      this.prisma.user.findMany({
        where,
        select: PERSON_SELECT,
        orderBy: [{ isActive: 'desc' }, { name: 'asc' }],
        skip: query.skip,
        take: query.limit,
      }),
      this.prisma.user.count({ where }),
    ]);
    return new Paginated(rows.map(toSummary), query.page, query.limit, total);
  }

  async get(
    user: AuthUser,
    role: PersonRole,
    id: string,
  ): Promise<PersonDetail> {
    const person = await this.prisma.user.findFirst({
      where: {
        id,
        ...(role === 'STAFF' ? staffScope(user) : { role: 'ENGINEER' }),
      },
      select: {
        ...PERSON_SELECT,
        supervisedStaff: {
          select: {
            staff: { select: { id: true, name: true, designation: true } },
            site: { select: { id: true, name: true } },
          },
          orderBy: { staff: { name: 'asc' } },
        },
      },
    });
    if (!person) throw notFound(role === 'STAFF' ? 'staff member' : 'engineer');
    return {
      ...toSummary(person),
      mustChangePassword: person.mustChangePassword,
      supervisedStaff: person.supervisedStaff.map((s) => ({
        ...s.staff,
        site: s.site,
      })),
    };
  }

  async createEngineer(
    actor: AuthUser,
    dto: CreateEngineerDto,
  ): Promise<{ person: PersonDetail; temporaryPassword: string }> {
    const siteIds = [...new Set(dto.siteIds ?? [])];
    if (
      siteIds.length &&
      (await this.prisma.site.count({ where: { id: { in: siteIds } } })) !==
        siteIds.length
    ) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Choose existing sites.',
        'siteIds',
      );
    }
    const created = await this.createUser(
      actor,
      'ENGINEER',
      dto,
      siteIds.length
        ? {
            engineerAssignments: {
              create: siteIds.map((siteId) => ({
                siteId,
                assignedById: actor.id,
              })),
            },
          }
        : {},
    );
    return {
      person: await this.get(actor, 'ENGINEER', created.id),
      temporaryPassword: created.temporaryPassword,
    };
  }

  async createStaff(
    actor: AuthUser,
    dto: CreateStaffDto,
  ): Promise<{ person: PersonDetail; temporaryPassword: string }> {
    if (Boolean(dto.siteId) !== Boolean(dto.engineerId)) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Choose both a site and an engineer, or neither.',
        'engineerId',
      );
    }
    const created = await this.createUser(actor, 'STAFF', dto, {
      designation: dto.designation,
    });
    if (dto.siteId && dto.engineerId) {
      await this.assignments.assignStaff(
        actor.id,
        created.id,
        dto.siteId,
        dto.engineerId,
      );
    }
    return {
      person: await this.get(actor, 'STAFF', created.id),
      temporaryPassword: created.temporaryPassword,
    };
  }

  async update(
    actor: AuthUser,
    role: PersonRole,
    id: string,
    dto: UpdateEngineerDto | UpdateStaffDto,
  ): Promise<PersonDetail> {
    const existing = await this.prisma.user.findFirst({ where: { id, role } });
    if (!existing)
      throw notFound(role === 'STAFF' ? 'staff member' : 'engineer');
    const phone = dto.phone === undefined ? undefined : requirePhone(dto.phone);
    const email = optionalEmail(dto.email);
    const employeeCode = dto.employeeCode?.trim().toUpperCase();
    await this.ensureUnique({ phone, email, employeeCode }, id);

    await this.prisma.user.update({
      where: { id },
      data: {
        name: dto.name?.trim(),
        phone,
        email,
        employeeCode,
        joiningDate:
          dto.joiningDate === undefined
            ? undefined
            : dto.joiningDate
              ? toDbDate(dto.joiningDate)
              : null,
        designation:
          role === 'STAFF' ? (dto as UpdateStaffDto).designation : undefined,
      },
    });
    await this.audit.record({
      actorId: actor.id,
      action: 'user.updated',
      entityType: 'User',
      entityId: id,
      changes: JSON.parse(JSON.stringify(dto)),
    });
    return this.get(actor, role, id);
  }

  /** Deactivating ends the person's sessions and assignments; history is kept. */
  async setStatus(
    actor: AuthUser,
    role: PersonRole,
    id: string,
    isActive: boolean,
  ): Promise<PersonDetail> {
    const existing = await this.prisma.user.findFirst({ where: { id, role } });
    if (!existing)
      throw notFound(role === 'STAFF' ? 'staff member' : 'engineer');
    if (existing.isActive !== isActive) {
      await this.prisma.$transaction(async (tx) => {
        if (!isActive) {
          if (role === 'ENGINEER')
            await this.assignments.releaseEngineer(actor.id, id, tx);
          else await this.assignments.unassignStaff(actor.id, id, tx);
          await tx.authSession.updateMany({
            where: { userId: id, revokedAt: null },
            data: { revokedAt: new Date() },
          });
        }
        await tx.user.update({ where: { id }, data: { isActive } });
        await this.audit.record(
          {
            actorId: actor.id,
            action: isActive ? 'user.activated' : 'user.deactivated',
            entityType: 'User',
            entityId: id,
          },
          tx,
        );
      });
    }
    return this.get(actor, role, id);
  }

  async assignStaff(
    actor: AuthUser,
    staffId: string,
    siteId: string,
    engineerId: string,
  ): Promise<PersonDetail> {
    await this.assignments.assignStaff(actor.id, staffId, siteId, engineerId);
    return this.get(actor, 'STAFF', staffId);
  }

  async unassignStaff(actor: AuthUser, staffId: string): Promise<PersonDetail> {
    if (
      !(await this.prisma.user.findFirst({
        where: { id: staffId, role: 'STAFF' },
      }))
    ) {
      throw notFound('staff member');
    }
    await this.assignments.unassignStaff(actor.id, staffId);
    return this.get(actor, 'STAFF', staffId);
  }

  private async createUser(
    actor: AuthUser,
    role: PersonRole,
    dto: {
      name: string;
      phone: string;
      email?: string | null;
      employeeCode?: string;
      joiningDate?: string | null;
    },
    extra: Partial<Prisma.UserCreateInput>,
  ): Promise<{ id: string; temporaryPassword: string }> {
    const phone = requirePhone(dto.phone);
    const email = optionalEmail(dto.email) ?? null;
    const employeeCode =
      dto.employeeCode?.trim().toUpperCase() ??
      (await nextEmployeeCode(this.prisma, role));
    await this.ensureUnique({ phone, email, employeeCode });

    // New people sign in with a temporary password and must choose their own.
    const temporaryPassword = generateTemporaryPassword();
    const user = await this.prisma.user.create({
      data: {
        role,
        name: dto.name.trim(),
        phone,
        email,
        employeeCode,
        joiningDate: dto.joiningDate ? toDbDate(dto.joiningDate) : null,
        passwordHash: await hashPassword(temporaryPassword),
        mustChangePassword: true,
        ...extra,
      },
      select: { id: true },
    });
    await this.audit.record({
      actorId: actor.id,
      action: 'user.created',
      entityType: 'User',
      entityId: user.id,
      changes: { role },
    });
    return { id: user.id, temporaryPassword };
  }

  private async ensureUnique(
    fields: { phone?: string; email?: string | null; employeeCode?: string },
    exceptId?: string,
  ): Promise<void> {
    const not = exceptId ? { id: { not: exceptId } } : {};
    const checks: [keyof typeof fields, ErrorCode, string][] = [
      [
        'phone',
        ErrorCode.PHONE_IN_USE,
        'This mobile number is already used by',
      ],
      ['email', ErrorCode.EMAIL_IN_USE, 'This e-mail is already used by'],
      [
        'employeeCode',
        ErrorCode.EMPLOYEE_CODE_IN_USE,
        'This employee ID is already used by',
      ],
    ];
    for (const [field, code, message] of checks) {
      const value = fields[field];
      if (!value) continue;
      const owner = await this.prisma.user.findFirst({
        where: { [field]: value, ...not },
        select: { name: true },
      });
      if (owner)
        throw conflict(code, `${message} ${owner.name}.`, [
          { field, message: 'already used' },
        ]);
    }
  }
}

function toSummary(row: PersonRow): PersonSummary {
  return {
    id: row.id,
    role: row.role,
    name: row.name,
    phone: row.phone,
    email: row.email,
    employeeCode: row.employeeCode,
    designation: row.designation,
    joiningDate: row.joiningDate ? fromDbDate(row.joiningDate) : null,
    isActive: row.isActive,
    lastLoginAt: row.lastLoginAt?.toISOString() ?? null,
    sites: row.engineerAssignments.map((a) => a.site),
    staffCount: row._count.supervisedStaff,
    assignment: row.staffAssignment
      ? {
          site: row.staffAssignment.site,
          engineer: row.staffAssignment.engineer,
        }
      : null,
  };
}
