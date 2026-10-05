import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/enums.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/routing/area.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/initials.dart';
import '../../../core/utils/launch.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/inline_message.dart';
import '../../../core/widgets/status_chip.dart';
import '../../auth/domain/user_role.dart';
import '../../auth/presentation/session_controller.dart';
import '../../staff_updates/domain/staff_update_models.dart';
import '../data/sites_repository.dart';
import '../domain/site_day.dart';

/// The site's staff board for a day: attendance and each slot, with sent
/// photos one tap away. Today by default; step back through earlier days.
class SiteDayTab extends ConsumerStatefulWidget {
  const SiteDayTab({super.key, required this.siteId});

  final String siteId;

  @override
  ConsumerState<SiteDayTab> createState() => _SiteDayTabState();
}

class _SiteDayTabState extends ConsumerState<SiteDayTab> {
  /// Null means "today" (by the server's calendar).
  String? _date;
  String? _today;

  void _step(String shown, int days) {
    final next = isoDate(DateTime.parse(shown).add(Duration(days: days)));
    setState(() => _date = next == _today ? null : next);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final key = (siteId: widget.siteId, date: _date);
    final day = ref.watch(siteDayProvider(key));
    if (_date == null && day.value != null) _today = day.value!.date;
    return AsyncValueView(
      value: day,
      onRetry: () => ref.invalidate(siteDayProvider(key)),
      data: (day) => RefreshIndicator(
        onRefresh: () => ref.refresh(siteDayProvider(key).future),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xxl),
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: l10n.boardPreviousDay,
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => _step(day.date, -1),
                ),
                Expanded(
                  child: Text(
                    day.date == _today ? l10n.siteTabToday : DateFormat('EEE d MMM').format(DateTime.parse(day.date)),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: l10n.boardNextDay,
                  icon: const Icon(Icons.chevron_right),
                  onPressed: day.date == _today ? null : () => _step(day.date, 1),
                ),
              ],
            ),
            if (!day.isWorkingDay)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: InlineMessage(
                  tone: StatusTone.info,
                  message: day.holiday != null ? l10n.dashboardHoliday(day.holiday!) : l10n.dashboardDayOff,
                ),
              ),
            if (day.staff.isEmpty) EmptyState(icon: Icons.groups_outlined, title: l10n.boardNoStaff),
            for (final person in day.staff) _StaffDayCard(day: person),
          ],
        ),
      ),
    );
  }
}

class _StaffDayCard extends ConsumerWidget {
  const _StaffDayCard({required this.day});

  final StaffDay day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final role = ref.watch(sessionProvider).value?.role;
    final area = ref.watch(areaPathProvider);
    final d = day;
    final attendance = d.attendance;
    // Not checked in shows as a chip instead.
    final attendanceText = attendance == null
        ? null
        : [
            if (attendance.checkInAt != null) l10n.boardCheckedIn(formatTime(attendance.checkInAt!)),
            if (attendance.checkOutAt != null) l10n.boardCheckedOut(formatTime(attendance.checkOutAt!)),
          ].join(' · ');

    bool reviewedByMe(SlotUpdateRef update) =>
        role == UserRole.admin ? update.adminViewedAt != null : update.engineerViewedAt != null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(child: Text(initialsOf(d.staff.name))),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(d.staff.name, style: theme.textTheme.titleMedium),
                      Text(
                        [?d.staff.designation?.label(l10n), ?attendanceText].join(' · '),
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                if (attendance != null)
                  Flexible(
                    child: StatusChip(label: attendance.status.label(l10n), tone: attendance.status.tone),
                  )
                else if (d.notCheckedIn)
                  Flexible(
                    child: StatusChip(label: l10n.boardNotCheckedIn, tone: StatusTone.warning),
                  ),
                IconButton(
                  tooltip: l10n.commonCall,
                  icon: const Icon(Icons.call_outlined),
                  onPressed: () => callPhone(d.staff.phone),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                for (final slot in d.slots)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                      child: _SlotButton(
                        slot: slot,
                        toReview: slot.update != null && !reviewedByMe(slot.update!),
                        onOpen: slot.update == null
                            ? null
                            : () => context.push(AppRoutes.staffUpdate(area, slot.update!.id)),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// One slot's state; a sent one opens its update and photo.
class _SlotButton extends StatelessWidget {
  const _SlotButton({required this.slot, required this.toReview, this.onOpen});

  final DaySlot slot;
  final bool toReview;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.tone(slot.state.tone);
    final photoGone = slot.update?.imageStatus == ImageStatus.deleted;
    return Material(
      color: colors.background,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.xs),
          child: Column(
            children: [
              Text(
                slot.slot.label(l10n),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: colors.foreground),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (slot.update != null)
                    Icon(
                      photoGone ? Icons.hide_image_outlined : Icons.photo_outlined,
                      size: 14,
                      color: colors.foreground,
                    ),
                  Flexible(
                    child: Text(
                      slot.update != null ? formatTime(slot.update!.submittedAt) : slot.state.label(l10n),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.foreground),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (toReview && !photoGone)
                Text(
                  l10n.boardToReview,
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(color: colors.foreground, fontWeight: FontWeight.w700),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
