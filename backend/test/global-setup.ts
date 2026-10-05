import { execSync } from 'node:child_process';

/** Brings the test database to the latest schema before any e2e test runs. */
export default function setup(): void {
  execSync('npx prisma migrate deploy', {
    stdio: 'inherit',
    env: { ...process.env, DATABASE_URL: process.env.TEST_DATABASE_URL },
  });
}
