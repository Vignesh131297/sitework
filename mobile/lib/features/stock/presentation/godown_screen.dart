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
import '../../auth/domain/user_role.dart';
import '../../auth/presentation/session_controller.dart';
import '../data/stock_repository.dart';
import '../domain/stock_models.dart';
import 'godown_form_screen.dart';
import 'stock_entry_screen.dart';
import 'stock_widgets.dart';

/// One godown: what it holds, what is on the way in and out, who runs it, and
/// (admins and its managers) the ways to buy in, send, write off and count its
/// stock. Engineers see quantities only.
class GodownScreen extends ConsumerWidget {
  const GodownScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(sessionProvider).value;
    final isAdmin = session?.role == UserRole.admin;
    final stock = ref.watch(godownStockProvider(id));
    final runs = isAdmin || (stock.value?.managers.any((m) => m.id == session?.userId) ?? false);
    return Scaffold(
      appBar: AppBar(
        title: Text(stock.value?.godown.name ?? ''),
        actions: [
          if (isAdmin && stock.value != null)
            IconButton(
              tooltip: l10n.godownEdit,
              onPressed: () => GodownFormScreen.open(context, godown: stock.value!.godown),
              icon: const Icon(Icons.edit_outlined),
            ),
        ],
      ),
      body: AsyncValueView(
        value: stock,
        onRetry: () => ref.invalidate(godownStockProvider(id)),
        data: (stock) => RefreshIndicator(
          onRefresh: () => ref.refresh(godownStockProvider(id).future),
          child: _GodownBody(stock: stock, isAdmin: isAdmin, runs: runs),
        ),
      ),
    );
  }
}

class _GodownBody extends ConsumerWidget {
  const _GodownBody({required this.stock, required this.isAdmin, required this.runs});

  final GodownStock stock;
  final bool isAdmin;

  /// An admin, or one of this godown's managers.
  final bool runs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final area = ref.watch(areaPathProvider);
    final godown = stock.godown;
    final here = (place: StockPlace.godown, id: godown.id, name: godown.name);
    final held = [
      for (final item in stock.items)
        if (item.hasStock) item,
    ];
    final empty = [
      for (final item in stock.items)
        if (!item.hasStock) item,
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxl),
      children: [
        if (godown.address case final address?) Text(address),
        if (!godown.isActive) Text(l10n.godownClosed, style: TextStyle(color: Theme.of(context).colorScheme.error)),
        Text(
          stock.managers.isEmpty
              ? l10n.godownNoManager
              : l10n.godownManagedBy(stock.managers.map((m) => m.name).join(', ')),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (stock.value case final value?) ...[
          const SizedBox(height: AppSpacing.md),
          AmountTile(label: l10n.stockValueOnHand, amount: formatInr(value.onHand), tone: StatusTone.neutral),
        ],
        if (runs && godown.isActive) ...[
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              FilledButton.icon(
                onPressed: () => StockEntryScreen.open(context, action: StockAction.purchase, to: here),
                icon: const Icon(Icons.shopping_cart_outlined),
                label: Text(l10n.stockActionPurchase),
              ),
              if (held.isNotEmpty) ...[
                FilledButton.tonalIcon(
                  onPressed: () => StockEntryScreen.open(context, action: StockAction.send, from: here),
                  icon: const Icon(Icons.local_shipping_outlined),
                  label: Text(l10n.stockActionSend),
                ),
                OutlinedButton.icon(
                  onPressed: () => StockEntryScreen.open(context, action: StockAction.writeOff, from: here),
                  icon: const Icon(Icons.delete_outline),
                  label: Text(l10n.stockActionWriteOff),
                ),
              ],
              OutlinedButton.icon(
                onPressed: () => StockEntryScreen.open(context, action: StockAction.count, from: here),
                icon: const Icon(Icons.rule_outlined),
                label: Text(l10n.stockActionCount),
              ),
            ],
          ),
        ],
        if (stock.arriving.isNotEmpty) ...[
          SectionHeader(l10n.stockArrivingHere),
          for (final entry in stock.arriving)
            EntryTile(
              entry: entry,
              action: entry.canReceive ? ConfirmReceiptButton(entry: entry) : null,
            ),
        ],
        if (stock.leaving.isNotEmpty) ...[
          SectionHeader(l10n.stockLeavingHere),
          for (final entry in stock.leaving) EntryTile(entry: entry),
        ],
        SectionHeader(
          l10n.stockInGodown,
          trailing: TextButton(
            onPressed: () => context.push(AppRoutes.stockHistory(area, godownId: godown.id)),
            child: Text(l10n.stockHistory),
          ),
        ),
        if (stock.items.isEmpty)
          EmptyState(icon: Icons.warehouse_outlined, title: l10n.godownEmpty)
        else if (held.isEmpty)
          Text(l10n.stockNothingHere),
        for (final item in held)
          HolderItemTile(
            item: item,
            onTap: isAdmin ? () => context.push(AppRoutes.adminMaterial(item.material.id)) : null,
          ),
        if (empty.isNotEmpty) ...[
          SectionHeader(l10n.stockUsedUp),
          for (final item in empty) HolderItemTile(item: item),
        ],
      ],
    );
  }
}
