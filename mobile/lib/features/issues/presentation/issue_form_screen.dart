import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/models/enums.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/routing/area.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/inline_message.dart';
import '../../../core/widgets/photo_picker_field.dart';
import '../../../core/widgets/priority_picker.dart';
import '../../../core/widgets/submit_state.dart';
import '../../sites/data/sites_repository.dart';
import '../data/issues_repository.dart';

/// Report a problem on a site, with optional photos.
class IssueFormScreen extends ConsumerStatefulWidget {
  const IssueFormScreen({super.key, this.siteId});

  final String? siteId;

  @override
  ConsumerState<IssueFormScreen> createState() => _IssueFormScreenState();
}

class _IssueFormScreenState extends ConsumerState<IssueFormScreen> with SubmitState {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  late String? _siteId = widget.siteId;
  var _priority = Priority.medium;
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
    final issue = await runSubmit(
      () => ref
          .read(issuesRepositoryProvider)
          .create(
            siteId: _siteId!,
            title: _title.text.trim(),
            description: _description.text.trim(),
            priority: _priority,
            photoPaths: _photos,
          ),
    );
    if (issue == null || !mounted) return;
    ref.bump(DataSet.issues);
    showSnack(context, l10n.issueReportedDone);
    context.pushReplacement(AppRoutes.issue(ref.read(areaPathProvider), issue.id));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const gap = SizedBox(height: AppSpacing.md);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.issueNew)),
      body: AsyncValueView(
        value: ref.watch(sitePickerProvider),
        onRetry: () => ref.invalidate(sitePickerProvider),
        data: (sites) => Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              DropdownButtonFormField<String>(
                initialValue: sites.any((s) => s.id == _siteId) ? _siteId : null,
                isExpanded: true,
                decoration: InputDecoration(labelText: l10n.fieldSite),
                items: [for (final s in sites) DropdownMenuItem(value: s.id, child: Text(s.name))],
                validator: (value) => value == null ? l10n.validationRequired : null,
                onChanged: (value) => setState(() => _siteId = value),
              ),
              gap,
              TextFormField(
                controller: _title,
                decoration: InputDecoration(labelText: l10n.fieldTitle),
                textCapitalization: TextCapitalization.sentences,
                maxLength: 120,
                validator: (value) => (value?.trim().length ?? 0) < 3 ? l10n.validationRequired : null,
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
              PriorityPicker(
                value: _priority,
                onChanged: submitting ? null : (value) => setState(() => _priority = value),
              ),
              const SizedBox(height: AppSpacing.lg),
              PhotoPickerField(
                paths: _photos,
                enabled: !submitting,
                onChanged: (paths) => setState(() => _photos = paths),
              ),
              if (submitError != null) ...[const SizedBox(height: AppSpacing.lg), InlineMessage(message: submitError!)],
              const SizedBox(height: AppSpacing.xl),
              SubmitButton(label: l10n.issueNew, busy: submitting, onPressed: _send),
            ],
          ),
        ),
      ),
    );
  }
}
