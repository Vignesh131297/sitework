import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../features/attendance/presentation/staff_attendance_screen.dart';
import '../../features/auth/domain/user_role.dart';
import '../../features/clients/presentation/client_detail_screen.dart';
import '../../features/clients/presentation/client_form_screen.dart';
import '../../features/dashboard/presentation/admin_dashboard_screen.dart';
import '../../features/dashboard/presentation/engineer_dashboard_screen.dart';
import '../../features/engineer_updates/presentation/engineer_update_detail_screen.dart';
import '../../features/engineer_updates/presentation/engineer_update_form_screen.dart';
import '../../features/engineer_updates/presentation/engineer_updates_screen.dart';
import '../../features/issues/presentation/issue_detail_screen.dart';
import '../../features/issues/presentation/issue_form_screen.dart';
import '../../features/issues/presentation/issues_screen.dart';
import '../../features/notifications/data/notifications_repository.dart';
import '../../features/notifications/presentation/notifications_poller.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/notifications/push/push_listener.dart';
import '../../features/payments/presentation/payments_screen.dart';
import '../../features/people/presentation/people_screen.dart';
import '../../features/people/presentation/person_detail_screen.dart';
import '../../features/people/presentation/person_form_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/reports/presentation/reports_screen.dart';
import '../../features/sites/presentation/engineer_sites_screen.dart';
import '../../features/sites/presentation/site_detail_screen.dart';
import '../../features/sites/presentation/site_form_screen.dart';
import '../../features/sites/presentation/sites_screen.dart';
import '../../features/staff_updates/presentation/capture_update_screen.dart';
import '../../features/staff_updates/presentation/queue_sync.dart';
import '../../features/staff_updates/presentation/review_screen.dart';
import '../../features/staff_updates/presentation/staff_history_screen.dart';
import '../../features/staff_updates/presentation/staff_home_screen.dart';
import '../../features/staff_updates/presentation/staff_update_screen.dart';
import '../../features/staff_updates/presentation/staff_updates_screen.dart';
import '../models/enums.dart';
import 'app_routes.dart';
import 'role_shell.dart';

// Bottom navigation per role (spec §30). Admin and Engineer open Profile from
// the app-bar avatar so their bars keep five tabs.
//
// Detail and form screens are full-screen routes above the shell: they can be
// opened from any tab, and Back returns to where the user was.

final List<RouteBase> adminRoutes = [
  roleShellRoute([
    ShellTab(
      path: AppRoutes.adminDashboard,
      icon: Icons.space_dashboard_outlined,
      selectedIcon: Icons.space_dashboard,
      label: (l10n) => l10n.navDashboard,
      screen: const AdminDashboardScreen(),
    ),
    ShellTab(
      path: AppRoutes.adminSites,
      icon: Icons.apartment_outlined,
      selectedIcon: Icons.apartment,
      label: (l10n) => l10n.navSites,
      screen: const SitesScreen(),
    ),
    ShellTab(
      path: AppRoutes.adminPayments,
      icon: Icons.currency_rupee_outlined,
      selectedIcon: Icons.currency_rupee,
      label: (l10n) => l10n.navPayments,
      screen: const PaymentsScreen(),
    ),
    ShellTab(
      path: AppRoutes.adminPeople,
      icon: Icons.groups_outlined,
      selectedIcon: Icons.groups,
      label: (l10n) => l10n.navPeople,
      screen: const PeopleScreen(),
    ),
    _alertsTab(AppRoutes.adminNotifications),
  ], wrap: (shell) => NotificationsPoller(child: PushListener(child: shell))),
  GoRoute(path: AppRoutes.adminProfile, builder: (context, state) => const ProfileScreen()),
  // Specific paths first: "new" and "clients/…" must not be read as a site id.
  GoRoute(path: AppRoutes.adminSiteNew, builder: (context, state) => const SiteFormScreen()),
  GoRoute(path: AppRoutes.adminClientNew, builder: (context, state) => const ClientFormScreen()),
  GoRoute(
    path: '${AppRoutes.adminSites}/clients/:id',
    builder: (context, state) => ClientDetailScreen(id: state.pathParameters['id']!),
    routes: [
      GoRoute(
        path: 'edit',
        builder: (context, state) => ClientFormScreen(id: state.pathParameters['id']),
      ),
    ],
  ),
  GoRoute(
    path: '${AppRoutes.adminSites}/:id',
    builder: (context, state) =>
        SiteDetailScreen(id: state.pathParameters['id']!, initialTab: state.uri.queryParameters['tab']),
    routes: [
      GoRoute(
        path: 'edit',
        builder: (context, state) => SiteFormScreen(id: state.pathParameters['id']),
      ),
    ],
  ),
  ..._personRoutes(UserRole.engineer, '${AppRoutes.adminPeople}/engineers'),
  ..._personRoutes(UserRole.staff, '${AppRoutes.adminPeople}/staff'),
  GoRoute(path: AppRoutes.issues(AppRoutes.adminArea), builder: (context, state) => const IssuesScreen()),
  GoRoute(
    path: AppRoutes.adminPaymentsAll,
    builder: (context, state) => AllPaymentsScreen(clientId: state.uri.queryParameters['clientId']),
  ),
  ..._reviewRoutes(AppRoutes.adminArea),
];

/// Photos, reports and issues: the same screens for admins and engineers.
List<RouteBase> _reviewRoutes(String area) => [
  GoRoute(
    path: '$area/staff-updates/:id',
    builder: (context, state) => StaffUpdateScreen(id: state.pathParameters['id']!),
  ),
  GoRoute(path: AppRoutes.review(area), builder: (context, state) => const ReviewScreen()),
  GoRoute(path: AppRoutes.reports(area), builder: (context, state) => const ReportsScreen()),
  GoRoute(
    path: '$area/updates/:id',
    builder: (context, state) => EngineerUpdateDetailScreen(id: state.pathParameters['id']!),
  ),
  GoRoute(
    path: '$area/issues/new',
    builder: (context, state) => IssueFormScreen(siteId: state.uri.queryParameters['siteId']),
  ),
  GoRoute(
    path: '$area/issues/:id',
    builder: (context, state) => IssueDetailScreen(id: state.pathParameters['id']!),
  ),
];

List<RouteBase> _personRoutes(UserRole role, String base) => [
  GoRoute(
    path: '$base/new',
    builder: (context, state) => PersonFormScreen(role: role),
  ),
  GoRoute(
    path: '$base/:id',
    builder: (context, state) => PersonDetailScreen(role: role, id: state.pathParameters['id']!),
    routes: [
      GoRoute(
        path: 'edit',
        builder: (context, state) => PersonFormScreen(role: role, id: state.pathParameters['id']),
      ),
    ],
  ),
];

final List<RouteBase> engineerRoutes = [
  roleShellRoute([
    ShellTab(
      path: AppRoutes.engineerDashboard,
      icon: Icons.space_dashboard_outlined,
      selectedIcon: Icons.space_dashboard,
      label: (l10n) => l10n.navDashboard,
      screen: const EngineerDashboardScreen(),
    ),
    ShellTab(
      path: AppRoutes.engineerSites,
      icon: Icons.apartment_outlined,
      selectedIcon: Icons.apartment,
      label: (l10n) => l10n.navSites,
      screen: const EngineerSitesScreen(),
    ),
    ShellTab(
      path: AppRoutes.engineerUpdates,
      icon: Icons.assignment_outlined,
      selectedIcon: Icons.assignment,
      label: (l10n) => l10n.navUpdates,
      screen: const EngineerUpdatesScreen(),
    ),
    ShellTab(
      path: AppRoutes.engineerIssues,
      icon: Icons.report_problem_outlined,
      selectedIcon: Icons.report_problem,
      label: (l10n) => l10n.navIssues,
      screen: const IssuesScreen(showProfileAction: true),
    ),
    _alertsTab(AppRoutes.engineerNotifications),
  ], wrap: (shell) => NotificationsPoller(child: PushListener(child: shell))),
  GoRoute(path: AppRoutes.engineerProfile, builder: (context, state) => const ProfileScreen()),
  GoRoute(
    path: '${AppRoutes.engineerSites}/:id',
    builder: (context, state) =>
        SiteDetailScreen(id: state.pathParameters['id']!, initialTab: state.uri.queryParameters['tab']),
  ),
  // "new" before ":id".
  GoRoute(
    path: AppRoutes.engineerUpdateNew,
    builder: (context, state) => EngineerUpdateFormScreen(siteId: state.uri.queryParameters['siteId']),
  ),
  ..._reviewRoutes(AppRoutes.engineerArea),
];

final List<RouteBase> staffRoutes = [
  roleShellRoute(
    [
      ShellTab(
        path: AppRoutes.staffHome,
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        label: (l10n) => l10n.navHome,
        screen: const StaffHomeScreen(),
      ),
      ShellTab(
        path: AppRoutes.staffAttendance,
        icon: Icons.how_to_reg_outlined,
        selectedIcon: Icons.how_to_reg,
        label: (l10n) => l10n.navAttendance,
        screen: const StaffAttendanceScreen(),
      ),
      ShellTab(
        path: AppRoutes.staffUpdates,
        icon: Icons.photo_camera_outlined,
        selectedIcon: Icons.photo_camera,
        label: (l10n) => l10n.navUpdates,
        screen: const StaffUpdatesScreen(),
      ),
      ShellTab(
        path: AppRoutes.staffHistory,
        icon: Icons.history_outlined,
        selectedIcon: Icons.history,
        label: (l10n) => l10n.navHistory,
        screen: const StaffHistoryScreen(),
      ),
      ShellTab(
        path: AppRoutes.staffProfile,
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: (l10n) => l10n.navProfile,
        screen: const ProfileScreen(),
      ),
    ],
    wrap: (shell) => NotificationsPoller(
      child: PushListener(child: QueueSync(child: shell)),
    ),
  ),
  GoRoute(path: AppRoutes.staffNotifications, builder: (context, state) => const NotificationsScreen()),
  GoRoute(
    path: AppRoutes.staffCapturePath,
    redirect: (context, state) =>
        TimeSlot.values.any((s) => s.apiValue == state.pathParameters['slot']) ? null : AppRoutes.staffHome,
    builder: (context, state) =>
        CaptureUpdateScreen(slot: TimeSlot.values.firstWhere((s) => s.apiValue == state.pathParameters['slot'])),
  ),
];

/// The Alerts tab (admin and engineer), with the unread count on its icon.
ShellTab _alertsTab(String path) => ShellTab(
  path: path,
  icon: Icons.notifications_outlined,
  selectedIcon: Icons.notifications,
  label: (l10n) => l10n.navAlerts,
  screen: const NotificationsScreen(showProfileAction: true),
  badgeCount: (ref) => ref.watch(unreadCountProvider).value ?? 0,
);
