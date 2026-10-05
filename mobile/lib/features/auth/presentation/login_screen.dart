import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/config/app_config.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/network/error_messages.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/widgets/inline_message.dart';
import '../../system/presentation/server_status.dart';
import 'password_field.dart';
import 'session_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  var _submitting = false;
  String? _error;

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting || !_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      // On success the router moves on to the user's home screen.
      await ref.read(sessionProvider.notifier).signIn(_identifier.text, _password.text);
    } on AppException catch (error) {
      if (mounted) setState(() => _error = error.userMessage(l10n));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _useDevLogin(DevLogin login) {
    _identifier.text = login.identifier;
    _password.text = login.password;
    _submit();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final devLogins = ref.watch(appConfigProvider).devLogins;
    final sessionEnded = ref.watch(sessionNoticeProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: AutofillGroup(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _BrandHeader(),
                      const SizedBox(height: AppSpacing.xxl),
                      if (sessionEnded && _error == null) ...[
                        InlineMessage(message: l10n.loginSessionEnded, tone: StatusTone.info),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                      if (_error != null) ...[InlineMessage(message: _error!), const SizedBox(height: AppSpacing.lg)],
                      TextFormField(
                        controller: _identifier,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.username],
                        decoration: InputDecoration(
                          labelText: l10n.loginIdentifierLabel,
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        validator: (value) => (value ?? '').trim().isEmpty ? l10n.loginIdentifierRequired : null,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      PasswordField(
                        controller: _password,
                        label: l10n.loginPasswordLabel,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submit(),
                        validator: (value) => (value ?? '').isEmpty ? l10n.loginPasswordRequired : null,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => context.push(
                            Uri(
                              path: AppRoutes.forgotPassword,
                              queryParameters: {'identifier': _identifier.text.trim()},
                            ).toString(),
                          ),
                          child: Text(l10n.loginForgotPassword),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      FilledButton(
                        onPressed: _submitting ? null : _submit,
                        child: _submitting
                            ? const SizedBox.square(dimension: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                            : Text(l10n.loginSubmit),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      const ServerStatus(),
                      if (devLogins.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xl),
                        _DevLogins(logins: devLogins, onSelected: _submitting ? null : _useDevLogin),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(color: scheme.primary, borderRadius: BorderRadius.circular(AppRadius.lg)),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Icon(Icons.construction, size: 40, color: scheme.onPrimary),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.appTitle, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSpacing.xs),
        Text(l10n.appTagline, style: theme.textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant)),
      ],
    );
  }
}

/// Development builds only: one tap signs in as a seeded account.
class _DevLogins extends StatelessWidget {
  const _DevLogins({required this.logins, required this.onSelected});

  final List<DevLogin> logins;
  final ValueChanged<DevLogin>? onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Text(l10n.loginDevQuickSignIn, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          alignment: WrapAlignment.center,
          children: [
            for (final login in logins)
              ActionChip(label: Text(login.label), onPressed: onSelected == null ? null : () => onSelected!(login)),
          ],
        ),
      ],
    );
  }
}
