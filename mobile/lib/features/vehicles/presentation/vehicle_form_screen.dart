import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/enums.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/inline_message.dart';
import '../../../core/widgets/submit_state.dart';
import '../data/vehicles_repository.dart';
import '../domain/vehicle_models.dart';

/// Adds a company vehicle, or (with [id]) changes one (admins).
class VehicleFormScreen extends ConsumerWidget {
  const VehicleFormScreen({super.key, this.id});

  final String? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final id = this.id;
    return Scaffold(
      appBar: AppBar(title: Text(id == null ? l10n.vehicleNewTitle : l10n.vehicleEditTitle)),
      body: id == null
          ? const _Form()
          : AsyncValueView(
              value: ref.watch(vehicleProvider(id)),
              onRetry: () => ref.invalidate(vehicleProvider(id)),
              data: (detail) => _Form(existing: detail.vehicle),
            ),
    );
  }
}

class _Form extends ConsumerStatefulWidget {
  const _Form({this.existing});

  final Vehicle? existing;

  @override
  ConsumerState<_Form> createState() => _FormState();
}

class _FormState extends ConsumerState<_Form> with SubmitState {
  final _formKey = GlobalKey<FormState>();
  late var _type = widget.existing?.type ?? VehicleType.bike;
  late final _registration = TextEditingController(text: widget.existing?.registrationNo);
  late final _makeModel = TextEditingController(text: widget.existing?.makeModel);
  late final _note = TextEditingController(text: widget.existing?.note);

  @override
  void dispose() {
    _registration.dispose();
    _makeModel.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    final repository = ref.read(vehiclesRepositoryProvider);
    final existing = widget.existing;
    final saved = await runSubmit(
      () => existing == null
          ? repository.create(
              type: _type,
              registrationNo: _registration.text.trim(),
              makeModel: _makeModel.text.trim(),
              note: textOrNull(_note),
            )
          : repository.update(
              existing.id,
              type: _type,
              registrationNo: _registration.text.trim(),
              makeModel: _makeModel.text.trim(),
              note: textOrNull(_note),
            ),
    );
    if (saved == null || !mounted) return;
    ref
      ..bump(DataSet.vehicles)
      ..bump(DataSet.people);
    showSnack(context, l10n.vehicleSaved(saved.vehicle.code));
    if (existing == null) {
      context.pushReplacement(AppRoutes.adminVehicle(saved.vehicle.id));
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const gap = SizedBox(height: AppSpacing.md);
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          DropdownButtonFormField<VehicleType>(
            initialValue: _type,
            isExpanded: true,
            decoration: InputDecoration(labelText: l10n.vehicleType),
            items: [
              for (final type in VehicleType.values) DropdownMenuItem(value: type, child: Text(type.label(l10n))),
            ],
            onChanged: (value) => setState(() => _type = value ?? _type),
          ),
          gap,
          TextFormField(
            controller: _registration,
            textCapitalization: TextCapitalization.characters,
            maxLength: 20,
            decoration: InputDecoration(
              labelText: l10n.vehicleRegistration,
              helperText: l10n.vehicleRegistrationHelper,
            ),
            validator: (value) =>
                (value ?? '').replaceAll(RegExp('[^A-Za-z0-9]'), '').length < 4 ? l10n.validationRequired : null,
          ),
          gap,
          TextFormField(
            controller: _makeModel,
            textCapitalization: TextCapitalization.words,
            maxLength: 80,
            decoration: InputDecoration(labelText: l10n.vehicleMakeModel, helperText: l10n.vehicleMakeModelHelper),
            validator: (value) => (value?.trim().length ?? 0) < 2 ? l10n.validationRequired : null,
          ),
          gap,
          TextFormField(
            controller: _note,
            decoration: InputDecoration(labelText: l10n.fieldNoteOptional),
            minLines: 1,
            maxLines: 4,
            maxLength: 500,
          ),
          if (submitError case final error?) ...[gap, InlineMessage(message: error)],
          const SizedBox(height: AppSpacing.lg),
          SubmitButton(label: l10n.vehicleSave, busy: submitting, onPressed: _save),
        ],
      ),
    );
  }
}
