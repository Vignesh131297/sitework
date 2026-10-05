import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/enums.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/inline_message.dart';
import '../../../core/widgets/photo_picker_field.dart';
import '../../../core/widgets/priority_picker.dart';
import '../../../core/widgets/submit_state.dart';
import '../../sites/data/sites_repository.dart';
import '../data/engineer_updates_repository.dart';

/// An engineer's report to the admin, with optional photos.
class EngineerUpdateFormScreen extends ConsumerStatefulWidget {
  const EngineerUpdateFormScreen({super.key, this.siteId});

  /// Preselected site (when opened from a site's page).
  final String? siteId;

  @override
  ConsumerState<EngineerUpdateFormScreen> createState() => _EngineerUpdateFormScreenState();
}

class _EngineerUpdateFormScreenState extends ConsumerState<EngineerUpdateFormScreen> with SubmitState {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  late String? _siteId = widget.siteId;
  var _type = EngineerUpdateType.progress;
  var _priority = Priority.medium;
  int? _progress;
  var _photos = <String>[];

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    final sent = await runSubmit(
      () => ref
          .read(engineerUpdatesRepositoryProvider)
          .create(
            siteId: _siteId!,
            type: _type,
            priority: _priority,
            title: textOrNull(_title),
            description: _description.text.trim(),
            progressPercent: _type == EngineerUpdateType.progress ? _progress : null,
            photoPaths: _photos,
          ),
    );
    if (sent == null || !mounted) return;
    ref
      ..bump(DataSet.engineerUpdates)
      ..bump(DataSet.sites);
    showSnack(context, l10n.engineerUpdateSent);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const gap = SizedBox(height: AppSpacing.md);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.engineerUpdateNew)),
      body: AsyncValueView(
        value: ref.watch(sitePickerProvider),
        onRetry: () => ref.invalidate(sitePickerProvider),
        data: (sites) {
          final site = sites.where((s) => s.id == _siteId).firstOrNull;
          _progress ??= site?.progressPercent;
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                DropdownButtonFormField<String>(
                  initialValue: site?.id,
                  isExpanded: true,
                  decoration: InputDecoration(labelText: l10n.fieldSite),
                  items: [for (final s in sites) DropdownMenuItem(value: s.id, child: Text(s.name))],
                  validator: (value) => value == null ? l10n.validationRequired : null,
                  onChanged: (value) => setState(() {
                    _siteId = value;
                    _progress = sites.where((s) => s.id == value).firstOrNull?.progressPercent;
                  }),
                ),
                gap,
                DropdownButtonFormField<EngineerUpdateType>(
                  isExpanded: true,
                  initialValue: _type,
                  decoration: InputDecoration(labelText: l10n.fieldType),
                  items: [
                    for (final type in EngineerUpdateType.values)
                      DropdownMenuItem(value: type, child: Text(type.label(l10n))),
                  ],
                  onChanged: (value) => setState(() => _type = value ?? _type),
                ),
                gap,
                PriorityPicker(
                  value: _priority,
                  onChanged: submitting ? null : (value) => setState(() => _priority = value),
                ),
                gap,
                TextFormField(
                  controller: _title,
                  decoration: InputDecoration(labelText: l10n.fieldTitleOptional),
                  textCapitalization: TextCapitalization.sentences,
                  maxLength: 120,
                ),
                TextFormField(
                  controller: _description,
                  decoration: InputDecoration(labelText: l10n.fieldDescription, alignLabelWithHint: true),
                  textCapitalization: TextCapitalization.sentences,
                  minLines: 4,
                  maxLines: 10,
                  maxLength: 2000,
                  validator: (value) => (value?.trim().length ?? 0) < 3 ? l10n.captureDescriptionTooShort : null,
                ),
                if (_type == EngineerUpdateType.progress && _siteId != null) ...[
                  Text(l10n.fieldProgressValue(_progress ?? 0)),
                  Slider(
                    value: (_progress ?? 0).toDouble(),
                    max: 100,
                    divisions: 20,
                    label: '${_progress ?? 0}%',
                    onChanged: submitting ? null : (value) => setState(() => _progress = value.round()),
                  ),
                ],
                gap,
                PhotoPickerField(
                  paths: _photos,
                  enabled: !submitting,
                  onChanged: (paths) => setState(() => _photos = paths),
                ),
                if (submitError != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  InlineMessage(message: submitError!),
                ],
                const SizedBox(height: AppSpacing.xl),
                SubmitButton(label: l10n.commonSend, busy: submitting, onPressed: _send),
              ],
            ),
          );
        },
      ),
    );
  }
}
