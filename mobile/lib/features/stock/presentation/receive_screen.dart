import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/form_fields.dart';
import '../../../core/widgets/info_widgets.dart';
import '../../../core/widgets/inline_message.dart';
import '../../../core/widgets/photo_picker_field.dart';
import '../../../core/widgets/submit_state.dart';
import '../data/stock_repository.dart';
import '../domain/stock_models.dart';
import 'stock_widgets.dart';

/// Confirms a delivery: what arrived of each material (all of it, unless the
/// receiver says otherwise), at least one photo, and a note if anything is
/// missing. The server checks it all again.
class ReceiveScreen extends ConsumerStatefulWidget {
  const ReceiveScreen({super.key, required this.entry});

  final StockEntry entry;

  static Future<void> open(BuildContext context, StockEntry entry) =>
      Navigator.of(context).push<void>(MaterialPageRoute(builder: (_) => ReceiveScreen(entry: entry)));

  @override
  ConsumerState<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends ConsumerState<ReceiveScreen> with SubmitState {
  final _formKey = GlobalKey<FormState>();
  late final _received = {
    for (final line in widget.entry.lines) line.material.id: TextEditingController(text: line.quantity),
  };
  final _note = TextEditingController();
  var _photos = <String>[];

  bool get _short => widget.entry.lines.any((line) {
    final value = num.tryParse(_received[line.material.id]!.text.trim());
    return value != null && value < num.parse(line.quantity);
  });

  @override
  void dispose() {
    for (final controller in _received.values) {
      controller.dispose();
    }
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;
    if (_photos.isEmpty) {
      setState(() => submitError = l10n.stockPhotoRequired);
      return;
    }
    final saved = await runSubmit(
      () => ref
          .read(stockRepositoryProvider)
          .receive(
            widget.entry.id,
            received: {for (final MapEntry(:key, :value) in _received.entries) key: value.text.trim()},
            note: textOrNull(_note),
            photoPaths: _photos,
          ),
    );
    if (saved == null || !mounted) return;
    ref
      ..bump(DataSet.stock)
      ..bump(DataSet.notifications);
    showSnack(context, l10n.stockReceived);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final e = widget.entry;
    const gap = SizedBox(height: AppSpacing.md);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.stockConfirmReceived)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              l10n.stockReceiveIntro(placeName(e.from, l10n), formatDate(e.movedOn)),
              style: theme.textTheme.bodyLarge,
            ),
            if (e.dcNumber case final dc?) ...[const SizedBox(height: AppSpacing.xs), Text(l10n.stockDcNumberIs(dc))],
            SectionHeader(l10n.stockWhatArrived),
            for (final line in e.lines) ...[
              QuantityField(
                controller: _received[line.material.id]!,
                label: line.material.name,
                unit: line.material.unit,
                helperText: l10n.stockSentQuantity(formatQuantity(line.quantity, line.material.unit)),
                validator: (value) {
                  if (value == null || !isQuantity(value)) return l10n.validationQuantity;
                  if (num.parse(value) > num.parse(line.quantity)) {
                    return l10n.stockReceiveTooMuch(formatQuantity(line.quantity, line.material.unit));
                  }
                  return null;
                },
              ),
              gap,
            ],
            ListenableBuilder(
              listenable: Listenable.merge(_received.values.toList()),
              builder: (context, _) => TextFormField(
                controller: _note,
                maxLength: 500,
                minLines: 1,
                maxLines: 3,
                decoration: InputDecoration(labelText: _short ? l10n.stockShortNote : l10n.fieldNoteOptional),
                validator: (value) => _short && (value?.trim().isEmpty ?? true) ? l10n.validationRequired : null,
              ),
            ),
            SectionHeader(l10n.stockReceivePhotos),
            PhotoPickerField(
              paths: _photos,
              enabled: !submitting,
              onChanged: (paths) => setState(() => _photos = paths),
            ),
            if (submitError case final error?) ...[gap, InlineMessage(message: error)],
            const SizedBox(height: AppSpacing.lg),
            SubmitButton(label: l10n.stockConfirmReceived, busy: submitting, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
