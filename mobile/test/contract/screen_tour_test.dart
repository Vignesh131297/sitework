import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sitework/core/network/image_loader.dart';
import 'package:sitework/core/widgets/async_value_view.dart';
import 'package:sitework/features/notifications/push/push_service.dart';

import '../helpers/admin_fixtures.dart';
import '../helpers/engineer_fixtures.dart';
import '../helpers/fake_api.dart';
import '../helpers/fake_auth_repository.dart';
import '../helpers/fake_push_service.dart';
import '../helpers/pump_app.dart';
import '../helpers/staff_fixtures.dart';

// Every screen, for every role, with responses recorded from the real API
// (test/contract/fixtures). A screen fails the tour if it throws, overflows on
// a phone-sized screen, shows an error, or asks for something the recording
// doesn't have.

String _raw(String name) => File('test/contract/fixtures/$name.json').readAsStringSync();

/// The first record's id in a recorded list.
String _firstId(String name) {
  final rows = (jsonDecode(_raw(name)) as Map<String, dynamic>)['data'] as List<dynamic>;
  return (rows.first as Map<String, dynamic>)['id'] as String;
}

FakeApi recordedApi({required String reportSites}) {
  FakeRaw json(String name) => FakeRaw(_raw(name), contentType: 'application/json');
  return FakeApi()
    ..on('GET', '/dashboard/admin', (_) => json('dashboard_admin'))
    ..on('GET', '/dashboard/engineer', (_) => json('dashboard_engineer'))
    ..on('GET', '/me/today', (_) => json('staff_today'))
    ..on('GET', '/sites', (_) => json('sites'))
    ..on('GET', '/sites/:id', (_) => json('site_detail'))
    ..on('GET', '/sites/:id/day', (_) => json('site_day'))
    ..on('GET', '/sites/:id/money', (_) => json('site_money'))
    ..on('GET', '/clients', (_) => json('clients'))
    ..on('GET', '/clients/:id', (_) => json('client_detail'))
    ..on('GET', '/engineers', (_) => json('engineers'))
    ..on('GET', '/engineers/:id', (_) => json('engineer_detail'))
    ..on('GET', '/staff', (_) => json('staff'))
    ..on('GET', '/staff/:id', (_) => json('staff_detail'))
    ..on('GET', '/staff-updates', (_) => json('staff_updates'))
    ..on('GET', '/staff-updates/:id', (_) => json('staff_update_detail'))
    ..on(
      'GET',
      '/staff-updates/:id/image',
      (_) => {'url': 'http://api.test/files/photo', 'expiresAt': '2099-01-01T00:00:00Z'},
    )
    ..on('POST', '/staff-updates/:id/views', (_) => json('staff_update_detail'))
    ..on('GET', '/attendance', (_) => json('attendance'))
    ..on('GET', '/engineer-updates', (_) => json('engineer_updates'))
    ..on('GET', '/engineer-updates/:id', (_) => json('engineer_update_detail'))
    ..on('POST', '/engineer-updates/:id/views', (_) => json('engineer_update_detail'))
    ..on('GET', '/issues', (_) => json('issues'))
    ..on('GET', '/issues/:id', (_) => json('issue_detail'))
    ..on('GET', '/notifications', (_) => json('notifications'))
    ..on('GET', '/notifications/unread-count', (_) => {'count': 3})
    ..on('POST', '/me/devices', (_) => {'registered': true})
    ..on('GET', '/payments/summary', (_) => json('payments_summary'))
    ..on('GET', '/payments', (_) => json('payments'))
    ..on('GET', '/reports/sites', (_) => json(reportSites))
    ..on('GET', '/reports/staff', (_) => json('report_staff'))
    ..on('GET', '/reports/engineers', (_) => json('report_engineers'))
    ..on('GET', '/reports/payments', (_) => json('report_payments'));
}

Future<FakeApi> startTour(WidgetTester tester, FakeAuthRepository auth, {required String reportSites}) async {
  final api = recordedApi(reportSites: reportSites);
  await pumpSiteWorkApp(
    tester,
    auth: auth,
    api: api,
    overrides: [
      imageLoaderProvider.overrideWithValue(FakeImageLoader()),
      pushServiceProvider.overrideWithValue(FakePushService()),
    ],
  );
  return api;
}

/// Opens [location] and checks the screen came up cleanly.
Future<void> visit(WidgetTester tester, String location) async {
  GoRouter.of(tester.element(find.byType(Scaffold).first)).go(location);
  await tester.pumpAndSettle();
  expect(find.byType(ErrorView), findsNothing, reason: location);
}

/// Taps each chip in turn (e.g. report kinds) and checks each result.
Future<void> tapEach(WidgetTester tester, List<String> labels) async {
  for (final label in labels) {
    await tester.tap(find.widgetWithText(ChoiceChip, label));
    await tester.pumpAndSettle();
    expect(find.byType(ErrorView), findsNothing, reason: label);
  }
}

const siteTabs = ['today', 'overview', 'team', 'updates', 'issues', 'payments'];

void main() {
  final siteId = _firstId('sites');

  testWidgets('admin: every tab and detail screen renders the recorded data', (tester) async {
    final api = await startTour(tester, signedInAdmin(), reportSites: 'report_sites');
    for (final location in [
      '/admin/dashboard',
      '/admin/sites',
      '/admin/payments',
      '/admin/payments/all',
      '/admin/people',
      '/admin/notifications',
      '/admin/profile',
      for (final tab in siteTabs) '/admin/sites/$siteId?tab=$tab',
      '/admin/sites/$siteId/edit',
      '/admin/sites/clients/${_firstId('clients')}',
      '/admin/people/engineers/${_firstId('engineers')}',
      '/admin/people/staff/${_firstId('staff')}',
      '/admin/staff-updates/${_firstId('staff_updates')}',
      '/admin/review',
      '/admin/updates/${_firstId('engineer_updates')}',
      '/admin/issues',
      '/admin/issues/${_firstId('issues')}',
      '/admin/reports',
    ]) {
      await visit(tester, location);
    }
    await tapEach(tester, ['Staff', 'Engineers', 'Payments', 'Sites']);
    expect(api.unanswered, isEmpty);
  });

  testWidgets('engineer: every tab and detail screen renders the recorded data', (tester) async {
    final api = await startTour(tester, signedInEngineer(), reportSites: 'report_sites_engineer');
    for (final location in [
      '/engineer/dashboard',
      '/engineer/sites',
      '/engineer/updates',
      '/engineer/updates/new',
      '/engineer/issues',
      '/engineer/notifications',
      '/engineer/profile',
      for (final tab in siteTabs) '/engineer/sites/$siteId?tab=$tab',
      '/engineer/staff-updates/${_firstId('staff_updates')}',
      '/engineer/review',
      '/engineer/updates/${_firstId('engineer_updates')}',
      '/engineer/issues/${_firstId('issues')}',
      '/engineer/issues/new',
      '/engineer/reports',
    ]) {
      await visit(tester, location);
    }
    await tapEach(tester, ['Staff', 'Sites']);
    expect(api.unanswered, isEmpty);
    // The tour leaves and re-enters the tab shell; the phone registers once.
    expect(api.sent('POST', '/me/devices'), hasLength(1));
  });

  testWidgets('staff: every tab renders the recorded data', (tester) async {
    final api = await startTour(tester, signedInStaff(), reportSites: 'report_sites');
    for (final location in [
      '/staff/dashboard',
      '/staff/attendance',
      '/staff/updates',
      '/staff/history',
      '/staff/profile',
      '/staff/notifications',
    ]) {
      await visit(tester, location);
    }
    expect(api.unanswered, isEmpty);
  });
}
