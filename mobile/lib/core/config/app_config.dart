import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppEnvironment { dev, staging, prod }

/// A seeded account offered as a one-tap sign-in in development builds.
class DevLogin {
  const DevLogin({required this.label, required this.identifier, required this.password});

  final String label;
  final String identifier;
  final String password;
}

/// Firebase project settings for push notifications. These identify the app
/// to Firebase and are not secrets; without them push is off and alerts are
/// fetched by polling instead.
class FirebaseConfig {
  const FirebaseConfig({
    required this.apiKey,
    required this.appId,
    required this.messagingSenderId,
    required this.projectId,
  });

  /// All four values, or null when any is missing.
  static FirebaseConfig? fromValues({
    required String apiKey,
    required String appId,
    required String messagingSenderId,
    required String projectId,
  }) => [apiKey, appId, messagingSenderId, projectId].any((value) => value.isEmpty)
      ? null
      : FirebaseConfig(apiKey: apiKey, appId: appId, messagingSenderId: messagingSenderId, projectId: projectId);

  final String apiKey;
  final String appId;
  final String messagingSenderId;
  final String projectId;
}

/// Build-time configuration, passed with
/// `--dart-define-from-file=env/<file>.json` (see mobile/README.md).
class AppConfig {
  const AppConfig({required this.environment, required this.apiBaseUrl, this.devLogins = const [], this.firebase});

  factory AppConfig.fromEnvironment() {
    const environmentName = String.fromEnvironment('APP_ENV');
    const apiBaseUrl = String.fromEnvironment('API_BASE_URL');
    const devLogins = String.fromEnvironment('DEV_LOGINS');
    final environment = AppEnvironment.values.asNameMap()[environmentName];
    if (environment == null || apiBaseUrl.isEmpty) {
      throw StateError(
        'Missing build configuration. Run with --flavor <dev|staging|prod> '
        '--dart-define-from-file=env/<file>.json (see mobile/README.md).',
      );
    }
    return AppConfig(
      environment: environment,
      apiBaseUrl: apiBaseUrl,
      devLogins: environment == AppEnvironment.dev ? parseDevLogins(devLogins) : const [],
      firebase: FirebaseConfig.fromValues(
        apiKey: const String.fromEnvironment('FIREBASE_API_KEY'),
        appId: const String.fromEnvironment('FIREBASE_APP_ID'),
        messagingSenderId: const String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
        projectId: const String.fromEnvironment('FIREBASE_PROJECT_ID'),
      ),
    );
  }

  final AppEnvironment environment;

  /// Includes the API version prefix, e.g. `http://10.0.2.2:3000/api/v1`.
  final String apiBaseUrl;

  /// Only ever set in dev builds (from env/dev.json), never compiled into others.
  final List<DevLogin> devLogins;

  /// Null: push notifications are off for this build.
  final FirebaseConfig? firebase;

  bool get isDev => environment == AppEnvironment.dev;

  Duration get connectTimeout => const Duration(seconds: 10);
  Duration get receiveTimeout => const Duration(seconds: 30);
}

/// "Label|identifier|password;Label|identifier|password"
List<DevLogin> parseDevLogins(String value) => [
  for (final entry in value.split(';'))
    if (entry.split('|') case [final label, final identifier, final password])
      DevLogin(label: label.trim(), identifier: identifier.trim(), password: password),
];

final appConfigProvider = Provider<AppConfig>(
  (ref) => throw UnimplementedError('Override appConfigProvider in bootstrap()'),
);
