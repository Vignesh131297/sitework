import 'dart:io';

import 'package:dio/dio.dart';

import 'app_exception.dart';

/// Converts a Dio failure into an [AppException].
AppException mapDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return const NetworkException(timedOut: true);
    case DioExceptionType.connectionError:
      return const NetworkException();
    case DioExceptionType.badResponse:
      final response = error.response;
      return response == null
          ? UnexpectedException(error)
          : apiExceptionFromResponse(response.statusCode ?? 0, response.data);
    case DioExceptionType.badCertificate:
    case DioExceptionType.cancel:
    case DioExceptionType.unknown:
      return error.error is SocketException ? const NetworkException() : UnexpectedException(error.error ?? error);
  }
}

/// Reads the API's error envelope; falls back to a code derived from the status.
ApiException apiExceptionFromResponse(int statusCode, Object? body) {
  if (body is Map<String, dynamic> && body['success'] == false && body['code'] is String) {
    final details = body['details'];
    return ApiException(
      statusCode: statusCode,
      code: body['code'] as String,
      message: body['message'] is String ? body['message'] as String : '',
      requestId: body['requestId'] is String ? body['requestId'] as String : null,
      details: details is List
          ? [
              for (final item in details.whereType<Map<String, dynamic>>())
                FieldError(
                  field: item['field'] is String ? item['field'] as String : null,
                  message: item['message'] is String ? item['message'] as String : '',
                ),
            ]
          : const [],
    );
  }
  return ApiException(statusCode: statusCode, code: _codeForStatus(statusCode));
}

String _codeForStatus(int status) => switch (status) {
  400 => 'BAD_REQUEST',
  401 => 'UNAUTHORIZED',
  403 => 'FORBIDDEN',
  404 => 'NOT_FOUND',
  409 => 'CONFLICT',
  413 => 'PAYLOAD_TOO_LARGE',
  429 => 'RATE_LIMITED',
  503 => 'SERVICE_UNAVAILABLE',
  _ => 'INTERNAL_ERROR',
};
