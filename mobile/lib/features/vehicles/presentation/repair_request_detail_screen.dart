import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/info_widgets.dart';
import '../../../core/widgets/status_chip.dart';
import '../../auth/domain/user_role.dart';
import '../../auth/presentation/session_controller.dart';
import '../../requests/presentation/request_detail_screens.dart';
import '../data/vehicles_repository.dart';
import '../domain/vehicle_models.dart';
import 'vehicle_widgets.dart';

/// One repair money request: how much, for which vehicle, why, the admin's
/// decision, and what the user can do now.
class RepairRequestDetailScreen extends ConsumerWidget {
  const RepairRequestDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final request = ref.watch(repairRequestProvider(id));
    return Scaffold(
      appBar: AppBar(title: Text(request.value?.code ?? l10n.repairTitle)),
      body: AsyncValueView(
        value: request,
        onRetry: () => ref.invalidate(repairRequestProvider(id)),
        data: (request) => RefreshIndicator(
          onRefresh: () => ref.refresh(repairRequestProvider(id).future),
          child: _Body(request: request),
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.request});

  final RepairRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final r = request;
    final repository = ref.read(vehiclesRepositoryProvider);
    final admin = ref.watch(sessionProvider).value?.role == UserRole.admin;
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxl),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.repairMoney(formatInr(r.amount)),
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            StatusChip(label: r.status.label(l10n), tone: r.status.tone),
          ],
        ),
        DetailRow(icon: Icons.person_outline, label: l10n.requestAskedByLabel, value: r.user.name),
        DetailRow(
          icon: vehicleIcon(r.vehicle.type),
          label: l10n.vehicleTitle,
          value: vehicleName(r.vehicle.makeModel, r.vehicle.registrationNo),
          // Only admins have a page for the vehicle.
          onTap: admin ? () => context.push(AppRoutes.adminVehicle(r.vehicle.id)) : null,
        ),
        DetailRow(icon: Icons.build_outlined, label: l10n.repairWhat, value: r.note),
        DetailRow(icon: Icons.schedule_outlined, label: l10n.requestAskedOn, value: formatDateTime(r.createdAt)),
        RequestDecision(status: r.status, reviewedBy: r.reviewedBy, note: r.reviewNote),
        RequestActions(
          code: r.code,
          canApprove: r.canApprove,
          canCancel: r.canCancel,
          approve: (note) => repository.approveRepair(r.id, note: note),
          reject: (reason) => repository.rejectRepair(r.id, reason),
          cancel: () => repository.cancelRepair(r.id),
        ),
      ],
    );
  }
}
