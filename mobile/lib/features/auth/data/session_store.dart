import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../domain/app_session.dart';
import '../domain/auth_models.dart';

/// Keeps the tokens and the signed-in user in Android's encrypted storage, so a
/// worker stays signed in across restarts and while offline. Cached in memory
/// after the first read because every API request needs the access token.
class SessionStore {
  SessionStore(this._storage);

  static const _key = 'sitework.session.v1';

  final FlutterSecureStorage _storage;
  StoredSession? _cached;
  var _loaded = false;

  Future<StoredSession?> read() async {
    if (_loaded) return _cached;
    final raw = await _storage.read(key: _key);
    _cached = raw == null ? null : _decode(raw);
    _loaded = true;
    return _cached;
  }

  Future<void> write(StoredSession session) async {
    _cached = session;
    _loaded = true;
    await _storage.write(key: _key, value: jsonEncode(session.toJson()));
  }

  Future<void> saveTokens(AuthTokens tokens) async {
    final current = await read();
    if (current != null) await write(current.copyWith(tokens: tokens));
  }

  Future<void> saveUser(AppSession user) async {
    final current = await read();
    if (current != null) await write(current.copyWith(user: user));
  }

  Future<void> clear() async {
    _cached = null;
    _loaded = true;
    await _storage.delete(key: _key);
  }

  // Unreadable data (e.g. after an app update changed the format) means signed out.
  StoredSession? _decode(String raw) {
    try {
      return StoredSession.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      return null;
    }
  }
}

final sessionStoreProvider = Provider<SessionStore>((ref) => SessionStore(const FlutterSecureStorage()));
