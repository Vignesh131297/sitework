import '../l10n/generated/app_localizations.dart';
import 'app_exception.dart';

extension AppExceptionMessage on AppException {
  /// The message to show for this failure. Generic API codes get a translated
  /// message so technical server text never reaches the screen.
  String userMessage(AppLocalizations l10n) => switch (this) {
    NetworkException(timedOut: true) => l10n.errorTimeout,
    NetworkException() => l10n.errorOffline,
    ApiException(:final code, :final message) => _apiMessage(code, message, l10n),
    UnexpectedException() => l10n.errorUnexpected,
  };
}

String _apiMessage(String code, String message, AppLocalizations l10n) => switch (code) {
  'BAD_REQUEST' => l10n.errorBadRequest,
  'UNAUTHORIZED' => l10n.errorSessionExpired,
  'FORBIDDEN' => l10n.errorForbidden,
  'NOT_FOUND' => l10n.errorNotFound,
  'PAYLOAD_TOO_LARGE' => l10n.errorFileTooLarge,
  'RATE_LIMITED' => l10n.errorRateLimited,
  'SERVICE_UNAVAILABLE' => l10n.errorServiceUnavailable,
  'INTERNAL_ERROR' => l10n.errorServer,
  // VALIDATION_FAILED, CONFLICT and feature codes (e.g. UPDATE_ALREADY_SUBMITTED)
  // carry a message written for users. Translations per code can be added here.
  _ => message.isNotEmpty ? message : l10n.errorUnexpected,
};
