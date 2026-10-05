import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sitework/core/network/auth_interceptor.dart';
import 'package:sitework/features/auth/data/session_store.dart';
import 'package:sitework/features/auth/domain/app_session.dart';
import 'package:sitework/features/auth/domain/auth_models.dart';
import 'package:sitework/features/auth/domain/user_role.dart';

/// A tiny fake API: accepts only [validToken]; everything else is expired.
class _FakeServer implements HttpClientAdapter {
  _FakeServer({required this.validToken});

  String validToken;
  var requests = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests += 1;
    if (options.headers['Authorization'] == 'Bearer $validToken') {
      return _json(200, {'success': true, 'data': 'ok'});
    }
    return _json(401, {'success': false, 'code': 'TOKEN_EXPIRED', 'message': 'expired'});
  }

  static ResponseBody _json(int status, Object body) => ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );

  @override
  void close({bool force = false}) {}
}

const _user = AppSession(userId: 'u1', name: 'Ravi', role: UserRole.staff);

AuthResult _result(String access) => AuthResult(accessToken: access, refreshToken: 'refresh-$access', user: _user);

void main() {
  late SessionStore store;
  late _FakeServer server;
  late Dio dio;
  late int refreshCalls;
  late int sessionEnds;

  Dio clientFor(_FakeServer server) => Dio(BaseOptions(baseUrl: 'http://api.test'))..httpClientAdapter = server;

  void wire({required Future<AuthResult> Function(String refreshToken) refresh}) {
    dio = clientFor(server)
      ..interceptors.add(
        AuthInterceptor(
          store: store,
          retryClient: clientFor(server),
          refresh: (token) {
            refreshCalls += 1;
            return refresh(token);
          },
          onSessionEnded: () async {
            sessionEnds += 1;
            await store.clear();
          },
        ),
      );
  }

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    store = SessionStore(const FlutterSecureStorage());
    await store.write(
      const StoredSession(
        tokens: AuthTokens(accessToken: 'old', refreshToken: 'refresh-old'),
        user: _user,
      ),
    );
    server = _FakeServer(validToken: 'old');
    refreshCalls = 0;
    sessionEnds = 0;
  });

  test('sends the stored access token', () async {
    wire(refresh: (_) async => _result('new'));
    expect((await dio.get<Object?>('/me')).statusCode, 200);
    expect(refreshCalls, 0);
  });

  test('refreshes once for several requests that fail together, then retries them', () async {
    server.validToken = 'new';
    wire(
      refresh: (token) async {
        expect(token, 'refresh-old');
        await Future<void>.delayed(const Duration(milliseconds: 20));
        return _result('new');
      },
    );

    final responses = await Future.wait([dio.get<Object?>('/a'), dio.get<Object?>('/b'), dio.get<Object?>('/c')]);

    expect(responses.map((r) => r.statusCode), everyElement(200));
    expect(refreshCalls, 1);
    expect((await store.read())!.tokens.accessToken, 'new');
    expect(sessionEnds, 0);
  });

  test('ends the session when the refresh token is rejected', () async {
    server.validToken = 'new';
    wire(
      refresh: (_) => Future.error(
        DioException(
          requestOptions: RequestOptions(path: '/auth/refresh'),
          response: Response<Object?>(
            requestOptions: RequestOptions(path: '/auth/refresh'),
            statusCode: 401,
            data: {'success': false, 'code': 'SESSION_REVOKED'},
          ),
          type: DioExceptionType.badResponse,
        ),
      ),
    );

    await expectLater(dio.get<Object?>('/me'), throwsA(isA<DioException>()));
    expect(sessionEnds, 1);
    expect(await store.read(), isNull);
  });

  test('keeps the session when the refresh fails for lack of network', () async {
    server.validToken = 'new';
    wire(
      refresh: (_) => Future.error(
        DioException(
          requestOptions: RequestOptions(path: '/auth/refresh'),
          type: DioExceptionType.connectionError,
        ),
      ),
    );

    await expectLater(
      dio.get<Object?>('/me'),
      throwsA(isA<DioException>().having((e) => e.type, 'type', DioExceptionType.connectionError)),
    );
    expect(sessionEnds, 0);
    expect(await store.read(), isNotNull);
  });

  test('ends the session at once on any 401 other than an expired token', () async {
    final revoking = _RevokingServer();
    dio = clientFor(server)
      ..httpClientAdapter = revoking
      ..interceptors.add(
        AuthInterceptor(
          store: store,
          retryClient: clientFor(server),
          refresh: (_) async {
            refreshCalls += 1;
            return _result('new');
          },
          onSessionEnded: () async => sessionEnds += 1,
        ),
      );

    await expectLater(dio.get<Object?>('/me'), throwsA(isA<DioException>()));
    expect(refreshCalls, 0);
    expect(sessionEnds, 1);
  });

  test('never touches public requests (sign-in)', () async {
    wire(refresh: (_) async => _result('new'));
    server.validToken = 'none';
    await expectLater(
      dio.post<Object?>('/auth/login', options: Options(extra: {publicRequest: true})),
      throwsA(isA<DioException>()),
    );
    expect(refreshCalls, 0);
    expect(sessionEnds, 0);
  });
}

class _RevokingServer implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString(
    jsonEncode({'success': false, 'code': 'SESSION_REVOKED', 'message': 'ended'}),
    401,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );

  @override
  void close({bool force = false}) {}
}
