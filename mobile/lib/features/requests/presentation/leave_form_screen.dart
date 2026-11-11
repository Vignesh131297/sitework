import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:uuid/uuid.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/enums.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/routing/area.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/time/server_clock.dart';
import '../../../core/widgets/form_fields.dart';
import '../../../core/widgets/inline_message.dart';
import '../../../core/widgets/submit_state.dart';
import '../data/requests_repository.dart';

/// Leave can be entered up to this many days after it started (the server's rule).
const _backdateDays = 30;

/// Ask for leave: the kind, the first and last day, and why. Staff leave goes
/// to their engineer and admins; an engineer's to admins.
class LeaveFormScreen extends ConsumerStatefulWidget {
  const LeaveFormScreen({super.key});

  @override
  ConsumerState<LeaveFormScreen> createState() => _LeaveFormScreenState();
}

class _LeaveFormScreenState extends ConsumerState<LeaveFormScreen> with SubmitState {
  final _formKey = GlobalKey<FormState>();

  /// Made once per form, so a retry after a dropped connection asks only once.
  final _requestId = const Uuid().v4();
  final _reason = TextEditingController();
  var _type = LeaveType.casual;
  String? _from;
  String? _to;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    final area = ref.read(areaPathProvider);
    final created = await runSubmit(
      () => ref
          .read(requestsRepositoryProvider)
          .askLeave(requestId: _requestId, type: _type, fromDate: _from!, toDate: _to!, reason: _reason.text.trim()),
    );
    if (created == null || !mounted) return;
    ref
      ..bump(DataSet.requests)
      ..bump(DataSet.notifications);
    showSnack(context, l10n.requestSentForApproval(created.code));
    context.pushReplacement(AppRoutes.leave(area, created.id));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const gap = SizedBox(height: AppSpacing.md);
    final today = ref.read(serverClockProvider.notifier).now();
    final earliest = today.subtract(const Duration(days: _backdateDays));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.leaveNewTitle)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(l10n.leaveType, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            SegmentedButton<LeaveType>(
              // Without the tick, three choices fit a small phone.
              showSelectedIcon: false,
              segments: [
                for (final type in LeaveType.values) ButtonSegment(value: type, label: Text(type.label(l10n))),
              ],
              selected: {_type},
              onSelectionChanged: (selection) => setState(() => _type = selection.first),
            ),
            gap,
            DateField(
              label: l10n.leaveFrom,
              initialValue: _from,
              firstDate: earliest,
              validator: (value) => value == null ? l10n.validationRequired : null,
              onChanged: (value) => setState(() => _from = value),
            ),
            gap,
            DateField(
              label: l10n.leaveTo,
              initialValue: _to,
              firstDate: earliest,
              validator: (value) {
                if (value == null) return l10n.validationRequired;
                if (_from != null && value.compareTo(_from!) < 0) return l10n.leaveToBeforeFrom;
                return null;
              },
              onChanged: (value) => setState(() => _to = value),
            ),
            gap,
            TextFormField(
              controller: _reason,
              decoration: InputDecoration(labelText: l10n.leaveReason),
              minLines: 1,
              maxLines: 4,
              maxLength: 500,
              validator: (value) => (value?.trim().length ?? 0) < 3 ? l10n.validationRequired : null,
            ),
            if (submitError case final error?) ...[gap, InlineMessage(message: error)],
            const SizedBox(height: AppSpacing.lg),
            SubmitButton(label: l10n.requestSendForApproval, busy: submitting, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
