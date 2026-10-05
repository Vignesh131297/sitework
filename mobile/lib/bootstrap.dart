import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/firebase/firebase_setup.dart';
import 'core/network/api_client.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = AppConfig.fromEnvironment();
  await startCrashReporting(config);

  runApp(
    ProviderScope(
      retry: retryTransientFailures,
      overrides: [appConfigProvider.overrideWithValue(config)],
      child: const SiteWorkApp(),
    ),
  );
}
