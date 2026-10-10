import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:uuid/uuid.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/models/enums.dart';
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

/// The site is done with a request: everything was used, or what is left goes
/// back to the request's godown (its manager confirms the return). Admins and
/// the godown hear about it.
class CloseRequestScreen extends ConsumerStatefulWidget {
  const CloseRequestScreen({super.key, required this.request});

  final MaterialRequest request;

  static Future<void> open(BuildContext context, MaterialRequest request) =>
      Navigator.of(context).push<void>(MaterialPageRoute(builder: (_) => CloseRequestScreen(request: request)));

  @override
  ConsumerState<CloseRequestScreen> createState() => _CloseRequestScreenState();
}

class _CloseRequestScreenState extends ConsumerState<CloseRequestScreen> with SubmitState {
  final _formKey = GlobalKey<FormState>();

  /// Made once per form, so a retry never returns the leftover twice.
  final _returnRequestId = const Uuid().v4();
  final _note = TextEditingController();
  final _returned = <String, TextEditingController>{};
  var _outcome = MaterialRequestOutcome.allUsed;

  @override
  void dispose() {
    _note.dispose();
    for (final controller in _returned.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _controllerFor(HolderStockRow item) =>
      _returned.putIfAbsent(item.material.id, () => TextEditingController(text: item.onHand));

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    final leftover = _outcome == MaterialRequestOutcome.leftoverReturned;
    final returned = [
      for (final MapEntry(:key, :value) in _returned.entries)
        if (num.tryParse(value.text.trim()) case final q? when q > 0) (materialId: key, quantity: value.text.trim()),
    ];
    if (leftover && returned.isEmpty) {
      setState(() => submitError = l10n.requestReturnSomething);
      return;
    }
    final saved = await runSubmit(
      () => ref
          .read(materialRequestsRepositoryProvider)
          .close(
            widget.request.id,
            outcome: _outcome,
            note: textOrNull(_note),
            returnRequestId: leftover ? _returnRequestId : null,
            returned: leftover ? returned : const [],
          ),
    );
    if (saved == null || !mounted) return;
    ref
      ..bump(DataSet.stock)
      ..bump(DataSet.notifications);
    showSnack(context, l10n.requestClosed(saved.code));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const gap = SizedBox(height: AppSpacing.md);
    final r = widget.request;
    final godownName = r.godown?.name ?? '';
    final requested = {for (final line in r.lines) line.material.id};
    return Scaffold(
      appBar: AppBar(title: Text(l10n.requestCloseTitle(r.code))),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(l10n.requestCloseIntro),
            gap,
            RadioGroup<MaterialRequestOutcome>(
              groupValue: _outcome,
              onChanged: (value) => setState(() => _outcome = value ?? _outcome),
              child: Column(
                children: [
                  RadioListTile(
                    value: MaterialRequestOutcome.allUsed,
                    title: Text(l10n.requestOutcomeAllUsed),
                    contentPadding: EdgeInsets.zero,
                  ),
                  RadioListTile(
                    value: MaterialRequestOutcome.leftoverReturned,
                    title: Text(l10n.requestOutcomeReturn(godownName)),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            if (_outcome == MaterialRequestOutcome.leftoverReturned) ...[
              SectionHeader(l10n.requestGoingBack),
              AsyncValueView(
                value: ref.watch(siteStockProvider(r.site.id)),
                onRetry: () => ref.invalidate(siteStockProvider(r.site.id)),
                data: (stock) {
                  final items = [
                    for (final item in stock.items)
                      if (item.hasStock && requested.contains(item.material.id)) item,
                  ];
                  if (items.isEmpty) return InlineMessage(message: l10n.requestNothingToReturn);
                  return Column(
                    children: [
                      for (final item in items)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: QuantityField(
                              controller: _controllerFor(item),
                              label: item.material.name,
                              unit: item.material.unit,
                              helperText: l10n.stockAvailable(formatQuantity(item.onHand, item.material.unit)),
                              validator: (value) {
                                if (value == null || !isQuantity(value)) return l10n.validationQuantity;
                                if (num.parse(value) > num.parse(item.onHand)) {
                                  return l10n.stockOnlyAvailable(formatQuantity(item.onHand, item.material.unit));
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      Text(l10n.requestReturnZeroHint, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  );
                },
              ),
            ],
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
            SubmitButton(label: l10n.requestClose, busy: submitting, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
