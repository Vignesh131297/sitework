import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sitework/core/location/location_service.dart';
import 'package:sitework/core/media/image_picker_provider.dart';
import 'package:sitework/features/staff_updates/data/update_queue.dart';

import '../helpers/fake_api.dart';
import '../helpers/pump_app.dart';
import '../helpers/staff_fixtures.dart';

const tallScreen = Size(1080, 6000);

Finder navTab(String label) => find.descendant(of: find.byType(NavigationBar), matching: find.text(label));

Future<void> tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

class StaffWorld {
  StaffWorld() {
    api
      ..on('GET', '/me/today', (_) => todayJson(checkedIn: checkedIn, morning: morning))
      ..on('POST', '/attendance/check-in', (_) {
        checkedIn = true;
        return attendanceJson();
      })
      ..on('POST', '/staff-updates', (_) {
        morning = 'SUBMITTED';
        return staffUpdateJson();
      })
      ..on(
        'GET',
        '/staff-updates',
        (_) => FakePage([staffUpdateJson(), staffUpdateJson(id: 'upd-0', imageStatus: 'DELETED')]),
      )
      ..on('GET', '/attendance', (_) => FakePage([attendanceJson(checkOutAt: '2026-10-04T12:35:00.000Z')]))
      ..on('GET', '/notifications/unread-count', (_) => {'count': unread})
      ..on(
        'GET',
        '/notifications',
        (_) => FakePage([
          {
            'id': 'n-1',
            'type': 'MISSING_UPDATE',
            'title': 'Morning Update due by 12:00 PM',
            'message': 'Take a photo of your work and send it.',
            'referenceType': null,
            'referenceId': null,
            'data': {'date': '2026-10-05', 'slot': 'MORNING'},
            'isRead': unread == 0,
            'createdAt': DateTime.now().subtract(const Duration(minutes: 5)).toUtc().toIso8601String(),
          },
        ]),
      )
      ..on('POST', '/notifications/:id/read', (r) {
        unread = 0;
        return {'id': r.params['id']};
      });
  }

  final api = FakeApi();
  final location = FakeLocationService();
  final photo = tinyPhoto();
  late final picker = FakeImagePicker(photo);
  final queueDirectory = Directory.systemTemp.createTempSync('sitework-staff-queue-');
  var checkedIn = false;
  var morning = 'PENDING';
  var unread = 1;

  Future<void> pump(WidgetTester tester) async {
    addTearDown(() {
      try {
        queueDirectory.deleteSync(recursive: true);
      } on FileSystemException {
        // Windows keeps a file open until its stream is collected; it's a temp folder.
      }
    });
    await pumpSiteWorkApp(
      tester,
      auth: signedInStaff(),
      screenSize: tallScreen,
      api: api,
      overrides: [
        locationServiceProvider.overrideWithValue(location),
        imagePickerProvider.overrideWithValue(picker),
        pendingUpdatesDirectoryProvider.overrideWith((ref) => queueDirectory),
      ],
    );
  }
}

void main() {
  testWidgets('staff check in with their location, which opens the open slot', (tester) async {
    final world = StaffWorld();
    await world.pump(tester);

    expect(find.text('Hello, Ravi'), findsOneWidget);
    expect(find.text('ABC Apartment Project'), findsOneWidget);
    expect(find.text('Arun Kumar'), findsOneWidget);
    expect(find.text('Check in first to send this update.'), findsOneWidget);
    expect(tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Take photo')).onPressed, isNull);

    await tap(tester, find.widgetWithText(FilledButton, 'Check in'));

    expect(world.api.sent('POST', '/attendance/check-in').single.json, {
      'latitude': 13.0879,
      'longitude': 80.2009,
      'accuracyM': 12.0,
      'isMocked': false,
    });
    expect(find.text('Checked in. Have a good day!'), findsOneWidget);
    expect(tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Take photo')).onPressed, isNotNull);
  });

  testWidgets('without GPS the check-in still goes, marked with the reason', (tester) async {
    final world = StaffWorld()..location.result = const LocationResult.problem(LocationProblem.permissionDeniedForever);
    await world.pump(tester);

    await tap(tester, find.widgetWithText(FilledButton, 'Check in'));

    expect(world.api.sent('POST', '/attendance/check-in').single.json, {'locationProblem': 'PERMISSION_DENIED'});
    expect(find.text('Location access is blocked. Allow it in Settings.'), findsOneWidget);
  });

  group('with only approximate location allowed', () {
    const approximate = LocationResult.fix(
      LocationFix(latitude: 13.09, longitude: 80.21, accuracyM: 2000, isMocked: false, approximate: true),
    );
    const hint =
        'Only approximate location is allowed, so this may be marked away from the site. '
        'Turn on "Use precise location" for this app.';

    testWidgets('check-in still goes, and asks for precise location', (tester) async {
      final world = StaffWorld()..location.result = approximate;
      await world.pump(tester);

      await tap(tester, find.widgetWithText(FilledButton, 'Check in'));

      expect(world.api.sent('POST', '/attendance/check-in').single.json, containsPair('accuracyM', 2000.0));
      expect(find.text(hint), findsOneWidget);
      expect(find.widgetWithText(SnackBarAction, 'Open settings'), findsOneWidget);
    });

    testWidgets('the capture screen says so next to the location', (tester) async {
      final world = StaffWorld()
        ..checkedIn = true
        ..location.result = approximate;
      await world.pump(tester);

      await tap(tester, find.widgetWithText(FilledButton, 'Take photo'));

      expect(find.text(hint), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Open settings'), findsOneWidget);
    });
  });

  testWidgets('a photo update is taken, described and sent as the API expects', (tester) async {
    final world = StaffWorld()..checkedIn = true;
    await world.pump(tester);

    await tap(tester, find.widgetWithText(FilledButton, 'Take photo'));
    expect(find.text('Morning update'), findsOneWidget);
    expect(world.picker.sources, hasLength(1), reason: 'the camera opens straight away');

    await tap(tester, find.widgetWithText(FilledButton, 'Send update'));
    expect(find.text('Write a few words about the work.'), findsOneWidget);
    expect(world.api.sent('POST', '/staff-updates'), isEmpty);

    await tester.enterText(find.byType(TextFormField), 'Plastering the first floor');
    await tap(tester, find.widgetWithText(FilledButton, 'Send update'));

    final form = world.api.sent('POST', '/staff-updates').single.body! as FormData;
    final fields = Map.fromEntries(form.fields);
    expect(fields['slot'], 'MORNING');
    expect(fields['description'], 'Plastering the first floor');
    expect(fields['photoSource'], 'CAMERA');
    expect(fields['latitude'], '13.0879');
    expect(fields['clientSubmissionId'], matches(RegExp(r'^[0-9a-f-]{36}$')));
    expect(form.files.single.key, 'photo');
    expect(find.text('Morning update sent.'), findsOneWidget);
    expect(find.text('Hello, Ravi'), findsOneWidget);
    expect(world.queueDirectory.listSync().where((f) => f.path.endsWith('.json')), isEmpty);
  });

  testWidgets('offline, the update is kept on the phone and shown as waiting', (tester) async {
    final world = StaffWorld()..checkedIn = true;
    await world.pump(tester);
    await tap(tester, find.widgetWithText(FilledButton, 'Take photo'));
    await tester.enterText(find.byType(TextFormField), 'Shuttering the slab');

    world.api.offline = true;
    await tap(tester, find.widgetWithText(FilledButton, 'Send update'));

    expect(find.text('No connection. Your update is saved and will be sent automatically.'), findsOneWidget);
    expect(find.text('Waiting to send'), findsOneWidget);
    expect(find.text('Saved on this phone, waiting to send'), findsOneWidget);
    expect(world.queueDirectory.listSync(), hasLength(2));

    // Back online: "Send now" delivers it.
    world.api.offline = false;
    await tap(tester, find.text('Send now'));
    expect(find.text('Waiting to send'), findsNothing);
    expect(world.api.sent('POST', '/staff-updates'), hasLength(1));
    expect(world.queueDirectory.listSync().where((f) => f.path.endsWith('.json')), isEmpty);
  });

  testWidgets('a refusal is explained on the capture screen', (tester) async {
    final world = StaffWorld()..checkedIn = true;
    world.api.on(
      'POST',
      '/staff-updates',
      (_) => throw const FakeApiError(400, 'SLOT_CLOSED', 'The Morning update closed at 12:00 PM.'),
    );
    await world.pump(tester);
    await tap(tester, find.widgetWithText(FilledButton, 'Take photo'));
    await tester.enterText(find.byType(TextFormField), 'Late work');
    await tap(tester, find.widgetWithText(FilledButton, 'Send update'));

    expect(find.text('The Morning update closed at 12:00 PM.'), findsOneWidget);
    expect(find.text('Morning update'), findsOneWidget, reason: 'stays on the form');
    expect(world.queueDirectory.listSync().where((f) => f.path.endsWith('.json')), isEmpty);
  });

  testWidgets('history shows sent updates and what happened to each photo', (tester) async {
    final world = StaffWorld();
    await world.pump(tester);
    await tap(tester, navTab('History'));

    expect(find.text('Photo waiting for review'), findsOneWidget);
    expect(find.text('Photo reviewed and removed'), findsOneWidget);

    await tap(tester, navTab('Attendance'));
    expect(find.text('Past days'), findsOneWidget);
    expect(find.textContaining('Worked 9 h 0 min'), findsOneWidget);
  });

  testWidgets('the bell shows unread alerts; opening one marks it read', (tester) async {
    final world = StaffWorld();
    await world.pump(tester);
    expect(find.descendant(of: find.byType(Badge), matching: find.text('1')), findsOneWidget);

    await tap(tester, find.byTooltip('Notifications'));
    expect(find.text('Morning Update due by 12:00 PM'), findsOneWidget);
    expect(find.text('Take a photo of your work and send it.\n5 min ago'), findsOneWidget);

    await tap(tester, find.text('Morning Update due by 12:00 PM'));
    expect(world.api.sent('POST', '/notifications/n-1/read'), hasLength(1));
    expect(find.text('Hello, Ravi'), findsOneWidget, reason: 'a reminder opens the home screen');
  });
}
