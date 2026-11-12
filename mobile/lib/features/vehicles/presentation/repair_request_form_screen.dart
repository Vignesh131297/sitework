import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:uuid/uuid.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/routing/area.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/form_fields.dart';
import '../../../core/widgets/inline_message.dart';
import '../../../core/widgets/submit_state.dart';
import '../data/vehicles_repository.dart';
import '../domain/vehicle_models.dart';
import 'vehicle_widgets.dart';

/// The staff member or engineer who holds a company vehicle asks for money to
/// repair it. An admin decides.
class RepairRequestFormScreen extends ConsumerWidget {
  const RepairRequestFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.repairAsk)),
      body: AsyncValueView(
        value: ref.watch(myVehicleProvider),
        onRetry: () => ref.invalidate(myVehicleProvider),
        data: (vehicle) => vehicle == null
            ? Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: InlineMessage(message: l10n.repairNoVehicle, tone: StatusTone.info),
              )
            : _Form(vehicle: vehicle),
      ),
    );
  }
}

class _Form extends ConsumerStatefulWidget {
  const _Form({required this.vehicle});

  final Vehicle vehicle;

  @override
  ConsumerState<_Form> createState() => _FormState();
}

class _FormState extends ConsumerState<_Form> with SubmitState {
  final _formKey = GlobalKey<FormState>();

  /// Made once per form, so a retry after a dropped connection asks only once.
  final _requestId = const Uuid().v4();
  final _amount = TextEditingController();
  final _note = TextEditingController();

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    final area = ref.read(areaPathProvider);
    final created = await runSubmit(
      () => ref
          .read(vehiclesRepositoryProvider)
          .askRepairMoney(requestId: _requestId, amount: _amount.text.trim(), note: _note.text.trim()),
    );
    if (created == null || !mounted) return;
    ref
      ..bump(DataSet.vehicles)
      ..bump(DataSet.notifications);
    showSnack(context, l10n.requestSentForApproval(created.code));
    context.pushReplacement(AppRoutes.repairRequest(area, created.id));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const gap = SizedBox(height: AppSpacing.md);
    final v = widget.vehicle;
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(vehicleIcon(v.type)),
            title: Text(v.makeModel),
            subtitle: Text(v.registrationNo),
          ),
          gap,
          AmountField(
            controller: _amount,
            label: l10n.repairAmount,
            helperText: l10n.repairAmountHelper,
            validator: (value) =>
                value == null || !isAmount(value) || num.parse(value) <= 0 ? l10n.validationAmount : null,
          ),
          gap,
          TextFormField(
            controller: _note,
            decoration: InputDecoration(labelText: l10n.repairWhat),
            textCapitalization: TextCapitalization.sentences,
            minLines: 2,
            maxLines: 4,
            maxLength: 500,
            validator: (value) => (value?.trim().length ?? 0) < 3 ? l10n.validationRequired : null,
          ),
          if (submitError case final error?) ...[gap, InlineMessage(message: error)],
          const SizedBox(height: AppSpacing.lg),
          SubmitButton(label: l10n.requestSendForApproval, busy: submitting, onPressed: _save),
        ],
      ),
    );
  }
}
