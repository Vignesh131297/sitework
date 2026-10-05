import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sitework/core/network/app_exception.dart';
import 'package:sitework/core/network/dio_error_mapper.dart';

DioException dioError(DioExceptionType type, {int? status, Object? data, Object? error}) {
  final options = RequestOptions(path: '/health');
  return DioException(
    requestOptions: options,
    type: type,
    error: error,
    response: status == null ? null : Response<Object?>(requestOptions: options, statusCode: status, data: data),
  );
}

void main() {
  group('mapDioException', () {
    test('treats every kind of timeout as a timed-out network failure', () {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.transformTimeout,
      ]) {
        expect(mapDioException(dioError(type)), isA<NetworkException>().having((e) => e.timedOut, 'timedOut', isTrue));
      }
    });

    test('treats connection failures as offline', () {
      expect(
        mapDioException(dioError(DioExceptionType.connectionError)),
        isA<NetworkException>().having((e) => e.timedOut, 'timedOut', isFalse),
      );
      expect(
        mapDioException(dioError(DioExceptionType.unknown, error: const SocketException('no route'))),
        isA<NetworkException>(),
      );
    });

    test('reads the API error envelope', () {
      final error = mapDioException(
        dioError(
          DioExceptionType.badResponse,
          status: 409,
          data: {
            'success': false,
            'code': 'UPDATE_ALREADY_SUBMITTED',
            'message': 'Morning update has already been submitted.',
            'details': [
              {'field': 'slot', 'message': 'already submitted'},
            ],
            'requestId': 'req-1',
          },
        ),
      );

      expect(
        error,
        isA<ApiException>()
            .having((e) => e.statusCode, 'statusCode', 409)
            .having((e) => e.code, 'code', 'UPDATE_ALREADY_SUBMITTED')
            .having((e) => e.message, 'message', 'Morning update has already been submitted.')
            .having((e) => e.requestId, 'requestId', 'req-1')
            .having((e) => e.details.single.field, 'details.field', 'slot'),
      );
    });

    test('derives a code from the status when the body is not an envelope', () {
      ApiException mapped(int status) =>
          mapDioException(dioError(DioExceptionType.badResponse, status: status, data: '<html>Bad gateway</html>'))
              as ApiException;

      expect(mapped(404).code, 'NOT_FOUND');
      expect(mapped(429).code, 'RATE_LIMITED');
      expect(mapped(502).code, 'INTERNAL_ERROR');
    });
  });
}
