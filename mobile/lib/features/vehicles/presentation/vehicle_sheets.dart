import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/models/refs.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/time/server_clock.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/form_fields.dart';
import '../../../core/widgets/inline_message.dart';
import '../../../core/widgets/submit_state.dart';
import '../../auth/domain/user_role.dart';
import '../../auth/presentation/user_role_label.dart';
import '../../people/data/people_repository.dart';
import '../../people/domain/person_models.dart';
import '../data/vehicles_repository.dart';
import 'vehicle_widgets.dart';

/// A vehicle as the sheets name it.
typedef VehicleChoice = ({String id, String name});

/// Active staff and engineers, for "Give to".
final _holderPickerProvider = FutureProvider.autoDispose<List<PersonSummary>>((ref) async {
  ref.watch(revisionProvider(DataSet.people));
  final repository = ref.watch(peopleRepositoryProvider);
  final pages = await Future.wait([
    repository.list(UserRole.staff, page: 1, limit: 100, active: true),
    repository.list(UserRole.engineer, page: 1, limit: 100, active: true),
  ]);
  return [...pages[0].items, ...pages[1].items];
});

/// Gives a company vehicle to a staff member or an engineer. From a vehicle's
/// page pass [vehicle]; from a person's profile pass [person]. Resolves to true
/// once saved.
Future<bool> showGiveVehicleSheet(BuildContext context, {VehicleChoice? vehicle, IdName? person}) async {
  assert(vehicle != null || person != null, 'Fix the vehicle or the person');
  final saved = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (_) => _GiveVehicleSheet(vehicle: vehicle, person: person),
  );
  return saved ?? false;
}

class _GiveVehicleSheet extends ConsumerStatefulWidget {
  const _GiveVehicleSheet({this.vehicle, this.person});

  final VehicleChoice? vehicle;
  final IdName? person;

  @override
  ConsumerState<_GiveVehicleSheet> createState() => _GiveVehicleSheetState();
}

class _GiveVehicleSheetState extends ConsumerState<_GiveVehicleSheet> with SubmitState {
  final _formKey = GlobalKey<FormState>();
  final _note = TextEditingController();
  late VehicleChoice? _vehicle = widget.vehicle;
  late IdName? _person = widget.person;
  late String? _givenOn = isoDate(ref.read(serverClockProvider.notifier).now());

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    final vehicle = _vehicle!;
    final person = _person!;
    final messenger = ScaffoldMessenger.of(context);
    final done = await runSubmit(
      () => ref
          .read(vehiclesRepositoryProvider)
          .give(vehicle.id, userId: person.id, givenOn: _givenOn!, note: textOrNull(_note)),
    );
    if (done == null || !mounted) return;
    ref
      ..bump(DataSet.vehicles)
      ..bump(DataSet.people)
      ..bump(DataSet.notifications);
    Navigator.of(context).pop(true);
    messenger.showSnackBar(SnackBar(content: Text(l10n.vehicleGivenTo(vehicle.name, person.name))));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final today = ref.read(serverClockProvider.notifier).now();
    const gap = SizedBox(height: AppSpacing.md);
    final title = widget.vehicle != null
        ? l10n.vehicleGiveTitle(widget.vehicle!.name)
        : l10n.vehicleGiveToTitle(widget.person!.name);
    return _SheetBody(
      formKey: _formKey,
      title: title,
      children: [
        if (widget.vehicle == null) ...[
          _VehicleField(selected: _vehicle, onChanged: (vehicle) => setState(() => _vehicle = vehicle)),
          gap,
        ],
        if (widget.person == null) ...[
          _PersonField(selected: _person, onChanged: (person) => setState(() => _person = person)),
          gap,
        ],
        DateField(
          label: l10n.vehicleGivenOn,
          initialValue: _givenOn,
          lastDate: today,
          validator: (value) => value == null ? l10n.validationRequired : null,
          onChanged: (value) => _givenOn = value,
        ),
        gap,
        TextFormField(
          controller: _note,
          decoration: InputDecoration(labelText: l10n.fieldNoteOptional),
          minLines: 1,
          maxLines: 3,
          maxLength: 500,
        ),
        if (submitError case final error?) ...[gap, InlineMessage(message: error)],
        const SizedBox(height: AppSpacing.lg),
        SubmitButton(
          label: l10n.vehicleGiveSave,
          busy: submitting,
          onPressed: _vehicle == null || _person == null ? null : _save,
        ),
      ],
    );
  }
}

/// Picks a vehicle that is in use and with nobody.
class _VehicleField extends ConsumerWidget {
  const _VehicleField({required this.selected, required this.onChanged});

  final VehicleChoice? selected;
  final ValueChanged<VehicleChoice?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return AsyncValueView(
      value: ref.watch(freeVehiclesProvider),
      onRetry: () => ref.invalidate(freeVehiclesProvider),
      data: (vehicles) {
        if (vehicles.isEmpty) return InlineMessage(message: l10n.vehicleNoFree, tone: StatusTone.info);
        return DropdownButtonFormField<String>(
          initialValue: selected?.id,
          isExpanded: true,
          decoration: InputDecoration(labelText: l10n.vehicleChoose),
          items: [
            for (final v in vehicles)
              DropdownMenuItem(
                value: v.id,
                child: Text(vehicleName(v.makeModel, v.registrationNo), overflow: TextOverflow.ellipsis),
              ),
          ],
          validator: (value) => value == null ? l10n.validationRequired : null,
          onChanged: (id) {
            final v = vehicles.where((v) => v.id == id).firstOrNull;
            onChanged(v == null ? null : (id: v.id, name: vehicleName(v.makeModel, v.registrationNo)));
          },
        );
      },
    );
  }
}

/// Picks an active staff member or engineer.
class _PersonField extends ConsumerWidget {
  const _PersonField({required this.selected, required this.onChanged});

  final IdName? selected;
  final ValueChanged<IdName?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return AsyncValueView(
      value: ref.watch(_holderPickerProvider),
      onRetry: () => ref.invalidate(_holderPickerProvider),
      data: (people) => DropdownButtonFormField<String>(
        initialValue: selected?.id,
        isExpanded: true,
        decoration: InputDecoration(labelText: l10n.vehicleGiveTo),
        items: [
          for (final person in people)
            DropdownMenuItem(
              value: person.id,
              child: Text(
                '${person.name} · ${person.role.label(l10n)} · ${person.employeeCode}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
        validator: (value) => value == null ? l10n.validationRequired : null,
        onChanged: (id) {
          final person = people.where((p) => p.id == id).firstOrNull;
          onChanged(person == null ? null : IdName(id: person.id, name: person.name));
        },
      ),
    );
  }
}

/// Takes a vehicle back from [holderName], who has had it since [givenOn].
/// Resolves to true once saved.
Future<bool> showTakeBackVehicleSheet(
  BuildContext context, {
  required VehicleChoice vehicle,
  required String holderName,
  required String givenOn,
}) async {
  final saved = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (_) => _TakeBackSheet(vehicle: vehicle, holderName: holderName, givenOn: givenOn),
  );
  return saved ?? false;
}

class _TakeBackSheet extends ConsumerStatefulWidget {
  const _TakeBackSheet({required this.vehicle, required this.holderName, required this.givenOn});

  final VehicleChoice vehicle;
  final String holderName;
  final String givenOn;

  @override
  ConsumerState<_TakeBackSheet> createState() => _TakeBackSheetState();
}

class _TakeBackSheetState extends ConsumerState<_TakeBackSheet> with SubmitState {
  final _formKey = GlobalKey<FormState>();
  final _note = TextEditingController();
  late String? _returnedOn = isoDate(ref.read(serverClockProvider.notifier).now());

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final done = await runSubmit(
      () => ref
          .read(vehiclesRepositoryProvider)
          .takeBack(widget.vehicle.id, returnedOn: _returnedOn!, note: textOrNull(_note)),
    );
    if (done == null || !mounted) return;
    ref
      ..bump(DataSet.vehicles)
      ..bump(DataSet.people)
      ..bump(DataSet.notifications);
    Navigator.of(context).pop(true);
    messenger.showSnackBar(SnackBar(content: Text(l10n.vehicleTakenBack(widget.vehicle.name))));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final today = ref.read(serverClockProvider.notifier).now();
    const gap = SizedBox(height: AppSpacing.md);
    return _SheetBody(
      formKey: _formKey,
      title: l10n.vehicleTakeBackTitle(widget.vehicle.name),
      children: [
        Text(
          '${l10n.vehicleTakeBackFrom(widget.holderName)} · ${l10n.vehicleSince(formatDate(widget.givenOn))}',
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        gap,
        DateField(
          label: l10n.vehicleReturnedOn,
          initialValue: _returnedOn,
          firstDate: DateTime.parse(widget.givenOn),
          lastDate: today,
          validator: (value) => value == null ? l10n.validationRequired : null,
          onChanged: (value) => _returnedOn = value,
        ),
        gap,
        TextFormField(
          controller: _note,
          decoration: InputDecoration(labelText: l10n.fieldNoteOptional),
          minLines: 1,
          maxLines: 3,
          maxLength: 500,
        ),
        if (submitError case final error?) ...[gap, InlineMessage(message: error)],
        const SizedBox(height: AppSpacing.lg),
        SubmitButton(label: l10n.vehicleTakeBack, busy: submitting, onPressed: _save),
      ],
    );
  }
}

/// A titled, scrollable form that stays above the keyboard.
class _SheetBody extends StatelessWidget {
  const _SheetBody({required this.formKey, required this.title, required this.children});

  final GlobalKey<FormState> formKey;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.lg),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
