# Releasing SiteWork

How to put the API online and publish the Android app. Everything in the code is
ready; what is left needs accounts and keys that only the owner can create. Nothing
on this list is stored in the repository.

## 1. What you need

| Item | Used for | Where it goes |
|---|---|---|
| A host that runs Docker images, with HTTPS (Render, Railway, Fly.io, a VPS with Caddy or nginx, …) | the API | — |
| PostgreSQL 17, managed, with automatic backups | the database | `DATABASE_URL` |
| A Supabase project with a **private** Storage bucket | photos | `SUPABASE_URL`, `SUPABASE_SERVICE_KEY`, `SUPABASE_BUCKET` |
| A Firebase project with an Android app per package name | push notifications, crash reports | server: service account; app: four `FIREBASE_*` settings |
| SMTP account (optional) | e-mailed password-reset codes | `SMTP_URL`, `MAIL_FROM` |
| A Google Play developer account | publishing | — |
| An upload keystore | signing the app | `android/key.properties`, or CI secrets |
| A domain for the API, e.g. `api.yourcompany.in` | the app's server address | `mobile/env/prod.json` |

> **Decide the app name and package now.** `SiteWork` and `com.sitework.app` are
> placeholders. The package can't change once the app is on Google Play. Change it in
> `mobile/android/app/build.gradle.kts` (`applicationId`, `namespace`), in the Kotlin
> package folder, and in the Firebase apps. Change the name in the `app_name` strings
> under `mobile/android/app/src/*/res/values/`.

## 2. The API

### Environment

Set these on the host (see `backend/.env.example` for every option):

| Variable | Production value |
|---|---|
| `NODE_ENV` | `production` |
| `HOST`, `PORT` | `0.0.0.0`, and the port your host expects (default 3000) |
| `LOG_LEVEL` | `info` |
| `DATABASE_URL` | the managed database's connection string (with `sslmode=require` if offered) |
| `JWT_SECRET`, `JWT_REFRESH_SECRET` | two different random strings of 64+ characters (`openssl rand -hex 32`). Changing them signs everyone out. |
| `STORAGE_DRIVER` | `supabase`, plus `SUPABASE_URL`, `SUPABASE_SERVICE_KEY` (service role key; server only) and `SUPABASE_BUCKET` |
| `PUSH_DRIVER` | `fcm`, plus `FIREBASE_PROJECT_ID`, `FIREBASE_CLIENT_EMAIL`, `FIREBASE_PRIVATE_KEY` from a service-account JSON |
| `MAIL_DRIVER` | `smtp` with `SMTP_URL` and `MAIL_FROM`, or `disabled` (admins then reset passwords) |
| `TRUST_PROXY` | `1` when one load balancer or proxy sits in front, as on most hosts |
| `JOBS_ENABLED` | `true` (safe on several instances: jobs take a database lock) |

The API refuses to start in production with development drivers or missing settings,
and it lists every problem at once.

### Build and deploy

From `backend/`:

```bash
docker build -t sitework-api .                      # the API
docker build -t sitework-migrate --target migrate .  # applies database migrations
```

Each release:

1. Run `sitework-migrate` once with `DATABASE_URL` set. It applies new migrations and exits.
2. Start or replace `sitework-api`. It listens on `PORT`.
3. Check `https://<api domain>/api/v1/health`. It should report `"status":"ok"` and
   `"database":"up"`.

CI builds both images on every push, so the Dockerfile is checked. Without Docker, run
`npm ci && npm run build && npm run db:deploy && node dist/main.js` on Node 24.

### The first admin

The seed is for development and refuses to run in production. Create the first admin
(and later ones) from the API image:

```bash
docker run --rm --env-file production.env sitework-api \
  node dist/cli/create-admin.js --name "Your Name" --phone +919876543210 --email you@example.com
```

It prints a temporary password. Sign in with it in the app; you'll be asked to choose
your own. Then add engineers, staff, clients and sites in the app.

### Running it

- **Logs** are JSON lines on stdout, one per request (id, path, status, user, duration).
  Every error response carries a `requestId`, which leads to the matching log line.
- **Business rules** (slot windows, grace periods, working days, photo timings) live in
  the database (`app_settings`) with safe defaults. Change them there, no release needed.
- **Backups**: turn on daily backups and point-in-time recovery at your database host.
  Photos are temporary by design, so the bucket needs no backup.
- **Scaling**: one small instance (1 vCPU, 512 MB) is plenty for a contractor's team; see
  [ARCHITECTURE.md §14](ARCHITECTURE.md#14-performance). More instances are safe.

## 3. Firebase (push and crash reports)

1. Create a Firebase project. Add an **Android app** for each package you'll ship:
   `com.sitework.app` (production) and, if you use them, `com.sitework.app.staging` and
   `com.sitework.app.dev`.
2. **Server:** Project settings → Service accounts → *Generate new private key*. Put
   `project_id`, `client_email` and `private_key` in the API's `FIREBASE_*` variables,
   and set `PUSH_DRIVER=fcm`.
3. **App:** from the Android app's settings (or its `google-services.json`), copy:
   - `apiKey` (current_key)
   - `mobilesdk_app_id`
   - `project_number`, used as the messaging sender id
   - `project_id`

   Put them in the `FIREBASE_*` fields of `mobile/env/<flavor>.json`, or in the CI
   variables (section 4). They identify the app and are not secrets. The app reads them
   at build time, so no `google-services.json` is needed.
4. Open **Crashlytics** in the console once to turn it on. Release builds with Firebase
   then report crashes. Debug builds never do.

Without Firebase settings the app still works: alerts arrive by polling every minute.

## 4. The Android app

### Server address

Set `API_BASE_URL` in `mobile/env/prod.json` (and `staging.json`) to your HTTPS API,
e.g. `https://api.yourcompany.in/api/v1`. Release builds can't use plain HTTP.

### Upload key (once)

```bash
keytool -genkey -v -keystore sitework-upload.jks -keyalg RSA -keysize 2048 \
  -validity 10000 -alias upload
```

Keep the keystore and its passwords in a password manager, never in the repository.
Google Play App Signing holds the real app-signing key; this upload key can be reset
through Play support if lost.

### Build with CI (recommended)

`.github/workflows/release-android.yml` builds a signed bundle when you push a tag
such as `v1.0.0+1` (version name 1.0.0, version code 1; the code must increase with
every upload). Repository settings → Secrets and variables → Actions:

| Kind | Name | Value |
|---|---|---|
| Secret | `ANDROID_UPLOAD_KEYSTORE_BASE64` | `base64 -w0 sitework-upload.jks` |
| Secret | `ANDROID_UPLOAD_STORE_PASSWORD` | keystore password |
| Secret | `ANDROID_UPLOAD_KEY_ALIAS` | `upload` |
| Secret | `ANDROID_UPLOAD_KEY_PASSWORD` | key password |
| Variable | `FIREBASE_API_KEY`, `FIREBASE_APP_ID`, `FIREBASE_MESSAGING_SENDER_ID`, `FIREBASE_PROJECT_ID` | from section 3 |

Download the `.aab` from the run's artifacts.

### Build on your own computer

Copy `mobile/android/key.properties.example` to `mobile/android/key.properties` and
fill it in (it is git-ignored). Then:

```bash
cd mobile
flutter build appbundle --release --flavor prod --dart-define-from-file=env/prod.json
```

On the development PC, Windows Smart App Control blocks Flutter's 32-bit ARM compiler.
Build there with `--target-platform android-arm64,android-x64`. That leaves out old
32-bit-only phones, so prefer the CI build for Play uploads.

### Google Play Console

1. Create the app and upload the bundle to **Internal testing** first. Install it on a
   few phones (admin, engineer, staff) and run a full day: check-in, three updates,
   reviews, a missed slot, a payment, a report.
2. **Data safety**: the app collects precise location (check-in and updates), photos
   (site updates, deleted after review), name, phone and e-mail (accounts), and crash
   logs and device ids (crash reports, push). It shares none of them. Data is encrypted
   in transit. Users can't delete their own account in the app; admins deactivate
   accounts.
3. **Privacy policy**: required because of location and photos. Publish one at a URL you
   control, covering the points above.
4. **Permissions**: location is foreground-only (no background location), so no special
   declaration is needed. Notifications are asked for at first sign-in on Android 13+.
5. Content rating questionnaire and app category (Business), then promote to Production.

## 5. Before going live

- [ ] App name and package decided (section 1)
- [ ] API on HTTPS, with `NODE_ENV=production` and `TRUST_PROXY` set; health check green
- [ ] Long random JWT secrets, different from staging's
- [ ] Supabase bucket private; the service key only on the server
- [ ] Database backups on
- [ ] Firebase server and app settings in place; a test push received
- [ ] First admin created, temporary password replaced
- [ ] `env/prod.json` points at the production API
- [ ] Bundle signed with the upload key; Internal testing passed
- [ ] Data safety form and privacy policy done
