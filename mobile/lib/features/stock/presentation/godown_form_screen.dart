import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/inline_message.dart';
import '../../../core/widgets/submit_state.dart';
import '../data/stock_repository.dart';
import '../domain/stock_models.dart';

/// Adds a godown, or edits one. A godown is closed (never deleted), and only
/// once its stock has moved out (the server checks).
class GodownFormScreen extends ConsumerStatefulWidget {
  const GodownFormScreen({super.key, this.godown});

  final Godown? godown;

  static Future<void> open(BuildContext context, {Godown? godown}) =>
      Navigator.of(context).push<void>(MaterialPageRoute(builder: (_) => GodownFormScreen(godown: godown)));

  @override
  ConsumerState<GodownFormScreen> createState() => _GodownFormScreenState();
}

class _GodownFormScreenState extends ConsumerState<GodownFormScreen> with SubmitState {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.godown?.name);
  late final _address = TextEditingController(text: widget.godown?.address);
  late var _active = widget.godown?.isActive ?? true;

  bool get _editing => widget.godown != null;

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    final repository = ref.read(stockRepositoryProvider);
    final saved = await runSubmit(
      () => _editing
          ? repository.updateGodown(widget.godown!.id, {
              'name': _name.text.trim(),
              'address': textOrNull(_address),
              'isActive': _active,
            })
          : repository.createGodown(name: _name.text.trim(), address: textOrNull(_address)),
    );
    if (saved == null || !mounted) return;
    ref.bump(DataSet.stock);
    showSnack(context, l10n.godownSaved);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const gap = SizedBox(height: AppSpacing.md);
    return Scaffold(
      appBar: AppBar(title: Text(_editing ? l10n.godownEdit : l10n.godownNew)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            TextFormField(
              controller: _name,
              decoration: InputDecoration(labelText: l10n.godownName, hintText: l10n.godownNameHint),
              textCapitalization: TextCapitalization.words,
              maxLength: 80,
              validator: (value) => (value?.trim().length ?? 0) < 2 ? l10n.validationRequired : null,
            ),
            TextFormField(
              controller: _address,
              decoration: InputDecoration(labelText: l10n.godownAddress),
              textCapitalization: TextCapitalization.sentences,
              minLines: 1,
              maxLines: 3,
              maxLength: 300,
            ),
            if (_editing)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.godownActive),
                subtitle: Text(l10n.godownActiveHelper),
                value: _active,
                onChanged: (value) => setState(() => _active = value),
              ),
            if (submitError case final error?) ...[gap, InlineMessage(message: error)],
            const SizedBox(height: AppSpacing.lg),
            SubmitButton(label: l10n.commonSave, busy: submitting, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
