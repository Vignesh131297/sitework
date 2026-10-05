import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/info_widgets.dart';
import '../../../core/widgets/inline_message.dart';
import '../../../core/widgets/status_chip.dart';
import '../domain/admin_dashboard.dart';

/// The date, and a note when no updates are due today.
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key, required this.date, required this.isWorkingDay, this.holiday});

  final String date;
  final bool isWorkingDay;
  final String? holiday;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(formatDate(date), style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        if (!isWorkingDay) ...[
          const SizedBox(height: AppSpacing.md),
          InlineMessage(
            tone: StatusTone.info,
            message: holiday != null ? l10n.dashboardHoliday(holiday!) : l10n.dashboardDayOff,
          ),
        ],
      ],
    );
  }
}

/// Two columns of equal-height cards.
class StatGrid extends StatelessWidget {
  const StatGrid({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += 2) {
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: children[i]),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: i + 1 < children.length ? children[i + 1] : const SizedBox()),
            ],
          ),
        ),
      );
      if (i + 2 < children.length) rows.add(const SizedBox(height: AppSpacing.md));
    }
    return Column(children: rows);
  }
}

/// Today's staff updates: submitted of expected, and what is outstanding.
class UpdatesCard extends StatelessWidget {
  const UpdatesCard({super.key, required this.totals, required this.isWorkingDay});

  final DayTotals totals;
  final bool isWorkingDay;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final progress = totals.expected == 0 ? 0.0 : totals.submitted / totals.expected;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.todayUpdatesTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.updatesSubmittedOf(totals.submitted, totals.expected),
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: progress, minHeight: 8),
            ),
            if (isWorkingDay) ...[
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  if (totals.missing > 0)
                    StatusChip(label: l10n.updatesMissing(totals.missing), tone: StatusTone.danger),
                  if (totals.pending > 0)
                    StatusChip(label: l10n.updatesPending(totals.pending), tone: StatusTone.warning),
                  if (totals.upcoming > 0)
                    StatusChip(label: l10n.updatesUpcoming(totals.upcoming), tone: StatusTone.neutral),
                  if (totals.notCheckedIn > 0)
                    StatusChip(label: l10n.updatesNotCheckedIn(totals.notCheckedIn), tone: StatusTone.warning),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A count with a label that opens a list (photos to review, open issues);
/// without a count, a plain link.
class CountTile extends StatelessWidget {
  const CountTile({
    super.key,
    required this.icon,
    required this.tone,
    required this.title,
    this.count,
    this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final StatusTone tone;
  final String title;
  final int? count;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: context.tone(tone).foreground),
        title: Text(title),
        subtitle: subtitle == null ? null : Text(subtitle!),
        trailing: count == null
            ? const Icon(Icons.chevron_right)
            : Text('$count', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
      ),
    );
  }
}

/// What needs someone's attention today, or a reassuring note when nothing does.
class AttentionSection extends StatelessWidget {
  const AttentionSection({super.key, required this.items, required this.onOpen});

  final List<AttentionItem> items;
  final ValueChanged<AttentionItem> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final known = [
      for (final item in items)
        if (item is! UnknownAttentionItem) item,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(l10n.attentionTitle),
        if (known.isEmpty)
          InlineMessage(message: l10n.attentionNothing, tone: StatusTone.success)
        else
          Card(
            child: Column(
              children: [for (final item in known) _AttentionTile(item: item, onTap: () => onOpen(item))],
            ),
          ),
      ],
    );
  }
}

class _AttentionTile extends StatelessWidget {
  const _AttentionTile({required this.item, required this.onTap});

  final AttentionItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (icon, tone, text, siteName) = switch (item) {
      MissingUpdatesItem(:final site, :final count, :final staffNames) => (
        Icons.photo_camera_outlined,
        StatusTone.danger,
        l10n.attentionMissing(count, staffNames.join(', ')),
        site.name,
      ),
      NotCheckedInItem(:final site, :final count, :final staffNames) => (
        Icons.how_to_reg_outlined,
        StatusTone.warning,
        l10n.attentionNotCheckedIn(count, staffNames.join(', ')),
        site.name,
      ),
      OverduePaymentItem(:final site, :final milestone, :final outstanding, :final dueDate) => (
        Icons.currency_rupee,
        StatusTone.danger,
        l10n.attentionOverdue(milestone.title, formatInr(outstanding), formatDate(dueDate)),
        site.name,
      ),
      CriticalIssueItem(:final site, :final issue) => (
        Icons.report_problem_outlined,
        StatusTone.danger,
        l10n.attentionCritical(issue.title),
        site.name,
      ),
      UnknownAttentionItem() => (Icons.info_outline, StatusTone.neutral, '', ''),
    };
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: context.tone(tone).foreground),
      title: Text(siteName),
      subtitle: Text(text),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

/// A site's day at a glance: engineers, staff, updates and latest activity.
class SiteActivityCard extends StatelessWidget {
  const SiteActivityCard({super.key, required this.activity, required this.onTap});

  final SiteActivity activity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final updates = activity.updates;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(activity.site.name, style: theme.textTheme.titleMedium)),
                  StatusChip(label: activity.site.status.label(l10n), tone: activity.site.status.tone),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                activity.engineers.isEmpty ? l10n.siteNoEngineer : activity.engineers.join(', '),
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(child: Text(l10n.staffCount(activity.staffCount))),
                  Flexible(
                    child: Text(l10n.updatesSubmittedOf(updates.submitted, updates.expected), textAlign: TextAlign.end),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: updates.expected == 0 ? 0 : updates.submitted / updates.expected,
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              // Wraps on narrow screens and with large text instead of overflowing.
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.xs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (updates.missing > 0)
                    StatusChip(label: l10n.updatesMissing(updates.missing), tone: StatusTone.danger),
                  Text(
                    activity.lastActivityAt == null
                        ? l10n.siteActivityNone
                        : l10n.siteActivityLast(formatDateTime(activity.lastActivityAt!)),
                    style: theme.textTheme.bodySmall,
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
