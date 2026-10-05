import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/form_fields.dart';
import '../../../core/widgets/inline_message.dart';
import '../../../core/widgets/submit_state.dart';
import '../../sites/domain/site_models.dart';
import '../data/payments_repository.dart';

/// Add a payment milestone to a site, or edit/delete [milestone].
Future<void> showMilestoneSheet(BuildContext context, {required String siteId, MilestoneView? milestone}) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => _MilestoneSheet(siteId: siteId, milestone: milestone),
    );

class _MilestoneSheet extends ConsumerStatefulWidget {
  const _MilestoneSheet({required this.siteId, this.milestone});

  final String siteId;
  final MilestoneView? milestone;

  @override
  ConsumerState<_MilestoneSheet> createState() => _MilestoneSheetState();
}

class _MilestoneSheetState extends ConsumerState<_MilestoneSheet> with SubmitState {
  final _formKey = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.milestone?.title);
  late final _amount = TextEditingController(text: widget.milestone?.amount.replaceFirst(RegExp(r'\.00$'), ''));
  late String? _dueDate = widget.milestone?.dueDate;

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    super.dispose();
  }

  void _done(String message) {
    ref
      ..bump(DataSet.payments)
      ..bump(DataSet.sites);
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    final repository = ref.read(paymentsRepositoryProvider);
    final existing = widget.milestone;
    final saved = await runSubmit(
      () => existing == null
          ? repository.addMilestone(
              widget.siteId,
              title: _title.text.trim(),
              amount: _amount.text.trim(),
              dueDate: _dueDate!,
            )
          : repository.updateMilestone(
              existing.id,
              title: _title.text.trim(),
              amount: _amount.text.trim(),
              dueDate: _dueDate,
            ),
    );
    if (saved != null && mounted) _done(l10n.milestoneSaved);
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.milestoneDeleteTitle,
      message: l10n.milestoneDeleteBody,
      confirmLabel: l10n.milestoneDelete,
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    try {
      await ref.read(paymentsRepositoryProvider).deleteMilestone(widget.milestone!.id);
      if (mounted) _done(l10n.milestoneDeleted);
    } on AppException catch (error) {
      if (mounted) showErrorSnack(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.milestone == null ? l10n.milestoneAdd : l10n.milestoneEdit,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _title,
                decoration: InputDecoration(labelText: l10n.fieldTitle),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) => (value?.trim().length ?? 0) < 2 ? l10n.validationRequired : null,
              ),
              const SizedBox(height: AppSpacing.md),
              AmountField(
                controller: _amount,
                label: l10n.fieldAmount,
                validator: (value) => value == null || !isAmount(value) ? l10n.validationAmount : null,
              ),
              const SizedBox(height: AppSpacing.md),
              DateField(
                label: l10n.fieldDueDate,
                initialValue: _dueDate,
                validator: (value) => value == null ? l10n.validationRequired : null,
                onChanged: (value) => _dueDate = value,
              ),
              if (submitError != null) ...[const SizedBox(height: AppSpacing.md), InlineMessage(message: submitError!)],
              const SizedBox(height: AppSpacing.lg),
              SubmitButton(label: l10n.commonSave, busy: submitting, onPressed: _save),
              if (widget.milestone != null)
                TextButton(
                  onPressed: submitting ? null : _delete,
                  style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
                  child: Text(l10n.milestoneDelete),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
