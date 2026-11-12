import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/admin_fixtures.dart';
import '../helpers/fake_api.dart';
import '../helpers/pump_app.dart';

const tallScreen = Size(1080, 7200);

Finder navTab(String label) => find.descendant(of: find.byType(NavigationBar), matching: find.text(label));

Future<void> tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> fill(WidgetTester tester, String label, String text) async {
  await tester.enterText(find.widgetWithText(TextFormField, label), text);
  await tester.pump();
}

/// Opens the dropdown labelled [label] and picks [option].
Future<void> choose(WidgetTester tester, String label, String option) async {
  await tap(tester, find.ancestor(of: find.text(label), matching: find.byType(DropdownButtonFormField<String>)));
  await tap(tester, find.text(option).last);
}

Future<FakeApi> pumpAdmin(WidgetTester tester, {FakeApi? api, Size screenSize = const Size(1080, 2400)}) async {
  final fake = api ?? adminApi();
  await pumpSiteWorkApp(tester, auth: signedInAdmin(), api: fake, screenSize: screenSize);
  return fake;
}

void main() {
  testWidgets('the dashboard summarizes the day and opens what needs attention', (tester) async {
    await pumpAdmin(tester, screenSize: tallScreen);

    expect(find.text('Active sites'), findsOneWidget);
    expect(find.text('₹24,50,000'), findsOneWidget);
    expect(find.text('5 of 9 submitted'), findsWidgets);
    expect(find.text("Today's site activity"), findsOneWidget);
    expect(find.text('2 missing updates: Ravi, Kumar'), findsOneWidget);
    expect(find.textContaining('Overdue: Foundation'), findsOneWidget);

    await tap(tester, find.text('2 missing updates: Ravi, Kumar'));
    // Missed updates open the site's staff board for today.
    expect(find.text('Kumar'), findsOneWidget);
    expect(find.text('Not checked in'), findsOneWidget);
    expect(find.text('To review'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Attention required'), findsOneWidget);
  });

  testWidgets('sites filter by status and show a site’s team and money', (tester) async {
    final api = await pumpAdmin(tester);
    await tap(tester, navTab('Sites'));
    expect(find.text('Green Villa'), findsOneWidget);

    await tap(tester, find.widgetWithText(ChoiceChip, 'On hold'));
    expect(api.sent('GET', '/sites').last.query, containsPair('status', 'ON_HOLD'));

    await tap(tester, find.text('ABC Apartment Project'));
    await tap(tester, find.widgetWithText(Tab, 'Overview'));
    expect(find.text('Progress 40%'), findsOneWidget);
    expect(find.text('Suresh · +919800000002'), findsOneWidget);

    await tap(tester, find.widgetWithText(Tab, 'Team'));
    expect(find.text('Arun Kumar'), findsOneWidget);
    expect(find.text('Mason · Reports to Arun Kumar'), findsOneWidget);

    await tap(tester, find.widgetWithText(Tab, 'Payments'));
    expect(find.text('Foundation'), findsOneWidget);
    expect(find.text('₹25,00,000'), findsOneWidget);
    expect(find.text('Overdue'), findsWidgets);
  });

  testWidgets('a new site is validated, sent as the API expects, then opened', (tester) async {
    final api = adminApi()
      ..on('POST', '/sites', (_) => siteDetailJson(id: 'site-9', name: 'New Tower'))
      ..on('GET', '/sites/site-9', (_) => siteDetailJson(id: 'site-9', name: 'New Tower'));
    await pumpAdmin(tester, api: api, screenSize: tallScreen);
    await tap(tester, navTab('Sites'));
    await tap(tester, find.text('New site'));

    await tap(tester, find.widgetWithText(FilledButton, 'Save'));
    expect(find.text('Required'), findsWidgets);
    expect(api.sent('POST', '/sites'), isEmpty);

    await fill(tester, 'Site name', 'New Tower');
    await choose(tester, 'Client', 'Mr. Rajesh');
    await fill(tester, 'Address', 'OMR, Chennai');
    await tap(tester, find.ancestor(of: find.text('Start date'), matching: find.byType(InputDecorator)));
    await tap(tester, find.text('OK'));
    await fill(tester, 'Contract amount', '2500000');
    await tap(tester, find.widgetWithText(FilledButton, 'Save'));

    final body = api.sent('POST', '/sites').single.json;
    expect(body, containsPair('name', 'New Tower'));
    expect(body, containsPair('clientId', 'client-1'));
    expect(body, containsPair('contractAmount', '2500000'));
    expect(body, containsPair('status', 'NOT_STARTED'));
    expect(body['startDate'], matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
    // Left empty, the server picks the code and the radius.
    expect(body.containsKey('code'), isFalse);
    expect(body.containsKey('geofenceRadiusM'), isFalse);
    expect(find.text('Site saved.'), findsOneWidget);
    expect(find.widgetWithText(AppBar, 'New Tower'), findsOneWidget);
  });

  testWidgets('deactivating a staff member asks first, then shows them inactive', (tester) async {
    var active = true;
    final api = adminApi()
      ..on('GET', '/staff/:id', (r) => personDetailJson(id: r.params['id']!, isActive: active))
      ..on('PATCH', '/staff/:id/status', (r) {
        active = r.json['isActive'] as bool;
        return personDetailJson(isActive: active);
      });
    await pumpAdmin(tester, api: api);
    await tap(tester, navTab('People'));
    await tap(tester, find.widgetWithText(Tab, 'Staff'));
    await tap(tester, find.text('Ravi'));

    await tap(tester, find.byTooltip('More actions'));
    await tap(tester, find.text('Deactivate'));
    expect(find.text('Deactivate Ravi?'), findsOneWidget);
    await tap(tester, find.widgetWithText(FilledButton, 'Deactivate'));

    expect(api.sent('PATCH', '/staff/staff-1/status').single.json, {'isActive': false});
    expect(find.text('Ravi has been deactivated.'), findsOneWidget);
    expect(find.text("This account is deactivated. They can't sign in."), findsOneWidget);
  });

  testWidgets('a new engineer gets a one-time temporary password', (tester) async {
    final api = adminApi()
      ..on(
        'POST',
        '/engineers',
        (_) => {
          'person': personDetailJson(id: 'eng-3', role: 'ENGINEER', name: 'Selvam'),
          'temporaryPassword': 'Temp-4821-xk',
        },
      )
      ..on('GET', '/engineers/:id', (r) => personDetailJson(id: r.params['id']!, role: 'ENGINEER', name: 'Selvam'));
    await pumpAdmin(tester, api: api, screenSize: tallScreen);
    await tap(tester, navTab('People'));
    await tap(tester, find.text('New engineer'));

    await fill(tester, 'Name', 'Selvam');
    await fill(tester, 'Mobile number', '90000 00012');
    await tap(tester, find.widgetWithText(FilterChip, 'ABC Apartment Project'));
    await tap(tester, find.widgetWithText(FilledButton, 'Save'));

    final body = api.sent('POST', '/engineers').single.json;
    expect(body, containsPair('siteIds', ['site-1']));
    expect(body.containsKey('employeeCode'), isFalse);
    expect(find.text('Temp-4821-xk'), findsOneWidget);

    await tap(tester, find.widgetWithText(FilledButton, 'OK'));
    expect(find.widgetWithText(AppBar, 'Selvam'), findsOneWidget);
    expect(find.text('ABC Apartment Project'), findsOneWidget);
  });

  testWidgets('an unassigned staff member is put on a site under a chosen engineer', (tester) async {
    var assigned = false;
    final api = adminApi()
      ..on(
        'GET',
        '/sites',
        (_) => FakePage([
          siteSummaryJson(engineers: const [arun, prakash]),
        ]),
      )
      ..on('GET', '/staff', (_) => FakePage([personJson(id: 'staff-2', name: 'Kumar', assigned: false)]))
      ..on('GET', '/staff/:id', (r) => personDetailJson(id: r.params['id']!, name: 'Kumar', assigned: assigned))
      ..on('PUT', '/staff/:id/assignment', (r) {
        assigned = true;
        return personDetailJson(id: r.params['id']!, name: 'Kumar');
      });
    await pumpAdmin(tester, api: api);
    await tap(tester, navTab('People'));
    await tap(tester, find.widgetWithText(Tab, 'Staff'));
    await tap(tester, find.text('Kumar'));
    expect(find.text('Not assigned to a site'), findsOneWidget);

    await tap(tester, find.text('Assign to site'));
    await choose(tester, 'Site', 'ABC Apartment Project');
    await choose(tester, 'Engineer', 'Prakash');
    await tap(tester, find.widgetWithText(FilledButton, 'Assign'));

    expect(api.sent('PUT', '/staff/staff-2/assignment').single.json, {'siteId': 'site-1', 'engineerId': 'eng-2'});
    expect(find.text('Kumar assigned to ABC Apartment Project.'), findsOneWidget);
    expect(find.text('Change site'), findsOneWidget);
  });

  testWidgets('a server rule violation is explained without losing the form', (tester) async {
    final api = adminApi()
      ..on(
        'PATCH',
        '/sites/:id',
        (_) => throw const FakeApiError(
          400,
          'CONTRACT_BELOW_RECEIVED',
          'The contract amount cannot be less than what has already been received.',
        ),
      );
    await pumpAdmin(tester, api: api, screenSize: tallScreen);
    await tap(tester, navTab('Sites'));
    await tap(tester, find.text('ABC Apartment Project'));
    await tap(tester, find.byTooltip('Edit site'));

    await fill(tester, 'Contract amount', '100');
    await tap(tester, find.widgetWithText(FilledButton, 'Save'));

    expect(api.sent('PATCH', '/sites/site-1').single.json, containsPair('contractAmount', '100'));
    expect(find.text('The contract amount cannot be less than what has already been received.'), findsOneWidget);
    expect(find.widgetWithText(AppBar, 'Edit site'), findsOneWidget);
  });
}
