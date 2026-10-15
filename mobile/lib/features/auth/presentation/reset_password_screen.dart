import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/network/error_messages.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/inline_message.dart';
import '../data/auth_repository.dart';
import 'password_field.dart';

/// Sets a new password with the 6-digit code from the reset e-mail.
class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key, this.identifier = ''});

  final String identifier;

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _identifier = TextEditingController(text: widget.identifier);
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  var _saving = false;
  String? _error;

  @override
  void dispose() {
    for (final controller in [_identifier, _code, _password, _confirm]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(authRepositoryProvider)
          .resetPassword(identifier: _identifier.text, code: _code.text, newPassword: _password.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.resetDone)));
      context.go(AppRoutes.login);
    } on AppException catch (error) {
      if (mounted) setState(() => _error = error.userMessage(l10n));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.resetTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screen,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_error != null) ...[InlineMessage(message: _error!), const SizedBox(height: AppSpacing.lg)],
                TextFormField(
                  controller: _identifier,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: l10n.loginIdentifierLabel,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  validator: loginIdentifierValidator(l10n),
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _code,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  autofillHints: const [AutofillHints.oneTimeCode],
                  decoration: InputDecoration(
                    labelText: l10n.resetCodeLabel,
                    prefixIcon: const Icon(Icons.pin_outlined),
                  ),
                  validator: (value) => RegExp(r'^\d{6}$').hasMatch(value ?? '') ? null : l10n.resetCodeInvalid,
                ),
                const SizedBox(height: AppSpacing.sm),
                PasswordField(
                  controller: _password,
                  label: l10n.newPasswordLabel,
                  helperText: l10n.passwordHelper,
                  autofillHints: const [AutofillHints.newPassword],
                  validator: (value) => newPasswordProblem(value ?? '', l10n),
                ),
                const SizedBox(height: AppSpacing.lg),
                PasswordField(
                  controller: _confirm,
                  label: l10n.confirmPasswordLabel,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.newPassword],
                  onSubmitted: (_) => _save(),
                  validator: (value) => value == _password.text ? null : l10n.passwordsDontMatch,
                ),
                const SizedBox(height: AppSpacing.xl),
                FilledButton(onPressed: _saving ? null : _save, child: Text(l10n.resetSubmit)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
