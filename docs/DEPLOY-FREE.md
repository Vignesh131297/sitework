# Deploying the API for free

This puts the SiteWork API online for $0 a month, using only free plans. It runs
without your computer. For the paid setup and the Play Store, see
[RELEASE.md](RELEASE.md).

| Service (free plan) | What it does |
|---|---|
| [Render](https://render.com) | Runs the API at `https://<name>.onrender.com` (`render.yaml` in this repo) |
| [Supabase](https://supabase.com) | The database and the photo storage |
| [Firebase](https://firebase.google.com) | Push notifications |
| [UptimeRobot](https://uptimerobot.com) | Calls the API every 5 minutes so Render never puts it to sleep |
| GitHub Actions | Updates the database tables on each release (the `migrate` job in CI) |

**Keep it free:** don't add a payment card to Render. Without one, Render pauses the
service if you ever go over a limit, instead of charging you. Run only this one free
service in your Render account: the 750 free hours a month cover one service all month.

Write each value down as you go. You need them in steps 4 and 5.

## 1. Supabase: database and photo storage

1. Sign up at supabase.com and click **New project**.
   - Name: `sitework`. Region: **South Asia (Mumbai)**. Plan: Free.
   - Database password: click **Generate a password**, or use only letters and digits.
     Save it.
2. **Storage** → **New bucket**. Name it `sitework-private` and keep **Public bucket
   turned off**. Photos are only ever shown through short-lived private links.
3. Click **Connect** at the top of the project. Under **Transaction pooler** (port
   `6543`), copy the connection string, put your password in place of
   `[YOUR-PASSWORD]`, and add this to the end:

   ```
   ?uselibpqcompat=true&sslmode=require
   ```

   It should look like this. This is your **`DATABASE_URL`**.

   ```
   postgresql://postgres.abcd1234:YourPassword@aws-0-ap-south-1.pooler.supabase.com:6543/postgres?uselibpqcompat=true&sslmode=require
   ```

   > The ending matters. Without `uselibpqcompat=true` the API refuses Supabase's
   > certificate and won't start. If your password has symbols, replace each one with
   > its URL code (`@` is `%40`, `#` is `%23`, `/` is `%2F`).

4. **Project Settings** → **API Keys**. Copy:
   - the **Project URL**, like `https://abcd1234.supabase.co`. This is **`SUPABASE_URL`**.
   - a **secret key** (`sb_secret_…`; create one if there is none). This is
     **`SUPABASE_SERVICE_KEY`**. It has full access: keep it only on Render.

## 2. Firebase: push notifications

1. Sign up at firebase.google.com and **Create a project** (Google Analytics is not needed).
2. **Project settings** → **Service accounts** → **Generate new private key**. A JSON
   file downloads. From it you need:
   - `project_id`: **`FIREBASE_PROJECT_ID`**
   - `client_email`: **`FIREBASE_CLIENT_EMAIL`**
   - `private_key`: **`FIREBASE_PRIVATE_KEY`**. Copy the whole value, from
     `-----BEGIN PRIVATE KEY-----` to `-----END PRIVATE KEY-----\n`.

Keep the file private and don't commit it.

## 3. GitHub: let CI update the database

In the GitHub repository: **Settings** → **Secrets and variables** → **Actions** →
**New repository secret**.

- Name: `PRODUCTION_DATABASE_URL`
- Value: the same `DATABASE_URL` as in step 1.3

Then merge your changes into `main` (or, on the **Actions** tab, open **CI** and click
**Run workflow** on `main`). When CI finishes, the **migrate** job should be green: it
has created the tables. Every later merge to `main` updates the tables the same way,
before Render deploys the new code.

## 4. Render: run the API

1. Sign up at render.com with your GitHub account. Skip adding a payment card.
2. **New** → **Blueprint**, pick the `sitework` repository, and let Render read
   `render.yaml`.
3. Render asks for the six values from steps 1 and 2: `DATABASE_URL`, `SUPABASE_URL`,
   `SUPABASE_SERVICE_KEY`, `FIREBASE_PROJECT_ID`, `FIREBASE_CLIENT_EMAIL` and
   `FIREBASE_PRIVATE_KEY`. Render creates the JWT secrets itself.
4. Click **Apply** and wait for the service to show **Live** (the first build takes a
   few minutes).
5. Open `https://<your-service>.onrender.com/api/v1/health`. It should show
   `"status":"ok"` and `"database":"up"`.

If it doesn't start, open the service's **Logs**. The API lists every missing or wrong
setting at once (`Invalid environment configuration: …`).

## 5. UptimeRobot: keep it awake

Render's free plan puts the API to sleep after 15 minutes without requests, which would
also stop the scheduled jobs (missed-update alerts, auto-absent, photo clean-up).

Sign up at uptimerobot.com → **New monitor** → type **HTTP(s)**, URL
`https://<your-service>.onrender.com/api/v1/health`, interval **5 minutes**. You also
get an e-mail if the API ever goes down.

## 6. The first admin

Render's free plan has no shell, so create the first admin from your computer. In
`backend/`, create a file named `.env.production.local` (git never commits it):

```
NODE_ENV=staging
DATABASE_URL=<the DATABASE_URL from step 1.3>
JWT_SECRET=any-text-of-at-least-32-characters-1
JWT_REFRESH_SECRET=any-text-of-at-least-32-characters-2
```

`staging` only lets the command run without the photo and push settings; it just adds
one row to the production database. Then:

```powershell
cd backend
npm run build
node --env-file=.env.production.local dist/cli/create-admin.js --name "Your Name" --phone +919876543210 --email you@example.com
```

It prints a temporary password. Sign in with it in the app and choose your own. Then
delete `.env.production.local`.

## 7. Point the app at it

Set `API_BASE_URL` in `mobile/env/prod.json` to
`https://<your-service>.onrender.com/api/v1` and build the APK:

```powershell
cd mobile
flutter build apk --release --flavor prod --dart-define-from-file=env/prod.json --target-platform android-arm64,android-x64
```

The APK is in `mobile/build/app/outputs/flutter-apk/app-prod-release.apk`. Until the app's
`FIREBASE_*` settings are filled in ([RELEASE.md §3](RELEASE.md#3-firebase-push-and-crash-reports)),
it checks for alerts every minute instead of receiving pushes.

## Free-plan limits

- **No uptime guarantee.** Render says free instances aren't meant for production: they
  can restart at any time. If UptimeRobot stops, the first request after a sleep takes
  about a minute and jobs pause.
- **Supabase pauses a project after 7 days without database use.** The API's jobs use
  the database every few minutes, so this only happens if the API is down for a week.
  Restore it from the Supabase dashboard.
- **Sized for a small team.** Free plans include 500 MB of database, 1 GB of photos and
  a slow processor: fine for about 20–30 staff, since photos are deleted after review.
- **E-mail is off** (free instances can't send mail). Admins reset passwords in the app.
- Supabase's old `service_role` keys stop working at the end of 2026. Use a
  `sb_secret_…` key, as in step 1.4.

## Moving to paid later

Change `plan: free` to `starter` in `render.yaml` (about $7 a month): no sleeping, no
UptimeRobot needed, and Render's Shell for running commands. The other services stay as
they are.
