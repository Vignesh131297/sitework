import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sitework/core/network/api_client.dart';
import 'package:sitework/core/network/app_exception.dart';

/// Answers every request with a fixed status and body.
class _CannedAdapter implements HttpClientAdapter {
  _CannedAdapter(this.statusCode, this.body);

  final int statusCode;
  final String body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString(
    body,
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );

  @override
  void close({bool force = false}) {}
}

ApiClient clientAnswering(int statusCode, String body) => ApiClient(
  Dio(BaseOptions(baseUrl: 'http://api.test/api/v1'))..httpClientAdapter = _CannedAdapter(statusCode, body),
);

void main() {
  group('ApiClient', () {
    test('unwraps the data of a success envelope', () async {
      final client = clientAnswering(200, '{"success":true,"data":{"status":"ok"}}');
      final status = await client.get('/health', decode: (data) => (data! as Map<String, dynamic>)['status']);
      expect(status, 'ok');
    });

    test('throws ApiException with the code from an error envelope', () async {
      final client = clientAnswering(
        404,
        '{"success":false,"code":"NOT_FOUND","message":"Site not found.","requestId":"r-9"}',
      );
      await expectLater(
        client.get('/sites/x', decode: (data) => data),
        throwsA(
          isA<ApiException>().having((e) => e.code, 'code', 'NOT_FOUND').having((e) => e.requestId, 'requestId', 'r-9'),
        ),
      );
    });

    test('rejects a 200 that is not an API envelope', () async {
      final client = clientAnswering(200, '{"hello":"captive portal"}');
      await expectLater(client.get('/health', decode: (data) => data), throwsA(isA<UnexpectedException>()));
    });

    test('reports a decoding bug as UnexpectedException', () async {
      final client = clientAnswering(200, '{"success":true,"data":42}');
      await expectLater(
        client.get('/health', decode: (data) => (data! as Map<String, dynamic>)['x']),
        throwsA(isA<UnexpectedException>()),
      );
    });
  });

  group('retryTransientFailures', () {
    test('retries network failures with growing delays, three times at most', () {
      expect(retryTransientFailures(0, const NetworkException()), const Duration(seconds: 2));
      expect(retryTransientFailures(2, const NetworkException()), const Duration(seconds: 8));
      expect(retryTransientFailures(3, const NetworkException()), isNull);
    });

    test('never retries an answer from the server', () {
      expect(retryTransientFailures(0, const ApiException(statusCode: 403, code: 'FORBIDDEN')), isNull);
    });
  });
}
