import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/enums.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/attachment_strip.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/submit_state.dart';
import '../../auth/domain/user_role.dart';
import '../../auth/presentation/session_controller.dart';
import '../data/issues_repository.dart';
import '../domain/issue_models.dart';

/// One issue, with the next step for it: start work, resolve, or (admins) reopen.
class IssueDetailScreen extends ConsumerStatefulWidget {
  const IssueDetailScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<IssueDetailScreen> createState() => _IssueDetailScreenState();
}

class _IssueDetailScreenState extends ConsumerState<IssueDetailScreen> {
  var _busy = false;

  Future<void> _change({required IssueStatus status, String? note}) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await ref.read(issuesRepositoryProvider).update(widget.id, status: status, resolutionNote: note);
      ref.bump(DataSet.issues);
      if (mounted) showSnack(context, l10n.issueUpdatedDone);
    } on AppException catch (error) {
      if (mounted) showErrorSnack(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resolve() async {
    final note = await showDialog<String>(context: context, builder: (_) => const _ResolveDialog());
    if (note != null) await _change(status: IssueStatus.resolved, note: note);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAdmin = ref.watch(sessionProvider).value?.role == UserRole.admin;
    final value = ref.watch(issueProvider(widget.id));
    return Scaffold(
      appBar: AppBar(
        title: Text(value.value?.title ?? ''),
        bottom: _busy ? const PreferredSize(preferredSize: Size.fromHeight(4), child: LinearProgressIndicator()) : null,
      ),
      body: AsyncValueView(
        value: value,
        onRetry: () => ref.invalidate(issueProvider(widget.id)),
        data: (issue) => ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _IssueBody(issue: issue),
            const SizedBox(height: AppSpacing.xl),
            ...switch (issue.status) {
              IssueStatus.open => [
                FilledButton.icon(
                  onPressed: _busy ? null : () => _change(status: IssueStatus.inProgress),
                  icon: const Icon(Icons.construction),
                  label: Text(l10n.issueStartWork),
                ),
                const SizedBox(height: AppSpacing.sm),
                OutlinedButton.icon(
                  onPressed: _busy ? null : _resolve,
                  icon: const Icon(Icons.task_alt),
                  label: Text(l10n.issueResolve),
                ),
              ],
              IssueStatus.inProgress => [
                FilledButton.icon(
                  onPressed: _busy ? null : _resolve,
                  icon: const Icon(Icons.task_alt),
                  label: Text(l10n.issueResolve),
                ),
              ],
              IssueStatus.resolved => [
                if (isAdmin)
                  OutlinedButton.icon(
                    onPressed: _busy ? null : () => _change(status: IssueStatus.open),
                    icon: const Icon(Icons.replay),
                    label: Text(l10n.issueReopen),
                  ),
              ],
            },
          ],
        ),
      ),
    );
  }
}

class _IssueBody extends StatelessWidget {
  const _IssueBody({required this.issue});

  final Issue issue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final i = issue;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            StatusChip(label: i.status.label(l10n), tone: i.status.tone),
            StatusChip(label: i.priority.label(l10n), tone: i.priority.tone),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(i.title, style: theme.textTheme.titleLarge),
        Text(i.site.name, style: muted),
        const SizedBox(height: AppSpacing.md),
        Text(i.description, style: theme.textTheme.bodyLarge),
        const SizedBox(height: AppSpacing.md),
        Text(l10n.issueReportedBy(i.reportedBy.name, formatDateTime(i.createdAt)), style: muted),
        if (i.attachments.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          AttachmentStrip(attachments: i.attachments),
        ],
        if (i.resolvedAt != null) ...[
          const SizedBox(height: AppSpacing.lg),
          Card(
            child: ListTile(
              leading: const Icon(Icons.task_alt),
              title: Text(i.resolutionNote ?? ''),
              subtitle: Text(l10n.issueResolvedBy(i.resolvedBy?.name ?? '', formatDateTime(i.resolvedAt!))),
            ),
          ),
        ],
      ],
    );
  }
}

class _ResolveDialog extends StatefulWidget {
  const _ResolveDialog();

  @override
  State<_ResolveDialog> createState() => _ResolveDialogState();
}

class _ResolveDialogState extends State<_ResolveDialog> {
  final _formKey = GlobalKey<FormState>();
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.issueResolveTitle),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _note,
          autofocus: true,
          minLines: 2,
          maxLines: 5,
          maxLength: 1000,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(labelText: l10n.issueResolutionLabel),
          validator: (value) => (value?.trim().length ?? 0) < 3 ? l10n.captureDescriptionTooShort : null,
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.commonCancel)),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) Navigator.of(context).pop(_note.text.trim());
          },
          child: Text(l10n.issueResolve),
        ),
      ],
    );
  }
}
