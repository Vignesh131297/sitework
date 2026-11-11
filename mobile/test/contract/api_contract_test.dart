import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sitework/core/models/enums.dart';
import 'package:sitework/features/attendance/domain/attendance_models.dart';
import 'package:sitework/features/auth/domain/auth_models.dart';
import 'package:sitework/features/clients/domain/client_models.dart';
import 'package:sitework/features/dashboard/domain/admin_dashboard.dart';
import 'package:sitework/features/engineer_updates/domain/engineer_update_models.dart';
import 'package:sitework/features/issues/domain/issue_models.dart';
import 'package:sitework/features/notifications/domain/notification_models.dart';
import 'package:sitework/features/payments/domain/payment_models.dart';
import 'package:sitework/features/people/domain/person_models.dart';
import 'package:sitework/features/reports/domain/report_models.dart';
import 'package:sitework/features/requests/domain/request_models.dart';
import 'package:sitework/features/sites/domain/site_day.dart';
import 'package:sitework/features/sites/domain/site_models.dart';
import 'package:sitework/features/staff_updates/domain/staff_update_models.dart';
import 'package:sitework/features/stock/domain/stock_models.dart';

// Responses recorded from the real API (seed data) decode into the app's
// models. Refresh the fixtures when the API changes: see test/contract/README.md.

Map<String, dynamic> _envelope(String name) =>
    jsonDecode(File('test/contract/fixtures/$name.json').readAsStringSync()) as Map<String, dynamic>;

Map<String, dynamic> _data(String name) => _envelope(name)['data'] as Map<String, dynamic>;

List<Map<String, dynamic>> _rows(String name) => [
  for (final row in _envelope(name)['data'] as List<dynamic>) row as Map<String, dynamic>,
];

void main() {
  test('profiles for each role', () {
    for (final role in ['admin', 'engineer', 'staff', 'godown_manager']) {
      expect(MeProfile.fromJson(_data('me_$role')).name, isNotEmpty, reason: role);
    }
  });

  test('one staff update and one issue in full', () {
    expect(StaffUpdate.fromJson(_data('staff_update_detail')).id, isNotEmpty);
    expect(Issue.fromJson(_data('issue_detail')).id, isNotEmpty);
  });

  test('admin dashboard', () {
    final dashboard = AdminDashboard.fromJson(_data('dashboard_admin'));
    expect(dashboard.counts.activeSites, greaterThan(0));
    expect(dashboard.attention.whereType<UnknownAttentionItem>(), isEmpty);
  });

  test('sites', () {
    expect(_rows('sites').map(SiteSummary.fromJson), isNotEmpty);
    final site = SiteDetail.fromJson(_data('site_detail'));
    expect(site.financials, isNotNull, reason: 'admins see money');
  });

  test('clients', () {
    expect(_rows('clients').map(ClientSummary.fromJson), isNotEmpty);
    expect(ClientDetail.fromJson(_data('client_detail')).sites, isNotEmpty);
  });

  test('engineers and staff', () {
    expect(_rows('engineers').map(PersonSummary.fromJson), isNotEmpty);
    expect(_rows('staff').map(PersonSummary.fromJson), isNotEmpty);
    expect(PersonDetail.fromJson(_data('engineer_detail')).sites, isNotEmpty);
    expect(PersonDetail.fromJson(_data('staff_detail')).assignment, isNotNull);
  });

  test('field work: the staff day, updates, attendance and notifications', () {
    final today = StaffToday.fromJson(_data('staff_today'));
    expect(today.slots, hasLength(3));
    expect(today.assignment, isNotNull);
    expect(_rows('staff_updates').map(StaffUpdate.fromJson), isNotEmpty);
    expect(_rows('attendance').map(AttendanceRecord.fromJson), isNotEmpty);
    expect(_rows('notifications').map(AppNotification.fromJson), isNotEmpty);
  });

  test('engineer work: dashboard, staff board, updates and issues', () {
    final dashboard = EngineerDashboard.fromJson(_data('dashboard_engineer'));
    expect(dashboard.sites, isNotEmpty);
    expect(dashboard.attention.whereType<UnknownAttentionItem>(), isEmpty);
    expect(SiteDay.fromJson(_data('site_day')).staff, isNotEmpty);
    expect(_rows('engineer_updates').map(EngineerUpdate.fromJson), isNotEmpty);
    expect(EngineerUpdate.fromJson(_data('engineer_update_detail')).description, isNotEmpty);
    expect(_rows('issues').map(Issue.fromJson), isNotEmpty);
  });

  test("payments: summary, payments and a site's money", () {
    final summary = PaymentsSummary.fromJson(_data('payments_summary'));
    expect(summary.sites, isNotEmpty);
    expect(_rows('payments').map(Payment.fromJson), isNotEmpty);
    expect(SiteMoney.fromJson(_data('site_money')).financials.milestones, isNotEmpty);
  });

  test('stock: overview, godown, site, entries, material and reports', () {
    final overview = StockOverview.fromJson(_data('stock_overview'));
    expect(overview.godowns, isNotEmpty);
    expect(overview.materials, isNotEmpty);
    expect(overview.sites, isNotEmpty);
    expect(StockOverview.fromJson(_data('stock_overview_engineer')).godowns, isNotEmpty);
    final godown = GodownStock.fromJson(_data('godown_stock'));
    expect(godown.items, isNotEmpty);
    expect(godown.value, isNotNull, reason: 'admins see values');
    final site = SiteStock.fromJson(_data('site_stock'));
    expect(site.items, isNotEmpty);
    expect(site.items.first.usedValue, isNotNull, reason: 'admins see values');
    final staffSite = SiteStock.fromJson(_data('site_stock_staff'));
    expect(staffSite.value, isNull, reason: 'staff never see money');
    expect(_rows('stock_entries').map(StockEntry.fromJson), isNotEmpty);
    expect(StockEntry.fromJson(_data('stock_entry_detail')).lines, isNotEmpty);
    expect(MaterialDetail.fromJson(_data('material_detail')).material.name, isNotEmpty);
    expect(_rows('report_stock').map(StockReportRow.fromJson), isNotEmpty);
    expect(_rows('report_stock_engineer').map(StockReportRow.fromJson).every((r) => r.usedValue == null), isTrue);
  });

  test('material requests, godown managers and sign-up', () {
    final requests = _rows('material_requests').map(MaterialRequest.fromJson).toList();
    expect(requests, isNotEmpty);
    expect(requests.map((r) => r.status).toSet(), contains(MaterialRequestStatus.pending));
    final detail = MaterialRequest.fromJson(_data('material_request_detail'));
    expect(detail.godown, isNotNull);
    expect(detail.entries, isNotEmpty);
    expect(detail.entries.first.request?.code, detail.code);
    expect(
      _rows('material_requests_godown')
          .map(MaterialRequest.fromJson)
          .every((r) => r.status != MaterialRequestStatus.pending),
      isTrue,
      reason: 'godowns see requests once approved',
    );
    final godown = GodownDashboard.fromJson(_data('dashboard_godown'));
    expect(godown.godowns, isNotEmpty);
    expect(StockOverview.fromJson(_data('stock_overview_godown')).sites, isEmpty);
    expect(GodownStock.fromJson(_data('godown_stock')).managers, isNotEmpty);
    final managers = _rows('godown_managers').map(PersonSummary.fromJson).toList();
    expect(managers.first.godowns, isNotEmpty);
    expect(PersonDetail.fromJson(_data('godown_manager_detail')).godowns, isNotEmpty);
    expect(_rows('admins').map(PersonSummary.fromJson), isNotEmpty);
    expect(_data('signup_status'), {'open': false});
    expect(AdminDashboard.fromJson(_data('dashboard_admin')).stock.requestsToApprove, greaterThan(0));
    expect(EngineerDashboard.fromJson(_data('dashboard_engineer')).stock.openRequests, greaterThan(0));
  });

  test('reports: sites, staff, engineers and payments', () {
    final sites = _rows('report_sites').map(SiteReportRow.fromJson).toList();
    expect(sites, isNotEmpty);
    expect(sites.every((row) => row.received != null), isTrue);
    expect(_rows('report_sites_engineer').map(SiteReportRow.fromJson).every((row) => row.received == null), isTrue);
    expect(_rows('report_staff').map(StaffReportRow.fromJson), isNotEmpty);
    expect(_rows('report_engineers').map(EngineerReportRow.fromJson), isNotEmpty);
    final payments = PaymentReport.fromJson(_data('report_payments'));
    expect(payments.sites, isNotEmpty);
    expect(payments.payments, isNotEmpty);
  });

  test('leave, money and food requests', () {
    final leave = _rows('leave_requests').map(LeaveRequest.fromJson).toList();
    expect(leave.map((l) => l.status).toSet(), containsAll([ApprovalStatus.pending, ApprovalStatus.approved]));
    expect(leave.where((l) => l.site == null), isNotEmpty, reason: "an engineer's leave");
    expect(LeaveRequest.fromJson(_data('leave_request_detail')).days, greaterThan(0));
    final requests = _rows('staff_requests').map(StaffRequest.fromJson).toList();
    expect(requests.map((r) => r.kind).toSet(), {StaffRequestKind.money, StaffRequestKind.food});
    expect(requests.where((r) => r.kind == StaffRequestKind.food).every((r) => r.meal != null), isTrue);
    expect(StaffRequest.fromJson(_data('staff_request_detail')).code, startsWith('RQ-'));
  });

  test("a staff member's own requests and the materials they can ask for", () {
    expect(_rows('leave_requests_staff').map(LeaveRequest.fromJson).every((l) => l.canCancel), isTrue);
    expect(_rows('staff_requests_staff').map(StaffRequest.fromJson), isNotEmpty);
    expect(_rows('material_requests_staff').map(MaterialRequest.fromJson), isEmpty);
    expect(_rows('materials').map(StockMaterial.fromJson).every((m) => m.isActive), isTrue);
  });
}
