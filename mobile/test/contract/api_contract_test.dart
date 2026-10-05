import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
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
import 'package:sitework/features/sites/domain/site_day.dart';
import 'package:sitework/features/sites/domain/site_models.dart';
import 'package:sitework/features/staff_updates/domain/staff_update_models.dart';

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
    for (final role in ['admin', 'engineer', 'staff']) {
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
}
