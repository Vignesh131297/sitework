import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sitework/core/media/image_picker_provider.dart';
import 'package:sitework/core/network/image_loader.dart';
import 'package:sitework/features/auth/domain/app_session.dart';
import 'package:sitework/features/auth/domain/auth_models.dart';
import 'package:sitework/features/auth/domain/user_role.dart';

import '../helpers/admin_fixtures.dart';
import '../helpers/engineer_fixtures.dart';
import '../helpers/fake_api.dart';
import '../helpers/fake_auth_repository.dart';
import '../helpers/pump_app.dart';
import '../helpers/staff_fixtures.dart';

// Material requests, from asking to closing, against responses recorded from
// the real API (seed data): a site asks, an admin approves or rejects, the
// godown's manager sends it, and the site closes it returning the leftover.

Map<String, dynamic> _envelope(String name) =>
    jsonDecode(File('test/contract/fixtures/$name.json').readAsStringSync()) as Map<String, dynamic>;

Map<String, dynamic> _data(String name) => _envelope(name)['data'] as Map<String, dynamic>;

Map<String, dynamic> _map(Object? value) => value! as Map<String, dynamic>;

/// The pending request (first in the list) and an approved one with a delivery.
final _pending = _map((_envelope('material_requests')['data'] as List<dynamic>).first);
final _approved = _data('material_request_detail');
final _siteId = _map(_data('site_stock')['site'])['id'] as String;

FakeApi _api({required Map<String, dynamic> request}) {
  FakeRaw json(String name) =>
      FakeRaw(File('test/contract/fixtures/$name.json').readAsStringSync(), contentType: 'application/json');
  final entry = _data('stock_entry_detail');
  return FakeApi()
    ..on('GET', '/dashboard/admin', (_) => json('dashboard_admin'))
    ..on('GET', '/dashboard/engineer', (_) => json('dashboard_engineer'))
    ..on('GET', '/dashboard/godown', (_) => json('dashboard_godown'))
    ..on('GET', '/notifications/unread-count', (_) => {'count': 0})
    ..on('POST', '/me/devices', (_) => {'registered': true})
    ..on('GET', '/sites/:id', (_) => json('site_detail'))
    ..on('GET', '/sites/:id/stock', (_) => json('site_stock'))
    ..on('GET', '/stock/overview', (_) => json('stock_overview'))
    ..on('GET', '/stock/godowns/:id', (_) => json('godown_stock'))
    ..on('GET', '/material-requests', (_) => json('material_requests'))
    ..on('GET', '/material-requests/:id', (_) => request)
    ..on('POST', '/material-requests', (_) => _pending)
    ..on('POST', '/material-requests/:id/approve', (_) => {...request, 'status': 'APPROVED', 'canApprove': false})
    ..on('POST', '/material-requests/:id/reject', (_) => {...request, 'status': 'REJECTED', 'canApprove': false})
    ..on('POST', '/material-requests/:id/close', (_) => {...request, 'status': 'CLOSED', 'canClose': false})
    ..on('POST', '/stock/transfers', (_) => entry);
}

Future<FakeApi> _open(
  WidgetTester tester,
  FakeAuthRepository auth,
  String location, {
  required Map<String, dynamic> request,
}) async {
  final api = _api(request: request);
  await pumpSiteWorkApp(
    tester,
    auth: auth,
    api: api,
    screenSize: const Size(1080, 6000),
    overrides: [
      imageLoaderProvider.overrideWithValue(FakeImageLoader()),
      imagePickerProvider.overrideWithValue(FakeImagePicker(tinyPhoto())),
    ],
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

Future<void> _choose(WidgetTester tester, String label, String option) async {
  await _tap(tester, find.ancestor(of: find.text(label), matching: find.byType(DropdownButtonFormField<String>)).first);
  await _tap(tester, find.text(option).last);
}

/// Selvam, who runs the Main godown in the seed data.
FakeAuthRepository _signedInManager() {
  final manager = _map((_data('godown_stock')['managers'] as List<dynamic>).first);
  return FakeAuthRepository(
    saved: StoredSession(
      tokens: const AuthTokens(accessToken: 'a', refreshToken: 'r'),
      user: AppSession(userId: manager['id'] as String, name: manager['name'] as String, role: UserRole.godownManager),
    ),
  );
}

void main() {
  testWidgets("an engineer asks for material from the site's Stock tab", (tester) async {
    final api = await _open(tester, signedInEngineer(), '/engineer/sites/$_siteId?tab=stock', request: _pending);

    await _tap(tester, find.widgetWithText(FilledButton, 'Request material'));
    await _choose(tester, 'Material', 'Cement OPC 53');
    await _tap(tester, find.widgetWithText(FilledButton, 'Send request'));
    expect(api.sent('POST', '/material-requests'), isEmpty, reason: 'no quantity yet');

    await tester.enterText(find.widgetWithText(TextFormField, 'Quantity needed'), '100');
    await tester.enterText(find.widgetWithText(TextFormField, 'What is it for? (optional)'), 'Second floor slab');
    await _tap(tester, find.widgetWithText(FilledButton, 'Send request'));

    final body = api.sent('POST', '/material-requests').single.json;
    final cement = _map(
      (_data('stock_overview')['materials'] as List<dynamic>).cast<Map<String, dynamic>>().firstWhere(
        (m) => _map(m['material'])['name'] == 'Cement OPC 53',
      )['material'],
    );
    expect(body['siteId'], _siteId);
    expect(body['lines'], [
      {'materialId': cement['id'], 'quantity': '100'},
    ]);
    expect(body['note'], 'Second floor slab');
    expect(body['requestId'], matches(RegExp(r'^[0-9a-f-]{36}$')));
    // The new request opens.
    expect(find.text('${_pending['code']} sent for approval.'), findsOneWidget);
    expect(find.text(_pending['code'] as String), findsWidgets);
  });

  testWidgets('an admin approves a request from a godown, sending none of one material', (tester) async {
    final api = await _open(tester, signedInAdmin(), '/admin/requests/${_pending['id']}', request: _pending);
    final lines = (_pending['lines'] as List<dynamic>).cast<Map<String, dynamic>>();
    final godown = _map(_map((_data('stock_overview')['godowns'] as List<dynamic>).first)['godown']);

    await _tap(tester, find.widgetWithText(FilledButton, 'Approve'));
    expect(find.text('Approve ${_pending['code']}'), findsOneWidget);
    await _choose(tester, 'Send from godown', godown['name'] as String);
    expect(find.textContaining('In godown:'), findsWidgets);
    await tester.enterText(find.widgetWithText(TextFormField, 'Approved quantity').last, '0');
    await _tap(tester, find.widgetWithText(FilledButton, 'Approve'));

    final body = api.sent('POST', '/material-requests/${_pending['id']}/approve').single.json;
    expect(body['godownId'], godown['id']);
    expect(body['lines'], [
      {'materialId': _map(lines.first['material'])['id'], 'approvedQuantity': lines.first['quantity']},
      {'materialId': _map(lines.last['material'])['id'], 'approvedQuantity': '0'},
    ]);
    expect(find.text('${_pending['code']} approved. The godown will send it.'), findsOneWidget);
  });

  testWidgets('an admin rejects a request with a reason the site will see', (tester) async {
    final api = await _open(tester, signedInAdmin(), '/admin/requests/${_pending['id']}', request: _pending);

    await _tap(tester, find.widgetWithText(OutlinedButton, 'Reject'));
    await _tap(tester, find.widgetWithText(FilledButton, 'Reject'));
    expect(api.sent('POST', '/material-requests/${_pending['id']}/reject'), isEmpty, reason: 'a reason is needed');
    await tester.enterText(find.widgetWithText(TextFormField, 'Why? The site will see this.'), 'Use the stock on site');
    await _tap(tester, find.widgetWithText(FilledButton, 'Reject'));

    expect(api.sent('POST', '/material-requests/${_pending['id']}/reject').single.json, {
      'reason': 'Use the stock on site',
    });
    expect(find.text('${_pending['code']} rejected.'), findsOneWidget);
  });

  testWidgets("the godown's manager sends what is left on an approved request, with the DC photo", (tester) async {
    final api = await _open(tester, _signedInManager(), '/godown/requests/${_approved['id']}', request: _approved);
    final left = (_approved['lines'] as List<dynamic>).cast<Map<String, dynamic>>().firstWhere(
      (line) => num.parse(line['leftToSend'] as String) > 0,
    );

    await _tap(tester, find.widgetWithText(FilledButton, 'Send material'));
    final title = 'Send ${_approved['code']}';
    expect(find.text(title), findsWidgets);
    await tester.enterText(find.widgetWithText(TextFormField, 'DC number'), 'DC-0110');
    await _tap(tester, find.widgetWithText(FilledButton, title));
    expect(find.text('Add a photo of the delivery challan.'), findsOneWidget);
    expect(api.sent('POST', '/stock/transfers'), isEmpty);

    await _tap(tester, find.text('Add photo'));
    await _tap(tester, find.text('Camera'));
    await _tap(tester, find.widgetWithText(FilledButton, title));

    final form = api.sent('POST', '/stock/transfers').single.body! as FormData;
    final fields = Map.fromEntries(form.fields);
    expect(fields['fromGodownId'], _map(_approved['godown'])['id']);
    expect(fields['toSiteId'], _map(_approved['site'])['id']);
    expect(fields['materialRequestId'], _approved['id']);
    expect(fields['dcNumber'], 'DC-0110');
    expect(jsonDecode(fields['lines']!), [
      {'materialId': _map(left['material'])['id'], 'quantity': left['leftToSend']},
    ]);
    expect(form.files.map((f) => f.key), ['photos']);
  });

  testWidgets('the site closes a request, returning the leftover to the godown', (tester) async {
    final request = {..._approved, 'canSend': false, 'canClose': true};
    final api = await _open(tester, signedInEngineer(), '/engineer/requests/${request['id']}', request: request);
    final godownName = _map(request['godown'])['name'];

    await _tap(tester, find.widgetWithText(FilledButton, 'Close request'));
    await _tap(tester, find.text('Return the leftover to $godownName'));
    await tester.enterText(find.widgetWithText(TextFormField, 'Cement OPC 53'), '10');
    await tester.enterText(find.widgetWithText(TextFormField, 'M-Sand'), '0');
    await _tap(tester, find.widgetWithText(FilledButton, 'Close request'));

    final body = api.sent('POST', '/material-requests/${request['id']}/close').single.json;
    final cement = _map(
      (request['lines'] as List<dynamic>).cast<Map<String, dynamic>>().firstWhere(
        (line) => _map(line['material'])['name'] == 'Cement OPC 53',
      )['material'],
    );
    expect(body['outcome'], 'LEFTOVER_RETURNED');
    expect(body['returnRequestId'], matches(RegExp(r'^[0-9a-f-]{36}$')));
    expect(body['lines'], [
      {'materialId': cement['id'], 'quantity': '10'},
    ]);
    expect(find.text('${request['code']} closed.'), findsOneWidget);
  });

  testWidgets('the first admin signs up while no admin exists', (tester) async {
    final auth = FakeAuthRepository()..signUpIsOpen = true;
    await pumpSiteWorkApp(tester, auth: auth, api: FakeApi(), screenSize: const Size(1080, 4000));

    await _tap(tester, find.text('Set up SiteWork (first admin)'));
    await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'Owner');
    await tester.enterText(find.widgetWithText(TextFormField, 'Mobile number'), '9876500099');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'Owner@2026x');
    await tester.enterText(find.widgetWithText(TextFormField, 'Confirm new password'), 'Owner@2026x');
    await _tap(tester, find.widgetWithText(FilledButton, 'Create admin account'));

    expect(auth.current?.role, UserRole.admin);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
