import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/location/location_messages.dart';
import '../../../core/location/location_service.dart';
import '../../../core/models/enums.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/submit_state.dart';
import '../../staff_updates/domain/staff_update_models.dart';
import '../data/attendance_repository.dart';
import '../domain/attendance_models.dart';

/// Today's check-in and check-out for a staff member. The server records the
/// time; the phone only sends where it is (or why it can't tell).
class AttendanceCard extends ConsumerStatefulWidget {
  const AttendanceCard({super.key, required this.today});

  final StaffToday today;

  @override
  ConsumerState<AttendanceCard> createState() => _AttendanceCardState();
}

class _AttendanceCardState extends ConsumerState<AttendanceCard> {
  var _busy = false;
  var _locating = false;

  Future<Map<String, Object>> _location() async {
    final l10n = AppLocalizations.of(context);
    final service = ref.read(locationServiceProvider);
    setState(() => _locating = true);
    final result = await service.current(timeout: Duration(seconds: widget.today.rules.fixTimeoutSeconds));
    if (mounted) {
      setState(() => _locating = false);
      // Allowed but marked for review (decision 13); the user is told why.
      final problem = result.problem;
      if (problem != null) showLocationProblem(context, service, problem);
      if (result.fix?.isMocked ?? false) {
        showSnack(context, l10n.locationMocked);
      } else if (result.fix?.approximate ?? false) {
        showApproximateLocation(context, service);
      }
    }
    return result.toApiFields();
  }

  Future<void> _run(Future<AttendanceRecord> Function(Map<String, Object> location) action, String done) async {
    setState(() => _busy = true);
    try {
      await action(await _location());
      if (!mounted) return;
      ref.bump(DataSet.attendance);
      showSnack(context, done);
    } on AppException catch (error) {
      if (mounted) showErrorSnack(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _checkOut() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.checkOutConfirmTitle,
      message: l10n.checkOutConfirmBody,
      confirmLabel: l10n.checkOut,
    );
    if (confirmed && mounted) await _run(ref.read(attendanceRepositoryProvider).checkOut, l10n.checkOutDone);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final today = widget.today;
    final record = today.attendance;
    final canCheckIn = today.isWorkingDay && today.assignment != null && !today.checkedIn;

    final lines = <Widget>[];
    if (record?.checkInAt != null) {
      lines.add(Text(l10n.checkedInAt(formatTime(record!.checkInAt!)), style: theme.textTheme.titleMedium));
    } else {
      lines.add(
        Text(today.isWorkingDay ? l10n.notCheckedInYet : l10n.checkInNotToday, style: theme.textTheme.titleMedium),
      );
    }
    if (record?.checkOutAt != null) lines.add(Text(l10n.checkedOutAt(formatTime(record!.checkOutAt!))));
    final worked = record?.workedMinutes;
    if (worked != null) lines.add(Text(l10n.workedDuration(worked ~/ 60, worked % 60)));

    final flag = record?.checkInLocationFlag;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(l10n.attendanceToday, style: theme.textTheme.labelLarge)),
                if (record != null) StatusChip(label: record.status.label(l10n), tone: record.status.tone),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ...lines,
            if (flag != null && flag != LocationFlag.ok) ...[
              const SizedBox(height: AppSpacing.sm),
              StatusChip(label: flag.label(l10n), tone: flag.tone, icon: Icons.location_off_outlined),
            ],
            if (canCheckIn || (today.checkedIn && !today.checkedOut)) ...[
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: canCheckIn
                    ? FilledButton.icon(
                        onPressed: _busy
                            ? null
                            : () => _run(ref.read(attendanceRepositoryProvider).checkIn, l10n.checkInDone),
                        icon: const Icon(Icons.login),
                        label: Text(l10n.checkIn),
                      )
                    : OutlinedButton.icon(
                        onPressed: _busy ? null : _checkOut,
                        icon: const Icon(Icons.logout),
                        label: Text(l10n.checkOut),
                      ),
              ),
            ],
            if (_locating) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  const SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                  const SizedBox(width: AppSpacing.sm),
                  Text(l10n.checkingLocation),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
