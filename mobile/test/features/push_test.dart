import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sitework/core/network/image_loader.dart';
import 'package:sitework/features/notifications/push/push_service.dart';

import '../helpers/engineer_fixtures.dart';
import '../helpers/fake_push_service.dart';
import '../helpers/pump_app.dart';

const issuePush = PushArrival(
  title: 'New high issue: Seepage in basement',
  body: 'ABC Apartment Project · reported by Admin',
  data: {
    'notificationId': 'n-9',
    'type': 'ISSUE',
    'referenceType': 'ISSUE',
    'referenceId': 'iss-1',
    'siteId': 'site-1',
  },
);

Future<EngineerWorld> pumpWithPush(WidgetTester tester, FakePushService push) async {
  final world = EngineerWorld()
    ..api.on('POST', '/me/devices', (_) => {'registered': true})
    ..api.on('DELETE', '/me/devices', (_) => {'removed': 1});
  await pumpSiteWorkApp(
    tester,
    auth: signedInEngineer(),
    api: world.api,
    screenSize: const Size(1080, 6000),
    overrides: [pushServiceProvider.overrideWithValue(push), imageLoaderProvider.overrideWithValue(FakeImageLoader())],
  );
  return world;
}

void main() {
  testWidgets('the phone is registered for pushes, and removed on sign-out', (tester) async {
    final push = FakePushService();
    final world = await pumpWithPush(tester, push);
    expect(world.api.sent('POST', '/me/devices').single.json, {
      'fcmToken': 'fcm-token-1234567890abcdefghij',
      'platform': 'android',
    });

    // FCM rotates the token: the server hears about the new one.
    push.refreshes.add('fcm-token-rotated-000000000000');
    await tester.pumpAndSettle();
    expect(world.api.sent('POST', '/me/devices').last.json['fcmToken'], 'fcm-token-rotated-000000000000');

    await tester.tap(find.byTooltip('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Sign out'));
    await tester.pumpAndSettle();

    expect(world.api.sent('DELETE', '/me/devices').single.json, {'fcmToken': 'fcm-token-rotated-000000000000'});
    expect(find.text('Forgot password?'), findsOneWidget);
  });

  testWidgets('a push while the app is open shows a banner that opens its screen', (tester) async {
    final push = FakePushService();
    await pumpWithPush(tester, push);

    push.foreground.add(issuePush);
    await tester.pumpAndSettle();
    expect(find.text('New high issue: Seepage in basement'), findsOneWidget);

    await tester.tap(find.text('View'));
    await tester.pumpAndSettle();
    expect(find.text('North wall after rain'), findsOneWidget, reason: 'the issue opened');
  });

  testWidgets('tapping a notification opens its screen, also when it launched the app', (tester) async {
    final push = FakePushService(initial: issuePush);
    await pumpWithPush(tester, push);
    expect(find.text('North wall after rain'), findsOneWidget);
  });

  testWidgets('builds without Firebase settings get no push and carry on', (tester) async {
    final world = EngineerWorld();
    await pumpSiteWorkApp(tester, auth: signedInEngineer(), api: world.api, screenSize: const Size(1080, 6000));
    expect(world.api.sent('POST', '/me/devices'), isEmpty);
    expect(find.text('Your sites'), findsOneWidget);
  });
}
