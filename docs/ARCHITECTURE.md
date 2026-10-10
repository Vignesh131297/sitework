# SiteWork architecture

Android app and API for a construction / site-work contractor. This document is the
reference for how the system is built and why. When a decision changes, update it here.

- **Approved:** 2026-10-04 (all clarification defaults accepted).
- **Status:** all ten phases built and tested, plus stock management (phase 11,
  [§15](#15-stock)) and material requests with godown managers (phase 12,
  [§15.5](#155-material-requests)). Going live needs the owner's accounts and keys; see
  [RELEASE.md](RELEASE.md) and [§12 Phases](#12-phases).

---

## 1. What the product is

Four roles share one app:

| Role | Scope |
|---|---|
| **Admin** | Everything: clients, sites, people, payments, reports, stock. Receives staff and engineer notifications. Approves material requests. |
| **Engineer** | Only their assigned sites and the staff on them. Reviews staff updates, reports progress and issues. Requests material for their sites. |
| **Staff** | Only their own site and records. Marks attendance and sends three photo updates a day. |
| **Godown manager** | Only the godowns an admin assigned them. Buys stock in, sends approved requests to sites, confirms returns. |

Only the first admin signs up in the app. After that, admins create every account, other
admins included.

The core is a **daily compliance loop**. Every active staff member sends a geotagged
photo update in each of three server-defined windows (Morning, Afternoon, Evening).
Their responsible engineer and an admin review it. The photo is deleted once both have
seen it, while the record stays. Slots that close without an update are flagged and
escalated. Around that loop sits a contractor back office: clients, sites, assignments,
payment milestones, issues and reports.

## 2. Decisions

Decisions from the approval. Business rules marked ⚙ are stored in `app_settings`
([§5.6](#56-business-rules-app_settings)), so they can change without a release.

| # | Topic | Decision |
|---|---|---|
| 1 | Local database | PostgreSQL 17. On the main dev machine it runs from portable binaries, per user, without admin rights (`scripts/local-postgres.ps1`). Other developers can use `docker-compose.yml`. |
| 2 | Engineers per site | A site can have several. Each staff assignment names one **responsible engineer**, the one whose photo view counts. |
| 3 | Admins | Several allowed. All are notified, and **any one** admin's view counts. |
| 4 | Payments | **Milestones** (amount, due date) plus **payments received**. Payments are applied to milestones oldest-due first. Admins can edit the contract value (audited). No GST in v1. Engineers see totals only. |
| 5 | Engineer and issue photos | Kept (permanent attachments). Only staff update photos are temporary. |
| 6 | Phones and language | Every staff member has their own Android phone. The UI is English, with all strings in ARB files so Tamil can be added. |
| 7 | Project basics | App name **SiteWork**, package **com.sitework.app**. Both are placeholders: confirm before Firebase setup (Phase 6). |
| 8 ⚙ | Late and offline updates | Accepted if captured inside the window and received within **180 min** after it closes; flagged *submitted offline*. Online submissions after the window plus **15 min** grace are rejected. |
| 9 ⚙ | Photo deletion | Deleted **30 min** after both required views. Photos not fully viewed are deleted **24 h** after submission. |
| 10 ⚙ | Working days | **Mon–Sat** plus admin-managed holidays. Staff must check in before updating. Staff who never check in are *Absent*, not "missing updates". |
| 11 ⚙ | Admin pushes | One push per staff update, grouped by site in the tray. A per-site digest is available as a setting. |
| 12 ⚙ | Location | Permission required. No GPS fix within 10 s → allowed and flagged. Mock locations and positions more than 300 m from the site are flagged, not blocked. |
| 13 | Forgot password | Admin resets it → temporary password → forced change at next sign-in. E-mail code for users with e-mail. SMS later. Staff use passwords (no PIN in v1). |
| 14 ⚙ | Attendance | Shift starts 09:00. Late after 09:15. Half day if under 4 h worked. Auto-Absent at day end. Admin corrections need a reason. |
| 15 | Report export | On screen plus CSV in v1. |
| 16 | Navigation | Admin and Engineer get five bottom tabs, with Profile opened from the app-bar avatar. The notifications tab is labelled **Alerts** so it fits. Staff get five tabs, Profile included. |
| 17 ⚙ | Gallery uploads | Allowed but marked *from gallery* for reviewers, and can be switched off. No watermark in v1. |
| 18 | Stock (added 2026-10-08) | Several **godowns**. Moves between godowns and sites take two steps: a DC photo when leaving a godown, and the receiver confirms what arrived with a photo. Purchases carry a price per unit, shown to **admins**, and to a godown manager on the purchases they entered; site costs use the weighted average price. Engineers **and site staff** record usage daily. Materials are added at any time (no fixed list). See [§15](#15-stock). |
| 19 ⚙ | Usage reminder | 18:30 on working days, to the engineers of each running site that holds stock but has no usage recorded that day. |
| 20 | Material requests (added 2026-10-08) | Stock reaches a site **only** through an approved request sent from a godown: the engineer asks, an admin approves (choosing the godown and quantities) or rejects, the godown's manager sends it (in parts if needed), the site confirms with a photo, and the engineer closes it as *all used* or returns the leftover to that godown. No site-to-site moves; engineers return stock to a godown only. See [§15.5](#155-material-requests). |
| 21 | Accounts | Only the first admin signs up (`POST /auth/signup`, closed once any admin exists). Admins create engineers, staff, **godown managers** (assigned to godowns) and other admins. |

## 3. System overview

```
┌─────────────────── Android app (Flutter) ────────────────────┐
│ presentation  screens, widgets ← Riverpod providers          │
│ domain        models, repository contracts, use-cases        │
│ data          Dio API clients, JSON-file offline queue       │
│ core          GoRouter role shells, auth interceptor,        │
│               secure storage, camera, GPS, FCM               │
└──────────────┬────────────────────────────────▲──────────────┘
               │ HTTPS: JSON + multipart        │ push
┌──────────────▼────────────────────┐    ┌──────┴───────┐
│ NestJS API (modular monolith)     │───→│ Firebase FCM │
│ JWT guard → Roles guard → scoping │    └──────────────┘
│ controllers → services → repos    │
│ jobs: missed-slot alerts,         │
│       image cleanup, overdue,     │
│       push dispatch               │
└───────┬──────────────────┬────────┘
        │ Prisma           │ service key (server only)
┌───────▼────────┐  ┌──────▼────────────────────────────┐
│ PostgreSQL     │  │ Supabase Storage (private bucket) │
│ source of truth│  │ temporary photos, signed URLs     │
└────────────────┘  └───────────────────────────────────┘
```

| Area | Decision | Why |
|---|---|---|
| Backend shape | One NestJS app and one database, with strict module boundaries | Right size for this scale; modules can be split out later |
| Background work | Scheduled jobs guarded by a Postgres advisory lock. The `notifications` table is also the push outbox | No Redis in v1; safe with several instances; no lost pushes |
| File storage | Storage interface with `supabase` and `local` drivers; private bucket | The app never holds the service key; development works without cloud accounts |
| Photo access | Uploaded *through* the API (validated); viewed via short-lived signed URLs | No permanent links to temporary photos |
| Time | `timestamptz` everywhere. Business dates and slots are computed on the server in the configured zone (Asia/Kolkata) | The phone's clock never decides |
| Money | `numeric(14,2)`, exact paise arithmetic, strings in JSON, totals derived | No rounding errors; never trusts the app (Rule 12) |
| Submissions | Each update carries a device-generated idempotency key | Offline retries can't duplicate |
| Push | Push interface with `fcm` and `log` drivers | Works before Firebase exists |

## 4. Repository layout

```
sitework/
  backend/            NestJS API (README inside)
  mobile/             Flutter Android app (README inside)
  docs/               this document, RELEASE.md (going live)
  scripts/            local-postgres.ps1, Docker init SQL
  docker-compose.yml  PostgreSQL for developers using Docker
  .github/workflows/  ci.yml (every push), release-android.yml (version tags)
  .vscode/            launch configurations per flavor + API
```

## 5. Backend

### 5.1 Stack

NestJS 12 (ESM, TypeScript 6) · Prisma 7.10 with the `pg` driver adapter · PostgreSQL 17 ·
zod 4 (config) · class-validator (DTOs) · Luxon (time zones) · argon2id (passwords) ·
nestjs-pino (structured logs) · helmet · compression · @nestjs/schedule (jobs) ·
@nestjs/throttler · sharp (photo re-encoding) · firebase-admin (push) · Vitest 4 · oxlint.

The Prisma CLI's `latest` tag currently points at an 8.0 release candidate, so `prisma`,
`@prisma/client` and `@prisma/adapter-pg` are pinned to exactly **7.10.0**. Upgrade
them together.

### 5.2 Layout

```
backend/
  prisma/
    schema.prisma            source of truth for the database
    migrations/              SQL migrations (CHECK constraints added by hand in init)
    seed.ts, seed/           realistic dev data, relative to "today"
  prisma.config.ts           Prisma 7 config (datasource URL, seed command)
  Dockerfile                 API image, plus a one-shot migration image
  src/
    main.ts                  bootstrap, Swagger (non-prod), listen
    app.setup.ts             HTTP setup shared with e2e tests (prefix, proxy, helmet, gzip)
    app.module.ts            config, logger, global pipe/filter/interceptor, feature modules
    config/env.ts            env schema, validated at boot
    common/                  errors, envelope, validation, pagination, time, money, location,
                             access scoping (siteScope / staffScope), audit, request logging
    auth/ users/             sign-in, sessions, guards, password rules, /me
    clients/ sites/ people/  back office: clients, sites, engineers, staff, assignments
    attendance/              check-in/out, admin marks and corrections, auto-absent
    staff-updates/           slot updates, missed-slot detection, photo views and cleanup,
                             the staff member's day, the site's day board
    engineer-updates/        engineer reports to admins (permanent photos via attachments/)
    issues/                  site issues, resolve and reopen
    payments/                milestones, payments, voids, site money, overdue alerts
    stock/                   godowns, materials, stock entries and balances (see §15)
    reports/                 date-range reports and CSV export
    dashboard/               admin and engineer dashboards
    notifications/ push/     inbox (also the push outbox), device tokens, FCM
    storage/ images/         Supabase or local storage, signed links, JPEG re-encoding
    jobs/                    scheduled jobs behind a Postgres advisory lock
    settings/                business rules: schema, defaults, cached service, holidays
    mail/ health/ prisma/
    generated/prisma/        generated client (git-ignored; created on npm install)
  test/                      e2e suites (separate database) and their support code
```

Each feature module has a **controller** (HTTP and DTO validation only) and a **service**
(business rules and scoping, using Prisma directly). Rules such as slot status, payment
allocation and attendance status are plain functions with unit tests.

### 5.3 Request pipeline

```
request-id middleware → helmet → gzip (over 1 KB) → body parser
  → JwtAuthGuard (session re-read from the database) → RolesGuard → throttler
  → ValidationPipe (whitelist, reject unknown fields, transform)
  → controller → service (rules + scope) → Prisma
  → ResponseEnvelopeInterceptor        errors → AllExceptionsFilter
```

Requests the guards turn away don't count towards rate limits. Each request is logged as
one line: id, method, path, status, user id and duration. Headers are never logged, and
signed file links are logged without their signature.

### 5.4 API contract

- Base path `/api/v1`. Swagger UI at `/docs` outside production.
- Success: `{ "success": true, "data": … }`. Paginated lists add `"meta": { page, limit, total, totalPages }`.
- Error: `{ "success": false, "code": "NOT_FOUND", "message": "…", "details"?: [{ field, message }], "requestId": "…" }`.
- Codes live in `src/common/errors/error-codes.ts` and are part of the contract: add, never rename.
  Feature codes (e.g. `UPDATE_ALREADY_SUBMITTED`) are added with their feature, and their
  messages are written for end users.
- Server errors never expose internals. 5xx responses always carry the generic message and the
  details go to the logs, findable by `requestId`. Every response echoes `x-request-id`.
- Money is a decimal string (`"850000.00"`). Instants are ISO-8601 UTC. Business dates are `YYYY-MM-DD`.

### 5.5 Configuration

`src/config/env.ts` validates the environment at boot and lists every problem at once.
Secrets come only from the environment (`.env` locally, never committed; see
`.env.example`). Production refuses the development-only drivers (`STORAGE_DRIVER=local`,
`PUSH_DRIVER=log`, `MAIL_DRIVER=log`). Deployment settings worth knowing: `TRUST_PROXY`
(behind a load balancer), `RATE_LIMIT_PER_MINUTE` (default 300 per user) and
`JOBS_ENABLED`. [RELEASE.md](RELEASE.md) has the full list.

### 5.6 Business rules (`app_settings`)

One row per group, validated by `src/settings/settings.schema.ts`. Missing or invalid
values fall back to the defaults, and invalid ones are logged. Values are cached for 30 s.

| Group | Default |
|---|---|
| `business` | time zone `Asia/Kolkata`, working days Mon–Sat |
| `updates` | Morning 10:00–12:00 · Afternoon 13:00–15:00 · Evening 16:00–19:00; grace 15 min; offline acceptance 180 min; check-in required; gallery allowed |
| `images` | TTL 24 h; expiry action DELETE; delete grace 30 min; max upload 5 MB |
| `location` | required; fix timeout 10 s; site radius 300 m; outside-site FLAG; mock FLAG |
| `attendance` | shift 09:00; late after 15 min; half day under 4 h; auto-absent |
| `notifications` | admin staff-update push EACH; missed-update digest on |
| `stock` | usage reminders on, at 18:30 |

### 5.7 Time

All instants are `timestamptz` (UTC). Business dates (`work_date`, `due_date`) are `DATE`
values computed on the server in the business time zone (`src/common/time/business-time.ts`).
The `/health` response gives the app the server clock and today's business date. The phone
uses them for display only, and the server re-checks every time-based rule.

### 5.8 Money

`numeric(14,2)` in the database. Arithmetic uses integer paise (`bigint`) in
`src/common/money/money.ts`. Received and pending amounts and milestone status are always
**derived**, never stored or accepted from the app. Payments are never deleted: mistakes are
**voided** with a reason and audited.

### 5.9 Tests

- `npm test`: unit tests for the pure rule modules (time, money, settings, slots, allocation,
  location, CSV, password rules, request logging, config).
- `npm run test:e2e`: boots the real app against the **separate** `sitework_test` database.
  It migrates that database first and never touches the dev database. A fake clock drives
  every time-based rule. Besides one suite per feature there are:
  - **Permission matrix.** It discovers every route from the controllers and checks that
    anonymous callers get 401 and wrong roles get 403. A new route without `@Roles` fails
    until it is reviewed and added to the list any signed-in user may call.
  - **Across teams.** An engineer and a staff member try another team's sites, staff,
    photos, reports and issues by id (404) and through list filters (empty results).
- CI (`.github/workflows/ci.yml`) runs all of this against PostgreSQL 17 on every push. It
  also checks that the seed loads and that both Docker images build.

## 6. Database

The source of truth is [`backend/prisma/schema.prisma`](../backend/prisma/schema.prisma).

### 6.1 Conventions

- UUIDv7 keys (time-ordered). snake_case tables and columns.
- Users are never hard-deleted (deactivated instead), and history is protected with `ON DELETE RESTRICT`.
- Rules Prisma can't express are CHECK constraints in the init migration. Prisma leaves
  them alone in later migrations (verified):
  - designation only for staff
  - non-negative or positive amounts
  - progress between 0 and 100
  - completion date on or after start
  - only ABSENT attendance may lack a check-in
  - check-out not before check-in
  - `image_key IS NULL` exactly when the photo is DELETED
  - an attachment has exactly one owner (an engineer update, an issue or a stock entry)
  - stock: places match their godown or site id, stock always goes somewhere else, only moves between godowns and sites wait for the receiver, a line never receives more than was sent, only purchases carry a price
  - material requests: quantities above zero, approved ones name a godown, rejected ones a reason, closed ones an outcome

### 6.2 Tables

| Group | Tables |
|---|---|
| Identity | `users` (role enum: ADMIN, ENGINEER, STAFF, GODOWN_MANAGER), `auth_sessions`, `device_tokens`, `password_reset_codes` |
| Sites | `clients`, `sites`, `engineer_assignments`, `staff_assignments`, `assignment_history` |
| Field activity | `attendance`, `staff_updates`, `missed_updates`, `engineer_updates`, `issues`, `attachments` |
| Money | `payment_milestones`, `payments` |
| Stock | `godowns`, `godown_assignments` (managers), `materials`, `stock_entries` (one per form), `stock_movements` (one line per material), `material_requests`, `material_request_lines` |
| Platform | `notifications` (inbox and push outbox), `app_settings`, `holidays`, `audit_logs` |

Refinements made during implementation, relative to the approved proposal:

- **Assignments hold only the current state.** `staff_assignments` has one row per staff member,
  enforced by a unique `staff_id`. `engineer_assignments` has one row per site and engineer.
  Ended assignments move to `assignment_history`. Queries never need an "is active" filter,
  and the uniqueness rules are plain constraints.
- **The responsible engineer must be on the site.** `staff_assignments (site_id, engineer_id)`
  is a composite foreign key to `engineer_assignments`. The database itself prevents removing
  an engineer from a site while staff still report to them there.
- **`missed_updates`** records the resolution when an offline update for that slot is accepted
  later (`resolved_at`, `resolved_by_update_id`).
- **`staff_updates.engineer_viewed_by` was dropped.** Only the engineer recorded at submission
  (`engineer_id`) can satisfy the engineer view.

### 6.3 Key constraints

| Rule | Enforced by |
|---|---|
| One official update per staff/site/date/slot (Rule 5) | `UNIQUE (staff_id, site_id, work_date, slot)` |
| Offline retries never duplicate | `UNIQUE client_submission_id` |
| A missed-slot alert fires once | `UNIQUE (staff_id, work_date, slot)` on `missed_updates` |
| No duplicate notification per recipient | `UNIQUE (recipient_id, dedupe_key)` |
| One attendance row per staff per day | `UNIQUE (staff_id, work_date)` |

### 6.4 Seed data

`npm run db:seed` replaces all data with a deterministic dataset whose dates are relative
to today:
- the spec's people, clients and sites
- two weeks of attendance and slot updates, including late check-ins, half days, absences, missed slots and offline uploads
- photos in every lifecycle state
- payment milestones totalling ₹24,50,000 received and ₹8,50,000 pending, two of them overdue
- engineer updates, issues and the notifications they would have produced
- two godowns, each with a manager, three weeks of stock, and material requests in every state (one waiting for approval, one part sent with its delivery on the way, one rejected, two closed with leftovers returned)

Development logins:

| Role | Login | Password |
|---|---|---|
| Admin | `+919000000001` or `admin@sitework.test` | `Admin@123` |
| Engineer (Arun Kumar) | `+919000000011` or `arun@sitework.test` | `Engineer@123` |
| Staff (Ravi) | `+919000000101` | `Staff@123` |
| Godown manager (Selvam, Main godown) | `+919000000201` | `Godown@123` |
| Godown manager (Karthik, Porur godown) | `+919000000202` | `Godown@123` |

## 7. Mobile app

### 7.1 Stack

Flutter 3.47 / Dart 3.13 · Riverpod 3 (manual providers, no code generation) ·
GoRouter 18 · Dio 5 · freezed and json_serializable · intl · **material_ui** · image_picker ·
geolocator (permissions only) · flutter_secure_storage · firebase_messaging and
firebase_crashlytics (both optional) · share_plus (CSV export).

> **Material library.** Flutter 3.47 ships Material twice: inside the framework
> (`package:flutter/material.dart`) and as the new `material_ui` package. go_router 18
> already uses `material_ui`, so the app imports **`package:material_ui/material_ui.dart`**
> everywhere and uses `material_ui`'s `GlobalMaterialLocalizations.delegates`. Don't import
> `flutter/material.dart`, because themes and localizations from the two don't mix. Wrap any
> third-party widget that still uses the old library in `MaterialUiCompatibilityBridge`.

### 7.2 Layout

```
mobile/
  env/                     dev.json, dev-usb.json, staging.json, prod.json (no secrets)
  android/app/src/<flavor> per-flavor app name; dev allows HTTP to the local API
  android/app/src/main/kotlin/.../CurrentLocationChannel.kt   one-shot position (see 7.7)
  lib/
    main.dart → bootstrap.dart (crash reporting) → app.dart
    core/
      config/              AppConfig from --dart-define-from-file
      firebase/            optional Firebase start-up and crash reporting
      l10n/                app_en.arb (+ generated/)
      network/             ApiClient, AppException, Dio error mapping, user messages, retry policy
      routing/             routes, redirect guard, role shells and tabs, area helpers
      location/ media/     GPS, camera and gallery picker
      time/ files/         server clock, share sheet
      theme/ utils/ widgets/
    features/              auth, profile, system, dashboard, sites, clients, people,
                           attendance, staff_updates, engineer_updates, issues,
                           notifications (with push), payments, reports, stock;
                           each with data / domain / presentation
  test/                    unit and widget tests; contract/ holds responses recorded from
                           the real API (refresh with tool/capture_contract_fixtures.dart)
```

Layer rules:
- Widgets never call Dio or contain business rules.
- Repositories and API classes live in `data/`. Models live in `domain/`. Screens and providers live in `presentation/`.
- One freezed model per entity, unless the API shape differs from what the UI needs.

The contract tests decode every recorded response into the app's models. A screen tour
then opens every screen for each role with those responses. It fails on errors,
overflows, and requests the recording can't answer.

### 7.3 Routing

Each role's screens live under its area: `/admin/*`, `/engineer/*`, `/staff/*` or `/godown/*`
(godown managers: Home, Requests, Stock and Alerts tabs).
`redirectFor` (pure and unit-tested) sends signed-out users to `/login`, sends signed-in users
to their home, and keeps them inside their own area. This only shapes navigation: the API
enforces every permission.

Each role has a `StatefulShellRoute` with a bottom navigation bar. Detail and form screens are
full-screen routes above the shell, opened with `push`, so Back returns to where the user
was. Tabs are opened with `go`. Screens that admins and engineers share (site, photo,
engineer update, issue, reports) are registered under both areas and build their links
from `areaPathProvider`. Notifications and pushes open the same routes.

### 7.4 Errors

The data layer throws only `AppException`: `NetworkException` (offline or timed out),
`ApiException` (the server's envelope: code, message, details, requestId) or
`UnexpectedException`. Screens show `userMessage(l10n)`:
- generic codes get translated text, so technical server text is never shown
- feature codes show the server's user-facing message

Riverpod retries only `NetworkException`, three times with back-off.

### 7.5 UI

- Material 3, with a navy brand colour and a safety-orange accent. Light and dark themes.
- Status tones (`success`, `warning`, `danger`, `info`, `neutral`) come from a theme extension.
- Primary actions are at least 52 dp tall.
- Staff screens favour large single actions. Admin screens can be dense.
- Every screen handles loading, empty and error states.

### 7.6 Configuration and flavors

`--flavor dev|staging|prod` installs separate apps: `com.sitework.app.dev`, `.staging`, and the
plain ID for prod. `--dart-define-from-file=env/<file>.json` supplies `APP_ENV` and
`API_BASE_URL`. Only the dev flavor allows plain HTTP, and only to `10.0.2.2` (emulator) and
`localhost` (USB phone with `adb reverse`). minSdk is 24 (Android 7.0). targetSdk follows Flutter.

The Firebase settings (`FIREBASE_*`) are optional and not secrets. Without them, push and
crash reports are off and alerts arrive by polling. Release signing reads
`android/key.properties` (git-ignored); without it, release builds use the debug key. App
data is excluded from Android backups (`data_extraction_rules.xml`).

### 7.7 Field data on the phone

- **Offline queue.** An update that can't be sent is kept as a JSON file plus its photo in the
  app's private folder. It is sent when the staff area opens, when the app returns to the
  foreground, and every 30 s while any wait. Each update
  carries its `clientSubmissionId`, so retries never duplicate. The phone deletes its copy
  once the server has it.
- **Server clock.** Capture times are corrected by the phone's offset from the server clock,
  as last seen in a response. The server still judges every window itself.
- **Location.** On Android, positions come from a native one-shot request
  (`CurrentLocationChannel.kt`, fused provider). Geolocator is used only for permissions,
  because its listener deadlocked the Android 17 emulator's location service. If the user
  allowed only approximate location, the app says so and offers the settings page. The admin
  site form refuses approximate positions.

## 8. Authentication (Phase 2)

```
LOGIN
 app  POST /auth/login { identifier: phone or email, password, deviceName }
 api  find user → active? → argon2 verify  (10 tries a minute per phone and IP;
      5 wrong passwords in a row lock the account for 15 min)
      create auth_session → access JWT (15 min; sub, role, sid)
                          + refresh token "sid.secret" (30 days; only a hash stored)
 app  store both in flutter_secure_storage (Android Keystore)
      → GET /me → redirect by role → register FCM token
      → must_change_password? → forced Change Password screen

EVERY REQUEST
 api  JwtAuthGuard: verify token, reload user by id (inactive → 401)
      RolesGuard: @Roles(...)
      Scope: every query filtered to what this user may see
      (out-of-scope id → 404, so other sites' records aren't revealed)

EXPIRY
 app  401 TOKEN_EXPIRED → one refresh at a time (other requests wait) → retry
 api  refresh token rotated on every use; an already-used token presented
      again (copied/stolen) → whole session revoked; user deactivated → revoked

LOGOUT / CHANGE PASSWORD
      logout: revoke session + delete device token → /login
      change password: verify current → revoke all other sessions
```

The role is never taken from the app. It comes from the server-signed token and is re-checked
against the database on every request, so deactivation is immediate.

**First admin.** `GET /auth/signup` says whether sign-up is open, which is only while no admin
exists; the login screen then offers "Set up SiteWork". `POST /auth/signup` creates that admin
and signs them in. An advisory lock makes two simultaneous sign-ups produce one admin; after
that it answers `SIGNUP_CLOSED`. Admins can't deactivate themselves, so one active admin
always remains.

## 9. Staff photo lifecycle (Phase 4)

```
                     AVAILABLE  (image_expires_at = submitted_at + TTL)
                         │
        ┌────────────────┼─────────────────────────┐
        ▼                ▼                         ▼
 engineer views     admin views          expiry job: not both viewed
 (snapshot eng.)    (any admin)          by image_expires_at (24 h)
        └──── both ──────┘                         │
                │                                  │
                ▼                                  ▼
 READY_FOR_DELETION (ALL_VIEWED)     READY_FOR_DELETION (EXPIRED)
                └────────────────┬─────────────────┘
                                 ▼  cleanup job, every 5 min (+ grace)
           delete object from storage → image_key = NULL,
           image_status = DELETED, image_deleted_at = now
           (on failure: attempts + 1, retried next run, up to 10 times)
```

- **Viewed** means the full-size photo rendered on screen. The app then calls
  `POST /staff-updates/:id/views`. Lists, pushes and opened notifications don't count.
- Each view and the status change happen in one conditional SQL `UPDATE`, so simultaneous
  views can't leave the photo stuck.
- Only the server deletes. Jobs hold an advisory lock. A daily sweep removes storage objects
  no record points to.
- No hidden copies: no thumbnails in lists, no disk cache, no save or share, and the phone
  deletes its copy after upload.
- The record (who, where, when, viewed when, deleted why) is kept permanently.

## 10. Notifications (records in Phase 4, push in Phase 6)

```
Business action ─ same DB transaction ─→ INSERT notifications (push_status PENDING)
                                         ON CONFLICT (recipient_id, dedupe_key) DO NOTHING
Push dispatcher (every 15 s, advisory-locked, batches of 200)
  → FCM → SENT | NO_DEVICE | retried, then FAILED after 3 attempts or 60 min;
          tokens FCM reports as dead are deleted
App: foreground snack bar with "View"; tap → route by reference_type
     (opening a notification is not viewing the photo)
```

| Event | Recipients | Duplicate protection |
|---|---|---|
| Staff update submitted | its engineer and all active admins | one per update |
| Engineer update or issue | all active admins | one per record |
| Issue status changed | reporting engineer | — |
| Slot missed | each missing staff member's engineer, plus admins | one summary per recipient, site and slot |
| Milestone overdue | admins | once per milestone |
| Stock sent between godowns and sites | the receiving site's engineers, or the receiving godown's managers (admins when it has none) | once per entry |
| Stock written off by an engineer or godown manager | admins | once per entry |
| Delivery confirmed short | admins and the sending godown's managers | once per entry |
| Material request made | admins | once per request |
| Request approved | the site's engineers; the godown's managers ("Send MR-0012 to …") | once per request |
| Request rejected | the site's engineers | once per request |
| Request closed | admins and the godown's managers | once per request |
| All godowns below a material's minimum | admins | once per drop below it |
| No usage recorded today (18:30) | the site's engineers | once per site and day |

Wording lives in `src/notifications/notification-messages.ts`, shared with the seed.
Pushes use Android's default channel at high priority. Android's automatic bundling groups
several pushes from the app; there is no per-site group (a known limitation). The app also
polls the unread count every minute, so alerts arrive without Firebase.

### Scheduled jobs

| Job | When | What |
|---|---|---|
| slots | every minute | reminders before a slot closes; missed-slot detection after |
| push | every 15 s | push dispatch |
| photos | every 5 min | expire unviewed photos, delete those due |
| absentees | every 15 min, after day end | mark staff who never checked in as Absent |
| overdue | hourly | overdue-milestone alerts |
| orphans | daily 03:17 | delete storage objects no record points to |
| stock-usage | every 15 min | after the reminder time on working days, the daily usage reminder |

## 11. Security

Reviewed in Phase 10.

| Area | In place |
|---|---|
| Identity | argon2id with OWASP parameters. Short access tokens (15 min). Rotating refresh tokens, stored hashed; reusing an old one ends the session. Session and user re-read on every request, so logout and deactivation are immediate. Lockout after 5 wrong passwords. |
| Authorization | Role from the signed token, checked against the database, never from the app. `@Roles` on every route not meant for all users, enforced by the permission-matrix test. Per-record scoping, with 404 for other teams' records (tested across teams). Site, staff assignment, payment totals and money visibility are decided by the server. |
| Input | DTO whitelisting that rejects unknown fields. Size limits on JSON and multipart. Photos re-encoded to JPEG with metadata stripped and a pixel limit. Parameterized SQL only. |
| Abuse | Rate limits per user (signed in) and per phone and IP (sign-in, reset). `TRUST_PROXY`, so limits see the real client behind a load balancer. |
| Data | Private storage bucket and short-lived signed links. Staff photos deleted server-side. Payments voided, never deleted. Audit log of sensitive changes. CHECK and foreign-key constraints. |
| Transport | HTTPS for staging and production; plain HTTP only in the dev flavor, to the local API. helmet headers. No CORS (there are no browser clients). |
| Errors and logs | Sanitized errors with request ids. Logs without headers, tokens or file signatures. Swagger off in production. |
| Secrets | Environment only. `.env`, `key.properties` and keystores git-ignored. CI secrets generated per run; release signing from repository secrets. |
| Phone | Tokens in Android Keystore-backed secure storage. App data excluded from backups. No photo caching on disk. Mock locations flagged. |
| Dependencies | `npm audit` clean for production dependencies, and checked in CI. |

Rule of thumb: never trust the app for role, totals, site ownership or assignment.

Left to the owner before going live (details in [RELEASE.md](RELEASE.md)):
- long random JWT secrets, different in each environment
- HTTPS in front of the API, with `TRUST_PROXY` set to match
- the Supabase service key kept on the server only
- database backups turned on at the host
- Google Play's Data safety form (location, photos, crash data)

## 12. Phases

| # | Phase | Status |
|---|---|---|
| 1 | Foundation: repo, database, API skeleton, full schema and seed, Flutter skeleton, flavors | **Done** |
| 2 | Auth: login, refresh, logout, password change, guards, scoping, role redirect | **Done** |
| 3 | Admin core: dashboard, clients, sites, people, assignments | **Done** |
| 4 | Staff: attendance, slot updates, offline queue, photo lifecycle, notification records | **Done** |
| 5 | Engineer: dashboard, staff board, photo viewer, engineer updates, issues | **Done** |
| 6 | Push: Firebase, device tokens, dispatcher, deep links, missed-slot summaries | **Done** |
| 7 | Payments: milestones, receipts, voiding, overdue job | **Done** |
| 8 | Reports, with CSV export | **Done** |
| 9 | Hardening: integration and permission tests, performance | **Done** |
| 10 | Release: signing, Crashlytics, logging, security review, Play Store | **Done** (publishing needs the owner's accounts: [RELEASE.md](RELEASE.md)) |
| 11 | Stock: godowns, materials, purchases with prices, deliveries with DC and photos, usage, returns, write-offs, counts, reports | **Done** |
| 12 | Material requests, godown managers, first-admin sign-up, admins creating admins | **Done** |

Each phase ends runnable and with tests for its rules.

## 13. Conventions

- Keep business logic out of widgets and controllers. API calls stay out of widgets.
- Prefer small files. Write rules as pure functions with unit tests.
- Comment only where the reason isn't obvious from the code.
- Add error codes; never rename them. User-facing strings go in ARB files.
- Never hard-code a business rule that belongs in `app_settings`.

## 14. Performance

Measured in Phase 9 on a laptop, with the production build and a year of synthetic data:
10 sites, 100 staff, 31k attendance days, 82k photo updates and 7k missed slots.

| Request | Alone | 10 at once (p50 / p99) |
|---|---|---|
| Admin dashboard | 67 ms | 251 / 777 ms |
| Photo list (20) | | 76 / 133 ms |
| Site report, 365 days | 60 ms | 232 / 403 ms |
| Staff report, 365 days | 70 ms | 377 / 706 ms |
| Engineer report, 365 days | 114 ms | 497 / 1095 ms |
| Unread count | | 41 / 83 ms |

Two problems were found and fixed:
- Photo lists sorted the whole table. New indexes on `submitted_at` and
  `(staff_id, submitted_at)` took that query from 81 ms to 0.2 ms.
- The engineer report loaded a year of photos into memory. It is now one SQL aggregate.

Responses over 1 KB are gzipped. A contractor's real load is tens to a few hundred users,
polling once a minute, which is far below these figures.

## 15. Stock

Added on 2026-10-08 at the client's request: materials, how much is in each godown and at
each site, what sites use, and what is left over going back.

### 15.1 Model

Every stock change is an **entry** (one form: a purchase, a delivery, a day's usage, a
write-off or a count) with **lines**, one per material. Each line moves a quantity from one
place to another. Places are a godown, a site, or the outside world: the supplier, *used*,
*waste*, and count corrections.

```
 Supplier ──buy──▶ GODOWN ──send against an approved request (DC photo)──▶ SITE ──use──▶ Used
                   ▲   ▲                                                    │  │
                   │   └──── return (leftover, or closing the request) ─────┘  └── write off ──▶ Waste
                   └── godown to godown
```

Sites never send to each other: a site returns what it doesn't need to a godown, and
another site requests it.

- **Balances are never stored.** A place holds what arrived there minus what left it, summed
  in one query over `stock_movements` (see `src/stock/stock-ledger.ts`, unit-tested). The
  lines repeat their entry's places, status and dates so that the sum needs no join.
- **Two steps between holders.** Stock leaving a godown or site is gone from the sender at
  once (`IN_TRANSIT`). It counts at the receiver only once they confirm it, with what actually
  arrived and at least one photo. Anything short needs a note, and admins are told.
- **Quantities are exact.** `numeric(12,3)`, integer thousandths in code
  (`src/common/quantity/quantity.ts`), and decimal strings in JSON.
- **Nothing is deleted.** Mistakes are cancelled (voided) with a reason. A cancellation that
  would leave a receiver below zero is refused.
- **No place gives more than it holds.** The materials' rows are locked (`FOR UPDATE`, in id
  order) while a form is checked and written, so two forms can't both take the last bag.
- **Retries are safe.** Every form carries a `requestId` made on the phone.

### 15.2 Who does what

| | Admin | Godown manager (own godowns) | Engineer (own sites) | Site staff (own site) |
|---|---|---|---|---|
| Godowns, assigning managers | ✓ | | | |
| Materials (added at any time) | ✓ | ✓ | | |
| Buy into a godown, with price per unit | ✓ | ✓ | | |
| Request material for a site | ✓ | | ✓ | |
| Approve or reject a request | ✓ | | | |
| Send to a site against an approved request (DC photo) | ✓ | ✓ | | |
| Send between godowns (DC photo) | ✓ | ✓ (from theirs) | | |
| Return from a site to a godown | ✓ | | ✓ | |
| Confirm a delivery or return (photo required) | ✓ | at their godowns | at their sites | |
| Record usage | ✓ | | ✓ | ✓ |
| Close a request (all used, or leftover returned) | ✓ | | ✓ | |
| Write off | ✓ | ✓ (admins are told) | ✓ (admins are told) | |
| Count, recording the difference | ✓ | ✓ | | |
| See godown stock | ✓ | their godowns | quantities | |
| Prices and values | ✓ | their own purchases | | |

Admins cancel anything (with a reason). Others cancel only what they recorded themselves, on
the same day: staff their usage, engineers their usage and write-offs, godown managers their
purchases, write-offs and counts. Engineers and godown managers may also cancel stock sent
from their site or godown while it is on the way.

### 15.3 Prices

Purchase lines carry a `rate` (₹ per unit). A material's price is the **weighted average**
of its purchases: everything paid divided by everything bought, up to the report's end date.
Site values, the stock report's *Used value* and material pages use it. Prices and values
are left out of every response for non-admins, except that a godown manager sees the prices
on purchases they entered themselves.

### 15.4 Low stock

A material with a minimum is *low* when all godowns together, plus whatever is on its way to
a godown, fall below it. Admins get one alert each time a drop takes it below the minimum.
Moving stock between godowns never looks like a drop.

### 15.5 Material requests

Added on 2026-10-08: stock reaches a site only through a request.

```
 engineer asks ──▶ PENDING ──admin approves (godown + quantities)──▶ APPROVED ──engineer closes──▶ CLOSED
                     │  │                                              │            (all used, or leftover
                     │  └── admin rejects (reason) ──▶ REJECTED         │             returned to the godown)
                     └── site or admin withdraws ──▶ CANCELLED          │
                                                                        ▼
                         godown manager sends (DC photo; in parts if needed) ──▶ site confirms (photo)
```

- **Numbered** `MR-0001` onwards (`material_requests.number`), so people can quote them.
- **Approval** names the godown and an approved quantity per material (zero: not supplied).
  The godown's managers are told what to send; the site is told who sends it.
- **Sending** is an ordinary transfer from that godown to that site carrying the request's id.
  The request row is locked while a delivery is checked, so deliveries never add up to more
  than was approved (`REQUEST_EXCEEDED`). How much has been sent, has arrived, is on the way
  and is left to send is worked out from the deliveries (`src/stock/request-progress.ts`),
  never stored. Cancelling a delivery frees its quantity again.
- **Closing** waits until nothing is on the way. With a leftover, the return to the
  request's godown and the close are written in one transaction, so neither happens without
  the other; the godown's manager confirms the return like any delivery.
- **Who sees what.** Admins see every request; engineers their sites'; godown managers the
  approved and closed requests of their godowns. The server says what the caller may do with
  each one (`canApprove`, `canCancel`, `canSend`, `canClose`).
- **Dashboards.** Admins see requests to approve, engineers their open requests, and godown
  managers requests still to send, returns to confirm and low stock (`GET /dashboard/godown`).
