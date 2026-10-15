import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/enums.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/routing/area.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/status_chip.dart';
import '../domain/stock_models.dart';
import 'receive_screen.dart';

/// A godown's or site's name, or where stock left the books to.
String placeName(StockPlaceRef ref, AppLocalizations l10n) => switch (ref.place) {
  StockPlace.godown => ref.godown?.name ?? '',
  StockPlace.site => ref.site?.name ?? '',
  StockPlace.supplier => l10n.stockPlaceSupplier,
  StockPlace.used => l10n.stockPlaceUsed,
  StockPlace.waste => l10n.stockPlaceWaste,
  StockPlace.adjustment => l10n.stockPlaceCount,
};

IconData stockKindIcon(StockKind kind) => switch (kind) {
  StockKind.purchase => Icons.shopping_cart_outlined,
  StockKind.transfer => Icons.local_shipping_outlined,
  StockKind.usage => Icons.construction_outlined,
  StockKind.writeOff => Icons.delete_outline,
  StockKind.adjustment => Icons.rule_outlined,
};

/// "Cement OPC 53 · 60 bag", plus how many other materials the entry carries.
String entrySummary(StockEntry entry, AppLocalizations l10n) {
  if (entry.lines.isEmpty) return l10n.stockCountNoDifference;
  final first = entry.lines.first;
  final text = '${first.material.name} · ${formatQuantity(first.quantity, first.material.unit)}';
  return entry.lines.length == 1 ? text : l10n.stockAndMore(text, entry.lines.length - 1);
}

/// The status worth showing on an entry, if any.
StatusChip? entryChip(StockEntry entry, AppLocalizations l10n) => switch (entry) {
  _ when entry.isVoided => StatusChip(label: l10n.stockStatusCancelled, tone: StatusTone.neutral),
  _ when entry.isOnTheWay => StatusChip(label: l10n.stockStatusOnTheWay, tone: StatusTone.warning),
  _ when entry.isShort => StatusChip(label: l10n.stockStatusShort, tone: StatusTone.danger),
  _ => null,
};

/// A stock entry in a list: what, how much, from where to where, and when.
/// [action] (e.g. a Confirm button) replaces the status chip.
class EntryTile extends ConsumerWidget {
  const EntryTile({super.key, required this.entry, this.action});

  final StockEntry entry;
  final Widget? action;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final area = ref.watch(areaPathProvider);
    final e = entry;
    final tone = e.isVoided
        ? StatusTone.neutral
        : e.isOnTheWay
        ? StatusTone.warning
        : StatusTone.info;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: () => context.push(AppRoutes.stockEntry(area, e.id)),
        leading: CircleAvatar(
          backgroundColor: context.tone(tone).background,
          child: Icon(stockKindIcon(e.kind), color: context.tone(tone).foreground),
        ),
        title: Text(
          entrySummary(e, l10n),
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            decoration: e.isVoided ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          '${placeName(e.from, l10n)} → ${placeName(e.to, l10n)}\n'
          '${e.kind.label(l10n)} · ${formatDate(e.movedOn)}',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        isThreeLine: true,
        trailing: action ?? entryChip(e, l10n),
      ),
    );
  }
}

/// "Confirm" for a delivery on the way: opens the form for what arrived.
class ConfirmReceiptButton extends StatelessWidget {
  const ConfirmReceiptButton({super.key, required this.entry});

  final StockEntry entry;

  @override
  Widget build(BuildContext context) => FilledButton.tonal(
    onPressed: () => ReceiveScreen.open(context, entry),
    child: Text(AppLocalizations.of(context).stockConfirm),
  );
}

/// A godown's or site's row for one material: how much is there, with what
/// happened to it so far and (admins) its value.
class HolderItemTile extends StatelessWidget {
  const HolderItemTile({super.key, required this.item, this.onTap});

  final HolderStockRow item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final unit = item.material.unit;
    String quantity(String value) => formatQuantity(value, unit);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        title: Text(item.material.name),
        subtitle: Text(
          [
            l10n.stockReceivedTotal(quantity(item.received)),
            if (num.parse(item.used) > 0) l10n.stockUsedTotal(quantity(item.used)),
            if (num.parse(item.sentOut) > 0) l10n.stockSentOutTotal(quantity(item.sentOut)),
            if (num.parse(item.wasted) > 0) l10n.stockWastedTotal(quantity(item.wasted)),
            if (item.onHandValue case final value? when item.hasStock) l10n.stockWorth(formatInr(value)),
          ].join(' · '),
        ),
        trailing: Text(
          quantity(item.onHand),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: item.hasStock ? null : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
