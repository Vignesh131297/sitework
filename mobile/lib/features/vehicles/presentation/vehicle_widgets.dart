import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/enums.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/routing/area.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/status_chip.dart';
import '../../auth/presentation/session_controller.dart';
import '../domain/vehicle_models.dart';

IconData vehicleIcon(VehicleType type) => switch (type) {
  VehicleType.bike => Icons.two_wheeler,
  VehicleType.scooter => Icons.moped_outlined,
  VehicleType.car => Icons.directions_car_outlined,
  VehicleType.van => Icons.local_shipping_outlined,
  VehicleType.other => Icons.commute_outlined,
};

/// "Hero Splendor Plus · TN09BK4821", as people name a vehicle.
String vehicleName(String makeModel, String registrationNo) => '$makeModel · $registrationNo';

/// A vehicle in the admin's list: what it is and who has it.
class VehicleTile extends StatelessWidget {
  const VehicleTile({super.key, required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final v = vehicle;
    final holder = v.holder;
    final (label, tone) = !v.isActive
        ? (l10n.vehicleOutOfUse, StatusTone.neutral)
        : holder == null
        ? (l10n.vehicleFree, StatusTone.info)
        : (l10n.vehicleWith(holder.user.name), StatusTone.success);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: () => context.push(AppRoutes.adminVehicle(v.id)),
        leading: Icon(vehicleIcon(v.type)),
        title: Text(v.makeModel, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                [v.registrationNo, v.code, v.type.label(l10n)].join(' · '),
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.xs),
              StatusChip(label: label, tone: tone),
            ],
          ),
        ),
      ),
    );
  }
}

/// A repair money request in a list. Shows who asked unless it is the caller's own.
class RepairRequestTile extends ConsumerWidget {
  const RepairRequestTile({super.key, required this.request});

  final RepairRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final area = ref.watch(areaPathProvider);
    final mine = ref.watch(sessionProvider).value?.userId == request.user.id;
    final r = request;
    final title = l10n.repairMoney(formatInr(r.amount));
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: () => context.push(AppRoutes.repairRequest(area, r.id)),
        leading: const Icon(Icons.build_outlined),
        title: Text(
          mine ? title : '${r.user.name} · $title',
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(r.note, maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(
                [r.code, r.vehicle.registrationNo, formatShortDate(r.createdAt.toLocal())].join(' · '),
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.xs),
              StatusChip(label: r.status.label(l10n), tone: r.status.tone),
            ],
          ),
        ),
      ),
    );
  }
}
