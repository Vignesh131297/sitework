import 'package:material_ui/material_ui.dart';

import '../l10n/generated/app_localizations.dart';
import '../network/app_exception.dart';
import '../network/error_messages.dart';

/// Shared form-submission state: a busy flag and a user-facing error message.
mixin SubmitState<T extends StatefulWidget> on State<T> {
  bool submitting = false;
  String? submitError;

  /// Runs [action] once at a time. Returns its result, or null if it failed
  /// (the failure is shown through [submitError]).
  Future<R?> runSubmit<R>(Future<R> Function() action) async {
    if (submitting) return null;
    final l10n = AppLocalizations.of(context);
    setState(() {
      submitting = true;
      submitError = null;
    });
    try {
      return await action();
    } on AppException catch (error) {
      if (mounted) setState(() => submitError = error.userMessage(l10n));
      return null;
    } finally {
      if (mounted) setState(() => submitting = false);
    }
  }
}

/// A form's main button: disabled with a spinner while [busy].
class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key, required this.label, required this.busy, required this.onPressed});

  final String label;
  final bool busy;

  /// Null disables the button (e.g. until the form can be sent).
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: busy ? null : onPressed,
    child: busy ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(label),
  );
}

/// Shows a snack bar with the user-facing message for [error].
void showErrorSnack(BuildContext context, Object error) {
  final l10n = AppLocalizations.of(context);
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(error is AppException ? error.userMessage(l10n) : l10n.errorUnexpected)));
}

void showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
