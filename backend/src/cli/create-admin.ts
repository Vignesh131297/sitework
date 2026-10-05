/**
 * Creates an admin account: the first one on a new installation (the seed never
 * runs in production), or another one later. Uses the same environment as the API.
 *
 *   node dist/cli/create-admin.js --name "Owner Name" --phone +919876543210 [--email a@b.c]
 *
 * Prints a temporary password, which must be replaced at the first sign-in.
 */
import { parseArgs } from 'node:util';
import { PrismaPg } from '@prisma/adapter-pg';
import { validateEnv } from '../config/env.js';
import { PrismaClient } from '../generated/prisma/client.js';
import { createAdmin } from '../people/create-admin.js';

const { values } = parseArgs({
  options: {
    name: { type: 'string' },
    phone: { type: 'string' },
    email: { type: 'string' },
  },
});
if (!values.name || !values.phone) {
  console.error(
    'Usage: node dist/cli/create-admin.js --name "Full Name" --phone +919876543210 [--email name@example.com]',
  );
  process.exit(2);
}

const env = validateEnv(process.env);
const prisma = new PrismaClient({
  adapter: new PrismaPg({ connectionString: env.DATABASE_URL }),
});
try {
  const admin = await createAdmin(prisma, {
    name: values.name,
    phone: values.phone,
    email: values.email,
  });
  console.log(
    `Admin created: ${admin.name} (${admin.employeeCode}), ${admin.phone}`,
  );
  console.log(`Temporary password: ${admin.temporaryPassword}`);
  console.log('They must choose their own password at first sign-in.');
} catch (error) {
  console.error(error instanceof Error ? error.message : error);
  process.exitCode = 1;
} finally {
  await prisma.$disconnect();
}
