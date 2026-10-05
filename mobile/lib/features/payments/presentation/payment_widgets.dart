import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/submit_state.dart';
import '../data/payments_repository.dart';
import '../domain/payment_models.dart';

/// A payment in a list: amount, how and when, and whether it was voided.
class PaymentTile extends StatelessWidget {
  const PaymentTile({super.key, required this.payment, this.showSite = true, this.onTap});

  final Payment payment;
  final bool showSite;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final p = payment;
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: context.tone(p.isVoided ? StatusTone.neutral : StatusTone.success).background,
          child: Icon(
            Icons.currency_rupee,
            color: context.tone(p.isVoided ? StatusTone.neutral : StatusTone.success).foreground,
          ),
        ),
        title: Text(
          formatInr(p.amount),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            decoration: p.isVoided ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          [
            [p.method.label(l10n), formatDate(p.paidOn), ?p.reference].join(' · '),
            if (showSite) '${p.site.name} · ${p.client.name}',
          ].join('\n'),
          style: muted,
        ),
        isThreeLine: showSite,
        trailing: p.isVoided ? StatusChip(label: l10n.paymentVoidChip, tone: StatusTone.neutral) : null,
      ),
    );
  }
}

/// Details of one payment, with the option to void it.
Future<void> showPaymentSheet(BuildContext context, Payment payment) => showModalBottomSheet<void>(
  context: context,
  showDragHandle: true,
  isScrollControlled: true,
  builder: (_) => _PaymentSheet(payment: payment),
);

class _PaymentSheet extends ConsumerStatefulWidget {
  const _PaymentSheet({required this.payment});

  final Payment payment;

  @override
  ConsumerState<_PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends ConsumerState<_PaymentSheet> {
  var _busy = false;

  Future<void> _void() async {
    final l10n = AppLocalizations.of(context);
    final reason = await showDialog<String>(context: context, builder: (_) => const _VoidDialog());
    if (reason == null || !mounted) return;
    setState(() => _busy = true);
    try {
      await ref.read(paymentsRepositoryProvider).voidPayment(widget.payment.id, reason);
      ref
        ..bump(DataSet.payments)
        ..bump(DataSet.sites);
      if (!mounted) return;
      Navigator.of(context).pop();
      showSnack(context, l10n.paymentVoided);
    } on AppException catch (error) {
      if (mounted) {
        setState(() => _busy = false);
        showErrorSnack(context, error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final p = widget.payment;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(formatInr(p.amount), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
            Text('${p.site.name} · ${p.client.name}'),
            const SizedBox(height: AppSpacing.md),
            Text([p.method.label(l10n), formatDate(p.paidOn), ?p.reference].join(' · ')),
            if (p.remarks != null) Text(p.remarks!),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${l10n.paymentRecordedBy(p.recordedBy.name)} · ${formatDateTime(p.createdAt)}',
              style: theme.textTheme.bodySmall,
            ),
            if (p.isVoided) ...[
              const SizedBox(height: AppSpacing.md),
              StatusChip(
                label: l10n.paymentVoidedBy(p.voidedBy?.name ?? '', p.voidReason ?? ''),
                tone: StatusTone.neutral,
              ),
            ] else ...[
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton.icon(
                onPressed: _busy ? null : _void,
                style: OutlinedButton.styleFrom(foregroundColor: theme.colorScheme.error),
                icon: const Icon(Icons.block),
                label: Text(l10n.paymentVoid),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _VoidDialog extends StatefulWidget {
  const _VoidDialog();

  @override
  State<_VoidDialog> createState() => _VoidDialogState();
}

class _VoidDialogState extends State<_VoidDialog> {
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
    return AlertDialog(
      title: Text(l10n.paymentVoidTitle),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.paymentVoidBody),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _reason,
              autofocus: true,
              maxLength: 300,
              decoration: InputDecoration(labelText: l10n.paymentVoidReason),
              validator: (value) => (value?.trim().length ?? 0) < 3 ? l10n.validationRequired : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.commonCancel)),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) Navigator.of(context).pop(_reason.text.trim());
          },
          child: Text(l10n.paymentVoid),
        ),
      ],
    );
  }
}
