import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/network/error_messages.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/inline_message.dart';
import 'password_field.dart';
import 'session_controller.dart';

/// Setting up SiteWork: the first admin creates their own account. Only open
/// while the server has no admin; after that admins create every account.
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  var _saving = false;
  String? _error;

  @override
  void dispose() {
    for (final controller in [_name, _phone, _email, _password, _confirm]) {
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
      // On success the router moves on to the admin's dashboard.
      await ref
          .read(sessionProvider.notifier)
          .signUp(name: _name.text, phone: _phone.text, email: textOrNull(_email), password: _password.text);
    } on AppException catch (error) {
      if (mounted) setState(() => _error = error.userMessage(l10n));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const gap = SizedBox(height: AppSpacing.lg);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.signUpTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screen,
          child: AutofillGroup(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InlineMessage(message: l10n.signUpIntro, tone: StatusTone.info),
                  gap,
                  if (_error != null) ...[InlineMessage(message: _error!), gap],
                  TextFormField(
                    controller: _name,
                    decoration: InputDecoration(
                      labelText: l10n.fieldName,
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.name],
                    validator: requiredText(l10n),
                  ),
                  gap,
                  TextFormField(
                    controller: _phone,
                    decoration: InputDecoration(
                      labelText: l10n.fieldPhone,
                      prefixIcon: const Icon(Icons.phone_outlined),
                    ),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.telephoneNumber],
                    validator: phoneValidator(l10n),
                  ),
                  gap,
                  TextFormField(
                    controller: _email,
                    decoration: InputDecoration(
                      labelText: l10n.fieldEmail,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    validator: emailValidator(l10n),
                  ),
                  gap,
                  PasswordField(
                    controller: _password,
                    label: l10n.loginPasswordLabel,
                    helperText: l10n.passwordHelper,
                    autofillHints: const [AutofillHints.newPassword],
                    validator: (value) => newPasswordProblem(value ?? '', l10n),
                  ),
                  gap,
                  PasswordField(
                    controller: _confirm,
                    label: l10n.confirmPasswordLabel,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.newPassword],
                    onSubmitted: (_) => _save(),
                    validator: (value) => value == _password.text ? null : l10n.passwordsDontMatch,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  FilledButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox.square(dimension: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                        : Text(l10n.signUpSubmit),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
