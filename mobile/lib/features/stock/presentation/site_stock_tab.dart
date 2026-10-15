import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/models/enums.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/routing/area.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/info_widgets.dart';
import '../data/material_requests_repository.dart';
import '../data/stock_repository.dart';
import '../domain/stock_models.dart';
import 'request_widgets.dart';
import 'stock_entry_screen.dart';
import 'stock_widgets.dart';

/// A site's stock: deliveries to confirm, its material requests, what is on
/// site, and the actions to request more, use, return to a godown or write it
/// off. Admins also count it and see what it is worth.
class SiteStockTab extends ConsumerWidget {
  const SiteStockTab({super.key, required this.siteId, required this.isAdmin});

  final String siteId;
  final bool isAdmin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueView(
      value: ref.watch(siteStockProvider(siteId)),
      onRetry: () => ref.invalidate(siteStockProvider(siteId)),
      data: (stock) => RefreshIndicator(
        onRefresh: () => ref.refresh(siteStockProvider(siteId).future),
        child: _SiteStockBody(stock: stock, isAdmin: isAdmin),
      ),
    );
  }
}

class _SiteStockBody extends ConsumerWidget {
  const _SiteStockBody({required this.stock, required this.isAdmin});

  final SiteStock stock;
  final bool isAdmin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final area = ref.watch(areaPathProvider);
    final site = stock.site;
    final here = (place: StockPlace.site, id: site.id, name: site.name);
    final onSite = [
      for (final item in stock.items)
        if (item.hasStock) item,
    ];
    final usedUp = [
      for (final item in stock.items)
        if (!item.hasStock) item,
    ];
    final open = site.status != SiteStatus.completed;

    void entry(StockAction action, {List<StockFormLine> prefill = const []}) =>
        StockEntryScreen.open(context, action: action, from: here, prefill: prefill);

    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxl),
      children: [
        if (stock.value case final value?) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  AmountTile(label: l10n.stockValueUsed, amount: formatInr(value.used ?? '0'), tone: StatusTone.info),
                  const SizedBox(height: AppSpacing.md),
                  AmountTile(label: l10n.stockValueOnSite, amount: formatInr(value.onHand), tone: StatusTone.neutral),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            if (open)
              FilledButton.icon(
                onPressed: () => context.push(AppRoutes.requestNew(area, siteId: site.id)),
                icon: const Icon(Icons.add_shopping_cart),
                label: Text(l10n.requestMaterial),
              ),
            if (onSite.isNotEmpty) ...[
              FilledButton.tonalIcon(
                onPressed: () => entry(StockAction.use),
                icon: const Icon(Icons.construction_outlined),
                label: Text(l10n.stockActionUse),
              ),
              FilledButton.tonalIcon(
                onPressed: () => entry(StockAction.send),
                icon: const Icon(Icons.assignment_return_outlined),
                label: Text(l10n.stockActionSendOn),
              ),
            ],
            if (onSite.isNotEmpty || isAdmin)
              _MoreActions(
                isAdmin: isAdmin,
                hasStock: onSite.isNotEmpty,
                onReturnAll: () => entry(
                  StockAction.send,
                  prefill: [
                    for (final item in onSite) (materialId: item.material.id, quantity: item.onHand, rate: null),
                  ],
                ),
                onWriteOff: () => entry(StockAction.writeOff),
                onCount: () => entry(StockAction.count),
              ),
          ],
        ),
        if (stock.arriving.isNotEmpty) ...[
          SectionHeader(l10n.stockArrivingHere),
          for (final e in stock.arriving)
            EntryTile(
              entry: e,
              action: e.canReceive ? ConfirmReceiptButton(entry: e) : null,
            ),
        ],
        if (stock.leaving.isNotEmpty) ...[
          SectionHeader(l10n.stockLeavingHere),
          for (final e in stock.leaving) EntryTile(entry: e),
        ],
        _OpenRequests(siteId: site.id),
        SectionHeader(
          l10n.stockOnSite,
          trailing: TextButton(
            onPressed: () => context.push(AppRoutes.stockHistory(area, siteId: site.id)),
            child: Text(l10n.stockHistory),
          ),
        ),
        if (stock.items.isEmpty && stock.arriving.isEmpty)
          EmptyState(icon: Icons.inventory_2_outlined, title: l10n.stockSiteEmpty, message: l10n.stockSiteEmptyBody)
        else if (onSite.isEmpty)
          Text(l10n.stockNothingHere),
        for (final item in onSite) HolderItemTile(item: item),
        if (usedUp.isNotEmpty) ...[
          SectionHeader(l10n.stockUsedUp),
          for (final item in usedUp) HolderItemTile(item: item),
        ],
      ],
    );
  }
}

class _MoreActions extends StatelessWidget {
  const _MoreActions({
    required this.isAdmin,
    required this.hasStock,
    required this.onReturnAll,
    required this.onWriteOff,
    required this.onCount,
  });

  final bool isAdmin;
  final bool hasStock;
  final VoidCallback onReturnAll;
  final VoidCallback onWriteOff;
  final VoidCallback onCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MenuAnchor(
      builder: (context, controller, _) => OutlinedButton.icon(
        onPressed: () => controller.isOpen ? controller.close() : controller.open(),
        icon: const Icon(Icons.more_horiz),
        label: Text(l10n.commonMore),
      ),
      menuChildren: [
        if (hasStock) ...[
          MenuItemButton(
            leadingIcon: const Icon(Icons.assignment_return_outlined),
            onPressed: onReturnAll,
            child: Text(l10n.stockSendEverything),
          ),
          MenuItemButton(
            leadingIcon: const Icon(Icons.delete_outline),
            onPressed: onWriteOff,
            child: Text(l10n.stockActionWriteOff),
          ),
        ],
        if (isAdmin)
          MenuItemButton(
            leadingIcon: const Icon(Icons.rule_outlined),
            onPressed: onCount,
            child: Text(l10n.stockActionCount),
          ),
      ],
    );
  }
}

/// The site's requests still waiting for approval or being sent.
class _OpenRequests extends ConsumerWidget {
  const _OpenRequests({required this.siteId});

  final String siteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final area = ref.watch(areaPathProvider);
    final requests = ref.watch(siteOpenRequestsProvider(siteId)).value ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          l10n.requestsOpenTitle,
          trailing: TextButton(
            onPressed: () => context.push(AppRoutes.requests(area, siteId: siteId)),
            child: Text(l10n.requestsAll),
          ),
        ),
        if (requests.isEmpty) Text(l10n.requestsNoneOpen),
        for (final request in requests) RequestTile(request: request),
      ],
    );
  }
}
