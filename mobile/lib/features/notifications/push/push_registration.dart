import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/app_exception.dart';
import 'push_service.dart';

class DevicesRepository {
  DevicesRepository(this._api);

  final ApiClient _api;

  Future<void> register(String token) =>
      _api.post('/me/devices', body: {'fcmToken': token, 'platform': 'android'}, decode: (_) {});

  Future<void> remove(String token) => _api.delete('/me/devices', body: {'fcmToken': token}, decode: (_) {});
}

final devicesRepositoryProvider = Provider<DevicesRepository>((ref) => DevicesRepository(ref.watch(apiClientProvider)));

/// Keeps the server told which phone should get the signed-in user's pushes.
class PushRegistration {
  PushRegistration(this._ref);

  final Ref _ref;
  String? _token;

  /// The token the server already has for this session.
  String? _sent;
  StreamSubscription<String>? _refreshes;

  /// After sign-in (or a restored session). Failures leave polling to cover.
  Future<void> register() async {
    final service = _ref.read(pushServiceProvider);
    final token = await service.start();
    if (token == null) return;
    _token = token;
    if (token != _sent) await _send(token);
    _refreshes ??= service.tokenRefreshes.listen((token) {
      _token = token;
      _send(token);
    });
  }

  /// Before signing out, so this phone stops getting that user's pushes.
  Future<void> unregister() async {
    final token = _token;
    unawaited(_refreshes?.cancel());
    _refreshes = null;
    _token = null;
    _sent = null;
    if (token == null) return;
    try {
      await _ref.read(devicesRepositoryProvider).remove(token);
    } on AppException {
      // Offline: the server drops the token when FCM reports it dead, or when
      // someone else signs in on this phone.
    }
  }

  Future<void> _send(String token) async {
    try {
      await _ref.read(devicesRepositoryProvider).register(token);
      _sent = token;
    } on AppException {
      // Retried on the next app start.
    }
  }
}

final pushRegistrationProvider = Provider<PushRegistration>(PushRegistration.new);
