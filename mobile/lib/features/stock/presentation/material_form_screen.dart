import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/form_fields.dart';
import '../../../core/widgets/inline_message.dart';
import '../../../core/widgets/submit_state.dart';
import '../data/stock_repository.dart';
import '../domain/stock_models.dart';

/// Units offered as one-tap choices; any other can be typed.
const commonUnits = ['bag', 'kg', 'ton', 'cft', 'cum', 'nos', 'm', 'sqft', 'litre', 'load'];

/// Adds a material, or edits one. The unit can't change once stock has been
/// recorded (the server refuses), and a material is switched off, never deleted.
class MaterialFormScreen extends ConsumerStatefulWidget {
  const MaterialFormScreen({super.key, this.material});

  final StockMaterial? material;

  /// Completes with the saved material, or null if the user backed out.
  static Future<StockMaterial?> open(BuildContext context, {StockMaterial? material}) =>
      Navigator.of(context)
          .push<StockMaterial>(MaterialPageRoute(builder: (_) => MaterialFormScreen(material: material)));

  @override
  ConsumerState<MaterialFormScreen> createState() => _MaterialFormScreenState();
}

class _MaterialFormScreenState extends ConsumerState<MaterialFormScreen> with SubmitState {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.material?.name);
  late final _unit = TextEditingController(text: widget.material?.unit);
  late final _category = TextEditingController(text: widget.material?.category);
  late final _minimum = TextEditingController(text: widget.material?.minStock);
  late var _active = widget.material?.isActive ?? true;

  bool get _editing => widget.material != null;

  @override
  void dispose() {
    for (final controller in [_name, _unit, _category, _minimum]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    final repository = ref.read(stockRepositoryProvider);
    final saved = await runSubmit(
      () => _editing
          ? repository.updateMaterial(widget.material!.id, {
              'name': _name.text.trim(),
              'unit': _unit.text.trim(),
              'category': textOrNull(_category),
              'minStock': textOrNull(_minimum),
              'isActive': _active,
            })
          : repository.createMaterial(
              name: _name.text.trim(),
              unit: _unit.text.trim(),
              category: textOrNull(_category),
              minStock: textOrNull(_minimum),
            ),
    );
    if (saved == null || !mounted) return;
    ref.bump(DataSet.stock);
    showSnack(context, l10n.materialSaved);
    Navigator.of(context).pop(saved.material);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const gap = SizedBox(height: AppSpacing.md);
    return Scaffold(
      appBar: AppBar(title: Text(_editing ? l10n.materialEdit : l10n.materialNew)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            TextFormField(
              controller: _name,
              decoration: InputDecoration(labelText: l10n.materialName, hintText: l10n.materialNameHint),
              textCapitalization: TextCapitalization.words,
              maxLength: 80,
              validator: (value) => (value?.trim().length ?? 0) < 2 ? l10n.validationRequired : null,
            ),
            TextFormField(
              controller: _unit,
              decoration: InputDecoration(labelText: l10n.materialUnit, helperText: l10n.materialUnitHelper),
              maxLength: 20,
              validator: requiredText(l10n),
            ),
            ListenableBuilder(
              listenable: _unit,
              builder: (context, _) => Wrap(
                spacing: AppSpacing.sm,
                children: [
                  for (final unit in commonUnits)
                    ChoiceChip(
                      label: Text(unit),
                      selected: _unit.text.trim() == unit,
                      onSelected: (_) => _unit.text = unit,
                    ),
                ],
              ),
            ),
            gap,
            TextFormField(
              controller: _category,
              decoration: InputDecoration(labelText: l10n.materialCategory, hintText: l10n.materialCategoryHint),
              textCapitalization: TextCapitalization.sentences,
              maxLength: 40,
            ),
            ListenableBuilder(
              listenable: _unit,
              builder: (context, _) => QuantityField(
                controller: _minimum,
                label: l10n.materialMinimum,
                unit: _unit.text.trim().isEmpty ? null : _unit.text.trim(),
                helperText: l10n.materialMinimumHelper,
                validator: (value) =>
                    value == null || value.trim().isEmpty || isQuantity(value) ? null : l10n.validationQuantity,
              ),
            ),
            if (_editing) ...[
              gap,
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.materialActive),
                subtitle: Text(l10n.materialActiveHelper),
                value: _active,
                onChanged: (value) => setState(() => _active = value),
              ),
            ],
            if (submitError case final error?) ...[gap, InlineMessage(message: error)],
            const SizedBox(height: AppSpacing.lg),
            SubmitButton(label: l10n.commonSave, busy: submitting, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
