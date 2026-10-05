import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/enums.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/info_widgets.dart';
import '../../../core/widgets/paged_list_view.dart';
import '../../../core/widgets/status_chip.dart';
import '../../staff_updates/data/staff_updates_repository.dart';
import '../data/attendance_repository.dart';
import '../domain/attendance_models.dart';
import 'attendance_card.dart';

/// Staff "Attendance": check in/out for today, then past days.
class StaffAttendanceScreen extends ConsumerWidget {
  const StaffAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final revision = ref.watch(revisionProvider(DataSet.attendance));
    final repository = ref.watch(attendanceRepositoryProvider);
    final today = ref.watch(staffTodayProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.attendanceTitle)),
      body: PagedListView(
        key: ValueKey('attendance-$revision'),
        fetch: (page) => repository.list(page: page),
        header: (context, total) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AsyncValueView(
              value: today,
              onRetry: () => ref.invalidate(staffTodayProvider),
              data: (today) => today.assignment == null ? const SizedBox.shrink() : AttendanceCard(today: today),
            ),
            SectionHeader(l10n.attendanceHistoryTitle),
          ],
        ),
        itemBuilder: (context, record) => AttendanceTile(record: record),
        empty: EmptyList(icon: Icons.event_available_outlined, message: l10n.attendanceHistoryEmpty),
      ),
    );
  }
}

class AttendanceTile extends StatelessWidget {
  const AttendanceTile({super.key, required this.record, this.showStaff = false});

  final AttendanceRecord record;
  final bool showStaff;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final r = record;
    final times = [
      if (r.checkInAt != null) formatTime(r.checkInAt!),
      if (r.checkOutAt != null) formatTime(r.checkOutAt!),
    ].join(' – ');
    final worked = r.workedMinutes;
    return Card(
      child: ListTile(
        title: Text(showStaff ? r.staff.name : formatShortDate(DateTime.parse(r.workDate))),
        subtitle: Text(
          [
            if (times.isNotEmpty) times,
            if (worked != null) l10n.workedDuration(worked ~/ 60, worked % 60),
            if (r.checkInLocationFlag != null && r.checkInLocationFlag != LocationFlag.ok)
              r.checkInLocationFlag!.label(l10n),
            ?r.correctionNote,
          ].join(' · '),
        ),
        trailing: StatusChip(label: r.status.label(l10n), tone: r.status.tone),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      ),
    );
  }
}
