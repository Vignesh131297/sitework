import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/submit_state.dart';

/// Shows a new temporary password once, for the admin to pass on. It is not
/// stored anywhere on the phone.
Future<void> showTemporaryPasswordDialog(BuildContext context, {required String name, required String password}) =>
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        final theme = Theme.of(context);
        return AlertDialog(
          icon: const Icon(Icons.key_outlined),
          title: Text(l10n.tempPasswordTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.tempPasswordBody(name)),
              const SizedBox(height: AppSpacing.lg),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: SelectableText(
                  password,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(fontFamily: 'monospace', letterSpacing: 1.5),
                ),
              ),
            ],
          ),
          actions: [
            TextButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: password));
                if (context.mounted) showSnack(context, l10n.commonCopied);
              },
              icon: const Icon(Icons.copy_outlined),
              label: Text(l10n.commonCopy),
            ),
            FilledButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.commonOk)),
          ],
        );
      },
    );
