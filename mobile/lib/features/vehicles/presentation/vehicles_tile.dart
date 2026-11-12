import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/status_colors.dart';
import '../../dashboard/presentation/dashboard_widgets.dart';
import '../data/vehicles_repository.dart';

/// Admin dashboard link to the company's vehicles, with how many repair money
/// requests are waiting (none shown until it loads, or if it can't).
class VehiclesTile extends ConsumerWidget {
  const VehiclesTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final waiting = ref.watch(repairRequestsToReviewProvider).value ?? 0;
    return CountTile(
      icon: Icons.two_wheeler,
      tone: waiting > 0 ? StatusTone.warning : StatusTone.neutral,
      title: l10n.vehiclesTitle,
      subtitle: waiting > 0 ? l10n.vehiclesRepairWaiting(waiting) : l10n.vehiclesSubtitle,
      onTap: () => context.push(AppRoutes.adminVehicles),
    );
  }
}
