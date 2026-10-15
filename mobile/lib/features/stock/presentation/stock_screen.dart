import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/routing/area.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/info_widgets.dart';
import '../../../core/widgets/profile_action.dart';
import '../../../core/widgets/status_chip.dart';
import '../../auth/domain/user_role.dart';
import '../../auth/presentation/session_controller.dart';
import '../data/stock_repository.dart';
import '../domain/stock_models.dart';
import 'godown_form_screen.dart';
import 'material_form_screen.dart';
import 'stock_entry_screen.dart';

/// All stock at a glance: the godowns, every material's totals, and what is
/// waiting to be confirmed. Admins and godown managers (for their godowns)
/// also buy stock in and send it between godowns; admins manage materials
/// and godowns. Engineers see quantities.
class StockScreen extends ConsumerStatefulWidget {
  const StockScreen({super.key, this.showProfileAction = false});

  /// On a tab (godown managers), the app bar opens the profile.
  final bool showProfileAction;

  @override
  ConsumerState<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends ConsumerState<StockScreen> {
  var _lowOnly = false;
  var _search = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final role = ref.watch(sessionProvider).value?.role;
    final isAdmin = role == UserRole.admin;
    final isManager = role == UserRole.godownManager;
    final area = ref.watch(areaPathProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.stockTitle),
        actions: [
          IconButton(
            tooltip: l10n.stockHistory,
            onPressed: () => context.push(AppRoutes.stockHistory(area)),
            icon: const Icon(Icons.history),
          ),
          if (isAdmin || isManager)
            MenuAnchor(
              builder: (context, controller, _) => IconButton(
                tooltip: l10n.commonMore,
                onPressed: () => controller.isOpen ? controller.close() : controller.open(),
                icon: const Icon(Icons.more_vert),
              ),
              menuChildren: [
                MenuItemButton(
                  leadingIcon: const Icon(Icons.add_box_outlined),
                  onPressed: () => MaterialFormScreen.open(context),
                  child: Text(l10n.materialNew),
                ),
                if (isAdmin)
                  MenuItemButton(
                    leadingIcon: const Icon(Icons.warehouse_outlined),
                    onPressed: () => GodownFormScreen.open(context),
                    child: Text(l10n.godownNew),
                  ),
              ],
            ),
          if (widget.showProfileAction) const ProfileAction(),
        ],
      ),
      body: AsyncValueView(
        value: ref.watch(stockOverviewProvider),
        onRetry: () => ref.invalidate(stockOverviewProvider),
        data: (overview) => RefreshIndicator(
          onRefresh: () => ref.refresh(stockOverviewProvider.future),
          child: _body(context, overview, isAdmin, isManager, area),
        ),
      ),
    );
  }

  Widget _body(BuildContext context, StockOverview overview, bool isAdmin, bool isManager, String area) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final term = _search.trim().toLowerCase();
    final materials = [
      for (final row in overview.materials)
        if ((!_lowOnly || row.low) && (term.isEmpty || row.material.name.toLowerCase().contains(term))) row,
    ]..sort((a, b) => (a.material.isActive ? 0 : 1) - (b.material.isActive ? 0 : 1));
    final lowCount = overview.materials.where((row) => row.low).length;
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxl),
      children: [
        if ((isAdmin || isManager) && overview.godowns.any((g) => g.godown.isActive))
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => StockEntryScreen.open(context, action: StockAction.purchase),
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: Text(l10n.stockActionPurchase),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: () => StockEntryScreen.open(context, action: StockAction.send),
                  icon: const Icon(Icons.local_shipping_outlined),
                  label: Text(l10n.stockActionSend),
                ),
              ),
            ],
          ),
        if (!isManager) ...[
          const SizedBox(height: AppSpacing.md),
          Card(
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: const Icon(Icons.assignment_outlined),
              title: Text(l10n.requestsTitle),
              subtitle: Text(isAdmin ? l10n.requestsAdminSubtitle : l10n.requestsEngineerSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.requests(area)),
            ),
          ),
        ],
        if (overview.toReceive > 0) ...[
          const SizedBox(height: AppSpacing.md),
          Card(
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: Icon(Icons.inventory_outlined, color: context.tone(StatusTone.warning).foreground),
              title: Text(l10n.stockToConfirm),
              trailing: Text(
                '${overview.toReceive}',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              onTap: () => context.push(AppRoutes.stockHistory(area, receivable: true)),
            ),
          ),
        ],
        SectionHeader(l10n.stockGodowns),
        if (overview.godowns.isEmpty)
          Text(
            isAdmin
                ? l10n.stockNoGodownsAdmin
                : isManager
                ? l10n.stockNoGodownsManager
                : l10n.stockNoGodowns,
          ),
        for (final summary in overview.godowns)
          Card(
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: const Icon(Icons.warehouse_outlined),
              title: Text(
                summary.godown.name,
                style: summary.godown.isActive ? null : TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
              subtitle: Text(
                [?summary.godown.address, if (!summary.godown.isActive) l10n.godownClosed].join(' · '),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: summary.arriving > 0
                  ? StatusChip(label: l10n.stockArrivingCount(summary.arriving), tone: StatusTone.warning)
                  : const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.stockGodown(area, summary.godown.id)),
            ),
          ),
        SectionHeader(l10n.stockMaterials),
        TextField(
          decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: l10n.stockSearch),
          onChanged: (value) => setState(() => _search = value),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            ChoiceChip(
              label: Text(l10n.commonAll),
              selected: !_lowOnly,
              onSelected: (_) => setState(() => _lowOnly = false),
            ),
            ChoiceChip(
              label: Text(l10n.stockLowCount(lowCount)),
              selected: _lowOnly,
              onSelected: (_) => setState(() => _lowOnly = true),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (overview.materials.isEmpty)
          EmptyState(
            icon: Icons.inventory_2_outlined,
            title: l10n.stockNoMaterials,
            message: isAdmin ? l10n.stockNoMaterialsBody : null,
            action: isAdmin
                ? FilledButton(onPressed: () => MaterialFormScreen.open(context), child: Text(l10n.materialNew))
                : null,
          )
        else if (materials.isEmpty)
          Text(l10n.stockNoMatch)
        else
          for (final row in materials) _MaterialTile(row: row, isAdmin: isAdmin),
      ],
    );
  }
}

class _MaterialTile extends StatelessWidget {
  const _MaterialTile({required this.row, required this.isAdmin});

  final MaterialTotals row;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final material = row.material;
    final unit = material.unit;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: isAdmin ? () => context.push(AppRoutes.adminMaterial(material.id)) : null,
        title: Text(
          material.name,
          style: material.isActive ? null : TextStyle(color: theme.colorScheme.onSurfaceVariant),
        ),
        subtitle: Text(
          [
            ?material.category,
            l10n.stockOnSitesTotal(formatQuantity(row.onSites, unit)),
            if (!material.isActive) l10n.materialInactive,
          ].join(' · '),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              formatQuantity(row.inGodowns, unit),
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            if (row.low) StatusChip(label: l10n.stockLow, tone: StatusTone.warning),
          ],
        ),
      ),
    );
  }
}
