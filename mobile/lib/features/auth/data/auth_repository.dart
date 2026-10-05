import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/app_exception.dart';
import '../domain/app_session.dart';
import '../domain/auth_models.dart';
import 'session_store.dart';

class AuthRepository {
  AuthRepository(this._api, this._store);

  final ApiClient _api;
  final SessionStore _store;

  Future<StoredSession?> restore() => _store.read();

  Future<AppSession> signIn(String identifier, String password) async {
    final result = await _api.post(
      '/auth/login',
      public: true,
      body: {'identifier': identifier.trim(), 'password': password, 'deviceName': _deviceName()},
      decode: (data) => AuthResult.fromJson(data! as Map<String, dynamic>),
    );
    await _store.write(StoredSession(tokens: result.tokens, user: result.user));
    return result.user;
  }

  Future<void> signOut() async {
    try {
      await _api.post('/auth/logout', decode: (_) {});
    } on AppException {
      // Offline or already ended: the device forgets the session either way.
    }
    await _store.clear();
  }

  /// Fetches the profile and keeps the cached session (role, name…) up to date.
  Future<MeProfile> fetchProfile() async {
    final me = await _api.get('/me', decode: (data) => MeProfile.fromJson(data! as Map<String, dynamic>));
    await _store.saveUser(me.toSession());
    return me;
  }

  Future<void> changePassword({required String currentPassword, required String newPassword}) async {
    await _api.patch(
      '/auth/password',
      body: {'currentPassword': currentPassword, 'newPassword': newPassword},
      decode: (_) {},
    );
    final stored = await _store.read();
    if (stored != null) {
      await _store.saveUser(stored.user.copyWith(mustChangePassword: false));
    }
  }

  /// Returns the server's message (it never says whether the account exists).
  Future<String> requestPasswordReset(String identifier) => _api.post(
    '/auth/forgot-password',
    public: true,
    body: {'identifier': identifier.trim()},
    decode: (data) => (data! as Map<String, dynamic>)['message'] as String,
  );

  Future<void> resetPassword({required String identifier, required String code, required String newPassword}) =>
      _api.post(
        '/auth/reset-password',
        public: true,
        body: {'identifier': identifier.trim(), 'code': code.trim(), 'newPassword': newPassword},
        decode: (_) {},
      );

  static String _deviceName() {
    final name = 'Android ${Platform.operatingSystemVersion}';
    return name.length > 100 ? name.substring(0, 100) : name;
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(apiClientProvider), ref.watch(sessionStoreProvider)),
);
