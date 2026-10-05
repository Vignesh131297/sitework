import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/session_store.dart';
import '../../features/auth/domain/auth_models.dart';
import '../../features/auth/presentation/session_controller.dart';
import '../config/app_config.dart';
import 'app_exception.dart';
import 'auth_interceptor.dart';
import 'dio_error_mapper.dart';

/// Decodes the `data` field of a successful response.
typedef Decoder<T> = T Function(Object? data);

/// One page of a list endpoint (`data` + `meta`).
class PageResult<T> {
  const PageResult({required this.items, required this.page, required this.totalPages, required this.total});

  final List<T> items;
  final int page;
  final int totalPages;
  final int total;

  bool get hasMore => page < totalPages;
}

/// Thin wrapper over Dio: unwraps `{ success: true, data }` and turns every
/// failure into an [AppException]. Repositories use this; widgets never do.
class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  Future<T> get<T>(String path, {required Decoder<T> decode, Map<String, Object?>? query}) =>
      _send(() => _dio.get<Object?>(path, queryParameters: _clean(query)), decode);

  Future<PageResult<T>> getPage<T>(
    String path, {
    required T Function(Map<String, dynamic> json) item,
    Map<String, Object?>? query,
  }) async {
    final body = await _envelope(() => _dio.get<Object?>(path, queryParameters: _clean(query)));
    try {
      final meta = body['meta'] as Map<String, dynamic>;
      return PageResult(
        items: [for (final row in body['data'] as List<dynamic>) item(row as Map<String, dynamic>)],
        page: meta['page'] as int,
        totalPages: meta['totalPages'] as int,
        total: meta['total'] as int,
      );
    } on Object catch (error) {
      throw UnexpectedException(error);
    }
  }

  Future<T> post<T>(
    String path, {
    required Decoder<T> decode,
    Object? body,
    bool public = false,
    ProgressCallback? onSendProgress,
  }) => _send(
    () => _dio.post<Object?>(
      path,
      data: body,
      options: public ? Options(extra: {publicRequest: true}) : null,
      onSendProgress: onSendProgress,
    ),
    decode,
  );

  Future<T> patch<T>(String path, {required Decoder<T> decode, Object? body}) =>
      _send(() => _dio.patch<Object?>(path, data: body), decode);

  Future<T> put<T>(String path, {required Decoder<T> decode, Object? body}) =>
      _send(() => _dio.put<Object?>(path, data: body), decode);

  Future<T> delete<T>(String path, {required Decoder<T> decode, Object? body}) =>
      _send(() => _dio.delete<Object?>(path, data: body), decode);

  /// Raw bytes (e.g. a CSV export), still with authentication and error mapping.
  Future<List<int>> download(String path, {Map<String, Object?>? query}) async {
    try {
      final response = await _dio.get<List<int>>(
        path,
        queryParameters: _clean(query),
        options: Options(responseType: ResponseType.bytes),
      );
      return response.data ?? const [];
    } on DioException catch (error) {
      throw mapDioException(error);
    }
  }

  Future<T> _send<T>(Future<Response<Object?>> Function() request, Decoder<T> decode) async {
    final body = await _envelope(request);
    try {
      return decode(body['data']);
    } on Object catch (error) {
      throw UnexpectedException(error);
    }
  }

  Future<Map<String, dynamic>> _envelope(Future<Response<Object?>> Function() request) async {
    final Response<Object?> response;
    try {
      response = await request();
    } on DioException catch (error) {
      throw mapDioException(error);
    }
    final body = response.data;
    if (body is! Map<String, dynamic> || body['success'] != true) {
      throw UnexpectedException(FormatException('Expected a success envelope from ${response.realUri}'));
    }
    return body;
  }

  static Map<String, Object?>? _clean(Map<String, Object?>? query) =>
      query == null ? null : (Map.of(query)..removeWhere((_, value) => value == null || value == ''));
}

BaseOptions _baseOptions(AppConfig config) => BaseOptions(
  baseUrl: config.apiBaseUrl,
  connectTimeout: config.connectTimeout,
  sendTimeout: config.receiveTimeout,
  receiveTimeout: config.receiveTimeout,
  contentType: Headers.jsonContentType,
  responseType: ResponseType.json,
);

/// Dio without the auth interceptor: used to refresh tokens and to retry.
final plainDioProvider = Provider<Dio>((ref) {
  final dio = Dio(_baseOptions(ref.watch(appConfigProvider)));
  ref.onDispose(dio.close);
  return dio;
});

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final plain = ref.watch(plainDioProvider);
  final store = ref.watch(sessionStoreProvider);
  final dio = Dio(_baseOptions(config));
  dio.interceptors.add(
    AuthInterceptor(
      store: store,
      retryClient: plain,
      refresh: (refreshToken) async {
        final response = await plain.post<Object?>('/auth/refresh', data: {'refreshToken': refreshToken});
        final data = (response.data! as Map<String, dynamic>)['data'] as Map<String, dynamic>;
        return AuthResult.fromJson(data);
      },
      onSessionEnded: () async {
        await store.clear();
        ref.read(sessionProvider.notifier).sessionEnded();
      },
    ),
  );
  if (config.isDev) {
    dio.interceptors.add(
      LogInterceptor(
        requestHeader: false,
        responseHeader: false,
        responseBody: false,
        logPrint: (line) => debugPrint('$line'),
      ),
    );
  }
  ref.onDispose(dio.close);
  return dio;
});

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient(ref.watch(dioProvider)));

/// Riverpod retry policy: transient network failures retry with back-off;
/// server answers (validation, permission, not found…) never do.
Duration? retryTransientFailures(int retryCount, Object error) {
  if (error is NetworkException && retryCount < 3) {
    return Duration(seconds: 2 << retryCount);
  }
  return null;
}
