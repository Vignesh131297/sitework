import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/firebase/firebase_setup.dart';
import '../../../core/models/enums.dart';
import '../domain/notification_models.dart';

/// A push as it reached the phone: what the server put in it (see PushDispatcher).
class PushArrival {
  const PushArrival({required this.title, required this.body, required this.data});

  final String title;
  final String body;
  final Map<String, String> data;

  /// The same notification as the in-app list has it, for routing.
  AppNotification toNotification() => AppNotification(
    id: data['notificationId'] ?? '',
    type: NotificationType.values.where((t) => t.apiValue == data['type']).firstOrNull ?? NotificationType.system,
    title: title,
    message: body,
    referenceType: ReferenceType.values.where((t) => t.apiValue == data['referenceType']).firstOrNull,
    referenceId: data['referenceId'],
    data: data,
    isRead: false,
    createdAt: DateTime.now(),
  );
}

/// Push notifications from the platform (Firebase Cloud Messaging), or nothing.
abstract class PushService {
  /// Asks for permission if needed; the device token, or null when push is off
  /// or the user declined.
  Future<String?> start();

  Stream<String> get tokenRefreshes;

  /// Arrived while the app was open (the system shows nothing then).
  Stream<PushArrival> get foregroundMessages;

  /// The user tapped a notification while the app was in the background.
  Stream<PushArrival> get openedMessages;

  /// The notification whose tap launched the app, if any.
  Future<PushArrival?> initialMessage();
}

/// Builds without Firebase settings: no push; alerts arrive by polling.
class DisabledPushService implements PushService {
  @override
  Future<String?> start() async => null;

  @override
  Stream<String> get tokenRefreshes => const Stream.empty();

  @override
  Stream<PushArrival> get foregroundMessages => const Stream.empty();

  @override
  Stream<PushArrival> get openedMessages => const Stream.empty();

  @override
  Future<PushArrival?> initialMessage() async => null;
}

class FirebasePushService implements PushService {
  FirebasePushService(this._config);

  final FirebaseConfig _config;
  Future<FirebaseMessaging?>? _ready;

  // A misconfigured project means no push rather than a failing app.
  Future<FirebaseMessaging?> _messaging() =>
      _ready ??= ensureFirebase(_config).then((ready) => ready ? FirebaseMessaging.instance : null);

  @override
  Future<String?> start() async {
    final messaging = await _messaging();
    if (messaging == null) return null;
    final settings = await messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.denied) return null;
    try {
      return await messaging.getToken();
    } on Object catch (error) {
      debugPrint('No push token: $error');
      return null;
    }
  }

  @override
  Stream<String> get tokenRefreshes =>
      Stream.fromFuture(_messaging()).asyncExpand((m) => m == null ? const Stream.empty() : m.onTokenRefresh);

  @override
  Stream<PushArrival> get foregroundMessages =>
      Stream.fromFuture(_messaging())
          .asyncExpand((m) => m == null ? const Stream.empty() : FirebaseMessaging.onMessage.map(_arrival));

  @override
  Stream<PushArrival> get openedMessages =>
      Stream.fromFuture(_messaging())
          .asyncExpand((m) => m == null ? const Stream.empty() : FirebaseMessaging.onMessageOpenedApp.map(_arrival));

  @override
  Future<PushArrival?> initialMessage() async {
    final message = await (await _messaging())?.getInitialMessage();
    return message == null ? null : _arrival(message);
  }

  static PushArrival _arrival(RemoteMessage message) => PushArrival(
    title: message.notification?.title ?? '',
    body: message.notification?.body ?? '',
    data: {for (final MapEntry(:key, :value) in message.data.entries) key: '$value'},
  );
}

final pushServiceProvider = Provider<PushService>((ref) {
  final firebase = ref.watch(appConfigProvider).firebase;
  return firebase == null ? DisabledPushService() : FirebasePushService(firebase);
});
