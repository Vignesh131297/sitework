import '../models/enums.dart';

/// Every route path in one place. Each role's screens live under its area.
abstract final class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  static const changePassword = '/change-password';

  /// Reachable without signing in.
  static const publicPaths = {login, forgotPassword, resetPassword};

  static const adminArea = '/admin';
  static const adminDashboard = '/admin/dashboard';
  static const adminSites = '/admin/sites';
  static const adminPayments = '/admin/payments';
  static const adminPaymentsAll = '/admin/payments/all';
  static const adminPeople = '/admin/people';
  static const adminNotifications = '/admin/notifications';
  static const adminProfile = '/admin/profile';

  static const engineerArea = '/engineer';
  static const engineerDashboard = '/engineer/dashboard';
  static const engineerSites = '/engineer/sites';
  static const engineerUpdates = '/engineer/updates';
  static const engineerIssues = '/engineer/issues';
  static const engineerNotifications = '/engineer/notifications';
  static const engineerProfile = '/engineer/profile';

  static const staffArea = '/staff';
  static const staffHome = '/staff/dashboard';
  static const staffAttendance = '/staff/attendance';
  static const staffUpdates = '/staff/updates';
  static const staffHistory = '/staff/history';
  static const staffProfile = '/staff/profile';

  // Admin detail screens (nested in their tab so the bottom bar stays).
  static const adminSiteNew = '$adminSites/new';
  static String adminSite(String id) => '$adminSites/$id';
  static String adminSiteEdit(String id) => '$adminSites/$id/edit';
  static const adminClientNew = '$adminSites/clients/new';
  static String adminClient(String id) => '$adminSites/clients/$id';
  static String adminClientEdit(String id) => '$adminSites/clients/$id/edit';
  static const adminEngineerNew = '$adminPeople/engineers/new';
  static String adminEngineer(String id) => '$adminPeople/engineers/$id';
  static String adminEngineerEdit(String id) => '$adminPeople/engineers/$id/edit';
  static const adminStaffNew = '$adminPeople/staff/new';
  static String adminStaffMember(String id) => '$adminPeople/staff/$id';
  static String adminStaffMemberEdit(String id) => '$adminPeople/staff/$id/edit';

  // Screens admins and engineers share, under each one's area ('/admin', '/engineer').
  static String site(String area, String id, {String? tab}) => '$area/sites/$id${tab == null ? '' : '?tab=$tab'}';
  static String staffUpdate(String area, String id) => '$area/staff-updates/$id';
  static String review(String area) => '$area/review';
  static String engineerUpdate(String area, String id) => '$area/updates/$id';
  static const engineerUpdateNew = '$engineerUpdates/new';
  static String engineerUpdateNewFor(String siteId) => '$engineerUpdateNew?siteId=$siteId';
  static String issues(String area) => '$area/issues';
  static String issue(String area, String id) => '$area/issues/$id';
  static String issueNew(String area, {String? siteId}) => '$area/issues/new${siteId == null ? '' : '?siteId=$siteId'}';
  static String reports(String area) => '$area/reports';

  // Staff full-screen routes.
  static const staffNotifications = '$staffArea/notifications';
  static const staffCapturePath = '$staffArea/capture/:slot';
  static String staffCapture(TimeSlot slot) => '$staffArea/capture/${slot.apiValue}';
}
