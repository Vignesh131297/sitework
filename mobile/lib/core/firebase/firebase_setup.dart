import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';

/// Starts Firebase once, for push and crash reports. Returns false when the
/// build has no Firebase settings or they are wrong; the app then runs without
/// push (alerts arrive by polling) and without crash reports.
Future<bool> ensureFirebase(FirebaseConfig? config) async {
  if (config == null) return false;
  if (Firebase.apps.isNotEmpty) return true;
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: config.apiKey,
        appId: config.appId,
        messagingSenderId: config.messagingSenderId,
        projectId: config.projectId,
      ),
    );
    return true;
  } on Object catch (error) {
    debugPrint('Firebase unavailable: $error');
    return false;
  }
}

/// Sends uncaught errors to Crashlytics in release builds that have Firebase.
/// Collection is off by default (AndroidManifest.xml), so debug runs and
/// builds without Firebase report nothing.
Future<void> startCrashReporting(AppConfig config) async {
  if (kDebugMode || !await ensureFirebase(config.firebase)) return;
  try {
    final crashlytics = FirebaseCrashlytics.instance;
    await crashlytics.setCrashlyticsCollectionEnabled(true);
    await crashlytics.setCustomKey('environment', config.environment.name);
    FlutterError.onError = crashlytics.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      crashlytics.recordError(error, stack, fatal: true);
      return true;
    };
  } on Object catch (error) {
    debugPrint('Crash reporting unavailable: $error');
  }
}
