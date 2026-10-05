import 'dart:ui' show Size;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sitework/app.dart';
import 'package:sitework/core/config/app_config.dart';
import 'package:sitework/features/auth/data/auth_repository.dart';
import 'package:sitework/features/system/domain/server_health.dart';
import 'package:sitework/features/system/presentation/server_status.dart';

import 'fake_api.dart';
import 'fake_auth_repository.dart';

final healthyServer = ServerHealth(
  status: 'ok',
  environment: 'development',
  version: '0.1.0',
  serverTime: DateTime.utc(2026, 10, 4, 4, 30),
  timeZone: 'Asia/Kolkata',
  businessDate: '2026-10-04',
);

/// Pumps the real app on a phone-sized screen with fake auth and server status.
Future<FakeAuthRepository> pumpSiteWorkApp(
  WidgetTester tester, {
  AppEnvironment environment = AppEnvironment.dev,
  List<DevLogin> devLogins = const [],
  FakeAuthRepository? auth,
  Future<ServerHealth> Function()? health,

  /// The API the app talks to; by default one that knows no routes (404).
  FakeApi? api,
  List<Override> overrides = const [],

  /// Physical pixels at 3x. Taller screens keep long forms fully built.
  Size screenSize = const Size(1080, 2400),
}) async {
  tester.view
    ..physicalSize = screenSize
    ..devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  FlutterSecureStorage.setMockInitialValues({});

  final fakeAuth = auth ?? FakeAuthRepository();
  await tester.pumpWidget(
    ProviderScope(
      retry: (_, _) => null,
      overrides: [
        appConfigProvider.overrideWithValue(
          AppConfig(environment: environment, apiBaseUrl: 'http://api.test/api/v1', devLogins: devLogins),
        ),
        authRepositoryProvider.overrideWithValue(fakeAuth),
        serverHealthProvider.overrideWith((ref) => (health ?? () async => healthyServer)()),
        ...(api ?? FakeApi()).overrides,
        ...overrides,
      ],
      child: const SiteWorkApp(),
    ),
  );
  await tester.pumpAndSettle();
  return fakeAuth;
}
