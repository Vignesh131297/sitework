import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/enums.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/routing/area.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/utils/relative_time.dart';
import '../../../core/widgets/paged_list_view.dart';
import '../../../core/widgets/status_chip.dart';
import '../data/engineer_updates_repository.dart';
import '../domain/engineer_update_models.dart';

/// Engineer updates, newest first: all the caller may see, or one site's.
class EngineerUpdatesList extends ConsumerWidget {
  const EngineerUpdatesList({super.key, this.siteId, this.header});

  final String? siteId;
  final Widget? header;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final revision = ref.watch(revisionProvider(DataSet.engineerUpdates));
    final repository = ref.watch(engineerUpdatesRepositoryProvider);
    final area = ref.watch(areaPathProvider);
    final header = this.header;
    return PagedListView(
      key: ValueKey('engineer-updates-$siteId-$revision'),
      fetch: (page) => repository.list(page: page, siteId: siteId),
      header: header == null ? null : (context, total) => header,
      itemBuilder: (context, update) => EngineerUpdateTile(
        update: update,
        showSite: siteId == null,
        onTap: () => context.push(AppRoutes.engineerUpdate(area, update.id)),
      ),
      empty: EmptyList(icon: Icons.assignment_outlined, message: l10n.engineerUpdatesEmpty),
    );
  }
}

class EngineerUpdateTile extends StatelessWidget {
  const EngineerUpdateTile({super.key, required this.update, this.showSite = true, this.onTap});

  final EngineerUpdate update;
  final bool showSite;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final u = update;
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: [
                  StatusChip(label: u.type.label(l10n), tone: u.type.tone),
                  if (u.priority == Priority.high || u.priority == Priority.critical)
                    StatusChip(label: u.priority.label(l10n), tone: u.priority.tone),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              if (u.title != null) Text(u.title!, style: theme.textTheme.titleMedium),
              Text(u.description, maxLines: 3, overflow: TextOverflow.ellipsis),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      [if (showSite) u.site.name, u.engineer.name, formatRelative(u.createdAt, l10n)].join(' · '),
                      style: muted,
                    ),
                  ),
                  if (u.attachmentCount > 0) ...[
                    Icon(Icons.photo_outlined, size: 16, color: muted?.color),
                    Text(' ${u.attachmentCount}', style: muted),
                  ],
                  const SizedBox(width: AppSpacing.sm),
                  Icon(
                    u.adminViewedAt != null ? Icons.done_all : Icons.done,
                    size: 16,
                    color: u.adminViewedAt != null ? context.tone(StatusTone.success).foreground : muted?.color,
                    semanticLabel: u.adminViewedAt != null ? l10n.reviewAdminDone : l10n.engineerUpdateNotSeen,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
