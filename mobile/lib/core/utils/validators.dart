import 'package:material_ui/material_ui.dart';

import '../l10n/generated/app_localizations.dart';

// Light form checks that catch typos before a request is sent. The server
// normalises and validates everything again.

final _phone = RegExp(r'^\+?[0-9][0-9 \-]{8,16}$');
final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

FormFieldValidator<String> requiredText(AppLocalizations l10n) =>
    (value) => (value == null || value.trim().isEmpty) ? l10n.validationRequired : null;

FormFieldValidator<String> phoneValidator(AppLocalizations l10n, {bool required = true}) => (value) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) return required ? l10n.validationRequired : null;
  return _phone.hasMatch(text) ? null : l10n.validationPhone;
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
