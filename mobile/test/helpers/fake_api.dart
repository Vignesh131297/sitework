import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:sitework/core/network/api_client.dart';

/// A request the app sent to [FakeApi].
class FakeRequest {
  const FakeRequest({
    required this.method,
    required this.path,
    required this.query,
    required this.body,
    required this.params,
  });

  final String method;
  final String path;
  final Map<String, String> query;
  final Object? body;

  /// Values of `:name` segments in the route that matched.
  final Map<String, String> params;

  Map<String, dynamic> get json => body! as Map<String, dynamic>;

  @override
  String toString() => '$method $path $query ${body ?? ''}';
}

/// Throw from a handler to answer with the API's error envelope.
/// A non-JSON answer, e.g. a CSV download.
class FakeRaw {
  const FakeRaw(this.body, {required this.contentType});

  final String body;
  final String contentType;
}

class FakeApiError implements Exception {
  const FakeApiError(this.status, this.code, [this.message = '']);

  final int status;
  final String code;
  final String message;
}

/// A list endpoint's answer: `data` plus pagination `meta`.
class FakePage {
  const FakePage(this.items, {this.page = 1, this.limit = 20, int? total}) : total = total ?? items.length;

  final List<Object?> items;
  final int page;
  final int limit;
  final int total;
}

typedef FakeHandler = Object? Function(FakeRequest request);

/// The API for widget tests. Register answers per route, e.g.
/// `api.on('GET', '/sites/:id', (r) => siteJson(r.params['id']))`; anything
/// unregistered answers 404 so a test notices. Every request is recorded.
class FakeApi implements HttpClientAdapter {
  final _routes = <({String method, RegExp pattern, List<String> names, FakeHandler handler})>[];
  final requests = <FakeRequest>[];

  /// Requests nothing answered (each got a 404), as "GET /path".
  final unanswered = <String>[];

  /// While true every request fails as if the phone had no connection.
  var offline = false;

  void on(String method, String path, FakeHandler handler) {
    final names = <String>[];
    final pattern = path.replaceAllMapped(RegExp(r':(\w+)'), (match) {
      names.add(match.group(1)!);
      return '([^/]+)';
    });
    // Later registrations win, so a test can override a default answer.
    _routes.insert(0, (method: method, pattern: RegExp('^$pattern\$'), names: names, handler: handler));
  }

  /// Requests with [method] whose path is [path].
  List<FakeRequest> sent(String method, String path) => [
    for (final r in requests)
      if (r.method == method && r.path == path) r,
  ];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (offline) throw const SocketException('offline (test)');
    final path = options.uri.path.replaceFirst('/api/v1', '');
    for (final route in _routes) {
      if (route.method != options.method) continue;
      final match = route.pattern.firstMatch(path);
      if (match == null) continue;
      final request = FakeRequest(
        method: options.method,
        path: path,
        query: options.uri.queryParameters,
        body: options.data,
        params: {for (var i = 0; i < route.names.length; i++) route.names[i]: match.group(i + 1)!},
      );
      requests.add(request);
      try {
        final result = route.handler(request);
        if (result is FakeRaw) {
          return ResponseBody.fromString(
            result.body,
            200,
            headers: {
              Headers.contentTypeHeader: [result.contentType],
            },
          );
        }
        if (result is FakePage) {
          return _json(200, {
            'success': true,
            'data': result.items,
            'meta': {
              'page': result.page,
              'limit': result.limit,
              'total': result.total,
              'totalPages': (result.total / result.limit).ceil(),
            },
          });
        }
        return _json(200, {'success': true, 'data': result});
      } on FakeApiError catch (error) {
        return _json(error.status, {
          'success': false,
          'code': error.code,
          'message': error.message,
          'requestId': 'test-request',
        });
      }
    }
    unanswered.add('${options.method} $path');
    return _json(404, {
      'success': false,
      'code': 'NOT_FOUND',
      'message': 'No fake answer for ${options.method} $path',
      'requestId': 'test-request',
    });
  }

  ResponseBody _json(int status, Object body) => ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );

  @override
  void close({bool force = false}) {}

  /// Routes the app's API calls here.
  List<Override> get overrides => [
    apiClientProvider.overrideWith(
      (ref) => ApiClient(
        Dio(BaseOptions(baseUrl: 'http://api.test/api/v1', contentType: Headers.jsonContentType))
          ..httpClientAdapter = this,
      ),
    ),
  ];
}
