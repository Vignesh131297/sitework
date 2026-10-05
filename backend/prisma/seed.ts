import 'dotenv/config';
import { PrismaPg } from '@prisma/adapter-pg';
import { PrismaClient } from '../src/generated/prisma/client.js';
import { DEV_PASSWORDS } from './seed/data.js';
import { writeSeedPhotos } from './seed/photos.js';
import { seedDatabase } from './seed/seed-database.js';

async function main(): Promise<void> {
  if (process.env.NODE_ENV === 'production') {
    throw new Error('Refusing to seed: NODE_ENV is production.');
  }
  const connectionString = process.env.DATABASE_URL;
  if (!connectionString) throw new Error('DATABASE_URL is not set.');

  const prisma = new PrismaClient({
    adapter: new PrismaPg({ connectionString }),
  });
  try {
    const counts = await seedDatabase(prisma, new Date());
    if ((process.env.STORAGE_DRIVER ?? 'local') === 'local') {
      counts.photoFiles = await writeSeedPhotos(
        prisma,
        process.env.LOCAL_STORAGE_DIR ?? './storage',
      );
    }
    console.table(counts);
    console.log('Development logins (phone or e-mail):');
    console.table([
      {
        role: 'Admin',
        login: '+919000000001 or admin@sitework.test',
        password: DEV_PASSWORDS.ADMIN,
      },
      {
        role: 'Engineer (Arun Kumar)',
        login: '+919000000011 or arun@sitework.test',
        password: DEV_PASSWORDS.ENGINEER,
      },
      {
        role: 'Staff (Ravi)',
        login: '+919000000101',
        password: DEV_PASSWORDS.STAFF,
      },
    ]);
  } finally {
    await prisma.$disconnect();
  }
}

main().catch((error: unknown) => {
  console.error(error);
  process.exitCode = 1;
});
