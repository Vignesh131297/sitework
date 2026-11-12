import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/initials.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/info_widgets.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/submit_state.dart';
import '../../auth/domain/user_role.dart';
import '../../auth/presentation/user_role_label.dart';
import '../data/vehicles_repository.dart';
import '../domain/vehicle_models.dart';
import 'vehicle_sheets.dart';
import 'vehicle_widgets.dart';

enum _Action { edit, outOfUse, backInUse }

/// One company vehicle: what it is, who has it, who had it, and the repair
/// money asked for it (admins).
class VehicleDetailScreen extends ConsumerStatefulWidget {
  const VehicleDetailScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends ConsumerState<VehicleDetailScreen> {
  var _busy = false;

  Future<void> _setActive(Vehicle vehicle, {required bool active}) async {
    final l10n = AppLocalizations.of(context);
    final name = vehicleName(vehicle.makeModel, vehicle.registrationNo);
    if (!active) {
      final confirmed = await showConfirmDialog(
        context,
        title: l10n.vehicleMarkOutOfUseTitle(name),
        message: l10n.vehicleMarkOutOfUseBody,
        confirmLabel: l10n.vehicleMarkOutOfUse,
        destructive: true,
      );
      if (!confirmed || !mounted) return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(vehiclesRepositoryProvider).setActive(vehicle.id, active: active);
      ref.bump(DataSet.vehicles);
      if (mounted) showSnack(context, active ? l10n.vehicleBackInUse(name) : l10n.vehicleMarkedOutOfUse(name));
    } on AppException catch (error) {
      if (mounted) showErrorSnack(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _onAction(_Action action, Vehicle vehicle) {
    switch (action) {
      case _Action.edit:
        context.push(AppRoutes.adminVehicleEdit(vehicle.id));
      case _Action.outOfUse:
        _setActive(vehicle, active: false);
      case _Action.backInUse:
        _setActive(vehicle, active: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final detail = ref.watch(vehicleProvider(widget.id));
    final vehicle = detail.value?.vehicle;
    return Scaffold(
      appBar: AppBar(
        title: Text(vehicle?.code ?? l10n.vehicleTitle),
        actions: [
          if (vehicle != null)
            PopupMenuButton<_Action>(
              enabled: !_busy,
              onSelected: (action) => _onAction(action, vehicle),
              itemBuilder: (context) => [
                PopupMenuItem(value: _Action.edit, child: Text(l10n.commonEdit)),
                if (vehicle.isActive && vehicle.holder == null)
                  PopupMenuItem(value: _Action.outOfUse, child: Text(l10n.vehicleMarkOutOfUse)),
                if (!vehicle.isActive) PopupMenuItem(value: _Action.backInUse, child: Text(l10n.vehicleBringBack)),
              ],
            ),
        ],
      ),
      body: AsyncValueView(
        value: detail,
        onRetry: () => ref.invalidate(vehicleProvider(widget.id)),
        data: (detail) => RefreshIndicator(
          onRefresh: () {
            ref.bump(DataSet.vehicles);
            return ref.read(vehicleProvider(widget.id).future);
          },
          child: _Body(detail: detail, busy: _busy),
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.detail, required this.busy});

  final VehicleDetail detail;
  final bool busy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final v = detail.vehicle;
    final holder = v.holder;
    final choice = (id: v.id, name: vehicleName(v.makeModel, v.registrationNo));
    final (statusLabel, statusTone) = !v.isActive
        ? (l10n.vehicleOutOfUse, StatusTone.neutral)
        : holder == null
        ? (l10n.vehicleFree, StatusTone.info)
        : (l10n.vehiclesFilterGiven, StatusTone.success);
    final repairs = ref.watch(_vehicleRepairsProvider(v.id));
    Widget note(String text) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Text(text, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
    );
    return ListView(
      padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.xxl),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              Icon(vehicleIcon(v.type), size: 32),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(v.makeModel, style: theme.textTheme.titleLarge),
                    Text(
                      '${v.registrationNo} · ${v.type.label(l10n)}',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              StatusChip(label: statusLabel, tone: statusTone),
            ],
          ),
        ),
        if (v.note case final text?) DetailRow(icon: Icons.notes_outlined, label: l10n.fieldNotes, value: text),
        if (holder != null)
          ListTile(
            leading: CircleAvatar(child: Text(initialsOf(holder.user.name))),
            title: Text(l10n.vehicleWith(holder.user.name)),
            subtitle: Text(
              [holder.user.role.label(l10n), l10n.vehicleSince(formatDate(holder.givenOn)), ?holder.note].join(' · '),
            ),
            onTap: () => context.push(
              holder.user.role == UserRole.engineer
                  ? AppRoutes.adminEngineer(holder.user.id)
                  : AppRoutes.adminStaffMember(holder.user.id),
            ),
          ),
        if (v.isActive)
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: holder == null
                  ? FilledButton.icon(
                      onPressed: busy ? null : () => showGiveVehicleSheet(context, vehicle: choice),
                      icon: const Icon(Icons.person_add_alt_1_outlined),
                      label: Text(l10n.vehicleGive),
                    )
                  : OutlinedButton.icon(
                      onPressed: busy
                          ? null
                          : () => showTakeBackVehicleSheet(
                              context,
                              vehicle: choice,
                              holderName: holder.user.name,
                              givenOn: holder.givenOn,
                            ),
                      icon: const Icon(Icons.undo),
                      label: Text(l10n.vehicleTakeBack),
                    ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: SectionHeader(l10n.vehicleRepairs),
        ),
        ...switch (repairs) {
          AsyncData(:final value) when value.isEmpty => [note(l10n.vehicleRepairsEmpty)],
          AsyncData(:final value) => [
            for (final request in value)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: RepairRequestTile(request: request),
              ),
          ],
          AsyncError() => [note(l10n.errorServer)],
          _ => [const Padding(padding: EdgeInsets.all(AppSpacing.lg), child: LinearProgressIndicator())],
        },
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: SectionHeader(l10n.vehicleHistory),
        ),
        if (detail.history.isEmpty) note(l10n.vehicleHistoryEmpty),
        for (final h in detail.history)
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: Text(h.user.name),
            subtitle: Text(
              [
                h.returnedOn == null
                    ? l10n.vehicleHistoryNow(formatDate(h.givenOn))
                    : l10n.vehicleHistoryRange(formatDate(h.givenOn), formatDate(h.returnedOn!)),
                ?h.note,
                ?h.returnNote,
              ].join(' · '),
            ),
          ),
      ],
    );
  }
}

/// The latest repair money requests for one vehicle.
final _vehicleRepairsProvider = FutureProvider.autoDispose.family<List<RepairRequest>, String>((ref, vehicleId) async {
  ref.watch(revisionProvider(DataSet.vehicles));
  final page = await ref.watch(vehiclesRepositoryProvider).repairRequests(page: 1, limit: 20, vehicleId: vehicleId);
  return page.items;
});
