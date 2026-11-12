import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/info_widgets.dart';
import '../../../core/widgets/profile_action.dart';
import '../../requests/presentation/approvals_tile.dart';
import '../../vehicles/presentation/vehicles_tile.dart';
import '../data/dashboard_repository.dart';
import '../domain/admin_dashboard.dart';
import 'dashboard_widgets.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navDashboard), actions: const [ProfileAction()]),
      body: AsyncValueView(
        value: ref.watch(adminDashboardProvider),
        onRetry: () => ref.invalidate(adminDashboardProvider),
        data: (dashboard) => RefreshIndicator(
          onRefresh: () => ref.refresh(adminDashboardProvider.future),
          child: _DashboardBody(dashboard: dashboard),
        ),
      ),
    );
  }
}

/// Where an attention item leads, for admins and engineers alike.
void openAttention(BuildContext context, String area, AttentionItem item) {
  final target = switch (item) {
    MissingUpdatesItem(:final site) || NotCheckedInItem(:final site) => AppRoutes.site(area, site.id, tab: 'today'),
    OverduePaymentItem(:final site) => AppRoutes.site(area, site.id, tab: 'payments'),
    CriticalIssueItem(:final issue) => AppRoutes.issue(area, issue.id),
    UnknownAttentionItem() => null,
  };
  if (target != null) context.push(target);
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.dashboard});

  final AdminDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const area = AppRoutes.adminArea;
    final d = dashboard;
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xxl),
      children: [
        DashboardHeader(date: d.date, isWorkingDay: d.isWorkingDay, holiday: d.holiday),
        const SizedBox(height: AppSpacing.lg),
        StatGrid(
          children: [
            StatCard(
              label: l10n.statActiveSites,
              value: '${d.counts.activeSites}',
              icon: Icons.apartment,
              onTap: () => context.go(AppRoutes.adminSites),
            ),
            StatCard(
              label: l10n.statClients,
              value: '${d.counts.clients}',
              icon: Icons.business_center_outlined,
              tone: StatusTone.neutral,
              onTap: () => context.go(AppRoutes.adminSites),
            ),
            StatCard(
              label: l10n.statEngineers,
              value: '${d.counts.engineers}',
              icon: Icons.engineering_outlined,
              tone: StatusTone.neutral,
              onTap: () => context.go(AppRoutes.adminPeople),
            ),
            StatCard(
              label: l10n.statStaff,
              value: '${d.counts.staff}',
              icon: Icons.groups_outlined,
              tone: StatusTone.neutral,
              onTap: () => context.go(AppRoutes.adminPeople),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _PaymentsCard(totals: d.payments),
        const SizedBox(height: AppSpacing.md),
        UpdatesCard(totals: d.updates, isWorkingDay: d.isWorkingDay),
        const SizedBox(height: AppSpacing.md),
        CountTile(
          icon: Icons.photo_library_outlined,
          tone: StatusTone.info,
          title: l10n.reviewTitle,
          count: d.toReview,
          onTap: () => context.push(AppRoutes.review(area)),
        ),
        CountTile(
          icon: Icons.report_problem_outlined,
          tone: StatusTone.danger,
          title: l10n.issuesOpen,
          count: d.issues.open,
          subtitle: d.issues.critical > 0 ? l10n.issuesCritical(d.issues.critical) : null,
          onTap: () => context.push(AppRoutes.issues(area)),
        ),
        CountTile(
          icon: Icons.inventory_2_outlined,
          tone: d.stock.lowStock > 0 || d.stock.toReceive > 0 ? StatusTone.warning : StatusTone.neutral,
          title: l10n.stockTitle,
          subtitle: d.stock.lowStock == 0 && d.stock.toReceive == 0
              ? l10n.stockEntrySubtitle
              : [
                  if (d.stock.lowStock > 0) l10n.stockLowCount(d.stock.lowStock),
                  if (d.stock.toReceive > 0) l10n.stockToConfirmCount(d.stock.toReceive),
                ].join(' · '),
          onTap: () => context.push(AppRoutes.stock(area)),
        ),
        CountTile(
          icon: Icons.assignment_outlined,
          tone: d.stock.requestsToApprove > 0 ? StatusTone.warning : StatusTone.neutral,
          title: l10n.requestsTitle,
          subtitle: d.stock.requestsToApprove > 0
              ? l10n.requestsToApproveCount(d.stock.requestsToApprove)
              : l10n.requestsAdminSubtitle,
          count: d.stock.requestsToApprove > 0 ? d.stock.requestsToApprove : null,
          onTap: () => context.push(AppRoutes.requests(area)),
        ),
        CountTile(
          icon: Icons.insert_chart_outlined,
          tone: StatusTone.neutral,
          title: l10n.reportsTitle,
          subtitle: l10n.reportsEntrySubtitle,
          onTap: () => context.push(AppRoutes.reports(area)),
        ),
        AttentionSection(items: d.attention, onOpen: (item) => openAttention(context, area, item)),
        const ApprovalsTile(),
        const VehiclesTile(),
        SectionHeader(l10n.siteActivityTitle),
        for (final site in d.sites) ...[
          SiteActivityCard(
            activity: site,
            onTap: () => context.push(AppRoutes.site(area, site.site.id, tab: 'today')),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _PaymentsCard extends StatelessWidget {
  const _PaymentsCard({required this.totals});

  final MoneyTotals totals;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go(AppRoutes.adminPayments),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.paymentsTitle, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.md),
              AmountTile(label: l10n.paymentsReceived, amount: formatInr(totals.received), tone: StatusTone.success),
              const SizedBox(height: AppSpacing.md),
              AmountTile(label: l10n.paymentsPending, amount: formatInr(totals.pending), tone: StatusTone.warning),
              if (totals.overdueCount > 0) ...[
                const SizedBox(height: AppSpacing.md),
                AmountTile(
                  label: l10n.paymentsOverdue,
                  caption: l10n.paymentsOverdueCount(totals.overdueCount),
                  amount: formatInr(totals.overdue),
                  tone: StatusTone.danger,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
