# SiteWork app

Flutter 3.47 (Android). Design and conventions: [`docs/ARCHITECTURE.md`](../docs/ARCHITECTURE.md).
Setup: the [root README](../README.md).

## Running

Every run needs a flavor and its configuration file:

```powershell
flutter run --flavor dev --dart-define-from-file=env/dev.json          # emulator → API on this PC
flutter run --flavor dev --dart-define-from-file=env/dev-usb.json      # USB phone (after adb reverse tcp:3000 tcp:3000)
flutter build appbundle --release --flavor prod --dart-define-from-file=env/prod.json  # Play Store
```

Release signing reads `android/key.properties` (git-ignored; see `key.properties.example`).
Without it, release builds use the debug key. Publishing steps: [`docs/RELEASE.md`](../docs/RELEASE.md).

| Flavor | App ID | Name on phone | API |
|---|---|---|---|
| dev | `com.sitework.app.dev` | SiteWork Dev | local, plain HTTP allowed |
| staging | `com.sitework.app.staging` | SiteWork Staging | `env/staging.json` (HTTPS) |
| prod | `com.sitework.app` | SiteWork | `env/prod.json` (HTTPS) |

The staging and prod URLs are placeholders until hosting is chosen. The env files hold no
secrets. Their `FIREBASE_*` fields are optional: fill them in to turn on push and crash reports.

**Notes for this PC**

- Windows Smart App Control blocks Flutter's 32-bit ARM compiler (`android-arm-release\gen_snapshot.exe`).
  Release and profile builds here need `--target-platform android-arm64,android-x64`. Debug builds
  are not affected. The release workflow in CI builds for 32-bit phones too.
- A just-booted emulator can show "isn't responding" dialogs for every app while it settles.
  Wait a minute, or use a release build to judge performance.

## Code generation

```powershell
dart run build_runner build --delete-conflicting-outputs   # after changing freezed / json models
flutter gen-l10n                                           # after editing lib/core/l10n/app_en.arb
```

Generated files are committed, so a fresh clone runs without these steps. CI regenerates
them and fails if the committed copies are stale.

## Contract fixtures

`test/contract/fixtures/` holds responses recorded from the real API. The contract tests
decode them, and a screen tour renders every screen with them. After an API change, start
the dev API on fresh seed data and run `dart run tool/capture_contract_fixtures.dart`.

## Conventions

- Import **`package:material_ui/material_ui.dart`**, never `package:flutter/material.dart`.
  go_router 18 uses the new `material_ui` package, and its themes and localizations don't mix with
  the framework copy.
- All user-facing text goes in `lib/core/l10n/app_en.arb`.
- Screens never call Dio. Feature code goes in `features/<name>/{data,domain,presentation}`.
- Analysis is strict (`strict-casts`, `strict-inference`). Keep `flutter analyze` at zero issues.
