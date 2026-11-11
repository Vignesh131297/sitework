import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/info_widgets.dart';
import '../../../core/widgets/periodic_refresh.dart';
import '../../../core/widgets/profile_action.dart';
import '../../requests/presentation/approvals_tile.dart';
import '../data/dashboard_repository.dart';
import '../domain/admin_dashboard.dart';
import 'admin_dashboard_screen.dart';
import 'dashboard_widgets.dart';

/// The engineer's day across their sites: updates, photos to review, issues.
class EngineerDashboardScreen extends ConsumerWidget {
  const EngineerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navDashboard), actions: const [ProfileAction()]),
      body: PeriodicRefresh(
        interval: const Duration(minutes: 2),
        onRefresh: () => ref.invalidate(engineerDashboardProvider),
        child: AsyncValueView(
          value: ref.watch(engineerDashboardProvider),
          onRetry: () => ref.invalidate(engineerDashboardProvider),
          data: (dashboard) => RefreshIndicator(
            onRefresh: () => ref.refresh(engineerDashboardProvider.future),
            child: _Body(dashboard: dashboard),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.dashboard});

  final EngineerDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const area = AppRoutes.engineerArea;
    final d = dashboard;
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xxl),
      children: [
        DashboardHeader(date: d.date, isWorkingDay: d.isWorkingDay, holiday: d.holiday),
        const SizedBox(height: AppSpacing.lg),
        StatGrid(
          children: [
            StatCard(
              label: l10n.statYourSites,
              value: '${d.sites.length}',
              icon: Icons.apartment,
              onTap: () => context.go(AppRoutes.engineerSites),
            ),
            StatCard(
              label: l10n.reviewTitle,
              value: '${d.toReview}',
              icon: Icons.photo_library_outlined,
              tone: d.toReview > 0 ? StatusTone.warning : StatusTone.success,
              onTap: () => context.push(AppRoutes.review(area)),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        UpdatesCard(totals: d.updates, isWorkingDay: d.isWorkingDay),
        const SizedBox(height: AppSpacing.md),
        CountTile(
          icon: Icons.report_problem_outlined,
          tone: StatusTone.danger,
          title: l10n.issuesOpen,
          count: d.issues.open,
          subtitle: d.issues.critical > 0 ? l10n.issuesCritical(d.issues.critical) : null,
          onTap: () => context.go(AppRoutes.engineerIssues),
        ),
        CountTile(
          icon: Icons.local_shipping_outlined,
          tone: d.stock.toReceive > 0 ? StatusTone.warning : StatusTone.neutral,
          title: l10n.stockDeliveriesToConfirm,
          count: d.stock.toReceive,
          onTap: () => context.push(AppRoutes.stockHistory(area, receivable: true)),
        ),
        CountTile(
          icon: Icons.assignment_outlined,
          tone: StatusTone.info,
          title: l10n.requestsTitle,
          subtitle: l10n.requestsEngineerSubtitle,
          count: d.stock.openRequests,
          onTap: () => context.push(AppRoutes.requests(area)),
        ),
        CountTile(
          icon: Icons.warehouse_outlined,
          tone: StatusTone.neutral,
          title: l10n.stockTitle,
          subtitle: l10n.stockEngineerSubtitle,
          onTap: () => context.push(AppRoutes.stock(area)),
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
