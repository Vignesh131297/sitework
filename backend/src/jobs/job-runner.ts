import { Injectable, Logger } from '@nestjs/common';
import { createHash } from 'node:crypto';
import { PrismaService } from '../prisma/prisma.service.js';

/**
 * Runs a scheduled job on one API instance at a time: the job holds a Postgres
 * advisory lock for as long as it runs, and other instances skip that tick.
 */
@Injectable()
export class JobRunner {
  private readonly logger = new Logger('Jobs');

  constructor(private readonly prisma: PrismaService) {}

  /** Returns false when another instance is already running [name]. */
  async exclusive(name: string, job: () => Promise<void>): Promise<boolean> {
    const key = lockKey(name);
    let ran = false;
    try {
      // The transaction pins one connection; the lock ends with it.
      await this.prisma.$transaction(
        async (tx) => {
          const [{ locked }] = await tx.$queryRaw<
            { locked: boolean }[]
          >`SELECT pg_try_advisory_xact_lock(${key}) AS locked`;
          if (!locked) return;
          ran = true;
          await job();
        },
        { maxWait: 10_000, timeout: 15 * 60_000 },
      );
    } catch (error) {
      this.logger.error(
        `Job ${name} failed: ${(error as Error).message}`,
        (error as Error).stack,
      );
    }
    return ran;
  }
}

/** A stable 64-bit lock id for a job name. */
function lockKey(name: string): bigint {
  return createHash('sha256')
    .update(`sitework-job:${name}`)
    .digest()
    .readBigInt64BE(0);
}
