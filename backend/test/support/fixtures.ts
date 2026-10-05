import { hashPassword } from '../../src/auth/password-hasher.js';
import { toDbDate } from '../../src/common/time/business-time.js';
import type { Designation, Role } from '../../src/generated/prisma/enums.js';
import type { PrismaService } from '../../src/prisma/prisma.service.js';

export const TEST_PASSWORD = 'Passw0rd2026';

/** Empties every table (keeps the migration history). */
export async function resetDatabase(prisma: PrismaService): Promise<void> {
  const tables = await prisma.$queryRaw<{ tablename: string }[]>`
    SELECT tablename FROM pg_tables
    WHERE schemaname = 'public' AND tablename <> '_prisma_migrations'`;
  if (tables.length === 0) return;
  await prisma.$executeRawUnsafe(
    `TRUNCATE TABLE ${tables.map((t) => `"public"."${t.tablename}"`).join(', ')} CASCADE`,
  );
}

const hashes = new Map<string, Promise<string>>();
let sequence = 0;

export interface UserFixture {
  role?: Role;
  name?: string;
  phone?: string;
  email?: string | null;
  password?: string;
  isActive?: boolean;
  mustChangePassword?: boolean;
  designation?: Designation;
}

export async function createUser(
  prisma: PrismaService,
  fixture: UserFixture = {},
) {
  sequence += 1;
  const role = fixture.role ?? 'STAFF';
  const password = fixture.password ?? TEST_PASSWORD;
  if (!hashes.has(password)) hashes.set(password, hashPassword(password));
  return prisma.user.create({
    data: {
      role,
      name: fixture.name ?? `${role.toLowerCase()} ${sequence}`,
      phone: fixture.phone ?? `+9198${String(sequence).padStart(8, '0')}`,
      email: fixture.email ?? null,
      employeeCode: `T-${process.pid}-${sequence}`,
      designation: role === 'STAFF' ? (fixture.designation ?? 'MASON') : null,
      passwordHash: await hashes.get(password)!,
      isActive: fixture.isActive ?? true,
      mustChangePassword: fixture.mustChangePassword ?? false,
    },
  });
}

/** A site with a client, the given engineers, and staff (each reporting to the first engineer). */
export async function createSite(
  prisma: PrismaService,
  options: {
    name?: string;
    createdById: string;
    engineerIds?: string[];
    staffIds?: string[];
  },
) {
  sequence += 1;
  const client = await prisma.client.create({
    data: { name: `Client ${sequence}`, phone: '+919000000000' },
  });
  const site = await prisma.site.create({
    data: {
      code: `T-SITE-${sequence}`,
      name: options.name ?? `Site ${sequence}`,
      clientId: client.id,
      address: 'Test address',
      latitude: 13.0878,
      longitude: 80.2008,
      geofenceRadiusM: 300,
      startDate: toDbDate('2026-01-01'),
      contractAmount: 1_000_000,
      status: 'IN_PROGRESS',
      createdById: options.createdById,
    },
  });
  const engineerIds = options.engineerIds ?? [];
  for (const engineerId of engineerIds) {
    await prisma.engineerAssignment.create({
      data: { siteId: site.id, engineerId },
    });
  }
  for (const staffId of options.staffIds ?? []) {
    await prisma.staffAssignment.create({
      data: { staffId, siteId: site.id, engineerId: engineerIds[0] },
    });
  }
  return site;
}
