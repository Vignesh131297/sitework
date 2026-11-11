import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/utils/launch.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/inline_message.dart';
import '../../../core/widgets/periodic_refresh.dart';
import '../../attendance/presentation/attendance_card.dart';
import '../../auth/presentation/session_controller.dart';
import '../../notifications/presentation/notification_bell.dart';
import '../../requests/presentation/staff_requests_card.dart';
import '../../stock/presentation/staff_usage_card.dart';
import '../data/staff_updates_repository.dart';
import '../domain/staff_update_models.dart';
import 'pending_updates_card.dart';
import 'today_slots.dart';

/// Staff "Home": the site, today's attendance, the three updates, the day's
/// material use, and quick ways to ask for leave, money, food or material.
class StaffHomeScreen extends ConsumerWidget {
  const StaffHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final name = ref.watch(sessionProvider).value?.name ?? '';
    return Scaffold(
      appBar: AppBar(title: Text(l10n.staffGreeting(name.split(' ').first)), actions: const [NotificationBell()]),
      body: StaffTodayView(
        builder: (today) => [
          _SiteHeader(today: today),
          if (today.assignment != null) ...[
            const SizedBox(height: AppSpacing.md),
            AttendanceCard(today: today),
            TodaySlots(today: today),
            StaffUsageCard(siteId: today.assignment!.site.id, siteName: today.assignment!.site.name),
            const StaffRequestsCard(),
          ],
          const PendingUpdatesCard(),
        ],
      ),
    );
  }
}

/// Loads `/me/today`, refreshes it as windows open and close, and lays out
/// [builder]'s widgets in a pull-to-refresh list.
class StaffTodayView extends ConsumerWidget {
  const StaffTodayView({super.key, required this.builder});

  final List<Widget> Function(StaffToday today) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) => PeriodicRefresh(
    interval: const Duration(minutes: 2),
    onRefresh: () => ref.invalidate(staffTodayProvider),
    child: AsyncValueView(
      value: ref.watch(staffTodayProvider),
      onRetry: () => ref.invalidate(staffTodayProvider),
      data: (today) => RefreshIndicator(
        onRefresh: () => ref.refresh(staffTodayProvider.future),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xxl),
          children: builder(today),
        ),
      ),
    ),
  );
}

class _SiteHeader extends StatelessWidget {
  const _SiteHeader({required this.today});

  final StaffToday today;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final assignment = today.assignment;
    final date = DateFormat('EEEE d MMMM').format(DateTime.parse(today.date));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(date, style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        if (!today.isWorkingDay) ...[
          const SizedBox(height: AppSpacing.md),
          InlineMessage(
            tone: StatusTone.info,
            message: today.holiday != null ? l10n.dashboardHoliday(today.holiday!) : l10n.dashboardDayOff,
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        if (assignment == null)
          EmptyState(icon: Icons.apartment_outlined, title: l10n.staffNotAssigned)
        else
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.apartment_outlined),
                  title: Text(assignment.site.name),
                  subtitle: Text(assignment.site.address),
                ),
                ListTile(
                  leading: const Icon(Icons.engineering_outlined),
                  title: Text(assignment.engineer.name),
                  subtitle: Text(l10n.staffYourEngineer),
                  trailing: assignment.engineer.phone == null
                      ? null
                      : IconButton(
                          tooltip: l10n.commonCall,
                          icon: const Icon(Icons.call_outlined),
                          onPressed: () => callPhone(assignment.engineer.phone!),
                        ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
