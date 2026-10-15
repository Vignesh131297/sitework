import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/models/enums.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/widgets/status_chip.dart';
import '../data/stock_repository.dart';
import 'stock_entry_screen.dart';

/// On a staff member's home: record today's material use at their site.
/// Hidden while the site holds no stock (or it can't be loaded).
class StaffUsageCard extends ConsumerWidget {
  const StaffUsageCard({super.key, required this.siteId, required this.siteName});

  final String siteId;
  final String siteName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final stock = ref.watch(siteStockProvider(siteId)).value;
    if (stock == null || !stock.items.any((item) => item.hasStock)) return const SizedBox.shrink();
    return Card(
      child: ListTile(
        leading: const Icon(Icons.construction_outlined),
        title: Text(l10n.stockStaffUsageTitle),
        subtitle: Align(
          alignment: Alignment.centerLeft,
          child: StatusChip(
            label: stock.usedToday ? l10n.stockUsageRecorded : l10n.stockUsageNotRecorded,
            tone: stock.usedToday ? StatusTone.success : StatusTone.warning,
          ),
        ),
        trailing: FilledButton.tonal(
          onPressed: () => StockEntryScreen.open(
            context,
            action: StockAction.use,
            from: (place: StockPlace.site, id: siteId, name: siteName),
          ),
          child: Text(l10n.stockRecord),
        ),
      ),
    );
  }
}
