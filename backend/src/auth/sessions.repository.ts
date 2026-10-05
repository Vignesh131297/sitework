import { Injectable } from '@nestjs/common';
import type { Prisma } from '../generated/prisma/client.js';
import { PrismaService } from '../prisma/prisma.service.js';
import { AUTH_USER_SELECT } from '../users/users.repository.js';

type Db = PrismaService | Prisma.TransactionClient;

@Injectable()
export class SessionsRepository {
  constructor(private readonly prisma: PrismaService) {}

  create(data: {
    userId: string;
    refreshTokenHash: string;
    deviceName: string | null;
    ipAddress: string | null;
    expiresAt: Date;
  }): Promise<{ id: string }> {
    return this.prisma.authSession.create({ data, select: { id: true } });
  }

  findWithUser(id: string) {
    return this.prisma.authSession.findUnique({
      where: { id },
      include: { user: { select: AUTH_USER_SELECT } },
    });
  }

  /**
   * Swaps the refresh-token hash, but only if the presented one is still current,
   * so two concurrent refreshes with the same token can't both succeed.
   */
  async rotate(
    id: string,
    currentHash: string,
    data: {
      refreshTokenHash: string;
      expiresAt: Date;
      lastUsedAt: Date;
      ipAddress: string | null;
    },
  ): Promise<boolean> {
    const { count } = await this.prisma.authSession.updateMany({
      where: { id, refreshTokenHash: currentHash, revokedAt: null },
      data,
    });
    return count === 1;
  }

  async revoke(id: string, now: Date = new Date()): Promise<void> {
    await this.prisma.authSession.updateMany({
      where: { id, revokedAt: null },
      data: { revokedAt: now },
    });
  }

  async revokeAllForUser(
    userId: string,
    options: { except?: string; db?: Db; now?: Date } = {},
  ): Promise<void> {
    await (options.db ?? this.prisma).authSession.updateMany({
      where: {
        userId,
        revokedAt: null,
        ...(options.except && { id: { not: options.except } }),
      },
      data: { revokedAt: options.now ?? new Date() },
    });
  }
}
