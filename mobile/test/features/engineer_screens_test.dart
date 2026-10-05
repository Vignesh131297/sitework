import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sitework/core/media/image_picker_provider.dart';
import 'package:sitework/core/network/image_loader.dart';

import '../helpers/admin_fixtures.dart';
import '../helpers/engineer_fixtures.dart';
import '../helpers/pump_app.dart';
import '../helpers/staff_fixtures.dart';

const tallScreen = Size(1080, 6000);

Finder navTab(String label) => find.descendant(of: find.byType(NavigationBar), matching: find.text(label));

Future<void> tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<EngineerWorld> pumpEngineer(WidgetTester tester, {EngineerWorld? world, FakeImageLoader? images}) async {
  final w = world ?? EngineerWorld();
  await pumpSiteWorkApp(
    tester,
    auth: signedInEngineer(),
    api: w.api,
    screenSize: tallScreen,
    overrides: [
      imageLoaderProvider.overrideWithValue(images ?? FakeImageLoader()),
      imagePickerProvider.overrideWithValue(FakeImagePicker(tinyPhoto())),
    ],
  );
  return w;
}

void main() {
  testWidgets('the dashboard leads to photos to review; showing one records the review', (tester) async {
    final images = FakeImageLoader();
    final world = await pumpEngineer(tester, images: images);

    expect(find.text('Your sites'), findsOneWidget);
    expect(find.text('1 person not checked in: Kumar'), findsOneWidget);

    await tap(tester, find.text('Photos to review'));
    expect(world.api.sent('GET', '/staff-updates').single.query, containsPair('pendingReview', 'true'));

    await tap(tester, find.text('Ravi Kumar · Morning'));
    expect(find.text('Ravi Kumar · Morning'), findsOneWidget, reason: 'the viewer title');
    expect(find.text('Plastering the first floor'), findsOneWidget);
    expect(images.requested.single, '/files/photo?expires=1&signature=x');
    expect(world.api.sent('POST', '/staff-updates/upd-1/views'), hasLength(1));
  });

  testWidgets('a deleted photo explains itself and records nothing', (tester) async {
    final world = EngineerWorld()..photoDeleted = true;
    await pumpEngineer(tester, world: world);
    unawaited(GoRouter.of(tester.element(find.byType(NavigationBar))).push('/engineer/staff-updates/upd-1'));
    await tester.pumpAndSettle();

    expect(find.textContaining('This photo has been deleted.'), findsOneWidget);
    expect(world.api.sent('POST', '/staff-updates/upd-1/views'), isEmpty);
  });

  testWidgets('the site board shows each person’s day and opens a sent update', (tester) async {
    final world = await pumpEngineer(tester);
    await tap(tester, navTab('Sites'));
    await tap(tester, find.text('ABC Apartment Project'));

    expect(find.text('Today'), findsWidgets);
    expect(find.text('Kumar'), findsOneWidget);
    expect(find.text('To review'), findsOneWidget);
    expect(find.byTooltip('Edit site'), findsNothing, reason: 'engineers do not edit sites');

    await tap(tester, find.text('To review'));
    expect(find.text('Plastering the first floor'), findsOneWidget);
    // The board reloads after the review, to show it done.
    expect(world.api.sent('GET', '/sites/site-1/day'), isNotEmpty);
  });

  testWidgets('an engineer reports progress with a photo', (tester) async {
    final world = await pumpEngineer(tester);
    await tap(tester, navTab('Updates'));
    await tap(tester, find.text('New update'));

    await tap(tester, find.ancestor(of: find.text('Site'), matching: find.byType(DropdownButtonFormField<String>)));
    await tap(tester, find.text('ABC Apartment Project').last);
    expect(find.text('Site progress: 40%'), findsOneWidget, reason: 'starts from the site’s progress');
    await tester.enterText(find.widgetWithText(TextFormField, 'Description'), 'Slab concreting done');
    await tap(tester, find.text('Add photo'));
    await tap(tester, find.text('Camera'));
    await tap(tester, find.widgetWithText(FilledButton, 'Send'));

    final form = world.api.sent('POST', '/engineer-updates').single.body! as FormData;
    final fields = Map.fromEntries(form.fields);
    expect(fields, containsPair('siteId', 'site-1'));
    expect(fields, containsPair('type', 'PROGRESS'));
    expect(fields, containsPair('priority', 'MEDIUM'));
    expect(fields, containsPair('progressPercent', '40'));
    expect(fields.containsKey('title'), isFalse);
    expect(form.files.map((f) => f.key), ['photos']);
    expect(find.text('Update sent to the admin.'), findsOneWidget);
  });

  testWidgets('an issue is reported, worked on and resolved with a note', (tester) async {
    final world = await pumpEngineer(tester);
    await tap(tester, navTab('Issues'));
    await tap(tester, find.text('Report issue'));

    await tap(tester, find.ancestor(of: find.text('Site'), matching: find.byType(DropdownButtonFormField<String>)));
    await tap(tester, find.text('ABC Apartment Project').last);
    await tester.enterText(find.widgetWithText(TextFormField, 'Title'), 'Seepage in basement');
    await tester.enterText(find.widgetWithText(TextFormField, 'Description'), 'North wall after rain');
    await tap(tester, find.text('High'));
    await tap(tester, find.widgetWithText(FilledButton, 'Report issue'));

    final form = world.api.sent('POST', '/issues').single.body! as FormData;
    expect(Map.fromEntries(form.fields), containsPair('priority', 'HIGH'));
    expect(find.text('Issue reported.'), findsOneWidget);

    await tap(tester, find.text('Start work'));
    expect(world.api.sent('PATCH', '/issues/iss-1').last.json, {'status': 'IN_PROGRESS'});

    await tap(tester, find.widgetWithText(FilledButton, 'Mark resolved'));
    await tester.enterText(find.widgetWithText(TextFormField, 'What was done?'), 'Waterproofing applied');
    await tap(tester, find.descendant(of: find.byType(AlertDialog), matching: find.text('Mark resolved')));
    expect(world.api.sent('PATCH', '/issues/iss-1').last.json, {
      'status': 'RESOLVED',
      'resolutionNote': 'Waterproofing applied',
    });
    expect(find.text('Waterproofing applied'), findsOneWidget);
    expect(find.text('Reopen'), findsNothing, reason: 'only admins reopen');
  });

  testWidgets('an admin opening an engineer update marks it seen', (tester) async {
    final world = EngineerWorld();
    world.api.on('GET', '/dashboard/admin', (_) => dashboardJson());
    await pumpSiteWorkApp(
      tester,
      auth: signedInAdmin(),
      api: world.api,
      screenSize: tallScreen,
      overrides: [imageLoaderProvider.overrideWithValue(FakeImageLoader())],
    );
    unawaited(GoRouter.of(tester.element(find.byType(NavigationBar))).push('/admin/updates/eu-1'));
    await tester.pumpAndSettle();

    expect(find.text('Slab concreting done'), findsOneWidget);
    expect(world.api.sent('POST', '/engineer-updates/eu-1/views'), hasLength(1));
  });
}
