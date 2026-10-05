import { hashPassword } from '../auth/password-hasher.js';
import { generateTemporaryPassword } from '../auth/password-rules.js';
import { normalizeEmail, normalizePhone } from '../common/identity/phone.js';
import type { PrismaClient } from '../generated/prisma/client.js';
import { nextEmployeeCode } from './employee-codes.js';

export interface NewAdmin {
  name: string;
  phone: string;
  email?: string;
}

export interface CreatedAdmin {
  id: string;
  name: string;
  phone: string;
  employeeCode: string;
  /** Shown once; the admin must replace it at first sign-in. */
  temporaryPassword: string;
}

/**
 * Adds an admin. The API can't (admins aren't managed in the app), so this is
 * how a new installation gets its first account: see src/cli/create-admin.ts.
 */
export async function createAdmin(
  db: Pick<PrismaClient, 'user' | 'auditLog' | '$transaction'>,
  input: NewAdmin,
): Promise<CreatedAdmin> {
  const name = input.name.trim();
  if (!name) throw new Error('Give the admin a name.');
  const phone = normalizePhone(input.phone);
  if (!phone) throw new Error('Enter a mobile number such as +919876543210.');
  const email = input.email ? normalizeEmail(input.email) : null;
  if (input.email && !email)
    throw new Error('That e-mail address is not valid.');

  const taken = await db.user.findFirst({
    where: { OR: [{ phone }, ...(email ? [{ email }] : [])] },
    select: { name: true },
  });
  if (taken) {
    throw new Error(
      `That mobile number or e-mail already belongs to ${taken.name}.`,
    );
  }

  const temporaryPassword = generateTemporaryPassword();
  const passwordHash = await hashPassword(temporaryPassword);
  const user = await db.$transaction(async (tx) => {
    const created = await tx.user.create({
      data: {
        role: 'ADMIN',
        name,
        phone,
        email,
        employeeCode: await nextEmployeeCode(tx, 'ADMIN'),
        passwordHash,
        mustChangePassword: true,
      },
    });
    await tx.auditLog.create({
      data: {
        actorId: null,
        action: 'user.created',
        entityType: 'User',
        entityId: created.id,
        changes: { role: 'ADMIN', via: 'command line' },
      },
    });
    return created;
  });
  return {
    id: user.id,
    name: user.name,
    phone: user.phone,
    employeeCode: user.employeeCode,
    temporaryPassword,
  };
}
