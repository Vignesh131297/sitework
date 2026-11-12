import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/refs.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/initials.dart';
import '../../../core/utils/launch.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/info_widgets.dart';
import '../../../core/widgets/inline_message.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/submit_state.dart';
import '../../auth/domain/user_role.dart';
import '../../auth/presentation/session_controller.dart';
import '../../auth/presentation/user_role_label.dart';
import '../../vehicles/presentation/vehicle_sheets.dart';
import '../../vehicles/presentation/vehicle_widgets.dart';
import '../data/people_repository.dart';
import '../domain/person_models.dart';
import 'assign_staff_sheet.dart';
import 'temporary_password_dialog.dart';

enum _Action { edit, resetPassword, deactivate, activate }

/// A person's profile (engineer, staff member, godown manager or admin), with
/// the admin's actions.
class PersonDetailScreen extends ConsumerStatefulWidget {
  const PersonDetailScreen({super.key, required this.role, required this.id});

  final UserRole role;
  final String id;

  @override
  ConsumerState<PersonDetailScreen> createState() => _PersonDetailScreenState();
}

class _PersonDetailScreenState extends ConsumerState<PersonDetailScreen> {
  var _busy = false;

  PersonKey get _key => (role: widget.role, id: widget.id);

  /// Runs a change, then refreshes everything that shows people or sites.
  Future<T?> _run<T>(Future<T> Function() change) async {
    if (_busy) return null;
    setState(() => _busy = true);
    try {
      final result = await change();
      ref
        ..bump(DataSet.people)
        ..bump(DataSet.sites)
        ..bump(DataSet.stock);
      return result;
    } on AppException catch (error) {
      if (mounted) showErrorSnack(context, error);
      return null;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _onAction(_Action action, PersonDetail person) async {
    final l10n = AppLocalizations.of(context);
    final repository = ref.read(peopleRepositoryProvider);
    switch (action) {
      case _Action.edit:
        await context.push(AppRoutes.adminPersonEdit(personSegment(widget.role), person.id));
      case _Action.resetPassword:
        final confirmed = await showConfirmDialog(
          context,
          title: l10n.personResetConfirmTitle,
          message: l10n.personResetConfirmBody(person.name),
          confirmLabel: l10n.personResetPassword,
        );
        if (!confirmed) return;
        final password = await _run(() => repository.resetPassword(person.id));
        if (password != null && mounted) {
          await showTemporaryPasswordDialog(context, name: person.name, password: password);
        }
      case _Action.deactivate:
        final confirmed = await showConfirmDialog(
          context,
          title: l10n.personDeactivateConfirmTitle(person.name),
          message: l10n.personDeactivateConfirmBody,
          confirmLabel: l10n.personDeactivate,
          destructive: true,
        );
        if (!confirmed) return;
        final done = await _run(() => repository.setActive(widget.role, person.id, active: false));
        if (done != null && mounted) showSnack(context, l10n.personDeactivated(person.name));
      case _Action.activate:
        final done = await _run(() => repository.setActive(widget.role, person.id, active: true));
        if (done != null && mounted) showSnack(context, l10n.personActivated(person.name));
    }
  }

  Future<void> _unassign(PersonDetail person) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.personUnassign,
      message: l10n.personUnassignConfirm(person.name, person.assignment!.site.name),
      confirmLabel: l10n.personUnassign,
      destructive: true,
    );
    if (!confirmed) return;
    final done = await _run(() => ref.read(peopleRepositoryProvider).unassignStaff(person.id));
    if (done != null && mounted) showSnack(context, l10n.staffUnassigned(person.name));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final person = ref.watch(personDetailProvider(_key));
    final loaded = person.value;
    // Admins can't switch off their own account.
    final isSelf = loaded?.id == ref.watch(sessionProvider).value?.userId;
    return Scaffold(
      appBar: AppBar(
        title: Text(loaded?.name ?? ''),
        bottom: _busy ? const PreferredSize(preferredSize: Size.fromHeight(4), child: LinearProgressIndicator()) : null,
        actions: [
          if (loaded != null)
            PopupMenuButton<_Action>(
              tooltip: l10n.commonActions,
              enabled: !_busy,
              onSelected: (action) => _onAction(action, loaded),
              itemBuilder: (context) => [
                PopupMenuItem(value: _Action.edit, child: Text(l10n.commonEdit)),
                if (loaded.isActive) PopupMenuItem(value: _Action.resetPassword, child: Text(l10n.personResetPassword)),
                if (loaded.isActive && !isSelf)
                  PopupMenuItem(value: _Action.deactivate, child: Text(l10n.personDeactivate))
                else if (!loaded.isActive)
                  PopupMenuItem(value: _Action.activate, child: Text(l10n.personActivate)),
              ],
            ),
        ],
      ),
      body: AsyncValueView(
        value: person,
        onRetry: () => ref.invalidate(personDetailProvider(_key)),
        data: (person) => RefreshIndicator(
          onRefresh: () => ref.refresh(personDetailProvider(_key).future),
          child: ListView(
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            children: [
              _Header(person: person),
              if (!person.isActive)
                _Padded(InlineMessage(message: l10n.personInactiveBanner, tone: StatusTone.neutral)),
              if (person.isActive && person.mustChangePassword)
                _Padded(InlineMessage(message: l10n.personPasswordPending, tone: StatusTone.info)),
              DetailRow(
                icon: Icons.phone_outlined,
                label: l10n.fieldPhone,
                value: person.phone,
                trailing: IconButton(
                  tooltip: l10n.commonCall,
                  icon: const Icon(Icons.call_outlined),
                  onPressed: () => callPhone(person.phone),
                ),
              ),
              if (person.email != null)
                DetailRow(icon: Icons.email_outlined, label: l10n.fieldEmail, value: person.email!),
              if (person.joiningDate != null)
                DetailRow(
                  icon: Icons.event_outlined,
                  label: l10n.fieldJoiningDate,
                  value: formatDate(person.joiningDate!),
                ),
              DetailRow(
                icon: Icons.login,
                label: l10n.personLastSignIn,
                value: person.lastLoginAt == null ? l10n.personNeverSignedIn : formatDateTime(person.lastLoginAt!),
              ),
              ...switch (person.role) {
                UserRole.staff => _staffSection(context, person),
                UserRole.engineer => _engineerSection(context, person),
                UserRole.godownManager => _godownSection(context, person),
                UserRole.admin => const <Widget>[],
              },
              if (person.role == UserRole.staff || person.role == UserRole.engineer)
                ..._vehicleSection(context, person),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _staffSection(BuildContext context, PersonDetail person) {
    final l10n = AppLocalizations.of(context);
    final assignment = person.assignment;
    Future<void> assign() => showAssignStaffSheet(
      context,
      staff: IdName(id: person.id, name: person.name),
      currentSiteId: assignment?.site.id,
      currentEngineerId: assignment?.engineer.id,
    );
    return [
      _Padded(SectionHeader(l10n.personAssignment)),
      if (assignment == null)
        ListTile(leading: const Icon(Icons.location_off_outlined), title: Text(l10n.personNotAssigned))
      else
        ListTile(
          leading: const Icon(Icons.apartment_outlined),
          title: Text(assignment.site.name),
          subtitle: Text(l10n.personSupervisedBy(assignment.engineer.name)),
          onTap: () => context.push(AppRoutes.adminSite(assignment.site.id)),
        ),
      if (person.isActive)
        _Padded(
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              FilledButton.tonalIcon(
                onPressed: _busy ? null : assign,
                icon: const Icon(Icons.swap_horiz),
                label: Text(assignment == null ? l10n.personAssign : l10n.personChangeAssignment),
              ),
              if (assignment != null)
                OutlinedButton(onPressed: _busy ? null : () => _unassign(person), child: Text(l10n.personUnassign)),
            ],
          ),
        ),
    ];
  }

  /// The company vehicle they hold, with "Give a vehicle" or "Take back".
  List<Widget> _vehicleSection(BuildContext context, PersonDetail person) {
    final l10n = AppLocalizations.of(context);
    final vehicle = person.vehicle;
    return [
      _Padded(SectionHeader(l10n.personVehicle)),
      if (vehicle == null)
        ListTile(leading: const Icon(Icons.two_wheeler), title: Text(l10n.personNoVehicle))
      else
        ListTile(
          leading: Icon(vehicleIcon(vehicle.type)),
          title: Text(vehicle.makeModel),
          subtitle: Text('${vehicle.registrationNo} · ${l10n.vehicleSince(formatDate(vehicle.givenOn))}'),
          onTap: () => context.push(AppRoutes.adminVehicle(vehicle.id)),
        ),
      if (person.isActive)
        _Padded(
          Align(
            alignment: Alignment.centerLeft,
            child: vehicle == null
                ? FilledButton.tonalIcon(
                    onPressed: _busy
                        ? null
                        : () => showGiveVehicleSheet(
                            context,
                            person: IdName(id: person.id, name: person.name),
                          ),
                    icon: const Icon(Icons.two_wheeler),
                    label: Text(l10n.personGiveVehicle),
                  )
                : OutlinedButton(
                    onPressed: _busy
                        ? null
                        : () => showTakeBackVehicleSheet(
                            context,
                            vehicle: (id: vehicle.id, name: vehicleName(vehicle.makeModel, vehicle.registrationNo)),
                            holderName: person.name,
                            givenOn: vehicle.givenOn,
                          ),
                    child: Text(l10n.vehicleTakeBack),
                  ),
          ),
        ),
    ];
  }

  List<Widget> _godownSection(BuildContext context, PersonDetail person) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return [
      _Padded(SectionHeader(l10n.personGodowns)),
      if (person.godowns.isEmpty)
        _Padded(
          Text(
            l10n.personNoGodowns,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
      for (final godown in person.godowns)
        ListTile(
          leading: const Icon(Icons.warehouse_outlined),
          title: Text(godown.name),
          onTap: () => context.push(AppRoutes.stockGodown(AppRoutes.adminArea, godown.id)),
        ),
    ];
  }

  List<Widget> _engineerSection(BuildContext context, PersonDetail person) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    Widget note(String text) =>
        _Padded(Text(text, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)));
    return [
      _Padded(SectionHeader(l10n.personSites)),
      if (person.sites.isEmpty) note(l10n.personNoSites),
      for (final site in person.sites)
        ListTile(
          leading: const Icon(Icons.apartment_outlined),
          title: Text(site.name),
          subtitle: Text(site.code),
          onTap: () => context.push(AppRoutes.adminSite(site.id)),
        ),
      _Padded(SectionHeader(l10n.personSupervises)),
      if (person.supervisedStaff.isEmpty) note(l10n.personSupervisesNone),
      for (final staff in person.supervisedStaff)
        ListTile(
          leading: CircleAvatar(child: Text(initialsOf(staff.name))),
          title: Text(staff.name),
          subtitle: Text([?staff.designation?.label(l10n), staff.site.name].join(' · ')),
          onTap: () => context.push(AppRoutes.adminStaffMember(staff.id)),
        ),
    ];
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.person});

  final PersonDetail person;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final role = person.designation?.label(l10n) ?? person.role.label(l10n);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          CircleAvatar(radius: 32, child: Text(initialsOf(person.name), style: theme.textTheme.titleLarge)),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(person.name, style: theme.textTheme.titleLarge),
                Text('$role · ${person.employeeCode}', style: theme.textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.xs),
                StatusChip(
                  label: person.isActive ? l10n.commonActive : l10n.commonInactive,
                  tone: person.isActive ? StatusTone.success : StatusTone.neutral,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Padded extends StatelessWidget {
  const _Padded(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
    child: child,
  );
}
