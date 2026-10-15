import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:uuid/uuid.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/models/enums.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/time/server_clock.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/form_fields.dart';
import '../../../core/widgets/info_widgets.dart';
import '../../../core/widgets/inline_message.dart';
import '../../../core/widgets/photo_picker_field.dart';
import '../../../core/widgets/submit_state.dart';
import '../data/stock_repository.dart';
import '../domain/stock_models.dart';
import 'material_form_screen.dart';

/// The ways stock is recorded.
enum StockAction { purchase, send, use, writeOff, count }

/// A material the form can offer, with what the source holds (null: no limit).
typedef StockOption = ({StockMaterial material, String? available});

/// One form for every way stock is recorded: bought into a godown, sent
/// between godowns, sent to a site against its approved request, returned
/// from a site to a godown, used, written off or counted. The server checks
/// every quantity against the books; the form helps get it right first time.
class StockEntryScreen extends ConsumerStatefulWidget {
  const StockEntryScreen({super.key, required this.action, this.from, this.to, this.prefill = const [], this.request});

  final StockAction action;

  /// Where the stock is or leaves from; the user picks one when null (sending).
  final StockHolder? from;

  /// Where it goes (sending) or is bought into; the user picks one when null.
  final StockHolder? to;

  /// Lines to start with, e.g. everything on site for "return everything".
  final List<StockFormLine> prefill;

  /// Sending to a site: the approved request it goes against. Only its
  /// materials can be sent, up to what is left to send.
  final MaterialRequest? request;

  static Future<void> open(
    BuildContext context, {
    required StockAction action,
    StockHolder? from,
    StockHolder? to,
    List<StockFormLine> prefill = const [],
    MaterialRequest? request,
  }) => Navigator.of(context).push<void>(
    MaterialPageRoute(
      builder: (_) => StockEntryScreen(action: action, from: from, to: to, prefill: prefill, request: request),
    ),
  );

  @override
  ConsumerState<StockEntryScreen> createState() => _StockEntryScreenState();
}

class _Line {
  _Line({this.materialId, String quantity = '', String rate = ''})
    : quantity = TextEditingController(text: quantity),
      rate = TextEditingController(text: rate);

  String? materialId;
  final TextEditingController quantity;
  final TextEditingController rate;

  void dispose() {
    quantity.dispose();
    rate.dispose();
  }
}

class _StockEntryScreenState extends ConsumerState<StockEntryScreen> with SubmitState {
  final _formKey = GlobalKey<FormState>();

  /// Made once per form, so a retry after a dropped connection is not recorded twice.
  final _requestId = const Uuid().v4();
  final _dcNumber = TextEditingController();
  final _supplier = TextEditingController();
  final _billNo = TextEditingController();
  final _note = TextEditingController();
  late final List<_Line> _lines = widget.prefill.isEmpty
      ? [_Line()]
      : [for (final line in widget.prefill) _Line(materialId: line.materialId, quantity: line.quantity)];
  late String _movedOn = isoDate(ref.read(serverClockProvider.notifier).now());
  late StockHolder? _from = widget.from;
  late StockHolder? _to = widget.to;
  var _photos = <String>[];

  StockAction get _action => widget.action;
  bool get _buying => _action == StockAction.purchase;
  bool get _counting => _action == StockAction.count;
  bool get _sending => _action == StockAction.send;
  bool get _dcPhotoRequired => _sending && _from?.place == StockPlace.godown;

  @override
  void dispose() {
    for (final controller in [_dcNumber, _supplier, _billNo, _note]) {
      controller.dispose();
    }
    for (final line in _lines) {
      line.dispose();
    }
    super.dispose();
  }

  String _title(AppLocalizations l10n) => switch (_action) {
    StockAction.purchase => l10n.stockActionPurchase,
    StockAction.send when widget.request != null => l10n.requestSendTitle(widget.request!.code),
    StockAction.send => _from?.place == StockPlace.site ? l10n.stockActionSendOn : l10n.stockActionSend,
    StockAction.use => l10n.stockActionUse,
    StockAction.writeOff => l10n.stockActionWriteOff,
    StockAction.count => l10n.stockActionCount,
  };

  AsyncValue<List<HolderStockRow>> _held(StockHolder holder) => holder.place == StockPlace.godown
      ? ref.watch(godownStockProvider(holder.id)).whenData((s) => s.items)
      : ref.watch(siteStockProvider(holder.id)).whenData((s) => s.items);

  /// What the form can offer: every material in use (buying, counting), or
  /// what the source holds (everything else).
  AsyncValue<List<StockOption>> _options() {
    final from = _from;
    if (_buying) {
      return ref
          .watch(stockOverviewProvider)
          .whenData(
            (o) => [
              for (final row in o.materials)
                if (row.material.isActive) (material: row.material, available: null),
            ],
          );
    }
    if (from == null) return const AsyncData([]);
    final held = _held(from);
    if (_counting) {
      final overview = ref.watch(stockOverviewProvider);
      if (held is! AsyncData || overview is! AsyncData) {
        return held.hasError ? AsyncError(held.error!, held.stackTrace!) : const AsyncLoading();
      }
      final onBooks = {for (final item in held.value!) item.material.id: item.onHand};
      return AsyncData([
        for (final row in overview.value!.materials)
          if (row.material.isActive || onBooks.containsKey(row.material.id))
            (material: row.material, available: onBooks[row.material.id] ?? '0'),
      ]);
    }
    if (widget.request case final request?) {
      // Up to what the godown holds and what is left to send on the request.
      final left = {
        for (final line in request.lines)
          if (line.hasLeftToSend) line.material.id: num.parse(line.leftToSend!),
      };
      return held.whenData(
        (items) => [
          for (final item in items)
            if (item.hasStock && left.containsKey(item.material.id))
              (
                material: item.material,
                available: num.parse(item.onHand) < left[item.material.id]!
                    ? item.onHand
                    : request.lines.firstWhere((l) => l.material.id == item.material.id).leftToSend,
              ),
        ],
      );
    }
    return held.whenData(
      (items) => [
        for (final item in items)
          if (item.hasStock && (item.material.isActive || !_sending || from.place == StockPlace.site))
            (material: item.material, available: item.onHand),
      ],
    );
  }

  StockForm _form() => StockForm(
    kind: switch (_action) {
      StockAction.purchase => StockFormKind.purchase,
      StockAction.send => StockFormKind.transfer,
      StockAction.use => StockFormKind.usage,
      StockAction.writeOff => StockFormKind.writeOff,
      StockAction.count => StockFormKind.count,
    },
    requestId: _requestId,
    movedOn: _movedOn,
    lines: [
      for (final line in _lines)
        (
          materialId: line.materialId!,
          quantity: line.quantity.text.trim(),
          rate: _buying ? line.rate.text.trim() : null,
        ),
    ],
    from: _from,
    to: _to,
    dcNumber: _sending ? textOrNull(_dcNumber) : null,
    supplier: _buying ? textOrNull(_supplier) : null,
    billNo: _buying ? textOrNull(_billNo) : null,
    note: textOrNull(_note),
    photoPaths: _photos,
    materialRequestId: widget.request?.id,
  );

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;
    if (_dcPhotoRequired && _photos.isEmpty) {
      setState(() => submitError = l10n.stockDcPhotoRequired);
      return;
    }
    final saved = await runSubmit(() => ref.read(stockRepositoryProvider).submit(_form()));
    if (saved == null || !mounted) return;
    ref
      ..bump(DataSet.stock)
      ..bump(DataSet.notifications);
    showSnack(context, _counting && saved.lines.isEmpty ? l10n.stockCountMatched : l10n.stockSaved);
    Navigator.of(context).pop();
  }

  void _addLine([String? materialId]) => setState(() => _lines.add(_Line(materialId: materialId)));

  void _removeLine(_Line line) => setState(() {
    _lines.remove(line);
    line.dispose();
  });

  /// Buying something new: add it to the materials list, then to this form.
  Future<void> _newMaterial() async {
    final created = await MaterialFormScreen.open(context);
    if (created == null || !mounted) return;
    final empty = _lines.where((line) => line.materialId == null).firstOrNull;
    if (empty != null) {
      setState(() => empty.materialId = created.id);
    } else {
      _addLine(created.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const gap = SizedBox(height: AppSpacing.md);
    final options = _options();
    final overview = (_sending && (widget.from == null || widget.to == null)) || (_buying && widget.to == null)
        ? ref.watch(stockOverviewProvider).value
        : null;
    return Scaffold(
      appBar: AppBar(title: Text(_title(l10n))),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            ..._places(l10n, overview),
            DateField(
              label: _counting ? l10n.stockCountedOn : l10n.fieldDate,
              initialValue: _movedOn,
              lastDate: ref.read(serverClockProvider.notifier).now(),
              onChanged: (value) => _movedOn = value ?? _movedOn,
            ),
            if (_buying) ...[
              gap,
              TextFormField(
                controller: _supplier,
                decoration: InputDecoration(labelText: l10n.stockSupplier),
                maxLength: 120,
              ),
              TextFormField(
                controller: _billNo,
                decoration: InputDecoration(labelText: l10n.stockBillNo),
                maxLength: 60,
              ),
            ],
            if (_sending) ...[
              gap,
              TextFormField(
                controller: _dcNumber,
                decoration: InputDecoration(labelText: l10n.stockDcNumber),
                maxLength: 60,
              ),
            ],
            SectionHeader(
              l10n.stockMaterials,
              trailing: _buying
                  ? TextButton.icon(
                      onPressed: submitting ? null : _newMaterial,
                      icon: const Icon(Icons.add_box_outlined),
                      label: Text(l10n.materialNew),
                    )
                  : null,
            ),
            AsyncValueView(
              value: options,
              onRetry: () {
                ref.invalidate(stockOverviewProvider);
                if (_from case final from?) {
                  from.place == StockPlace.godown
                      ? ref.invalidate(godownStockProvider(from.id))
                      : ref.invalidate(siteStockProvider(from.id));
                }
              },
              data: (options) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (options.isEmpty)
                    InlineMessage(
                      message: _from == null && !_buying ? l10n.stockChooseSource : l10n.stockNothingToChoose,
                    )
                  else ...[
                    for (final (index, line) in _lines.indexed)
                      _LineCard(
                        key: ObjectKey(line),
                        line: line,
                        index: index,
                        options: [
                          for (final option in options)
                            if (option.material.id == line.materialId ||
                                !_lines.any((other) => other.materialId == option.material.id))
                              option,
                        ],
                        action: _action,
                        onChanged: () => setState(() {}),
                        onRemove: _lines.length > 1 ? () => _removeLine(line) : null,
                      ),
                    if (_lines.length < options.length)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: _addLine,
                          icon: const Icon(Icons.add),
                          label: Text(l10n.stockAddMaterial),
                        ),
                      ),
                  ],
                ],
              ),
            ),
            gap,
            TextFormField(
              controller: _note,
              decoration: InputDecoration(
                labelText: switch (_action) {
                  StockAction.use => l10n.stockUsedFor,
                  StockAction.writeOff => l10n.stockWhatHappened,
                  StockAction.count => l10n.stockCountNote,
                  _ => l10n.fieldNoteOptional,
                },
              ),
              minLines: 1,
              maxLines: 4,
              maxLength: 500,
              validator: _action == StockAction.writeOff || _counting
                  ? (value) => (value?.trim().length ?? 0) < 3 ? l10n.validationRequired : null
                  : null,
            ),
            if (_buying || _sending) ...[
              SectionHeader(
                _buying
                    ? l10n.stockBillPhotosOptional
                    : _dcPhotoRequired
                    ? l10n.stockDcPhotos
                    : l10n.stockPhotosOptional,
              ),
              PhotoPickerField(
                paths: _photos,
                enabled: !submitting,
                onChanged: (paths) => setState(() => _photos = paths),
              ),
            ],
            if (submitError case final error?) ...[gap, InlineMessage(message: error)],
            const SizedBox(height: AppSpacing.lg),
            SubmitButton(
              label: _title(l10n),
              busy: submitting,
              onPressed: options.value?.isEmpty ?? true ? null : _save,
            ),
          ],
        ),
      ),
    );
  }

  /// Where the stock is, comes from and goes: fixed ones as text, open ones as pickers.
  List<Widget> _places(AppLocalizations l10n, StockOverview? overview) {
    const gap = SizedBox(height: AppSpacing.md);
    final godowns = [
      for (final g in overview?.godowns ?? const <GodownSummary>[])
        if (g.godown.isActive) (place: StockPlace.godown, id: g.godown.id, name: g.godown.name),
    ];
    final from = _from;
    final to = _to;
    return [
      if (_buying)
        if (widget.to == null)
          _HolderField(
            label: l10n.stockIntoGodown,
            holders: godowns,
            value: to,
            onChanged: (holder) => setState(() => _to = holder),
          )
        else
          _FixedPlace(label: l10n.stockIntoGodown, name: to!.name),
      if (!_buying)
        if (widget.from == null)
          _HolderField(
            label: l10n.stockSendFrom,
            holders: godowns,
            value: from,
            onChanged: (holder) => setState(() {
              _from = holder;
              for (final line in _lines) {
                line.materialId = null;
              }
            }),
          )
        else
          _FixedPlace(label: _sending ? l10n.stockSendFrom : l10n.stockAt, name: from!.name),
      if (_sending) ...[
        gap,
        if (widget.to == null)
          // Sites get stock only against an approved request (sent from the
          // request itself); here it goes to a godown.
          _HolderField(
            label: from?.place == StockPlace.site ? l10n.stockReturnTo : l10n.stockSendTo,
            holders: [
              for (final holder in godowns)
                if (holder.id != from?.id) holder,
            ],
            value: to,
            onChanged: (holder) => setState(() => _to = holder),
          )
        else
          _FixedPlace(label: l10n.stockSendTo, name: to!.name),
        if (widget.to == null && from?.place != StockPlace.site) ...[
          const SizedBox(height: AppSpacing.sm),
          InlineMessage(message: l10n.stockSendSitesHint, tone: StatusTone.info),
        ],
      ],
      gap,
    ];
  }
}

class _FixedPlace extends StatelessWidget {
  const _FixedPlace({required this.label, required this.name});

  final String label;
  final String name;

  @override
  Widget build(BuildContext context) => InputDecorator(
    decoration: InputDecoration(labelText: label, prefixIcon: const Icon(Icons.place_outlined)),
    child: Text(name),
  );
}

/// Picks a godown or site; the list says which is which.
class _HolderField extends StatelessWidget {
  const _HolderField({required this.label, required this.holders, required this.value, required this.onChanged});

  final String label;
  final List<StockHolder> holders;
  final StockHolder? value;
  final ValueChanged<StockHolder?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String key(StockHolder h) => '${h.place.apiValue}:${h.id}';
    final current = value == null ? null : key(value!);
    return DropdownButtonFormField<String>(
      key: ValueKey('$label-${holders.length}'),
      initialValue: holders.any((h) => key(h) == current) ? current : null,
      isExpanded: true,
      decoration: InputDecoration(labelText: label, prefixIcon: const Icon(Icons.place_outlined)),
      items: [
        for (final holder in holders)
          DropdownMenuItem(
            value: key(holder),
            child: Text(
              '${holder.place == StockPlace.godown ? l10n.stockGodownLabel : l10n.stockSiteLabel} · ${holder.name}',
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      validator: (value) => value == null ? l10n.validationRequired : null,
      onChanged: (value) => onChanged(holders.where((h) => key(h) == value).firstOrNull),
    );
  }
}

class _LineCard extends StatelessWidget {
  const _LineCard({
    super.key,
    required this.line,
    required this.index,
    required this.options,
    required this.action,
    required this.onChanged,
    this.onRemove,
  });

  final _Line line;
  final int index;
  final List<StockOption> options;
  final StockAction action;
  final VoidCallback onChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final counting = action == StockAction.count;
    final chosen = options.where((o) => o.material.id == line.materialId).firstOrNull;
    final available = chosen?.available;
    final unit = chosen?.material.unit;
    return Card(
      key: ValueKey('stock-line-$index'),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.xs, AppSpacing.sm),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    key: ValueKey('material-$index-${line.materialId}'),
                    initialValue: chosen == null ? null : line.materialId,
                    isExpanded: true,
                    decoration: InputDecoration(labelText: l10n.stockMaterial),
                    items: [
                      for (final option in options)
                        DropdownMenuItem(
                          value: option.material.id,
                          child: Text(option.material.name, overflow: TextOverflow.ellipsis),
                        ),
                    ],
                    validator: (value) => value == null ? l10n.validationRequired : null,
                    onChanged: (value) {
                      line.materialId = value;
                      onChanged();
                    },
                  ),
                ),
                IconButton(tooltip: l10n.stockRemoveLine, onPressed: onRemove, icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: QuantityField(
                controller: line.quantity,
                label: counting ? l10n.stockCountedQuantity : l10n.stockQuantity,
                unit: unit,
                helperText: available == null || unit == null
                    ? null
                    : counting
                    ? l10n.stockOnBooks(formatQuantity(available, unit))
                    : l10n.stockAvailable(formatQuantity(available, unit)),
                validator: (value) {
                  if (value == null || !isQuantity(value)) return l10n.validationQuantity;
                  final quantity = num.parse(value);
                  if (!counting && quantity <= 0) return l10n.validationQuantity;
                  if (!counting && available != null && unit != null && quantity > num.parse(available)) {
                    return l10n.stockOnlyAvailable(formatQuantity(available, unit));
                  }
                  return null;
                },
              ),
            ),
            if (action == StockAction.purchase) ...[
              const SizedBox(height: AppSpacing.sm),
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: AmountField(
                  controller: line.rate,
                  label: unit == null ? l10n.stockRate : l10n.stockRatePer(unit),
                  validator: (value) => value == null || !isAmount(value) ? l10n.validationAmount : null,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
