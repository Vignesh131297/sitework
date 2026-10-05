import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/network/error_messages.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/status_chip.dart';
import '../data/system_api.dart';
import '../domain/server_health.dart';

final serverHealthProvider = FutureProvider.autoDispose<ServerHealth>((ref) => ref.watch(systemApiProvider).health());

/// Shows whether the app can reach the API, with a retry when it can't.
class ServerStatus extends ConsumerWidget {
  const ServerStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final muted = textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);

    return ref
        .watch(serverHealthProvider)
        .when(
          data: (health) => Column(
            children: [
              StatusChip(label: l10n.serverConnected, tone: StatusTone.success, icon: Icons.check_circle_outline),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.serverDetails(health.environment, health.version, formatTime(health.serverTime)),
                style: muted,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          error: (error, _) => Column(
            children: [
              StatusChip(label: l10n.serverUnreachable, tone: StatusTone.danger, icon: Icons.cloud_off_outlined),
              const SizedBox(height: AppSpacing.sm),
              Text(
                error is AppException ? error.userMessage(l10n) : l10n.errorUnexpected,
                style: muted,
                textAlign: TextAlign.center,
              ),
              TextButton.icon(
                onPressed: () => ref.invalidate(serverHealthProvider),
                icon: const Icon(Icons.refresh),
                label: Text(l10n.commonRetry),
              ),
            ],
          ),
          loading: () => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2)),
              const SizedBox(width: AppSpacing.sm),
              Text(l10n.serverChecking, style: muted),
            ],
          ),
        );
  }
}
