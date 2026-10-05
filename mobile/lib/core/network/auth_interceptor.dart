import 'package:dio/dio.dart';

import '../../features/auth/data/session_store.dart';
import '../../features/auth/domain/auth_models.dart';

/// `Options(extra: {publicRequest: true})` marks a request that must not carry
/// or refresh the user's token (sign-in, password reset).
const publicRequest = 'public';

typedef TokenRefresher = Future<AuthResult> Function(String refreshToken);

/// Adds the access token to requests. When the server says it has expired, the
/// token is refreshed once (other failing requests wait in the queue) and the
/// request is retried. A rejected refresh ends the session; a network failure
/// during refresh does not, so workers stay signed in while offline.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this._store,
    required this._refresh,
    required this._retryClient,
    required this._onSessionEnded,
  });

  final SessionStore _store;
  final TokenRefresher _refresh;
  // Retries go through a client without this interceptor: re-entering the queue
  // from inside onError would deadlock it.
  final Dio _retryClient;
  final Future<void> Function() _onSessionEnded;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.extra[publicRequest] != true) {
      final stored = await _store.read();
      if (stored != null) {
        options.headers['Authorization'] = 'Bearer ${stored.tokens.accessToken}';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final response = err.response;
    if (response?.statusCode != 401 || err.requestOptions.extra[publicRequest] == true) {
      return handler.next(err);
    }
    if (_errorCode(response!.data) != 'TOKEN_EXPIRED') {
      // Revoked, signed out elsewhere, disabled or no token: the session is over.
      await _onSessionEnded();
      return handler.next(err);
    }

    final stored = await _store.read();
    if (stored == null) {
      await _onSessionEnded();
      return handler.next(err);
    }
    try {
      var tokens = stored.tokens;
      // Requests queued behind an earlier refresh already have a new token to use.
      if (err.requestOptions.headers['Authorization'] == 'Bearer ${tokens.accessToken}') {
        final result = await _refresh(tokens.refreshToken);
        tokens = result.tokens;
        await _store.write(StoredSession(tokens: tokens, user: result.user));
      }
      final retry = err.requestOptions..headers['Authorization'] = 'Bearer ${tokens.accessToken}';
      handler.resolve(await _retryClient.fetch<Object?>(retry));
    } on DioException catch (failure) {
      if (failure.response?.statusCode == 401) await _onSessionEnded();
      handler.next(failure);
    }
  }

  static String? _errorCode(Object? body) =>
      body is Map<String, dynamic> && body['code'] is String ? body['code'] as String : null;
}
