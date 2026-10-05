# SiteWork

Android app and API for a construction / site-work contractor: sites, clients,
payments, staff attendance and the three-times-a-day photo updates that engineers
and admins review.

| Part | Stack | Folder |
|---|---|---|
| API | NestJS 12 · Prisma 7 · PostgreSQL 17 | [`backend/`](backend/) |
| App | Flutter 3.47 · Riverpod · GoRouter · Dio | [`mobile/`](mobile/) |
| Design | Architecture, schema, rules, security, performance | [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) |
| Going live | Accounts, deployment, Play Store | [`docs/RELEASE.md`](docs/RELEASE.md) |

**Status:** all ten phases are built and tested. Going live needs the owner's accounts
and keys; see [RELEASE.md](docs/RELEASE.md).

## Prerequisites

- Node.js 24 (24.15 or newer avoids npm engine warnings)
- Flutter 3.47 with the Android SDK, plus an emulator or an Android phone
- PostgreSQL 17, one of:
  - **Windows without admin rights:** the portable setup below
  - **Docker:** `docker compose up -d` (see `docker-compose.yml`)

## 1. Database

Portable PostgreSQL (what this machine uses). The binaries go in
`%LOCALAPPDATA%\Programs\PostgreSQL\17` (EDB "binaries" zip), and the data in
`%LOCALAPPDATA%\PostgreSQL\17\data`.

```powershell
powershell -ExecutionPolicy Bypass -File scripts/local-postgres.ps1 init    # once: cluster, role, databases
powershell -ExecutionPolicy Bypass -File scripts/local-postgres.ps1 start   # after each reboot
```

`init` prints `DATABASE_URL` and `TEST_DATABASE_URL` for `backend/.env`. The superuser
password is saved in `.local/postgres-superuser.txt` (git-ignored). From `backend/` you can also
use `npm run db:start`, `db:stop` and `db:status`.

## 2. API

```powershell
cd backend
copy .env.example .env      # then fill in DATABASE_URL, TEST_DATABASE_URL and the two JWT secrets
npm install                 # also generates the Prisma client
npm run db:migrate          # apply migrations
npm run db:seed             # realistic sample data (dates relative to today)
npm run start:dev           # http://localhost:3000/api/v1/health · Swagger: http://localhost:3000/docs
```

In development, photos are stored in `backend/storage/`, pushes and e-mails are only
logged, and scheduled jobs run inside the API.

## 3. App

```powershell
cd mobile
flutter pub get
flutter run --flavor dev --dart-define-from-file=env/dev.json        # emulator
```

On a phone connected over USB, run `adb reverse tcp:3000 tcp:3000`, then use
`--dart-define-from-file=env/dev-usb.json`. VS Code has a launch configuration for each
of these (open the `sitework` folder).

The dev build's sign-in screen has one-tap buttons for the seeded accounts:

| Role | Login | Password |
|---|---|---|
| Admin | `+919000000001` or `admin@sitework.test` | `Admin@123` |
| Engineer (Arun Kumar) | `+919000000011` or `arun@sitework.test` | `Engineer@123` |
| Staff (Ravi) | `+919000000101` | `Staff@123` |

Push notifications and crash reports need Firebase settings in `env/*.json`
([RELEASE.md §3](docs/RELEASE.md#3-firebase-push-and-crash-reports)). Without them the
app polls for alerts instead.

## Tests

```powershell
cd backend; npm run typecheck; npm run lint; npm test; npm run test:e2e
cd mobile;  flutter analyze; flutter test
```

`test:e2e` uses the separate `sitework_test` database and never the dev data. It
includes a permission matrix over every API route, and cross-team access checks. The
app's contract tests use responses recorded from the real API. After changing the API,
refresh them with `dart run tool/capture_contract_fixtures.dart`, with the dev API
running on seed data.

CI (`.github/workflows/ci.yml`) runs all of the above on every push, and also builds the
API's Docker images. Pushing a tag such as `v1.0.0+1` builds a signed Play Store bundle
(`.github/workflows/release-android.yml`).
