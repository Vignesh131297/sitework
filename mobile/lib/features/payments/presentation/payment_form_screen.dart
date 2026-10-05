import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/enums.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/form_fields.dart';
import '../../../core/widgets/inline_message.dart';
import '../../../core/widgets/submit_state.dart';
import '../data/payments_repository.dart';

/// Records money received for a site. The server refuses anything above what
/// is left on the contract.
class PaymentFormScreen extends ConsumerStatefulWidget {
  const PaymentFormScreen({super.key, required this.siteId, required this.siteName});

  final String siteId;
  final String siteName;

  static Future<void> open(BuildContext context, {required String siteId, required String siteName}) =>
      Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => PaymentFormScreen(siteId: siteId, siteName: siteName),
        ),
      );

  @override
  ConsumerState<PaymentFormScreen> createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends ConsumerState<PaymentFormScreen> with SubmitState {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _reference = TextEditingController();
  final _remarks = TextEditingController();
  var _paidOn = isoDate(DateTime.now());
  var _method = PaymentMethod.upi;

  @override
  void dispose() {
    for (final controller in [_amount, _reference, _remarks]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    final saved = await runSubmit(
      () => ref
          .read(paymentsRepositoryProvider)
          .record(
            widget.siteId,
            amount: _amount.text.trim(),
            paidOn: _paidOn,
            method: _method,
            reference: textOrNull(_reference),
            remarks: textOrNull(_remarks),
          ),
    );
    if (saved == null || !mounted) return;
    ref
      ..bump(DataSet.payments)
      ..bump(DataSet.sites);
    showSnack(context, l10n.paymentRecorded);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const gap = SizedBox(height: AppSpacing.md);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.paymentsRecord)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(widget.siteName, style: Theme.of(context).textTheme.titleMedium),
            gap,
            AmountField(
              controller: _amount,
              label: l10n.fieldAmount,
              validator: (value) => value == null || !isAmount(value) ? l10n.validationAmount : null,
            ),
            gap,
            DateField(
              label: l10n.fieldPaidOn,
              initialValue: _paidOn,
              lastDate: DateTime.now(),
              onChanged: (value) => _paidOn = value ?? _paidOn,
            ),
            gap,
            DropdownButtonFormField<PaymentMethod>(
              isExpanded: true,
              initialValue: _method,
              decoration: InputDecoration(labelText: l10n.fieldMethod),
              items: [
                for (final method in PaymentMethod.values)
                  DropdownMenuItem(value: method, child: Text(method.label(l10n))),
              ],
              onChanged: (value) => setState(() => _method = value ?? _method),
            ),
            gap,
            TextFormField(
              controller: _reference,
              decoration: InputDecoration(labelText: l10n.fieldReference),
              maxLength: 80,
            ),
            TextFormField(
              controller: _remarks,
              decoration: InputDecoration(labelText: l10n.fieldRemarks),
              minLines: 2,
              maxLines: 4,
              maxLength: 500,
            ),
            if (submitError != null) ...[const SizedBox(height: AppSpacing.md), InlineMessage(message: submitError!)],
            const SizedBox(height: AppSpacing.lg),
            SubmitButton(label: l10n.paymentsRecord, busy: submitting, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
