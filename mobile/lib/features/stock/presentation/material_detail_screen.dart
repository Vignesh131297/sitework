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
import '../../../core/widgets/status_chip.dart';
import '../data/stock_repository.dart';
import '../domain/stock_models.dart';
import 'material_form_screen.dart';
import 'stock_widgets.dart';

/// One material (admins): its average price, how much each godown and site
/// holds, what is on the way, and its latest entries.
class MaterialDetailScreen extends ConsumerWidget {
  const MaterialDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final detail = ref.watch(materialDetailProvider(id));
    return Scaffold(
      appBar: AppBar(
        title: Text(detail.value?.material.name ?? ''),
        actions: [
          if (detail.value case final detail?)
            IconButton(
              tooltip: l10n.materialEdit,
              onPressed: () => MaterialFormScreen.open(context, material: detail.material),
              icon: const Icon(Icons.edit_outlined),
            ),
        ],
      ),
      body: AsyncValueView(
        value: detail,
        onRetry: () => ref.invalidate(materialDetailProvider(id)),
        data: (detail) => RefreshIndicator(
          onRefresh: () => ref.refresh(materialDetailProvider(id).future),
          child: _MaterialBody(detail: detail),
        ),
      ),
    );
  }
}

class _MaterialBody extends ConsumerWidget {
  const _MaterialBody({required this.detail});

  final MaterialDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final material = detail.material;
    final unit = material.unit;
    String quantity(String value) => formatQuantity(value, unit);
    final minimum = material.minStock;
    final low = minimum != null && material.isActive && num.parse(detail.inGodowns) < num.parse(minimum);
    const area = AppRoutes.adminArea;
    Widget holding(String name, String onHand, VoidCallback onTap) => Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        title: Text(name),
        trailing: Text(quantity(onHand), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
      ),
    );
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxl),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(l10n.stockInGodowns, style: theme.textTheme.labelLarge)),
                    if (low) StatusChip(label: l10n.stockLow, tone: StatusTone.warning),
                    if (!material.isActive) StatusChip(label: l10n.materialInactive, tone: StatusTone.neutral),
                  ],
                ),
                Text(
                  quantity(detail.inGodowns),
                  style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  [
                    l10n.stockOnSitesTotal(quantity(detail.onSites)),
                    if (num.parse(detail.inTransit) > 0) l10n.stockInTransitTotal(quantity(detail.inTransit)),
                    if (minimum != null) l10n.stockMinimum(quantity(minimum)),
                    if (detail.averageRate case final rate?) l10n.stockAveragePrice(formatInr(rate), unit),
                    ?material.category,
                  ].join(' · '),
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
        SectionHeader(l10n.stockGodowns),
        if (detail.godowns.isEmpty) Text(l10n.stockNoneInGodowns),
        for (final h in detail.godowns)
          holding(h.godown.name, h.onHand, () => context.push(AppRoutes.stockGodown(area, h.godown.id))),
        SectionHeader(l10n.stockAtSites),
        if (detail.sites.isEmpty) Text(l10n.stockNotAtSites),
        for (final h in detail.sites)
          holding(h.site.name, h.onHand, () => context.push(AppRoutes.site(area, h.site.id, tab: 'stock'))),
        SectionHeader(
          l10n.stockLatest,
          trailing: TextButton(
            onPressed: () => context.push(AppRoutes.stockHistory(area, materialId: material.id)),
            child: Text(l10n.stockHistory),
          ),
        ),
        AsyncValueView(
          value: ref.watch(materialEntriesProvider(material.id)),
          onRetry: () => ref.invalidate(materialEntriesProvider(material.id)),
          data: (entries) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (entries.isEmpty) Text(l10n.stockNoEntries),
              for (final entry in entries) EntryTile(entry: entry),
            ],
          ),
        ),
      ],
    );
  }
}
