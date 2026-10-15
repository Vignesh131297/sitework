import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/models/enums.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/info_widgets.dart';
import '../../../core/widgets/inline_message.dart';
import '../../../core/widgets/periodic_refresh.dart';
import '../../../core/widgets/profile_action.dart';
import '../../../core/widgets/status_chip.dart';
import '../../stock/presentation/stock_entry_screen.dart';
import '../data/dashboard_repository.dart';
import '../domain/admin_dashboard.dart';
import 'dashboard_widgets.dart';

/// A godown manager's day: approved requests to send, returns to confirm, low
/// stock, and their godowns.
class GodownDashboardScreen extends ConsumerWidget {
  const GodownDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navHome), actions: const [ProfileAction()]),
      body: PeriodicRefresh(
        interval: const Duration(minutes: 2),
        onRefresh: () => ref.invalidate(godownDashboardProvider),
        child: AsyncValueView(
          value: ref.watch(godownDashboardProvider),
          onRetry: () => ref.invalidate(godownDashboardProvider),
          data: (dashboard) => RefreshIndicator(
            onRefresh: () => ref.refresh(godownDashboardProvider.future),
            child: _Body(dashboard: dashboard),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.dashboard});

  final GodownDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const area = AppRoutes.godownArea;
    final d = dashboard;
    final active = [
      for (final g in d.godowns)
        if (g.godown.isActive) g,
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xxl),
      children: [
        DashboardHeader(date: d.date, isWorkingDay: true),
        const SizedBox(height: AppSpacing.lg),
        if (active.isEmpty)
          InlineMessage(message: l10n.stockNoGodownsManager, tone: StatusTone.info)
        else
          FilledButton.icon(
            onPressed: () => StockEntryScreen.open(
              context,
              action: StockAction.purchase,
              to: active.length == 1
                  ? (place: StockPlace.godown, id: active.single.godown.id, name: active.single.godown.name)
                  : null,
            ),
            icon: const Icon(Icons.shopping_cart_outlined),
            label: Text(l10n.stockActionPurchase),
          ),
        const SizedBox(height: AppSpacing.md),
        CountTile(
          icon: Icons.local_shipping_outlined,
          tone: d.toSend > 0 ? StatusTone.warning : StatusTone.neutral,
          title: l10n.requestsToSend,
          count: d.toSend,
          onTap: () => context.go(AppRoutes.godownRequests),
        ),
        CountTile(
          icon: Icons.inventory_outlined,
          tone: d.toReceive > 0 ? StatusTone.warning : StatusTone.neutral,
          title: l10n.stockReturnsToConfirm,
          count: d.toReceive,
          onTap: () => context.push(AppRoutes.stockHistory(area, receivable: true)),
        ),
        CountTile(
          icon: Icons.trending_down,
          tone: d.lowStock > 0 ? StatusTone.danger : StatusTone.neutral,
          title: l10n.stockLowTitle,
          subtitle: l10n.stockLowSubtitle,
          count: d.lowStock,
          onTap: () => context.go(AppRoutes.godownStock),
        ),
        SectionHeader(l10n.godownsYours),
        for (final summary in d.godowns)
          Card(
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: const Icon(Icons.warehouse_outlined),
              title: Text(summary.godown.name),
              subtitle: summary.godown.address == null ? null : Text(summary.godown.address!),
              trailing: summary.arriving > 0
                  ? StatusChip(label: l10n.stockArrivingCount(summary.arriving), tone: StatusTone.warning)
                  : const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.stockGodown(area, summary.godown.id)),
            ),
          ),
      ],
    );
  }
}
