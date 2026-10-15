import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/form_fields.dart';
import '../../../core/widgets/info_widgets.dart';
import '../../../core/widgets/inline_message.dart';
import '../../../core/widgets/submit_state.dart';
import '../data/material_requests_repository.dart';
import '../data/stock_repository.dart';
import '../domain/stock_models.dart';

/// An admin approves a request: the godown that supplies it and how much of
/// each material (zero for one that won't be supplied). The godown's manager
/// then sends it.
class ApproveRequestScreen extends ConsumerStatefulWidget {
  const ApproveRequestScreen({super.key, required this.request});

  final MaterialRequest request;

  static Future<void> open(BuildContext context, MaterialRequest request) =>
      Navigator.of(context).push<void>(MaterialPageRoute(builder: (_) => ApproveRequestScreen(request: request)));

  @override
  ConsumerState<ApproveRequestScreen> createState() => _ApproveRequestScreenState();
}

class _ApproveRequestScreenState extends ConsumerState<ApproveRequestScreen> with SubmitState {
  final _formKey = GlobalKey<FormState>();
  final _note = TextEditingController();
  late final _approved = {
    for (final line in widget.request.lines) line.material.id: TextEditingController(text: line.quantity),
  };
  String? _godownId;

  @override
  void dispose() {
    _note.dispose();
    for (final controller in _approved.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    if (_approved.values.every((c) => num.parse(c.text.trim()) == 0)) {
      setState(() => submitError = l10n.requestApproveSomething);
      return;
    }
    final saved = await runSubmit(
      () => ref
          .read(materialRequestsRepositoryProvider)
          .approve(
            widget.request.id,
            godownId: _godownId!,
            approved: {for (final MapEntry(:key, :value) in _approved.entries) key: value.text.trim()},
            note: textOrNull(_note),
          ),
    );
    if (saved == null || !mounted) return;
    ref
      ..bump(DataSet.stock)
      ..bump(DataSet.notifications);
    showSnack(context, l10n.requestApproved(saved.code));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const gap = SizedBox(height: AppSpacing.md);
    final r = widget.request;
    final godownId = _godownId;
    // What the chosen godown holds, to approve what it can supply.
    final held = godownId == null ? null : ref.watch(godownStockProvider(godownId));
    final onHand = {for (final item in held?.value?.items ?? const <HolderStockRow>[]) item.material.id: item.onHand};
    return Scaffold(
      appBar: AppBar(title: Text(l10n.requestApproveTitle(r.code))),
      body: AsyncValueView(
        value: ref.watch(stockOverviewProvider),
        onRetry: () => ref.invalidate(stockOverviewProvider),
        data: (overview) => Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text(l10n.requestApproveIntro(r.site.name, r.requestedBy.name)),
              gap,
              DropdownButtonFormField<String>(
                initialValue: godownId,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: l10n.requestSupplyFrom,
                  prefixIcon: const Icon(Icons.warehouse_outlined),
                ),
                items: [
                  for (final g in overview.godowns)
                    if (g.godown.isActive)
                      DropdownMenuItem(
                        value: g.godown.id,
                        child: Text(g.godown.name, overflow: TextOverflow.ellipsis),
                      ),
                ],
                validator: (value) => value == null ? l10n.validationRequired : null,
                onChanged: (value) => setState(() => _godownId = value),
              ),
              SectionHeader(l10n.requestApprovedQuantities),
              Text(l10n.requestApproveZeroHint, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: AppSpacing.sm),
              for (final line in r.lines)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(line.material.name, style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: AppSpacing.sm),
                        QuantityField(
                          controller: _approved[line.material.id]!,
                          label: l10n.requestApprovedQuantity,
                          unit: line.material.unit,
                          helperText: [
                            l10n.requestAsked(formatQuantity(line.quantity, line.material.unit)),
                            if (godownId != null && held?.value != null)
                              l10n.requestInGodown(formatQuantity(onHand[line.material.id] ?? '0', line.material.unit)),
                          ].join(' · '),
                          validator: (value) => value == null || !isQuantity(value) ? l10n.validationQuantity : null,
                        ),
                      ],
                    ),
                  ),
                ),
              gap,
              TextFormField(
                controller: _note,
                decoration: InputDecoration(labelText: l10n.requestNoteForSite),
                minLines: 1,
                maxLines: 3,
                maxLength: 500,
              ),
              if (submitError case final error?) ...[gap, InlineMessage(message: error)],
              const SizedBox(height: AppSpacing.lg),
              SubmitButton(label: l10n.requestApprove, busy: submitting, onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}
