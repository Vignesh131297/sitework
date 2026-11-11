import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/enums.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/routing/area.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/status_chip.dart';
import '../../auth/presentation/session_controller.dart';
import '../domain/request_models.dart';

/// "Mon 5 Oct" or "Mon 5 Oct – Wed 7 Oct".
String leaveDates(LeaveRequest leave) {
  final from = formatShortDate(DateTime.parse(leave.fromDate));
  return leave.fromDate == leave.toDate ? from : '$from – ${formatShortDate(DateTime.parse(leave.toDate))}';
}

/// "₹1,500 advance" or "Lunch on Mon 5 Oct".
String staffRequestTitle(StaffRequest request, AppLocalizations l10n) => switch (request.kind) {
  StaffRequestKind.money => l10n.moneyAdvance(formatInr(request.amount ?? '0')),
  StaffRequestKind.food => l10n.foodMealOn(
    request.meal?.label(l10n) ?? '',
    request.forDate == null ? '' : formatShortDate(DateTime.parse(request.forDate!)),
  ),
};

/// A leave request in a list. Shows who asked unless it is the caller's own.
class LeaveTile extends ConsumerWidget {
  const LeaveTile({super.key, required this.leave});

  final LeaveRequest leave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final area = ref.watch(areaPathProvider);
    final mine = ref.watch(sessionProvider).value?.userId == leave.user.id;
    final l = leave;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: () => context.push(AppRoutes.leave(area, l.id)),
        title: Text(
          mine ? l.type.label(l10n) : '${l.user.name} · ${l.type.label(l10n)}',
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${leaveDates(l)} · ${l10n.leaveDays(l.days)}'),
              Text(l.reason, maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(
                [l.code, ?l.site?.name].join(' · '),
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.xs),
              StatusChip(label: l.status.label(l10n), tone: l.status.tone),
            ],
          ),
        ),
      ),
    );
  }
}

/// A money or food request in a list. Shows who asked unless it is the caller's own.
class StaffRequestTile extends ConsumerWidget {
  const StaffRequestTile({super.key, required this.request});

  final StaffRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final area = ref.watch(areaPathProvider);
    final mine = ref.watch(sessionProvider).value?.userId == request.staff.id;
    final r = request;
    final title = staffRequestTitle(r, l10n);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: () => context.push(AppRoutes.staffRequest(area, r.id)),
        leading: Icon(r.kind == StaffRequestKind.money ? Icons.currency_rupee : Icons.restaurant_outlined),
        title: Text(
          mine ? title : '${r.staff.name} · $title',
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (r.note case final note?) Text(note, maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(
                [r.code, r.site.name, formatShortDate(r.createdAt.toLocal())].join(' · '),
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.xs),
              StatusChip(label: r.status.label(l10n), tone: r.status.tone),
            ],
          ),
        ),
      ),
    );
  }
}

/// Asks for an optional note before approving. Completes with the note ('' for
/// none), or null if cancelled.
Future<String?> showApproveDialog(BuildContext context, String code) =>
    showDialog<String>(context: context, builder: (_) => _NoteDialog(code: code, reject: false));

/// Asks why before rejecting. Completes with the reason, or null if cancelled.
Future<String?> showRejectDialog(BuildContext context, String code) =>
    showDialog<String>(context: context, builder: (_) => _NoteDialog(code: code, reject: true));

class _NoteDialog extends StatefulWidget {
  const _NoteDialog({required this.code, required this.reject});

  final String code;
  final bool reject;

  @override
  State<_NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<_NoteDialog> {
  final _formKey = GlobalKey<FormState>();
  final _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text(widget.reject ? l10n.approvalRejectTitle(widget.code) : l10n.approvalApproveTitle(widget.code)),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _text,
          autofocus: true,
          maxLength: 500,
          minLines: 1,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: widget.reject ? l10n.approvalRejectReason : l10n.fieldNoteOptional,
          ),
          validator: widget.reject
              ? (value) => (value?.trim().length ?? 0) < 3 ? l10n.validationRequired : null
              : null,
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.commonCancel)),
        FilledButton(
          style: widget.reject
              ? FilledButton.styleFrom(backgroundColor: scheme.error, foregroundColor: scheme.onError)
              : null,
          onPressed: () {
            if (_formKey.currentState!.validate()) Navigator.of(context).pop(_text.text.trim());
          },
          child: Text(widget.reject ? l10n.requestReject : l10n.requestApprove),
        ),
      ],
    );
  }
}
