import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/models/enums.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/paged_list_view.dart';
import '../data/stock_repository.dart';
import 'stock_widgets.dart';

enum _Filter { all, onTheWay, cancelled }

/// Stock entries, newest first: a site's, a godown's, a material's, or
/// everything the user may see. With [receivable], only what they can confirm.
class StockHistoryScreen extends ConsumerStatefulWidget {
  const StockHistoryScreen({super.key, this.siteId, this.godownId, this.materialId, this.receivable = false});

  final String? siteId;
  final String? godownId;
  final String? materialId;
  final bool receivable;

  @override
  ConsumerState<StockHistoryScreen> createState() => _StockHistoryScreenState();
}

class _StockHistoryScreenState extends ConsumerState<StockHistoryScreen> {
  var _filter = _Filter.all;

  String _label(_Filter filter, AppLocalizations l10n) => switch (filter) {
    _Filter.all => l10n.commonAll,
    _Filter.onTheWay => l10n.stockStatusOnTheWay,
    _Filter.cancelled => l10n.stockStatusCancelled,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final revision = ref.watch(revisionProvider(DataSet.stock));
    final repository = ref.watch(stockRepositoryProvider);
    final status = switch (_filter) {
      _Filter.all => null,
      _Filter.onTheWay => StockMovementStatus.inTransit,
      _Filter.cancelled => StockMovementStatus.voided,
    };
    return Scaffold(
      appBar: AppBar(title: Text(widget.receivable ? l10n.stockToConfirm : l10n.stockHistory)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!widget.receivable)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              child: Row(
                children: [
                  for (final filter in _Filter.values)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: ChoiceChip(
                        label: Text(_label(filter, l10n)),
                        selected: _filter == filter,
                        onSelected: (_) => setState(() => _filter = filter),
                      ),
                    ),
                ],
              ),
            ),
          Expanded(
            child: PagedListView(
              key: ValueKey(
                'stock-${widget.siteId}-${widget.godownId}-${widget.materialId}-${widget.receivable}-$_filter-$revision',
              ),
              fetch: (page) => repository.entries(
                page: page,
                siteId: widget.siteId,
                godownId: widget.godownId,
                materialId: widget.materialId,
                status: status,
                receivable: widget.receivable,
              ),
              empty: EmptyState(
                icon: Icons.inventory_2_outlined,
                title: widget.receivable ? l10n.stockNothingToConfirm : l10n.stockNoEntries,
              ),
              itemBuilder: (context, entry) => EntryTile(
                entry: entry,
                action: widget.receivable && entry.canReceive ? ConfirmReceiptButton(entry: entry) : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
