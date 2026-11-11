import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:uuid/uuid.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/enums.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/routing/area.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/time/server_clock.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/form_fields.dart';
import '../../../core/widgets/inline_message.dart';
import '../../../core/widgets/submit_state.dart';
import '../data/requests_repository.dart';

/// A meal can be asked for this many days ahead (the server's rule).
const _foodAheadDays = 30;

/// A staff member asks for money (an advance) or a meal for themselves. An
/// engineer on their site or an admin decides.
class StaffRequestFormScreen extends ConsumerStatefulWidget {
  const StaffRequestFormScreen({super.key, required this.kind});

  final StaffRequestKind kind;

  @override
  ConsumerState<StaffRequestFormScreen> createState() => _StaffRequestFormScreenState();
}

class _StaffRequestFormScreenState extends ConsumerState<StaffRequestFormScreen> with SubmitState {
  final _formKey = GlobalKey<FormState>();

  /// Made once per form, so a retry after a dropped connection asks only once.
  final _requestId = const Uuid().v4();
  final _amount = TextEditingController();
  final _note = TextEditingController();
  var _meal = Meal.lunch;
  String? _forDate;

  bool get _money => widget.kind == StaffRequestKind.money;

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
          .read(requestsRepositoryProvider)
          .ask(
            requestId: _requestId,
            kind: widget.kind,
            amount: _money ? _amount.text.trim() : null,
            forDate: _money ? null : _forDate,
            meal: _money ? null : _meal,
            note: textOrNull(_note),
          ),
    );
    if (created == null || !mounted) return;
    ref
      ..bump(DataSet.requests)
      ..bump(DataSet.notifications);
    showSnack(context, l10n.requestSentForApproval(created.code));
    context.pushReplacement(AppRoutes.staffRequest(area, created.id));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const gap = SizedBox(height: AppSpacing.md);
    final today = ref.read(serverClockProvider.notifier).now();
    return Scaffold(
      appBar: AppBar(title: Text(_money ? l10n.moneyNewTitle : l10n.foodNewTitle)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            if (_money)
              AmountField(
                controller: _amount,
                label: l10n.moneyAmount,
                helperText: l10n.moneyAmountHelper,
                validator: (value) =>
                    value == null || !isAmount(value) || num.parse(value) <= 0 ? l10n.validationAmount : null,
              )
            else ...[
              DateField(
                label: l10n.foodDay,
                initialValue: _forDate,
                firstDate: today,
                lastDate: today.add(const Duration(days: _foodAheadDays)),
                validator: (value) => value == null ? l10n.validationRequired : null,
                onChanged: (value) => _forDate = value,
              ),
              gap,
              Text(l10n.foodMeal, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: AppSpacing.sm),
              SegmentedButton<Meal>(
                // Without the tick, three choices fit a small phone.
                showSelectedIcon: false,
                segments: [for (final meal in Meal.values) ButtonSegment(value: meal, label: Text(meal.label(l10n)))],
                selected: {_meal},
                onSelectionChanged: (selection) => setState(() => _meal = selection.first),
              ),
            ],
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
            SubmitButton(label: l10n.requestSendForApproval, busy: submitting, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
