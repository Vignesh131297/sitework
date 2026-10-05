/// Every failure the data layer reports. Screens never see Dio or raw server
/// errors; they show [AppException]s through `userMessage` (see error_messages.dart).
sealed class AppException implements Exception {
  const AppException();
}

/// The request got no usable answer: offline, DNS failure, refused, timed out.
final class NetworkException extends AppException {
  const NetworkException({this.timedOut = false});

  final bool timedOut;

  @override
  String toString() => 'NetworkException(timedOut: $timedOut)';
}

/// The server answered with its error envelope `{ success: false, code, message }`.
final class ApiException extends AppException {
  const ApiException({
    required this.statusCode,
    required this.code,
    this.message = '',
    this.details = const [],
    this.requestId,
  });

  final int statusCode;

  /// Stable machine-readable code from the API contract, e.g. `NOT_FOUND`.
  final String code;

  /// Server-written message. Only shown for codes whose messages are meant for users.
  final String message;
  final List<FieldError> details;

  /// Quote this when reporting a problem; it ties the error to server logs.
  final String? requestId;

  @override
  String toString() => 'ApiException($statusCode $code, requestId: $requestId)';
}

/// Anything else: a bug or an unexpected response shape.
final class UnexpectedException extends AppException {
  const UnexpectedException(this.cause);

  final Object cause;

  @override
  String toString() => 'UnexpectedException($cause)';
}

class FieldError {
  const FieldError({required this.message, this.field});

  final String? field;
  final String message;
}
