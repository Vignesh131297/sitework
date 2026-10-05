import 'dotenv/config';
import { defineConfig } from 'vitest/config';

// E2E tests run the real app against a separate database (never the dev database).
const testDatabaseUrl = process.env.TEST_DATABASE_URL;
if (!testDatabaseUrl) {
  throw new Error(
    'Set TEST_DATABASE_URL (see .env.example) to run the e2e tests.',
  );
}

export default defineConfig({
  // Resolves path aliases declared in tsconfig.json (e.g. from `nest g library`).
  resolve: { tsconfigPaths: true },
  test: {
    globals: true,
    root: './',
    include: ['**/*.e2e-spec.ts'],
    globalSetup: ['./test/global-setup.ts'],
    env: {
      NODE_ENV: 'test',
      // 4xx responses are expected in tests; server errors still show.
      LOG_LEVEL: 'error',
      DATABASE_URL: testDatabaseUrl,
      // Tests run jobs by calling them directly, at chosen times.
      JOBS_ENABLED: 'false',
      STORAGE_DRIVER: 'local',
      LOCAL_STORAGE_DIR: './.test-storage',
    },
    // Test files share one database.
    fileParallelism: false,
  },
});
