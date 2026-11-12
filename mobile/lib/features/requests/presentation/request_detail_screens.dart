import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/enums.dart';
import '../../../core/models/refs.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/info_widgets.dart';
import '../../../core/widgets/inline_message.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/submit_state.dart';
import '../data/requests_repository.dart';
import '../domain/request_models.dart';
import 'request_widgets.dart';

/// One leave request: who, when, why, the decision, and what the user can do now.
class LeaveDetailScreen extends ConsumerWidget {
  const LeaveDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final leave = ref.watch(leaveRequestProvider(id));
    return Scaffold(
      appBar: AppBar(title: Text(leave.value?.code ?? l10n.leaveTitle)),
      body: AsyncValueView(
        value: leave,
        onRetry: () => ref.invalidate(leaveRequestProvider(id)),
        data: (leave) => RefreshIndicator(
          onRefresh: () => ref.refresh(leaveRequestProvider(id).future),
          child: _LeaveBody(leave: leave),
        ),
      ),
    );
  }
}

class _LeaveBody extends ConsumerWidget {
  const _LeaveBody({required this.leave});

  final LeaveRequest leave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final l = leave;
    final repository = ref.read(requestsRepositoryProvider);
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxl),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l.type.label(l10n),
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            StatusChip(label: l.status.label(l10n), tone: l.status.tone),
          ],
        ),
        DetailRow(icon: Icons.person_outline, label: l10n.requestAskedByLabel, value: l.user.name),
        if (l.site case final site?) DetailRow(icon: Icons.apartment_outlined, label: l10n.fieldSite, value: site.name),
        DetailRow(
          icon: Icons.event_outlined,
          label: l10n.leaveWhen,
          value: '${leaveDates(l)} · ${l10n.leaveDays(l.days)}',
        ),
        DetailRow(icon: Icons.notes_outlined, label: l10n.leaveReason, value: l.reason),
        DetailRow(icon: Icons.schedule_outlined, label: l10n.requestAskedOn, value: formatDateTime(l.createdAt)),
        RequestDecision(status: l.status, reviewedBy: l.reviewedBy, note: l.reviewNote),
        RequestActions(
          code: l.code,
          canApprove: l.canApprove,
          canCancel: l.canCancel,
          approve: (note) => repository.approveLeave(l.id, note: note),
          reject: (reason) => repository.rejectLeave(l.id, reason),
          cancel: () => repository.cancelLeave(l.id),
        ),
      ],
    );
  }
}

/// One money or food request: what, for whom, the decision, and what the user can do now.
class StaffRequestDetailScreen extends ConsumerWidget {
  const StaffRequestDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final request = ref.watch(staffRequestProvider(id));
    return Scaffold(
      appBar: AppBar(title: Text(request.value?.code ?? l10n.staffRequestTitle)),
      body: AsyncValueView(
        value: request,
        onRetry: () => ref.invalidate(staffRequestProvider(id)),
        data: (request) => RefreshIndicator(
          onRefresh: () => ref.refresh(staffRequestProvider(id).future),
          child: _StaffRequestBody(request: request),
        ),
      ),
    );
  }
}

class _StaffRequestBody extends ConsumerWidget {
  const _StaffRequestBody({required this.request});

  final StaffRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final r = request;
    final repository = ref.read(requestsRepositoryProvider);
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxl),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                staffRequestTitle(r, l10n),
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            StatusChip(label: r.status.label(l10n), tone: r.status.tone),
          ],
        ),
        DetailRow(icon: Icons.person_outline, label: l10n.requestAskedByLabel, value: r.staff.name),
        DetailRow(icon: Icons.apartment_outlined, label: l10n.fieldSite, value: r.site.name),
        if (r.note case final note?) DetailRow(icon: Icons.notes_outlined, label: l10n.fieldNotes, value: note),
        DetailRow(icon: Icons.schedule_outlined, label: l10n.requestAskedOn, value: formatDateTime(r.createdAt)),
        RequestDecision(status: r.status, reviewedBy: r.reviewedBy, note: r.reviewNote),
        RequestActions(
          code: r.code,
          canApprove: r.canApprove,
          canCancel: r.canCancel,
          approve: (note) => repository.approveStaffRequest(r.id, note: note),
          reject: (reason) => repository.rejectStaffRequest(r.id, reason),
          cancel: () => repository.cancelStaffRequest(r.id),
        ),
      ],
    );
  }
}

/// Who decided, and their note or reason. Shared with repair money requests.
class RequestDecision extends StatelessWidget {
  const RequestDecision({super.key, required this.status, required this.reviewedBy, required this.note});

  final ApprovalStatus status;
  final IdName? reviewedBy;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final by = reviewedBy?.name ?? '';
    final message = switch (status) {
      ApprovalStatus.approved => [l10n.approvalApprovedBy(by), ?note].join('\n'),
      ApprovalStatus.rejected => l10n.requestRejectedBecause(by, note ?? ''),
      ApprovalStatus.cancelled => l10n.approvalWithdrawnNote,
      ApprovalStatus.pending => null,
    };
    if (message == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: InlineMessage(message: message, tone: status.tone),
    );
  }
}

/// Approve and reject (for whoever may decide), or withdraw (for whoever asked).
/// Shared with repair money requests.
class RequestActions extends ConsumerStatefulWidget {
  const RequestActions({
    super.key,
    required this.code,
    required this.canApprove,
    required this.canCancel,
    required this.approve,
    required this.reject,
    required this.cancel,
  });

  final String code;
  final bool canApprove;
  final bool canCancel;
  final Future<Object?> Function(String? note) approve;
  final Future<Object?> Function(String reason) reject;
  final Future<Object?> Function() cancel;

  @override
  ConsumerState<RequestActions> createState() => _RequestActionsState();
}

class _RequestActionsState extends ConsumerState<RequestActions> {
  var _busy = false;

  Future<void> _run(Future<Object?> Function() change, String done) async {
    setState(() => _busy = true);
    try {
      await change();
      ref
        ..bump(DataSet.requests)
        ..bump(DataSet.attendance)
        ..bump(DataSet.vehicles)
        ..bump(DataSet.notifications);
      if (mounted) showSnack(context, done);
    } on AppException catch (error) {
      if (mounted) showErrorSnack(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _approve() async {
    final l10n = AppLocalizations.of(context);
    final note = await showApproveDialog(context, widget.code);
    if (note == null || !mounted) return;
    await _run(() => widget.approve(note.isEmpty ? null : note), l10n.approvalApprovedDone(widget.code));
  }

  Future<void> _reject() async {
    final l10n = AppLocalizations.of(context);
    final reason = await showRejectDialog(context, widget.code);
    if (reason == null || !mounted) return;
    await _run(() => widget.reject(reason), l10n.requestRejected(widget.code));
  }

  Future<void> _withdraw() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.requestWithdrawTitle(widget.code),
      message: l10n.approvalWithdrawBody,
      confirmLabel: l10n.requestWithdraw,
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    await _run(widget.cancel, l10n.requestWithdrawn(widget.code));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    if (!widget.canApprove && !widget.canCancel) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_busy) const LinearProgressIndicator(),
          if (widget.canApprove)
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _busy ? null : _approve,
                    icon: const Icon(Icons.check),
                    label: Text(l10n.requestApprove),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _busy ? null : _reject,
                    style: OutlinedButton.styleFrom(foregroundColor: theme.colorScheme.error),
                    icon: const Icon(Icons.close),
                    label: Text(l10n.requestReject),
                  ),
                ),
              ],
            ),
          if (widget.canCancel)
            Align(
              child: TextButton(onPressed: _busy ? null : _withdraw, child: Text(l10n.requestWithdraw)),
            ),
        ],
      ),
    );
  }
}
