import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/routing/area.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../data/vehicles_repository.dart';
import 'vehicle_widgets.dart';

/// Staff "Home" and the engineer's dashboard: the company vehicle the user
/// holds, with a way to ask for repair money. Nothing is shown to someone
/// without a vehicle, or until it loads.
class MyVehicleCard extends ConsumerWidget {
  const MyVehicleCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final area = ref.watch(areaPathProvider);
    final vehicle = ref.watch(myVehicleProvider).value;
    if (vehicle == null) return const SizedBox.shrink();
    final since = vehicle.holder?.givenOn;
    return Card(
      margin: const EdgeInsets.only(top: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.sm, AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.myVehicleTitle, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.secondaryContainer,
                foregroundColor: theme.colorScheme.onSecondaryContainer,
                child: Icon(vehicleIcon(vehicle.type)),
              ),
              title: Text(vehicle.makeModel),
              subtitle: Text(
                [vehicle.registrationNo, if (since != null) l10n.vehicleSince(formatDate(since))].join(' · '),
              ),
            ),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                FilledButton.tonalIcon(
                  onPressed: () => context.push(AppRoutes.repairRequestNew(area)),
                  icon: const Icon(Icons.build_outlined),
                  label: Text(l10n.repairAsk),
                ),
                TextButton(
                  onPressed: () => context.push(AppRoutes.myRequests(area, tab: 'repair')),
                  child: Text(l10n.repairMine),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
