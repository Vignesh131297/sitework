import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/files/file_sharer.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/time/server_clock.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/submit_state.dart';
import '../../auth/domain/user_role.dart';
import '../../auth/presentation/session_controller.dart';
import '../../sites/data/sites_repository.dart';
import '../data/reports_repository.dart';
import '../domain/report_models.dart';
import 'report_views.dart';

enum ReportPeriod { thisWeek, thisMonth, lastMonth, custom }

/// The server accepts at most this many days in one report.
const maxReportDays = 366;

/// The dates a preset covers, up to [today] (weeks start on Monday).
ReportRange reportRangeFor(ReportPeriod period, DateTime today) {
  final day = DateTime(today.year, today.month, today.day);
  return switch (period) {
    ReportPeriod.thisWeek => (
      from: isoDate(DateTime(day.year, day.month, day.day - (day.weekday - 1))),
      to: isoDate(day),
    ),
    ReportPeriod.thisMonth || ReportPeriod.custom => (from: isoDate(DateTime(day.year, day.month)), to: isoDate(day)),
    ReportPeriod.lastMonth => (
      from: isoDate(DateTime(day.year, day.month - 1)),
      to: isoDate(DateTime(day.year, day.month, 0)),
    ),
  };
}

/// Figures over a date range for admins (every report) and engineers (their
/// sites and staff), with a CSV export through the share sheet.
class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  var _kind = ReportKind.sites;
  var _period = ReportPeriod.thisMonth;
  late ReportRange _range = reportRangeFor(_period, _today());
  String? _siteId;
  var _exporting = false;

  DateTime _today() => ref.read(serverClockProvider.notifier).now();

  ReportQuery get _query =>
      (kind: _kind, from: _range.from, to: _range.to, siteId: _kind == ReportKind.engineers ? null : _siteId);

  Future<void> _choosePeriod(ReportPeriod period) async {
    if (period != ReportPeriod.custom) {
      setState(() {
        _period = period;
        _range = reportRangeFor(period, _today());
      });
      return;
    }
    final l10n = AppLocalizations.of(context);
    final today = _today();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(today.year - 3),
      lastDate: DateTime(today.year, today.month, today.day),
      initialDateRange: DateTimeRange(start: DateTime.parse(_range.from), end: DateTime.parse(_range.to)),
    );
    if (picked == null || !mounted) return;
    if (picked.end.difference(picked.start).inDays >= maxReportDays) {
      showSnack(context, l10n.reportsTooLong(maxReportDays));
      return;
    }
    setState(() {
      _period = ReportPeriod.custom;
      _range = (from: isoDate(picked.start), to: isoDate(picked.end));
    });
  }

  Future<void> _export() async {
    final query = _query;
    setState(() => _exporting = true);
    try {
      final bytes = await ref.read(reportsRepositoryProvider).csv(query);
      final name = ReportsRepository.fileName(query);
      await ref.read(fileSharerProvider).share(name: name, bytes: bytes, mimeType: 'text/csv', subject: name);
    } on Object catch (error) {
      if (mounted) showErrorSnack(context, error);
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isAdmin = ref.watch(sessionProvider).value?.role == UserRole.admin;
    final query = _query;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reportsTitle),
        actions: [
          IconButton(
            tooltip: l10n.reportsExport,
            onPressed: _exporting ? null : _export,
            icon: _exporting
                ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.ios_share),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(reportProvider(query).future),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xxl),
          children: [
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final kind in ReportKind.values)
                  if (isAdmin || !kind.adminOnly)
                    ChoiceChip(
                      label: Text(kind.label(l10n)),
                      selected: kind == _kind,
                      onSelected: (_) => setState(() => _kind = kind),
                    ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final period in ReportPeriod.values)
                  ChoiceChip(
                    avatar: period == ReportPeriod.custom ? const Icon(Icons.date_range, size: 18) : null,
                    label: Text(period.label(l10n)),
                    selected: period == _period,
                    onSelected: (_) => _choosePeriod(period),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.reportsRange(formatDate(_range.from), formatDate(_range.to)),
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            if (_kind != ReportKind.engineers) ...[
              const SizedBox(height: AppSpacing.md),
              _SiteFilter(value: _siteId, onChanged: (id) => setState(() => _siteId = id)),
            ],
            const SizedBox(height: AppSpacing.lg),
            AsyncValueView(
              value: ref.watch(reportProvider(query)),
              onRetry: () => ref.invalidate(reportProvider(query)),
              data: (result) => ReportResultView(result: result),
            ),
          ],
        ),
      ),
    );
  }
}

class _SiteFilter extends ConsumerWidget {
  const _SiteFilter({required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sites = ref.watch(reportSitesProvider).value ?? const [];
    return DropdownButtonFormField<String?>(
      key: ValueKey('site-filter-${sites.length}'),
      initialValue: sites.any((s) => s.id == value) ? value : null,
      isExpanded: true,
      decoration: InputDecoration(labelText: l10n.fieldSite, prefixIcon: const Icon(Icons.apartment_outlined)),
      items: [
        DropdownMenuItem(value: null, child: Text(l10n.reportsAllSites)),
        for (final site in sites)
          DropdownMenuItem(
            value: site.id,
            child: Text(site.name, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: onChanged,
    );
  }
}

extension ReportKindLabel on ReportKind {
  String label(AppLocalizations l10n) => switch (this) {
    ReportKind.sites => l10n.reportKindSites,
    ReportKind.staff => l10n.reportKindStaff,
    ReportKind.engineers => l10n.reportKindEngineers,
    ReportKind.payments => l10n.reportKindPayments,
    ReportKind.stock => l10n.reportKindStock,
  };
}

extension ReportPeriodLabel on ReportPeriod {
  String label(AppLocalizations l10n) => switch (this) {
    ReportPeriod.thisWeek => l10n.reportPeriodThisWeek,
    ReportPeriod.thisMonth => l10n.reportPeriodThisMonth,
    ReportPeriod.lastMonth => l10n.reportPeriodLastMonth,
    ReportPeriod.custom => l10n.reportPeriodCustom,
  };
}

/// Every site in the user's scope, finished ones included, for the filter.
final reportSitesProvider = FutureProvider.autoDispose(
  (ref) async => (await ref.watch(sitesRepositoryProvider).list(page: 1, limit: 100)).items,
);
