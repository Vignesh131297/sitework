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
import '../../../core/utils/relative_time.dart';
import '../../../core/widgets/paged_list_view.dart';
import '../../../core/widgets/status_chip.dart';
import '../data/issues_repository.dart';
import '../domain/issue_models.dart';

enum _Filter { unresolved, open, inProgress, resolved, all }

/// Issues, most urgent unresolved first: everywhere the caller may see, or one site.
class IssuesList extends ConsumerStatefulWidget {
  const IssuesList({super.key, this.siteId, this.action});

  final String? siteId;

  /// Shown above the filters (e.g. "Report issue" on a site's page).
  final Widget? action;

  @override
  ConsumerState<IssuesList> createState() => _IssuesListState();
}

class _IssuesListState extends ConsumerState<IssuesList> {
  var _filter = _Filter.unresolved;

  String _label(_Filter filter, AppLocalizations l10n) => switch (filter) {
    _Filter.unresolved => l10n.issueFilterUnresolved,
    _Filter.open => IssueStatus.open.label(l10n),
    _Filter.inProgress => IssueStatus.inProgress.label(l10n),
    _Filter.resolved => IssueStatus.resolved.label(l10n),
    _Filter.all => l10n.commonAll,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final revision = ref.watch(revisionProvider(DataSet.issues));
    final repository = ref.watch(issuesRepositoryProvider);
    final area = ref.watch(areaPathProvider);
    final status = switch (_filter) {
      _Filter.open => IssueStatus.open,
      _Filter.inProgress => IssueStatus.inProgress,
      _Filter.resolved => IssueStatus.resolved,
      _Filter.unresolved || _Filter.all => null,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ?widget.action,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
          child: Row(
            children: [
              for (final filter in _Filter.values)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: ChoiceChip(
                    label: Text(_label(filter, l10n)),
                    selected: _filter == filter,
                    onSelected: (_) => setState(() => _filter = filter),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: PagedListView(
            key: ValueKey('issues-${widget.siteId}-$_filter-$revision'),
            fetch: (page) => repository.list(
              page: page,
              siteId: widget.siteId,
              status: status,
              unresolved: _filter == _Filter.unresolved,
            ),
            itemBuilder: (context, issue) => IssueTile(
              issue: issue,
              showSite: widget.siteId == null,
              onTap: () => context.push(AppRoutes.issue(area, issue.id)),
            ),
            empty: EmptyList(icon: Icons.verified_outlined, message: l10n.issuesEmpty),
          ),
        ),
      ],
    );
  }
}

class IssueTile extends StatelessWidget {
  const IssueTile({super.key, required this.issue, this.showSite = true, this.onTap});

  final Issue issue;
  final bool showSite;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final i = issue;
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
                  StatusChip(label: i.status.label(l10n), tone: i.status.tone),
                  StatusChip(label: i.priority.label(l10n), tone: i.priority.tone),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(i.title, style: theme.textTheme.titleMedium),
              Text(i.description, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: AppSpacing.sm),
              Text(
                [
                  if (showSite) i.site.name,
                  i.reportedBy.name,
                  formatRelative(i.createdAt, l10n),
                  if (i.attachmentCount > 0) l10n.attachmentsCount(i.attachmentCount),
                ].join(' · '),
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
