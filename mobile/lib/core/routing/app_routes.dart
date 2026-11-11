import '../models/enums.dart';

/// Every route path in one place. Each role's screens live under its area.
abstract final class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const signUp = '/sign-up';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  static const changePassword = '/change-password';

  /// Reachable without signing in.
  static const publicPaths = {login, signUp, forgotPassword, resetPassword};

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

  static const godownArea = '/godown';
  static const godownHome = '/godown/dashboard';
  static const godownRequests = '/godown/requests';
  static const godownStock = '/godown/stock';
  static const godownNotifications = '/godown/notifications';
  static const godownProfile = '/godown/profile';

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

  /// Godown managers and admins: [segment] is 'godown-managers' or 'admins'.
  static String adminPersonNew(String segment) => '$adminPeople/$segment/new';
  static String adminPerson(String segment, String id) => '$adminPeople/$segment/$id';
  static String adminPersonEdit(String segment, String id) => '$adminPeople/$segment/$id/edit';
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

  // Stock: godowns and materials, shared by admins and engineers.
  static String stock(String area) => '$area/stock';
  static String stockGodown(String area, String id) => '$area/stock/godowns/$id';
  static String stockEntry(String area, String id) => '$area/stock/entries/$id';

  /// Stock entries, filtered to a site, a godown or a material; with
  /// [receivable], what the user can confirm now.
  static String stockHistory(
    String area, {
    String? siteId,
    String? godownId,
    String? materialId,
    bool receivable = false,
  }) {
    final query = {
      'siteId': ?siteId,
      'godownId': ?godownId,
      'materialId': ?materialId,
      if (receivable) 'receivable': 'true',
    };
    return Uri(path: '$area/stock/history', queryParameters: query.isEmpty ? null : query).toString();
  }

  // Material requests: a site asks, an admin approves, the godown sends.
  static String requests(String area, {String? siteId}) =>
      Uri(path: '$area/requests', queryParameters: siteId == null ? null : {'siteId': siteId}).toString();
  static String request(String area, String id) => '$area/requests/$id';
  static String requestNew(String area, {String? siteId}) =>
      '$area/requests/new${siteId == null ? '' : '?siteId=$siteId'}';

  /// A material's page (admins only: it shows prices).
  static String adminMaterial(String id) => '$adminArea/stock/materials/$id';

  // Leave, and staff members' money and food requests.
  /// The caller's own requests (staff: [tab] is 'leave', 'money' or 'material'; engineers: their leave).
  static String myRequests(String area, {String? tab}) => '$area/my-requests${tab == null ? '' : '?tab=$tab'}';

  /// Leave, money and food waiting for an admin or engineer to decide.
  static String approvals(String area) => '$area/approvals';
  static String leave(String area, String id) => '$area/leave/$id';
  static String leaveNew(String area) => '$area/leave/new';
  static String staffRequest(String area, String id) => '$area/staff-requests/$id';
  static String staffRequestNew(String area, StaffRequestKind kind) =>
      '$area/staff-requests/new?kind=${kind.apiValue}';

  // Staff full-screen routes.
  static const staffNotifications = '$staffArea/notifications';
  static const staffCapturePath = '$staffArea/capture/:slot';
  static String staffCapture(TimeSlot slot) => '$staffArea/capture/${slot.apiValue}';
}
