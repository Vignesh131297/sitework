import 'package:material_ui/material_ui.dart';

import '../l10n/generated/app_localizations.dart';

// Light form checks that catch typos before a request is sent. The server
// normalises and validates everything again.

// The server's rule (normalizePhone): an Indian mobile number is 10 digits starting
// with 6-9, typed with or without +91, 91 or 0; other countries start with "+".
final _indianMobile = RegExp(r'^(?:\+?91|0)?[6-9]\d{9}$');
final _otherCountry = RegExp(r'^\+(?!91)[1-9]\d{9,14}$');
final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// Whether [text] is a mobile number the server accepts. Spaces, dashes and
/// brackets are ignored, as on the server.
bool isValidPhone(String text) {
  final compact = text.trim().replaceAll(RegExp(r'[\s().-]'), '');
  return _indianMobile.hasMatch(compact) || _otherCountry.hasMatch(compact);
}

FormFieldValidator<String> requiredText(AppLocalizations l10n) =>
    (value) => (value == null || value.trim().isEmpty) ? l10n.validationRequired : null;

FormFieldValidator<String> phoneValidator(AppLocalizations l10n, {bool required = true}) => (value) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) return required ? l10n.validationRequired : null;
  return isValidPhone(text) ? null : l10n.validationPhone;
};

/// Sign-in fields take a mobile number or an e-mail; an "@" means e-mail.
FormFieldValidator<String> loginIdentifierValidator(AppLocalizations l10n) => (value) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) return l10n.loginIdentifierRequired;
  if (text.contains('@')) return _email.hasMatch(text) ? null : l10n.validationEmail;
  return isValidPhone(text) ? null : l10n.validationPhone;
};

FormFieldValidator<String> emailValidator(AppLocalizations l10n) => (value) {
  final text = value?.trim() ?? '';
  return text.isEmpty || _email.hasMatch(text) ? null : l10n.validationEmail;
};

FormFieldValidator<String> intRangeValidator(AppLocalizations l10n, int min, int max, {bool required = true}) =>
    (value) {
      final text = value?.trim() ?? '';
      if (text.isEmpty) return required ? l10n.validationRequired : null;
      final number = int.tryParse(text);
      if (number == null) return l10n.validationNumber;
      return number < min || number > max ? l10n.validationRange(min, max) : null;
    };

/// The trimmed text, or null when empty (the API treats null as "not set").
String? textOrNull(TextEditingController controller) {
  final text = controller.text.trim();
  return text.isEmpty ? null : text;
}
