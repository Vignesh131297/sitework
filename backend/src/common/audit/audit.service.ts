import { Global, Injectable, Module } from '@nestjs/common';
import type { Prisma } from '../../generated/prisma/client.js';
import { PrismaService } from '../../prisma/prisma.service.js';

export interface AuditEntry {
  actorId: string | null;
  /** e.g. "user.password_reset", "payment.voided" */
  action: string;
  entityType: string;
  entityId: string;
  changes?: Prisma.InputJsonValue;
}

type Db = Pick<PrismaService, 'auditLog'> | Prisma.TransactionClient;

/** Append-only record of sensitive changes. Pass the transaction client to write atomically. */
@Injectable()
export class AuditService {
  constructor(private readonly prisma: PrismaService) {}

  async record(entry: AuditEntry, db: Db = this.prisma): Promise<void> {
    await db.auditLog.create({ data: entry });
  }
}

@Global()
@Module({ providers: [AuditService], exports: [AuditService] })
export class AuditModule {}
