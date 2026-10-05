import { Injectable } from '@nestjs/common';
import type { LoginIdentifier } from '../common/identity/phone.js';
import type { Prisma } from '../generated/prisma/client.js';
import { PrismaService } from '../prisma/prisma.service.js';

/** The user fields authentication needs. */
export const AUTH_USER_SELECT = {
  id: true,
  role: true,
  name: true,
  phone: true,
  email: true,
  passwordHash: true,
  isActive: true,
  mustChangePassword: true,
  failedLoginCount: true,
  lockedUntil: true,
} as const satisfies Prisma.UserSelect;

export type AuthUserRecord = Prisma.UserGetPayload<{
  select: typeof AUTH_USER_SELECT;
}>;

type Db = PrismaService | Prisma.TransactionClient;

@Injectable()
export class UsersRepository {
  constructor(private readonly prisma: PrismaService) {}

  findForLogin(identifier: LoginIdentifier): Promise<AuthUserRecord | null> {
    return this.prisma.user.findUnique({
      where:
        identifier.kind === 'email'
          ? { email: identifier.email }
          : { phone: identifier.phone },
      select: AUTH_USER_SELECT,
    });
  }

  findForAuth(id: string): Promise<AuthUserRecord | null> {
    return this.prisma.user.findUnique({
      where: { id },
      select: AUTH_USER_SELECT,
    });
  }

  async recordFailedLogin(
    id: string,
    state: { failedLoginCount: number; lockedUntil: Date | null },
  ): Promise<void> {
    await this.prisma.user.update({ where: { id }, data: state });
  }

  async recordSuccessfulLogin(id: string, now: Date): Promise<void> {
    await this.prisma.user.update({
      where: { id },
      data: { failedLoginCount: 0, lockedUntil: null, lastLoginAt: now },
    });
  }

  /** Sets a new password hash and clears any lockout. */
  async setPassword(
    id: string,
    passwordHash: string,
    mustChangePassword: boolean,
    db: Db = this.prisma,
  ): Promise<void> {
    await db.user.update({
      where: { id },
      data: {
        passwordHash,
        mustChangePassword,
        failedLoginCount: 0,
        lockedUntil: null,
      },
    });
  }

  findProfile(id: string) {
    return this.prisma.user.findUnique({
      where: { id },
      select: {
        id: true,
        name: true,
        role: true,
        phone: true,
        email: true,
        employeeCode: true,
        designation: true,
        joiningDate: true,
        mustChangePassword: true,
        staffAssignment: {
          select: {
            site: {
              select: { id: true, code: true, name: true, address: true },
            },
            engineer: { select: { id: true, name: true, phone: true } },
          },
        },
        engineerAssignments: {
          select: { site: { select: { id: true, code: true, name: true } } },
          orderBy: { site: { name: 'asc' } },
        },
      },
    });
  }
}
