import 'dart:async';

import 'package:sitework/features/notifications/push/push_service.dart';

/// Push that the test drives: a token, and messages on demand.
class FakePushService implements PushService {
  FakePushService({this.token = 'fcm-token-1234567890abcdefghij', this.initial});

  final String? token;
  final PushArrival? initial;
  final foreground = StreamController<PushArrival>.broadcast();
  final opened = StreamController<PushArrival>.broadcast();
  final refreshes = StreamController<String>.broadcast();

  @override
  Future<String?> start() async => token;

  @override
  Stream<String> get tokenRefreshes => refreshes.stream;

  @override
  Stream<PushArrival> get foregroundMessages => foreground.stream;

  @override
  Stream<PushArrival> get openedMessages => opened.stream;

  @override
  Future<PushArrival?> initialMessage() async => initial;
}
