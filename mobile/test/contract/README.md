# API contract fixtures

`fixtures/*.json` are real responses from the API running on seed data. The
contract tests check that the app's models decode them, so a renamed or
retyped server field fails a test here instead of on a phone.

Refresh them after an API change (dev server running with seed data):

```sh
cd mobile
dart run tool/capture_contract_fixtures.dart
```

The fixtures hold seed data only: no tokens, no real people.
