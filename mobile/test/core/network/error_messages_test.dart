import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sitework/core/l10n/generated/app_localizations.dart';
import 'package:sitework/core/network/app_exception.dart';
import 'package:sitework/core/network/error_messages.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));

  group('userMessage', () {
    test('explains network failures', () {
      expect(const NetworkException().userMessage(l10n), l10n.errorOffline);
      expect(const NetworkException(timedOut: true).userMessage(l10n), l10n.errorTimeout);
    });

    test('replaces generic server text with a translated message', () {
      const error = ApiException(statusCode: 400, code: 'BAD_REQUEST', message: 'Unexpected end of JSON input');
      expect(error.userMessage(l10n), l10n.errorBadRequest);
      expect(const ApiException(statusCode: 500, code: 'INTERNAL_ERROR').userMessage(l10n), l10n.errorServer);
    });

    test('shows the server message for feature-specific codes', () {
      const error = ApiException(
        statusCode: 409,
        code: 'UPDATE_ALREADY_SUBMITTED',
        message: 'Morning update has already been submitted.',
      );
      expect(error.userMessage(l10n), 'Morning update has already been submitted.');
    });

    test('falls back to a generic message when the server sent none', () {
      expect(const ApiException(statusCode: 409, code: 'SOMETHING_NEW').userMessage(l10n), l10n.errorUnexpected);
      expect(UnexpectedException(Exception('boom')).userMessage(l10n), l10n.errorUnexpected);
    });
  });
}
