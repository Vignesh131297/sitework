import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/attachment_strip.dart';
import '../../../core/widgets/status_chip.dart';
import '../../auth/domain/user_role.dart';
import '../../auth/presentation/session_controller.dart';
import '../data/engineer_updates_repository.dart';
import '../domain/engineer_update_models.dart';

/// One engineer update. An admin opening it marks it seen.
class EngineerUpdateDetailScreen extends ConsumerStatefulWidget {
  const EngineerUpdateDetailScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<EngineerUpdateDetailScreen> createState() => _EngineerUpdateDetailScreenState();
}

class _EngineerUpdateDetailScreenState extends ConsumerState<EngineerUpdateDetailScreen> {
  var _marked = false;

  Future<void> _markSeen(EngineerUpdate update) async {
    if (_marked || update.adminViewedAt != null || ref.read(sessionProvider).value?.role != UserRole.admin) return;
    _marked = true;
    try {
      await ref.read(engineerUpdatesRepositoryProvider).markViewed(update.id);
      ref.bump(DataSet.engineerUpdates);
    } on AppException {
      _marked = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    ref.listen(engineerUpdateProvider(widget.id), (_, next) {
      final update = next.value;
      if (update != null) _markSeen(update);
    });
    final value = ref.watch(engineerUpdateProvider(widget.id));
    return Scaffold(
      appBar: AppBar(title: Text(value.value?.type.label(l10n) ?? '')),
      body: AsyncValueView(
        value: value,
        onRetry: () => ref.invalidate(engineerUpdateProvider(widget.id)),
        data: (u) => ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                StatusChip(label: u.type.label(l10n), tone: u.type.tone),
                StatusChip(label: u.priority.label(l10n), tone: u.priority.tone),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (u.title != null) Text(u.title!, style: theme.textTheme.titleLarge),
            Text(u.description, style: theme.textTheme.bodyLarge),
            if (u.progressPercent != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(l10n.fieldProgressValue(u.progressPercent!)),
              const SizedBox(height: AppSpacing.xs),
              LinearProgressIndicator(value: u.progressPercent! / 100, minHeight: 8),
            ],
            const SizedBox(height: AppSpacing.md),
            Text(
              [u.site.name, u.engineer.name, formatDateTime(u.createdAt)].join(' · '),
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              u.adminViewedAt == null
                  ? l10n.engineerUpdateNotSeen
                  : l10n.engineerUpdateSeen(formatDateTime(u.adminViewedAt!)),
              style: theme.textTheme.bodySmall,
            ),
            if (u.attachments.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              AttachmentStrip(attachments: u.attachments),
            ],
          ],
        ),
      ),
    );
  }
}
