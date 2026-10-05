import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/network/error_messages.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/info_widgets.dart';
import '../../../core/widgets/submit_state.dart';
import '../../auth/presentation/session_controller.dart';
import '../data/update_queue.dart';
import '../domain/pending_update.dart';

/// Updates saved on this phone that the server hasn't accepted yet.
class PendingUpdatesCard extends ConsumerWidget {
  const PendingUpdatesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final userId = ref.watch(sessionProvider).value?.userId;
    final items = [
      for (final item in ref.watch(updateQueueProvider).value ?? const <PendingUpdate>[])
        if (item.userId == userId) item,
    ];
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          l10n.queueTitle,
          trailing: items.any((i) => i.state == PendingState.waiting)
              ? TextButton(
                  onPressed: () => ref.read(updateQueueProvider.notifier).flush(userId!),
                  child: Text(l10n.queueSendNow),
                )
              : null,
        ),
        for (final item in items) _PendingTile(item: item),
      ],
    );
  }
}

class _PendingTile extends ConsumerWidget {
  const _PendingTile({required this.item});

  final PendingUpdate item;

  Future<void> _discard(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.queueDiscardTitle,
      message: l10n.queueDiscardBody,
      confirmLabel: l10n.queueDiscard,
      destructive: true,
    );
    if (confirmed) await ref.read(updateQueueProvider.notifier).discard(item.id);
  }

  Future<void> _retry(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(updateQueueProvider.notifier).retry(item.id);
    final error = result.error;
    if (context.mounted && error != null && result.outcome == SendOutcome.rejected) showErrorSnack(context, error);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final status = switch (item.state) {
      PendingState.waiting => l10n.queueWaiting,
      PendingState.sending => l10n.queueSending,
      PendingState.failed => l10n.queueFailed(
        ApiException(
          statusCode: 400,
          code: item.errorCode ?? 'BAD_REQUEST',
          message: item.errorMessage ?? '',
        ).userMessage(l10n),
      ),
    };
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(item.photoPath),
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                cacheWidth: 128,
                errorBuilder: (_, _, _) => const SizedBox.square(dimension: 64, child: Icon(Icons.image_outlined)),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.queueTaken(item.slot.label(l10n), formatDateTime(item.capturedAt)),
                    style: theme.textTheme.titleSmall,
                  ),
                  Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    status,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: item.state == PendingState.failed
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (item.state != PendingState.sending)
                    Wrap(
                      spacing: AppSpacing.sm,
                      children: [
                        if (item.state == PendingState.failed)
                          TextButton(onPressed: () => _retry(context, ref), child: Text(l10n.commonRetry)),
                        TextButton(onPressed: () => _discard(context, ref), child: Text(l10n.queueDiscard)),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
