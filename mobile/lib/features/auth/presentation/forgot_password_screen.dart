import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/network/error_messages.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/widgets/inline_message.dart';
import '../data/auth_repository.dart';

/// Requests an e-mailed reset code. Staff without e-mail are told to ask their admin.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key, this.initialIdentifier = ''});

  final String initialIdentifier;

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _identifier = TextEditingController(text: widget.initialIdentifier);
  var _sending = false;
  String? _sentMessage;
  String? _error;

  @override
  void dispose() {
    _identifier.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_sending || !_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      final message = await ref.read(authRepositoryProvider).requestPasswordReset(_identifier.text);
      if (mounted) setState(() => _sentMessage = message);
    } on AppException catch (error) {
      if (mounted) setState(() => _error = error.userMessage(l10n));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _enterCode() => context.push(
    Uri(path: AppRoutes.resetPassword, queryParameters: {'identifier': _identifier.text.trim()}).toString(),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.forgotTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screen,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.forgotBody, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: AppSpacing.xl),
                TextFormField(
                  controller: _identifier,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _send(),
                  decoration: InputDecoration(
                    labelText: l10n.loginIdentifierLabel,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  validator: (value) => (value ?? '').trim().isEmpty ? l10n.loginIdentifierRequired : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                if (_error != null) ...[InlineMessage(message: _error!), const SizedBox(height: AppSpacing.lg)],
                if (_sentMessage != null) ...[
                  InlineMessage(message: _sentMessage!, tone: StatusTone.info),
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton(onPressed: _enterCode, child: Text(l10n.forgotHaveCode)),
                  const SizedBox(height: AppSpacing.sm),
                  OutlinedButton(onPressed: _sending ? null : _send, child: Text(l10n.forgotSendAgain)),
                ] else ...[
                  FilledButton(onPressed: _sending ? null : _send, child: Text(l10n.forgotSend)),
                  const SizedBox(height: AppSpacing.sm),
                  TextButton(onPressed: _enterCode, child: Text(l10n.forgotHaveCode)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
