import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sitework/core/media/image_picker_provider.dart';
import 'package:sitework/core/network/image_loader.dart';

import '../helpers/admin_fixtures.dart';
import '../helpers/engineer_fixtures.dart';
import '../helpers/fake_api.dart';
import '../helpers/fake_auth_repository.dart';
import '../helpers/pump_app.dart';
import '../helpers/staff_fixtures.dart';

// Stock forms against responses recorded from the real API (seed data).

Map<String, dynamic> _fixture(String name) =>
    jsonDecode(File('test/contract/fixtures/$name.json').readAsStringSync()) as Map<String, dynamic>;

Map<String, dynamic> _data(String name) => _fixture(name)['data'] as Map<String, dynamic>;

final _siteStock = _data('site_stock');
final _overview = _data('stock_overview');
final _siteId = (_siteStock['site'] as Map<String, dynamic>)['id'] as String;

FakeApi _stockApi() {
  FakeRaw json(String name) =>
      FakeRaw(File('test/contract/fixtures/$name.json').readAsStringSync(), contentType: 'application/json');
  final entry = _data('stock_entry_detail');
  return FakeApi()
    ..on('GET', '/dashboard/admin', (_) => json('dashboard_admin'))
    ..on('GET', '/dashboard/engineer', (_) => json('dashboard_engineer'))
    ..on('GET', '/notifications/unread-count', (_) => {'count': 0})
    ..on('POST', '/me/devices', (_) => {'registered': true})
    ..on('GET', '/sites/:id', (_) => json('site_detail'))
    ..on('GET', '/sites/:id/stock', (_) => json('site_stock'))
    ..on('GET', '/stock/overview', (_) => json('stock_overview'))
    ..on('GET', '/stock/godowns/:id', (_) => json('godown_stock'))
    ..on('POST', '/stock/usage', (_) => entry)
    ..on('POST', '/stock/purchases', (_) => entry)
    ..on('POST', '/stock/entries/:id/receive', (_) => entry);
}

Future<FakeApi> _open(WidgetTester tester, FakeAuthRepository auth, String location) async {
  final api = _stockApi();
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

void main() {
  testWidgets('an engineer records the day’s usage from the site’s Stock tab', (tester) async {
    final api = await _open(tester, signedInEngineer(), '/engineer/sites/$_siteId?tab=stock');
    final item = (_siteStock['items'] as List<dynamic>).first as Map<String, dynamic>;
    final material = item['material'] as Map<String, dynamic>;

    await _tap(tester, find.widgetWithText(FilledButton, 'Record usage'));
    await _choose(tester, 'Material', material['name'] as String);
    expect(find.textContaining('Available:'), findsOneWidget);
    await tester.enterText(find.widgetWithText(TextFormField, 'Quantity'), '5');
    await tester.enterText(find.widgetWithText(TextFormField, 'Used for, e.g. first floor slab (optional)'), 'Slab');
    await _tap(tester, find.widgetWithText(FilledButton, 'Record usage'));

    final body = api.sent('POST', '/stock/usage').single.json;
    expect(body['siteId'], _siteId);
    expect(body['lines'], [
      {'materialId': material['id'], 'quantity': '5'},
    ]);
    expect(body['note'], 'Slab');
    expect(body['requestId'], matches(RegExp(r'^[0-9a-f-]{36}$')));
    expect(find.text('Stock saved.'), findsOneWidget);
  });

  testWidgets('a delivery is confirmed only with a photo, with what arrived of each material', (tester) async {
    final api = await _open(tester, signedInAdmin(), '/admin/sites/$_siteId?tab=stock');
    final arriving = (_siteStock['arriving'] as List<dynamic>).first as Map<String, dynamic>;
    final lines = arriving['lines'] as List<dynamic>;

    await _tap(tester, find.widgetWithText(FilledButton, 'Confirm').first);
    expect(find.text('What arrived'), findsOneWidget);
    await _tap(tester, find.widgetWithText(FilledButton, 'Confirm received'));
    expect(find.text('Add at least one photo of what arrived.'), findsOneWidget);
    expect(api.sent('POST', '/stock/entries/${arriving['id']}/receive'), isEmpty);

    await _tap(tester, find.text('Add photo'));
    await _tap(tester, find.text('Camera'));
    await _tap(tester, find.widgetWithText(FilledButton, 'Confirm received'));

    final form = api.sent('POST', '/stock/entries/${arriving['id']}/receive').single.body! as FormData;
    final fields = Map.fromEntries(form.fields);
    expect(jsonDecode(fields['lines']!), [
      for (final line in lines.cast<Map<String, dynamic>>())
        {'materialId': (line['material'] as Map<String, dynamic>)['id'], 'receivedQuantity': line['quantity']},
    ]);
    expect(form.files.map((f) => f.key), ['photos']);
    expect(find.text('Stock received.'), findsOneWidget);
  });

  testWidgets('an admin buys stock into a godown, with the price per unit', (tester) async {
    final api = await _open(tester, signedInAdmin(), '/admin/stock');
    final godown =
        ((_overview['godowns'] as List<dynamic>).first as Map<String, dynamic>)['godown'] as Map<String, dynamic>;
    final material =
        ((_overview['materials'] as List<dynamic>).first as Map<String, dynamic>)['material'] as Map<String, dynamic>;

    await _tap(tester, find.widgetWithText(FilledButton, 'Stock in'));
    await _choose(tester, 'Into godown', 'Godown · ${godown['name']}');
    await _choose(tester, 'Material', material['name'] as String);
    await tester.enterText(find.widgetWithText(TextFormField, 'Quantity'), '10');
    await tester.enterText(find.widgetWithText(TextFormField, 'Price per ${material['unit']} (₹)'), '380');
    await tester.enterText(find.widgetWithText(TextFormField, 'Supplier (optional)'), 'Ramco');
    await _tap(tester, find.widgetWithText(FilledButton, 'Stock in'));

    final form = api.sent('POST', '/stock/purchases').single.body! as FormData;
    final fields = Map.fromEntries(form.fields);
    expect(fields['godownId'], godown['id']);
    expect(fields['supplier'], 'Ramco');
    expect(jsonDecode(fields['lines']!), [
      {'materialId': material['id'], 'quantity': '10', 'rate': '380'},
    ]);
    expect(find.text('Stock saved.'), findsOneWidget);
  });
}
