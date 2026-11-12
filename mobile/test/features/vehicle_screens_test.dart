import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sitework/core/network/image_loader.dart';
import 'package:sitework/features/auth/domain/app_session.dart';
import 'package:sitework/features/auth/domain/auth_models.dart';
import 'package:sitework/features/auth/domain/user_role.dart';

import '../helpers/admin_fixtures.dart';
import '../helpers/engineer_fixtures.dart';
import '../helpers/fake_api.dart';
import '../helpers/fake_auth_repository.dart';
import '../helpers/pump_app.dart';

// Company vehicles, against responses recorded from the real API (seed data):
// an admin gives a free vehicle to someone and takes it back; the person who
// holds one asks for repair money; an admin decides.

Map<String, dynamic> _envelope(String name) =>
    jsonDecode(File('test/contract/fixtures/$name.json').readAsStringSync()) as Map<String, dynamic>;

Map<String, dynamic> _data(String name) => _envelope(name)['data'] as Map<String, dynamic>;

List<Map<String, dynamic>> _rows(String name) => (_envelope(name)['data'] as List<dynamic>).cast();

Map<String, dynamic> _map(Object? value) => value! as Map<String, dynamic>;

/// The first vehicle (with a holder), a free one, the waiting repair request.
final _held = _data('vehicle_detail');
final _free = _rows('vehicles').firstWhere((v) => v['holder'] == null && v['isActive'] == true);
final _pending = _rows('vehicle_repair_requests').firstWhere((r) => r['status'] == 'PENDING');
final _staffVehicle = _map(_data('vehicle_mine_staff')['vehicle']);

FakeApi _api() {
  FakeRaw json(String name) => FakeRaw(_raw(name), contentType: 'application/json');
  return FakeApi()
    ..on('GET', '/dashboard/admin', (_) => json('dashboard_admin'))
    ..on('GET', '/dashboard/engineer', (_) => json('dashboard_engineer'))
    ..on('GET', '/me/today', (_) => json('staff_today'))
    ..on('GET', '/notifications/unread-count', (_) => {'count': 0})
    ..on('POST', '/me/devices', (_) => {'registered': true})
    ..on('GET', '/leave-requests', (_) => json('leave_requests'))
    ..on('GET', '/staff-requests', (_) => json('staff_requests'))
    ..on('GET', '/staff', (_) => json('staff'))
    ..on('GET', '/engineers', (_) => json('engineers'))
    ..on(
      'GET',
      '/vehicles',
      (r) => r.query['status'] == 'FREE'
          ? {
              'data': [_free],
              'meta': _page,
            }
          : json('vehicles'),
    )
    // Later registrations are matched first, so "mine" comes after ":id".
    ..on('GET', '/vehicles/:id', (r) => r.params['id'] == _free['id'] ? {..._free, 'history': <Object>[]} : _held)
    ..on('GET', '/vehicles/mine', (_) => json('vehicle_mine_staff'))
    ..on('GET', '/sites/:id/stock', (_) => json('site_stock_staff'))
    ..on('POST', '/vehicles/:id/assign', (_) => _held)
    ..on('POST', '/vehicles/:id/return', (_) => {..._held, 'holder': null})
    ..on('GET', '/vehicle-repair-requests', (_) => json('vehicle_repair_requests'))
    ..on('GET', '/vehicle-repair-requests/:id', (_) => _pending)
    ..on('POST', '/vehicle-repair-requests', (_) => _pending)
    ..on(
      'POST',
      '/vehicle-repair-requests/:id/approve',
      (_) => {..._pending, 'status': 'APPROVED', 'canApprove': false},
    )
    ..on(
      'POST',
      '/vehicle-repair-requests/:id/reject',
      (_) => {..._pending, 'status': 'REJECTED', 'canApprove': false},
    );
}

const _page = {'page': 1, 'limit': 20, 'total': 1, 'totalPages': 1};

String _raw(String name) => File('test/contract/fixtures/$name.json').readAsStringSync();

Future<FakeApi> _open(WidgetTester tester, FakeAuthRepository auth, String location) async {
  final api = _api();
  await pumpSiteWorkApp(
    tester,
    auth: auth,
    api: api,
    screenSize: const Size(1080, 6000),
    overrides: [imageLoaderProvider.overrideWithValue(FakeImageLoader())],
  );
  unawaited(GoRouter.of(tester.element(find.byType(NavigationBar))).push(location));
  await tester.pumpAndSettle();
  return api;
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Ravi, who holds the Splendor in the seed data.
FakeAuthRepository _signedInHolder() {
  final holder = _map(_map(_staffVehicle['holder'])['user']);
  return FakeAuthRepository(
    saved: StoredSession(
      tokens: const AuthTokens(accessToken: 'a', refreshToken: 'r'),
      user: AppSession(userId: holder['id'] as String, name: holder['name'] as String, role: UserRole.staff),
    ),
  );
}

void main() {
  testWidgets('an admin gives a free vehicle to someone from its page', (tester) async {
    final api = await _open(tester, signedInAdmin(), '/admin/vehicles/${_free['id']}');
    expect(find.text('With nobody'), findsOneWidget);

    await _tap(tester, find.widgetWithText(FilledButton, 'Give to someone'));
    await _tap(tester, find.widgetWithText(FilledButton, 'Give vehicle'));
    expect(api.sent('POST', '/vehicles/${_free['id']}/assign'), isEmpty, reason: 'nobody chosen yet');

    final staff = _rows('staff').first;
    await _tap(
      tester,
      find.ancestor(of: find.text('Give to'), matching: find.byType(DropdownButtonFormField<String>)).first,
    );
    await _tap(tester, find.text('${staff['name']} · Staff · ${staff['employeeCode']}').last);
    await tester.enterText(find.widgetWithText(TextFormField, 'Note (optional)'), 'With helmet');
    await _tap(tester, find.widgetWithText(FilledButton, 'Give vehicle'));

    final body = api.sent('POST', '/vehicles/${_free['id']}/assign').single.json;
    expect(body['userId'], staff['id']);
    expect(body['givenOn'], matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
    expect(body['note'], 'With helmet');
    expect(find.textContaining('given to ${staff['name']}'), findsOneWidget);
  });

  testWidgets('an admin takes a vehicle back from its holder', (tester) async {
    final api = await _open(tester, signedInAdmin(), '/admin/vehicles/${_held['id']}');
    final holder = _map(_map(_held['holder'])['user']);
    expect(find.text('With ${holder['name']}'), findsOneWidget);

    await _tap(tester, find.widgetWithText(OutlinedButton, 'Take back'));
    await tester.enterText(find.widgetWithText(TextFormField, 'Note (optional)'), 'Moved sites');
    await _tap(tester, find.widgetWithText(FilledButton, 'Take back'));

    final body = api.sent('POST', '/vehicles/${_held['id']}/return').single.json;
    expect(body['returnedOn'], matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
    expect(body['note'], 'Moved sites');
    expect(find.textContaining('taken back'), findsOneWidget);
  });

  testWidgets('a staff member who holds a vehicle asks for repair money from Home', (tester) async {
    final api = await _open(tester, _signedInHolder(), '/staff/dashboard');
    // The card is below the day's updates.
    await tester.scrollUntilVisible(find.text('My vehicle'), 300, scrollable: find.byType(Scrollable).first);
    expect(find.text('My vehicle'), findsOneWidget);
    expect(find.text(_staffVehicle['makeModel'] as String), findsOneWidget);

    await _tap(tester, find.widgetWithText(FilledButton, 'Ask for repair money'));
    await _tap(tester, find.widgetWithText(FilledButton, 'Send for approval'));
    expect(api.sent('POST', '/vehicle-repair-requests'), isEmpty, reason: 'amount and reason needed');

    await tester.enterText(find.widgetWithText(TextFormField, 'Amount'), '850');
    await tester.enterText(find.widgetWithText(TextFormField, 'What needs repair?'), 'Rear tyre puncture');
    await _tap(tester, find.widgetWithText(FilledButton, 'Send for approval'));

    final body = api.sent('POST', '/vehicle-repair-requests').single.json;
    expect(body['amount'], '850');
    expect(body['note'], 'Rear tyre puncture');
    expect(body['requestId'], matches(RegExp(r'^[0-9a-f-]{36}$')));
    expect(find.text('${_pending['code']} sent for approval.'), findsOneWidget);
  });

  testWidgets('an admin approves repair money with a note', (tester) async {
    final api = await _open(tester, signedInAdmin(), '/admin/vehicle-repairs/${_pending['id']}');
    expect(find.text('₹850 for repair'), findsOneWidget);

    await _tap(tester, find.widgetWithText(FilledButton, 'Approve'));
    await tester.enterText(find.widgetWithText(TextFormField, 'Note (optional)'), 'Keep the bill');
    // The dialog's button, above the screen's.
    await _tap(tester, find.widgetWithText(FilledButton, 'Approve').last);

    expect(api.sent('POST', '/vehicle-repair-requests/${_pending['id']}/approve').single.json, {
      'note': 'Keep the bill',
    });
    expect(find.text('${_pending['code']} approved.'), findsOneWidget);
  });
}
