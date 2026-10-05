import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/network/error_messages.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/widgets/inline_message.dart';
import '../data/auth_repository.dart';
import 'password_field.dart';
import 'session_controller.dart';

/// Voluntary change (from Profile) or forced after an admin reset, when the
/// server accepts nothing else until the temporary password is replaced.
class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  var _saving = false;
  String? _error;

  @override
  void dispose() {
    for (final controller in [_current, _password, _confirm]) {
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
          .changePassword(currentPassword: _current.text, newPassword: _password.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.changePasswordDone)));
      final session = ref.read(sessionProvider).value;
      ref.read(sessionProvider.notifier).passwordChanged();
      if (session != null && session.mustChangePassword) {
        context.go(session.role.homePath);
      } else if (context.canPop()) {
        context.pop();
      }
    } on AppException catch (error) {
      if (mounted) setState(() => _error = error.userMessage(l10n));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final forced = ref.watch(sessionProvider).value?.mustChangePassword ?? false;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.changePasswordTitle),
        automaticallyImplyLeading: !forced,
        actions: [
          if (forced)
            TextButton(onPressed: () => ref.read(sessionProvider.notifier).signOut(), child: Text(l10n.profileSignOut)),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screen,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (forced) ...[
                  InlineMessage(message: l10n.changePasswordForcedBody, tone: StatusTone.info),
                  const SizedBox(height: AppSpacing.lg),
                ],
                if (_error != null) ...[InlineMessage(message: _error!), const SizedBox(height: AppSpacing.lg)],
                PasswordField(
                  controller: _current,
                  label: forced ? l10n.temporaryPasswordLabel : l10n.currentPasswordLabel,
                  validator: (value) => (value ?? '').isEmpty ? l10n.loginPasswordRequired : null,
                ),
                const SizedBox(height: AppSpacing.lg),
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
                FilledButton(onPressed: _saving ? null : _save, child: Text(l10n.changePasswordSubmit)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
