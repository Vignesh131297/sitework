import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/models/enums.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/routing/area.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/info_widgets.dart';
import '../../../core/widgets/inline_message.dart';
import '../../../core/widgets/submit_state.dart';
import '../../auth/domain/user_role.dart';
import '../../auth/presentation/session_controller.dart';
import '../data/material_requests_repository.dart';
import '../domain/stock_models.dart';
import 'approve_request_screen.dart';
import 'close_request_screen.dart';
import 'request_widgets.dart';
import 'stock_entry_screen.dart';
import 'stock_widgets.dart';

/// One material request: what was asked and approved, how much has been sent
/// and has arrived, the deliveries and returns, and what the user can do now.
class RequestDetailScreen extends ConsumerWidget {
  const RequestDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final request = ref.watch(materialRequestProvider(id));
    return Scaffold(
      appBar: AppBar(title: Text(request.value?.code ?? l10n.requestTitle)),
      body: AsyncValueView(
        value: request,
        onRetry: () => ref.invalidate(materialRequestProvider(id)),
        data: (request) => RefreshIndicator(
          onRefresh: () => ref.refresh(materialRequestProvider(id).future),
          child: _RequestBody(request: request),
        ),
      ),
    );
  }
}

class _RequestBody extends ConsumerStatefulWidget {
  const _RequestBody({required this.request});

  final MaterialRequest request;

  @override
  ConsumerState<_RequestBody> createState() => _RequestBodyState();
}

class _RequestBodyState extends ConsumerState<_RequestBody> {
  var _busy = false;

  Future<void> _run(Future<MaterialRequest> Function() change, String done) async {
    setState(() => _busy = true);
    try {
      await change();
      ref
        ..bump(DataSet.stock)
        ..bump(DataSet.notifications);
      if (mounted) showSnack(context, done);
    } on AppException catch (error) {
      if (mounted) showErrorSnack(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _reject() async {
    final l10n = AppLocalizations.of(context);
    final reason = await showDialog<String>(context: context, builder: (_) => const _RejectDialog());
    if (reason == null || !mounted) return;
    await _run(
      () => ref.read(materialRequestsRepositoryProvider).reject(widget.request.id, reason),
      l10n.requestRejected(widget.request.code),
    );
  }

  Future<void> _withdraw() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.requestWithdrawTitle(widget.request.code),
      message: l10n.requestWithdrawBody,
      confirmLabel: l10n.requestWithdraw,
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    await _run(
      () => ref.read(materialRequestsRepositoryProvider).cancel(widget.request.id),
      l10n.requestWithdrawn(widget.request.code),
    );
  }

  /// The godown's manager (or an admin) sends what is left to send.
  void _send() {
    final r = widget.request;
    final godown = r.godown!;
    StockEntryScreen.open(
      context,
      action: StockAction.send,
      from: (place: StockPlace.godown, id: godown.id, name: godown.name),
      to: (place: StockPlace.site, id: r.site.id, name: r.site.name),
      request: r,
      prefill: [
        for (final line in r.lines)
          if (line.hasLeftToSend) (materialId: line.material.id, quantity: line.leftToSend!, rate: null),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final area = ref.watch(areaPathProvider);
    final role = ref.watch(sessionProvider).value?.role;
    final r = widget.request;
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final siteLink = role == UserRole.admin || role == UserRole.engineer;
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxl),
      children: [
        if (_busy) const LinearProgressIndicator(),
        Row(
          children: [
            Expanded(
              child: Text(r.site.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            ),
            requestChip(r, l10n),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(l10n.requestAskedBy(r.requestedBy.name, formatDateTime(r.createdAt)), style: muted),
        if (r.neededBy case final date?) Text(l10n.requestNeededBy(formatDate(date))),
        if (r.note case final note?) ...[const SizedBox(height: AppSpacing.xs), Text(note)],
        if (siteLink)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => context.push(AppRoutes.site(area, r.site.id, tab: 'stock')),
              icon: const Icon(Icons.apartment_outlined),
              label: Text(l10n.requestSiteStock),
            ),
          ),
        if (r.status == MaterialRequestStatus.rejected) ...[
          const SizedBox(height: AppSpacing.sm),
          InlineMessage(
            message: l10n.requestRejectedBecause(r.reviewedBy?.name ?? '', r.reviewNote ?? ''),
            tone: StatusTone.danger,
          ),
        ],
        if (r.godown case final godown?) ...[
          const SizedBox(height: AppSpacing.sm),
          InlineMessage(
            message: [l10n.requestApprovedFrom(r.reviewedBy?.name ?? '', godown.name), ?r.reviewNote].join('\n'),
            tone: StatusTone.info,
          ),
        ],
        if (r.status == MaterialRequestStatus.closed) ...[
          const SizedBox(height: AppSpacing.sm),
          InlineMessage(
            message: [
              r.outcome == MaterialRequestOutcome.leftoverReturned
                  ? l10n.requestClosedLeftover(r.closedBy?.name ?? '')
                  : l10n.requestClosedAllUsed(r.closedBy?.name ?? ''),
              ?r.closeNote,
            ].join('\n'),
            tone: StatusTone.neutral,
          ),
        ],
        SectionHeader(l10n.stockMaterials),
        for (final line in r.lines) _LineTile(line: line, approved: r.godown != null),
        if (r.canApprove || r.canSend || r.canClose || r.canCancel) const SizedBox(height: AppSpacing.lg),
        if (r.canApprove)
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _busy ? null : () => ApproveRequestScreen.open(context, r),
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
        if (r.canSend)
          FilledButton.icon(
            onPressed: _busy ? null : _send,
            icon: const Icon(Icons.local_shipping_outlined),
            label: Text(l10n.requestSendNow),
          ),
        if (r.canClose) ...[
          if (r.canSend) const SizedBox(height: AppSpacing.sm),
          FilledButton.tonalIcon(
            onPressed: _busy ? null : () => CloseRequestScreen.open(context, r),
            icon: const Icon(Icons.task_alt),
            label: Text(l10n.requestClose),
          ),
        ],
        if (r.status == MaterialRequestStatus.approved &&
            !r.canClose &&
            r.anythingOnTheWay &&
            role != UserRole.godownManager)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Text(l10n.requestConfirmFirst, style: muted),
          ),
        if (r.canCancel)
          Align(
            child: TextButton(onPressed: _busy ? null : _withdraw, child: Text(l10n.requestWithdraw)),
          ),
        // Staff don't open stock entries (their own requests show what arrived above).
        if (r.entries.isNotEmpty && role != UserRole.staff) ...[
          SectionHeader(l10n.requestDeliveries),
          for (final e in r.entries)
            EntryTile(
              entry: e,
              action: e.canReceive ? ConfirmReceiptButton(entry: e) : null,
            ),
        ],
      ],
    );
  }
}

/// Asked, approved, sent, arrived and still to send of one material.
class _LineTile extends StatelessWidget {
  const _LineTile({required this.line, required this.approved});

  final MaterialRequestLine line;
  final bool approved;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final unit = line.material.unit;
    String q(String value) => formatQuantity(value, unit);
    final notSupplied = line.approvedQuantity != null && num.parse(line.approvedQuantity!) == 0;
    return Card(
      child: ListTile(
        title: Text(line.material.name),
        subtitle: Text(
          [
            l10n.requestAsked(q(line.quantity)),
            if (approved && notSupplied) l10n.requestNotSupplied,
            if (approved && !notSupplied) ...[
              l10n.requestSentAmount(q(line.sent)),
              if (num.parse(line.onTheWay) > 0) l10n.requestOnTheWayAmount(q(line.onTheWay)),
              if (num.parse(line.received) > 0) l10n.requestArrivedAmount(q(line.received)),
              if (line.hasLeftToSend) l10n.requestLeftAmount(q(line.leftToSend!)),
            ],
          ].join(' · '),
        ),
        trailing: Text(
          q(line.approvedQuantity ?? line.quantity),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: notSupplied ? theme.colorScheme.onSurfaceVariant : null,
          ),
        ),
      ),
    );
  }
}

class _RejectDialog extends StatefulWidget {
  const _RejectDialog();

  @override
  State<_RejectDialog> createState() => _RejectDialogState();
}

class _RejectDialogState extends State<_RejectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reason = TextEditingController();

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text(l10n.requestRejectTitle),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _reason,
          autofocus: true,
          maxLength: 300,
          minLines: 1,
          maxLines: 3,
          decoration: InputDecoration(labelText: l10n.requestRejectReason),
          validator: (value) => (value?.trim().length ?? 0) < 3 ? l10n.validationRequired : null,
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.commonCancel)),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: scheme.error, foregroundColor: scheme.onError),
          onPressed: () {
            if (_formKey.currentState!.validate()) Navigator.of(context).pop(_reason.text.trim());
          },
          child: Text(l10n.requestReject),
        ),
      ],
    );
  }
}
