import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/models/enums.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/utils/relative_time.dart';
import '../../../core/widgets/paged_list_view.dart';
import '../../../core/widgets/profile_action.dart';
import '../../../core/widgets/submit_state.dart';
import '../../auth/domain/user_role.dart';
import '../../auth/presentation/session_controller.dart';
import '../data/notifications_repository.dart';
import '../domain/notification_models.dart';

/// Where a notification leads for this role, if anywhere. Tab screens are
/// gone to (they live in the shell); detail screens are pushed on top.
({String path, bool isTab})? notificationTarget(AppNotification notification, UserRole role) {
  final n = notification;
  final area = role.areaPath;
  final siteId = n.data?['siteId'];
  final id = n.referenceId;
  final requestId = n.data?['requestId'];
  if (role == UserRole.staff) {
    // Their requests open the request; a missed update, Home.
    final own = switch (n.referenceType) {
      ReferenceType.leaveRequest when id != null => AppRoutes.leave(area, id),
      ReferenceType.staffRequest when id != null => AppRoutes.staffRequest(area, id),
      ReferenceType.vehicleRepairRequest when id != null => AppRoutes.repairRequest(area, id),
      _ when requestId != null => AppRoutes.request(area, requestId),
      _ => null,
    };
    if (own != null) return (path: own, isTab: false);
    // Home shows the missing update, and the vehicle they were given.
    return n.type == NotificationType.missingUpdate || n.referenceType == ReferenceType.vehicle
        ? (path: AppRoutes.staffHome, isTab: true)
        : null;
  }
  // An engineer's own vehicle is on their dashboard.
  if (role == UserRole.engineer && n.referenceType == ReferenceType.vehicle) {
    return (path: AppRoutes.engineerDashboard, isTab: true);
  }
  final materialId = n.data?['materialId'];
  final godownId = n.data?['godownId'];
  final path = switch (n.referenceType) {
    // Material requests open the request.
    _ when requestId != null => AppRoutes.request(area, requestId),
    // Stock: low-stock alerts open the material; stock on its way to a godown
    // opens the godown; anything at a site opens its Stock tab.
    _ when n.type == NotificationType.stock && role == UserRole.admin && materialId != null => AppRoutes.adminMaterial(
      materialId,
    ),
    _ when n.type == NotificationType.stock && n.data?['to'] == 'GODOWN' && godownId != null => AppRoutes.stockGodown(
      area,
      godownId,
    ),
    // Godown managers have no site screens: they open the entry itself.
    ReferenceType.stockEntry when role == UserRole.godownManager && id != null => AppRoutes.stockEntry(area, id),
    _ when role == UserRole.godownManager => null,
    _ when n.type == NotificationType.stock && siteId != null => AppRoutes.site(area, siteId, tab: 'stock'),
    ReferenceType.staffUpdate when id != null => AppRoutes.staffUpdate(area, id),
    ReferenceType.engineerUpdate when id != null => AppRoutes.engineerUpdate(area, id),
    ReferenceType.issue when id != null => AppRoutes.issue(area, id),
    ReferenceType.leaveRequest when id != null => AppRoutes.leave(area, id),
    ReferenceType.staffRequest when id != null => AppRoutes.staffRequest(area, id),
    ReferenceType.vehicleRepairRequest when id != null => AppRoutes.repairRequest(area, id),
    ReferenceType.vehicle when id != null && role == UserRole.admin => AppRoutes.adminVehicle(id),
    ReferenceType.paymentMilestone || ReferenceType.payment when siteId != null && role == UserRole.admin =>
      AppRoutes.site(area, siteId, tab: 'payments'),
    _ when n.type == NotificationType.missingUpdate && siteId != null => AppRoutes.site(area, siteId, tab: 'today'),
    _ when siteId != null => AppRoutes.site(area, siteId),
    _ => null,
  };
  return path == null ? null : (path: path, isTab: false);
}

/// The signed-in user's notifications ("Alerts"), newest first.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key, this.showProfileAction = false});

  final bool showProfileAction;

  Future<void> _markAllRead(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(notificationsRepositoryProvider).markAllRead();
      ref.bump(DataSet.notifications);
    } on AppException catch (error) {
      if (context.mounted) showErrorSnack(context, error);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final revision = ref.watch(revisionProvider(DataSet.notifications));
    final repository = ref.watch(notificationsRepositoryProvider);
    final hasUnread = (ref.watch(unreadCountProvider).value ?? 0) > 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.screenNotifications),
        actions: [
          if (hasUnread)
            IconButton(
              tooltip: l10n.notificationsMarkAllRead,
              icon: const Icon(Icons.done_all),
              onPressed: () => _markAllRead(context, ref),
            ),
          if (showProfileAction) const ProfileAction(),
        ],
      ),
      body: PagedListView(
        key: ValueKey('notifications-$revision'),
        fetch: (page) => repository.list(page: page),
        separator: const Divider(height: 1),
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        itemBuilder: (context, notification) => NotificationTile(notification: notification),
        empty: EmptyList(icon: Icons.notifications_none, message: l10n.notificationsEmpty),
      ),
    );
  }
}

class NotificationTile extends ConsumerWidget {
  const NotificationTile({super.key, required this.notification});

  final AppNotification notification;

  Future<void> _open(BuildContext context, WidgetRef ref) async {
    final n = notification;
    final role = ref.read(sessionProvider).value?.role;
    if (!n.isRead) {
      try {
        await ref.read(notificationsRepositoryProvider).markRead(n.id);
        ref.bump(DataSet.notifications);
      } on AppException {
        // Opening still works; it stays unread until next time.
      }
    }
    final target = role == null ? null : notificationTarget(n, role);
    if (target == null || !context.mounted) return;
    if (target.isTab) {
      context.go(target.path);
    } else {
      await context.push<void>(target.path);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final n = notification;
    final (icon, tone) = switch (n.type) {
      NotificationType.staffUpdate => (Icons.photo_camera_outlined, StatusTone.info),
      NotificationType.engineerUpdate => (Icons.assignment_outlined, StatusTone.info),
      NotificationType.missingUpdate => (Icons.alarm_outlined, StatusTone.warning),
      NotificationType.payment => (Icons.currency_rupee, StatusTone.danger),
      NotificationType.issue => (Icons.report_problem_outlined, StatusTone.danger),
      NotificationType.attendance => (Icons.how_to_reg_outlined, StatusTone.neutral),
      NotificationType.system => (Icons.info_outline, StatusTone.neutral),
      NotificationType.stock => (Icons.inventory_2_outlined, StatusTone.warning),
      NotificationType.leave => (Icons.event_busy_outlined, StatusTone.info),
      NotificationType.staffRequest => (Icons.receipt_long_outlined, StatusTone.info),
      NotificationType.vehicle => (Icons.two_wheeler, StatusTone.info),
    };
    final colors = context.tone(tone);
    return ListTile(
      onTap: () => _open(context, ref),
      tileColor: n.isRead ? null : theme.colorScheme.primaryContainer.withValues(alpha: 0.25),
      leading: CircleAvatar(
        backgroundColor: colors.background,
        child: Icon(icon, color: colors.foreground, size: 20),
      ),
      title: Text(n.title, style: n.isRead ? null : const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text('${n.message}\n${formatRelative(n.createdAt, l10n)}'),
      isThreeLine: true,
      trailing: n.isRead
          ? null
          : Icon(Icons.circle, size: 10, color: theme.colorScheme.primary, semanticLabel: l10n.notificationUnread),
    );
  }
}
