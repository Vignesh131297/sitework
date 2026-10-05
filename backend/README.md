# SiteWork API

NestJS 12 (ESM, TypeScript 6), Prisma 7.10 with the PostgreSQL driver adapter.
Design and conventions: [`docs/ARCHITECTURE.md`](../docs/ARCHITECTURE.md). Setup: the
[root README](../README.md).

## Scripts

| Command | What it does |
|---|---|
| `npm run start:dev` | API with reload on change: `http://localhost:3000/api/v1`, Swagger at `/docs` |
| `npm run build` / `start:prod` | Compile to `dist/` and run it |
| `npm run typecheck` · `lint` · `format` | tsc, oxlint, Prettier |
| `npm test` | Unit tests (Vitest) |
| `npm run test:e2e` | E2E tests against `TEST_DATABASE_URL` (migrated automatically) |
| `npm run db:migrate` | Create and apply a migration after editing `prisma/schema.prisma` |
| `npm run db:deploy` | Apply pending migrations (CI and production) |
| `npm run db:seed` | Replace all data with the development dataset |
| `npm run db:reset` | Drop everything, re-apply migrations, seed |
| `npm run db:studio` | Browse the data in Prisma Studio |
| `npm run db:start` · `db:stop` · `db:status` | Local portable PostgreSQL (Windows) |
| `node dist/cli/create-admin.js --name … --phone …` | Create an admin (the first one in production); prints a temporary password |

Production images: `docker build .` (API) and `docker build --target migrate .`
(migrations). See [`docs/RELEASE.md`](../docs/RELEASE.md).

## Notes

- **Prisma versions are pinned** to 7.10.0, because the CLI's `latest` tag is an 8.0 release
  candidate. Upgrade `prisma`, `@prisma/client` and `@prisma/adapter-pg` together.
- The Prisma client is generated into `src/generated/prisma` (git-ignored) by `npm install`.
  Run `npx prisma generate` after pulling schema changes.
- **CHECK constraints** live in `prisma/migrations/*_init/migration.sql`, because Prisma can't
  express them. To add one, create the migration with `npx prisma migrate dev --create-only`,
  append the SQL, then apply it.
- New error codes go in `src/common/errors/error-codes.ts`. The app relies on them, so never rename one.
- Business rules belong in `src/settings/settings.schema.ts` (stored in `app_settings`), not in constants.
