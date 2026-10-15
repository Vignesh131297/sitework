import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/enums.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/routing/area.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/info_widgets.dart';
import '../../../core/widgets/status_chip.dart';
import '../../stock/domain/stock_models.dart';
import '../domain/report_models.dart';

/// A report's figures as cards, one per site, person or engineer.
class ReportResultView extends StatelessWidget {
  const ReportResultView({super.key, required this.result});

  final ReportResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final empty = EmptyState(icon: Icons.insert_chart_outlined, title: l10n.reportsEmpty);
    return switch (result) {
      SitesReport(:final rows) when rows.isEmpty => empty,
      StaffReport(:final rows) when rows.isEmpty => empty,
      EngineersReport(:final rows) when rows.isEmpty => empty,
      StockReport(:final rows) when rows.isEmpty => empty,
      StockReport(:final rows) => _StockView(rows: rows),
      SitesReport(:final rows) => Column(children: [for (final row in rows) _SiteCard(row: row)]),
      StaffReport(:final rows) => Column(children: [for (final row in rows) _StaffCard(row: row)]),
      EngineersReport(:final rows) => Column(children: [for (final row in rows) _EngineerCard(row: row)]),
      PaymentsReport(:final report) => _PaymentsView(report: report),
    };
  }
}

class _SiteCard extends ConsumerWidget {
  const _SiteCard({required this.row});

  final SiteReportRow row;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final area = ref.watch(areaPathProvider);
    final received = row.received;
    return _ReportCard(
      title: row.site.name,
      subtitle: '${row.site.code} · ${row.client.name}',
      trailing: ComplianceChip(percent: row.updates.compliancePercent),
      onTap: () => context.push(AppRoutes.site(area, row.site.id)),
      children: [
        _MetricGroup(title: l10n.reportsGroupUpdates, metrics: _updateMetrics(l10n, row.updates)),
        _MetricGroup(title: l10n.reportsGroupAttendance, metrics: _attendanceMetrics(l10n, row.attendance)),
        _MetricGroup(
          title: l10n.reportsGroupWork,
          metrics: [
            _Metric(l10n.reportsEngineerUpdates, row.engineerUpdates),
            _Metric(l10n.reportsIssuesOpened, row.issues.opened),
            _Metric(l10n.reportsIssuesResolved, row.issues.resolved),
            _Metric(l10n.reportsIssuesOpenNow, row.issues.openNow, alert: StatusTone.danger),
          ],
        ),
        if (received != null)
          AmountTile(label: l10n.reportsReceivedInRange, amount: formatInr(received), tone: StatusTone.success),
      ],
    );
  }
}

class _StaffCard extends StatelessWidget {
  const _StaffCard({required this.row});

  final StaffReportRow row;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final staff = row.staff;
    return _ReportCard(
      title: staff.name,
      subtitle: [
        staff.employeeCode,
        if (staff.designation case final designation?) designation.label(l10n),
        row.site?.name ?? l10n.filterUnassigned,
        if (!staff.isActive) l10n.commonInactive,
      ].join(' · '),
      trailing: ComplianceChip(percent: row.updates.compliancePercent),
      children: [
        _MetricGroup(title: l10n.reportsGroupUpdates, metrics: _updateMetrics(l10n, row.updates)),
        _MetricGroup(title: l10n.reportsGroupAttendance, metrics: _attendanceMetrics(l10n, row.attendance)),
      ],
    );
  }
}

class _EngineerCard extends StatelessWidget {
  const _EngineerCard({required this.row});

  final EngineerReportRow row;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reviews = row.reviews;
    final rate = reviews.reviewRatePercent;
    return _ReportCard(
      title: row.engineer.name,
      subtitle: [row.engineer.employeeCode, if (!row.engineer.isActive) l10n.commonInactive].join(' · '),
      children: [
        _MetricGroup(
          title: l10n.reportsGroupReviews,
          metrics: [
            _Metric(l10n.reportsPhotos, reviews.photos),
            _Metric(l10n.reportsReviewed, reviews.reviewed),
            _Metric.text(
              l10n.reportsReviewRate,
              rate == null ? '–' : '$rate%',
              tone: rate == null ? null : _percentTone(rate),
            ),
            _Metric.text(l10n.reportsReviewMinutes, reviews.averageMinutes == null ? '–' : '${reviews.averageMinutes}'),
          ],
        ),
        _MetricGroup(
          title: l10n.reportsGroupWork,
          metrics: [
            _Metric(l10n.reportKindSites, row.sites),
            _Metric(l10n.reportsEngineerUpdates, row.engineerUpdates),
            _Metric(l10n.reportsIssuesReported, row.issues.reported),
            _Metric(l10n.reportsIssuesResolved, row.issues.resolved),
          ],
        ),
      ],
    );
  }
}

class _PaymentsView extends ConsumerWidget {
  const _PaymentsView({required this.report});

  final PaymentReport report;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final area = ref.watch(areaPathProvider);
    final totals = report.totals;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AmountTile(
                  label: l10n.reportsReceivedInRange,
                  amount: formatInr(totals.received),
                  tone: StatusTone.success,
                  caption: l10n.reportsPaymentCount(totals.count),
                ),
                for (final method in PaymentMethod.values)
                  if (totals.byMethod[method.apiValue] case final amount?)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: Row(
                        children: [
                          Expanded(child: Text(method.label(l10n))),
                          Text(formatInr(amount), style: theme.textTheme.titleSmall),
                        ],
                      ),
                    ),
              ],
            ),
          ),
        ),
        SectionHeader(l10n.paymentsBySite),
        for (final site in report.sites)
          _ReportCard(
            title: site.site.name,
            subtitle: '${site.site.code} · ${site.client.name}',
            onTap: () => context.push(AppRoutes.site(area, site.site.id, tab: 'payments')),
            children: [
              _MetricGroup(
                wide: true,
                metrics: [
                  _Metric.text(l10n.reportsInRange, formatInr(site.receivedInRange)),
                  _Metric.text(l10n.reportsReceivedToDate, formatInr(site.receivedToDate)),
                  _Metric.text(l10n.paymentsPending, formatInr(site.pending)),
                  _Metric.text(
                    l10n.paymentsOverdue,
                    formatInr(site.overdue),
                    tone: double.parse(site.overdue) > 0 ? StatusTone.danger : null,
                  ),
                ],
              ),
            ],
          ),
        SectionHeader(l10n.reportsPaymentsInRange),
        if (report.payments.isEmpty)
          EmptyState(icon: Icons.receipt_long_outlined, title: l10n.reportsNoPayments)
        else
          Card(
            child: Column(
              children: [
                for (final payment in report.payments)
                  ListTile(
                    title: Text(formatInr(payment.amount)),
                    subtitle: Text(
                      [
                        formatDate(payment.paidOn),
                        payment.method.label(l10n),
                        payment.site.name,
                        ?payment.reference,
                      ].join(' · '),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

List<_Metric> _updateMetrics(AppLocalizations l10n, UpdateCounts updates) => [
  _Metric(l10n.reportsUpdatesSent, updates.submitted),
  _Metric(l10n.reportsUpdatesMissed, updates.missed, alert: StatusTone.danger),
  _Metric(l10n.reportsSentOffline, updates.offline),
  _Metric(l10n.reportsLocationFlagged, updates.locationFlagged, alert: StatusTone.warning),
];

List<_Metric> _attendanceMetrics(AppLocalizations l10n, AttendanceCounts attendance) => [
  _Metric(l10n.attendancePresent, attendance.present),
  _Metric(l10n.attendanceLate, attendance.late, alert: StatusTone.warning),
  _Metric(l10n.attendanceHalfDay, attendance.halfDay),
  _Metric(l10n.attendanceAbsent, attendance.absent, alert: StatusTone.danger),
];

StatusTone _percentTone(int percent) => percent >= 90
    ? StatusTone.success
    : percent >= 70
    ? StatusTone.warning
    : StatusTone.danger;

/// Share of due photo updates that were sent: green from 90%, amber from 70%.
class ComplianceChip extends StatelessWidget {
  const ComplianceChip({super.key, required this.percent});

  final int? percent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = percent;
    return p == null
        ? StatusChip(label: l10n.reportsNothingDue, tone: StatusTone.neutral)
        : StatusChip(label: l10n.reportsCompliance(p), tone: _percentTone(p));
  }
}

/// Stock over the dates: one card per place (godowns first, then sites), each
/// material from what was there at the start to what was left. Admins also
/// see what the used stock cost.
class _StockView extends ConsumerWidget {
  const _StockView({required this.rows});

  final List<StockReportRow> rows;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final area = ref.watch(areaPathProvider);
    final places = <String, List<StockReportRow>>{};
    for (final row in rows) {
      places.putIfAbsent('${row.place.apiValue}:${row.site?.id ?? row.godown?.id}', () => []).add(row);
    }
    return Column(
      children: [
        for (final materials in places.values)
          _ReportCard(
            title: materials.first.site?.name ?? materials.first.godown?.name ?? '',
            subtitle: materials.first.site?.code ?? l10n.stockGodownLabel,
            onTap: switch (materials.first) {
              StockReportRow(:final site?) => () => context.push(AppRoutes.site(area, site.id, tab: 'stock')),
              StockReportRow(:final godown?) => () => context.push(AppRoutes.stockGodown(area, godown.id)),
              _ => null,
            },
            children: [
              for (final row in materials)
                _MetricGroup(
                  title: '${row.material.name} (${row.material.unit})',
                  metrics: [
                    _Metric.text(l10n.reportsStockOpening, formatQuantity(row.opening)),
                    _Metric.text(l10n.reportsStockReceived, formatQuantity(row.received)),
                    _Metric.text(l10n.reportsStockUsed, formatQuantity(row.used)),
                    _Metric.text(l10n.reportsStockClosing, formatQuantity(row.closing)),
                    if (num.parse(row.sentOut) != 0)
                      _Metric.text(l10n.reportsStockSentOut, formatQuantity(row.sentOut)),
                    if (num.parse(row.wasted) != 0)
                      _Metric.text(l10n.reportsStockWasted, formatQuantity(row.wasted), tone: StatusTone.danger),
                    if (num.parse(row.adjusted) != 0)
                      _Metric.text(l10n.reportsStockAdjusted, formatQuantity(row.adjusted), tone: StatusTone.warning),
                    if (row.usedValue case final value? when num.parse(value) != 0)
                      _Metric.text(l10n.reportsStockUsedValue, formatInr(value)),
                  ],
                ),
            ],
          ),
      ],
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.title, required this.subtitle, required this.children, this.trailing, this.onTap});

  final String title;
  final String subtitle;
  final List<Widget> children;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: theme.textTheme.titleMedium),
                        Text(subtitle, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  // Its own width (capped), so long names keep the rest of the row.
                  if (trailing case final trailing?)
                    Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.sm),
                      child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 140), child: trailing),
                    ),
                ],
              ),
              for (final child in children) ...[const SizedBox(height: AppSpacing.md), child],
            ],
          ),
        ),
      ),
    );
  }
}

class _Metric {
  /// A count, coloured with [alert] when it isn't zero.
  _Metric(this.label, int count, {StatusTone? alert}) : value = '$count', tone = count > 0 ? alert : null;

  _Metric.text(this.label, this.value, {this.tone});

  final String label;
  final String value;
  final StatusTone? tone;
}

/// Figures in a grid (four columns, or two for [wide] values such as amounts),
/// with an optional caption above.
class _MetricGroup extends StatelessWidget {
  const _MetricGroup({this.title, required this.metrics, this.wide = false});

  final String? title;
  final List<_Metric> metrics;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title case final title?) ...[
          Text(title, style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary)),
          const SizedBox(height: AppSpacing.xs),
        ],
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = wide || constraints.maxWidth < 280 ? 2 : 4;
            final width = (constraints.maxWidth - AppSpacing.sm * (columns - 1)) / columns;
            return Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final metric in metrics)
                  SizedBox(
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          metric.value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: metric.tone == null ? null : context.tone(metric.tone!).foreground,
                          ),
                        ),
                        Text(metric.label, style: theme.textTheme.bodySmall, maxLines: 2),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
