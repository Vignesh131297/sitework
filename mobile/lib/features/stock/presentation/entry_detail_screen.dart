import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/enums.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/routing/area.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/attachment_strip.dart';
import '../../../core/widgets/info_widgets.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/submit_state.dart';
import '../../engineer_updates/domain/engineer_update_models.dart';
import '../data/stock_repository.dart';
import '../domain/stock_models.dart';
import 'receive_screen.dart';
import 'stock_widgets.dart';

/// One stock entry in full: every material, the photos (DC, bill, what
/// arrived), who did what, and confirm or cancel when the user may.
class EntryDetailScreen extends ConsumerWidget {
  const EntryDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final entry = ref.watch(stockEntryProvider(id));
    return Scaffold(
      appBar: AppBar(title: Text(entry.value?.kind.label(l10n) ?? l10n.stockEntryTitle)),
      body: AsyncValueView(
        value: entry,
        onRetry: () => ref.invalidate(stockEntryProvider(id)),
        data: (entry) => RefreshIndicator(
          onRefresh: () => ref.refresh(stockEntryProvider(id).future),
          child: _EntryBody(entry: entry),
        ),
      ),
    );
  }
}

class _EntryBody extends ConsumerStatefulWidget {
  const _EntryBody({required this.entry});

  final StockEntry entry;

  @override
  ConsumerState<_EntryBody> createState() => _EntryBodyState();
}

class _EntryBodyState extends ConsumerState<_EntryBody> {
  var _busy = false;

  Future<void> _cancel() async {
    final l10n = AppLocalizations.of(context);
    final reason = await showDialog<String>(context: context, builder: (_) => const _CancelDialog());
    if (reason == null || !mounted) return;
    setState(() => _busy = true);
    try {
      await ref.read(stockRepositoryProvider).cancel(widget.entry.id, reason);
      ref.bump(DataSet.stock);
      if (mounted) showSnack(context, l10n.stockCancelled);
    } on AppException catch (error) {
      if (mounted) showErrorSnack(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final e = widget.entry;
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final chip = entryChip(e, l10n);
    List<Attachment> photos(StockPhotoStage stage) => [
      for (final p in e.photos)
        if (p.stage == stage) Attachment(id: p.id, mime: p.mime, url: p.url, expiresAt: p.expiresAt),
    ];
    final sent = photos(StockPhotoStage.sent);
    final received = photos(StockPhotoStage.received);
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxl),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${placeName(e.from, l10n)} → ${placeName(e.to, l10n)}',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            ?chip,
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          [
            formatDate(e.movedOn),
            if (e.dcNumber case final dc?) l10n.stockDcNumberIs(dc),
            ?e.supplier,
            if (e.billNo case final bill?) l10n.stockBillNoIs(bill),
          ].join(' · '),
        ),
        if (e.note case final note?) ...[const SizedBox(height: AppSpacing.xs), Text(note)],
        Text('${l10n.stockRecordedBy(e.createdBy.name)} · ${formatDateTime(e.createdAt)}', style: muted),
        if (e.request case final request?)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => context.push(AppRoutes.request(ref.read(areaPathProvider), request.id)),
              icon: const Icon(Icons.assignment_outlined),
              label: Text(l10n.stockForRequest(request.code)),
            ),
          ),
        SectionHeader(l10n.stockMaterials),
        if (e.lines.isEmpty) Text(l10n.stockCountNoDifference),
        for (final line in e.lines) _LineTile(line: line, kind: e.kind),
        if (e.totalAmount case final total?)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: AmountTile(label: l10n.stockTotalAmount, amount: formatInr(total), tone: StatusTone.neutral),
          ),
        if (sent.isNotEmpty) ...[
          SectionHeader(e.kind == StockKind.purchase ? l10n.stockBillPhotos : l10n.stockDcPhotos),
          AttachmentStrip(attachments: sent),
        ],
        if (e.receivedBy case final by?) ...[
          SectionHeader(l10n.stockReceivedTitle),
          Text([l10n.stockReceivedBy(by.name), if (e.receivedAt case final at?) formatDateTime(at)].join(' · ')),
          if (e.receiveNote case final note?) Text(note),
          if (received.isNotEmpty) ...[const SizedBox(height: AppSpacing.sm), AttachmentStrip(attachments: received)],
        ],
        if (e.isVoided) ...[
          const SizedBox(height: AppSpacing.lg),
          StatusChip(
            label: l10n.stockCancelledBy(e.voidedBy?.name ?? '', e.voidReason ?? ''),
            tone: StatusTone.neutral,
          ),
        ],
        if (e.canReceive) ...[
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: _busy ? null : () => ReceiveScreen.open(context, e),
            icon: const Icon(Icons.inventory_outlined),
            label: Text(l10n.stockConfirmReceived),
          ),
        ],
        if (e.canVoid) ...[
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: _busy ? null : _cancel,
            style: OutlinedButton.styleFrom(foregroundColor: theme.colorScheme.error),
            icon: const Icon(Icons.block),
            label: Text(l10n.stockCancel),
          ),
        ],
      ],
    );
  }
}

class _LineTile extends StatelessWidget {
  const _LineTile({required this.line, required this.kind});

  final StockLine line;
  final StockKind kind;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final unit = line.material.unit;
    final received = line.receivedQuantity;
    return Card(
      child: ListTile(
        title: Text(line.material.name),
        subtitle: Text(
          [
            if (kind == StockKind.transfer && received != null)
              l10n.stockReceivedOf(formatQuantity(received, unit), formatQuantity(line.quantity, unit)),
            if (line.rate case final rate?) l10n.stockAtRate(formatInr(rate), unit),
            if (line.amount case final amount?) formatInr(amount),
          ].join(' · '),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              formatQuantity(line.quantity, unit),
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            if (line.shortQuantity case final short?)
              StatusChip(label: l10n.stockShortChip(formatQuantity(short, unit)), tone: StatusTone.danger),
          ],
        ),
      ),
    );
  }
}

class _CancelDialog extends StatefulWidget {
  const _CancelDialog();

  @override
  State<_CancelDialog> createState() => _CancelDialogState();
}

class _CancelDialogState extends State<_CancelDialog> {
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
      title: Text(l10n.stockCancelTitle),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.stockCancelBody),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _reason,
              autofocus: true,
              maxLength: 300,
              decoration: InputDecoration(labelText: l10n.stockCancelReason),
              validator: (value) => (value?.trim().length ?? 0) < 3 ? l10n.validationRequired : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.commonCancel)),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: scheme.error, foregroundColor: scheme.onError),
          onPressed: () {
            if (_formKey.currentState!.validate()) Navigator.of(context).pop(_reason.text.trim());
          },
          child: Text(l10n.stockCancel),
        ),
      ],
    );
  }
}
