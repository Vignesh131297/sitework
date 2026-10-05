import { HttpStatus, Injectable } from '@nestjs/common';
import { AuditService } from '../common/audit/audit.service.js';
import { AppException } from '../common/errors/app.exception.js';
import { ErrorCode } from '../common/errors/error-codes.js';
import {
  badRequest,
  conflict,
  notFound,
} from '../common/errors/http-errors.js';
import type { Prisma } from '../generated/prisma/client.js';
import { PrismaService } from '../prisma/prisma.service.js';

type Tx = Prisma.TransactionClient;

/**
 * Who works where. Assignment tables hold only current assignments; ended ones
 * move to assignment_history. The database itself refuses a staff assignment
 * whose engineer isn't on the same site (composite foreign key).
 */
@Injectable()
export class AssignmentsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
  ) {}

  async requireActiveEngineers(
    ids: string[],
    db: Tx | PrismaService = this.prisma,
  ): Promise<void> {
    const unique = [...new Set(ids)];
    const found = await db.user.count({
      where: { id: { in: unique }, role: 'ENGINEER', isActive: true },
    });
    if (found !== unique.length) {
      throw badRequest(
        ErrorCode.VALIDATION_FAILED,
        'Choose active engineers only.',
        'engineerIds',
      );
    }
  }

  /** Replaces the site's engineers. An engineer who still supervises staff here can't be removed. */
  async setSiteEngineers(
    actorId: string,
    siteId: string,
    engineerIds: string[],
  ): Promise<void> {
    const wanted = new Set(engineerIds);
    await this.prisma.$transaction(async (tx) => {
      await this.requireActiveEngineers([...wanted], tx);
      const current = await tx.engineerAssignment.findMany({
        where: { siteId },
      });
      const removed = current.filter((a) => !wanted.has(a.engineerId));
      const added = [...wanted].filter(
        (id) => !current.some((a) => a.engineerId === id),
      );

      if (removed.length > 0) {
        const staff = await tx.staffAssignment.findMany({
          where: {
            siteId,
            engineerId: { in: removed.map((a) => a.engineerId) },
          },
          select: {
            staff: { select: { name: true } },
            engineer: { select: { name: true } },
          },
        });
        if (staff.length > 0) {
          throw conflict(
            ErrorCode.ENGINEER_HAS_STAFF,
            `Move these staff to another engineer first: ${staff
              .map((s) => `${s.staff.name} (${s.engineer.name})`)
              .join(', ')}.`,
          );
        }
      }

      const now = new Date();
      for (const assignment of removed) {
        await tx.engineerAssignment.delete({ where: { id: assignment.id } });
        await tx.assignmentHistory.create({
          data: {
            kind: 'ENGINEER',
            userId: assignment.engineerId,
            siteId,
            assignedAt: assignment.assignedAt,
            unassignedAt: now,
            endedById: actorId,
          },
        });
      }
      if (added.length > 0) {
        await tx.engineerAssignment.createMany({
          data: added.map((engineerId) => ({
            siteId,
            engineerId,
            assignedById: actorId,
          })),
        });
      }
      if (removed.length + added.length > 0) {
        await this.audit.record(
          {
            actorId,
            action: 'site.engineers_changed',
            entityType: 'Site',
            entityId: siteId,
            changes: { added, removed: removed.map((a) => a.engineerId) },
          },
          tx,
        );
      }
    });
  }

  /** Puts a staff member on a site under one of its engineers; the old assignment becomes history. */
  async assignStaff(
    actorId: string,
    staffId: string,
    siteId: string,
    engineerId: string,
  ): Promise<void> {
    await this.prisma.$transaction(async (tx) => {
      const staff = await tx.user.findFirst({
        where: { id: staffId, role: 'STAFF' },
      });
      if (!staff) throw notFound('staff member');
      if (!staff.isActive) {
        throw badRequest(
          ErrorCode.USER_INACTIVE,
          'Activate this staff member before assigning them.',
        );
      }
      const site = await tx.site.findUnique({
        where: { id: siteId },
        select: { status: true },
      });
      if (!site) throw notFound('site');
      if (site.status === 'COMPLETED') {
        throw badRequest(
          ErrorCode.SITE_CLOSED,
          'This site is completed. Choose an active site.',
          'siteId',
        );
      }
      const onSite = await tx.engineerAssignment.findUnique({
        where: { siteId_engineerId: { siteId, engineerId } },
      });
      if (!onSite) {
        throw badRequest(
          ErrorCode.ENGINEER_NOT_ON_SITE,
          'Choose an engineer who is assigned to this site.',
          'engineerId',
        );
      }

      const now = new Date();
      const current = await tx.staffAssignment.findUnique({
        where: { staffId },
      });
      if (current?.siteId === siteId && current.engineerId === engineerId)
        return;
      if (current) {
        await this.endStaffAssignment(tx, current, actorId, now);
      }
      await tx.staffAssignment.create({
        data: {
          staffId,
          siteId,
          engineerId,
          assignedById: actorId,
          assignedAt: now,
        },
      });
      await this.audit.record(
        {
          actorId,
          action: 'staff.assigned',
          entityType: 'User',
          entityId: staffId,
          changes: {
            siteId,
            engineerId,
            previousSiteId: current?.siteId ?? null,
          },
        },
        tx,
      );
    });
  }

  async unassignStaff(
    actorId: string,
    staffId: string,
    db?: Tx,
  ): Promise<void> {
    const run = async (tx: Tx) => {
      const current = await tx.staffAssignment.findUnique({
        where: { staffId },
      });
      if (!current) return;
      await this.endStaffAssignment(tx, current, actorId, new Date());
      await this.audit.record(
        {
          actorId,
          action: 'staff.unassigned',
          entityType: 'User',
          entityId: staffId,
          changes: { siteId: current.siteId },
        },
        tx,
      );
    };
    if (db) await run(db);
    else await this.prisma.$transaction(run);
  }

  /** Ends every site assignment of an engineer (on deactivation). */
  async releaseEngineer(
    actorId: string,
    engineerId: string,
    tx: Tx,
  ): Promise<void> {
    const supervised = await tx.staffAssignment.count({
      where: { engineerId },
    });
    if (supervised > 0) {
      throw new AppException(
        ErrorCode.ENGINEER_HAS_STAFF,
        `This engineer still supervises ${supervised} staff member${supervised === 1 ? '' : 's'}. Move them to another engineer first.`,
        HttpStatus.CONFLICT,
      );
    }
    const now = new Date();
    const assignments = await tx.engineerAssignment.findMany({
      where: { engineerId },
    });
    for (const assignment of assignments) {
      await tx.engineerAssignment.delete({ where: { id: assignment.id } });
      await tx.assignmentHistory.create({
        data: {
          kind: 'ENGINEER',
          userId: engineerId,
          siteId: assignment.siteId,
          assignedAt: assignment.assignedAt,
          unassignedAt: now,
          endedById: actorId,
        },
      });
    }
  }

  private async endStaffAssignment(
    tx: Tx,
    assignment: {
      id: string;
      staffId: string;
      siteId: string;
      engineerId: string;
      assignedAt: Date;
    },
    actorId: string,
    now: Date,
  ): Promise<void> {
    await tx.staffAssignment.delete({ where: { id: assignment.id } });
    await tx.assignmentHistory.create({
      data: {
        kind: 'STAFF',
        userId: assignment.staffId,
        siteId: assignment.siteId,
        engineerId: assignment.engineerId,
        assignedAt: assignment.assignedAt,
        unassignedAt: now,
        endedById: actorId,
      },
    });
  }
}
