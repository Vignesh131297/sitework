import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sitework/core/config/app_config.dart';
import 'package:sitework/core/network/app_exception.dart';
import 'package:sitework/features/auth/domain/app_session.dart';
import 'package:sitework/features/auth/domain/auth_models.dart';
import 'package:sitework/features/auth/domain/user_role.dart';

import 'helpers/fake_api.dart';
import 'helpers/fake_auth_repository.dart';
import 'helpers/pump_app.dart';

Future<void> tapText(WidgetTester tester, String text) async {
  await tester.ensureVisible(find.text(text).first);
  await tester.tap(find.text(text).first);
  await tester.pumpAndSettle();
}

Future<void> signIn(WidgetTester tester, String identifier, String password) async {
  await tester.enterText(find.widgetWithText(TextFormField, 'Mobile number or e-mail'), identifier);
  await tester.enterText(find.widgetWithText(TextFormField, 'Password'), password);
  await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('starts at sign-in when no session is saved', (tester) async {
    await pumpSiteWorkApp(tester);

    expect(find.widgetWithText(FilledButton, 'Sign in'), findsOneWidget);
    expect(find.text('Server connected'), findsOneWidget);
  });

  testWidgets('validates the form and explains wrong credentials', (tester) async {
    await pumpSiteWorkApp(tester);

    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();
    expect(find.text('Enter your mobile number or e-mail.'), findsOneWidget);
    expect(find.text('Enter your password.'), findsOneWidget);

    await signIn(tester, '+919000000101', 'wrong-password1');
    expect(find.text('The mobile number/e-mail or password is incorrect.'), findsOneWidget);
  });

  testWidgets('staff signs in, lands on their tabs, sees their profile and signs out', (tester) async {
    final auth = await pumpSiteWorkApp(tester);

    await signIn(tester, '+919000000101', FakeAuthRepository.password);
    for (final tab in ['Home', 'Attendance', 'Updates', 'History', 'Profile']) {
      expect(find.text(tab), findsWidgets, reason: tab);
    }

    await tapText(tester, 'Profile');
    expect(find.text('Ravi'), findsOneWidget);
    expect(find.text('ABC Apartment Project\nAnna Nagar'), findsOneWidget);
    expect(find.text('Arun Kumar\n+919000000011'), findsOneWidget);

    await tapText(tester, 'Sign out');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign out'));
    await tester.pumpAndSettle();

    expect(auth.signOuts, 1);
    expect(find.text('Forgot password?'), findsOneWidget);
  });

  testWidgets('a temporary password must be replaced before anything else', (tester) async {
    final auth = FakeAuthRepository(
      accounts: {'+919000000101': FakeAuthRepository.ravi.copyWith(mustChangePassword: true)},
    );
    await pumpSiteWorkApp(tester, auth: auth);

    await signIn(tester, '+919000000101', FakeAuthRepository.password);
    expect(find.textContaining('temporary password'), findsWidgets);
    expect(find.text('Home'), findsNothing);

    await tester.enterText(find.widgetWithText(TextFormField, 'Temporary password'), FakeAuthRepository.password);
    await tester.enterText(find.widgetWithText(TextFormField, 'New password'), 'short');
    await tester.enterText(find.widgetWithText(TextFormField, 'Confirm new password'), 'short');
    await tapText(tester, 'Save password');
    expect(find.text('Use at least 8 characters.'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, 'New password'), 'Mine2026pass');
    await tester.enterText(find.widgetWithText(TextFormField, 'Confirm new password'), 'Mine2026pass');
    await tapText(tester, 'Save password');

    expect(auth.changedTo, 'Mine2026pass');
    expect(find.text('Attendance'), findsOneWidget);
  });

  testWidgets('a saved session opens straight into the role home, even offline', (tester) async {
    final auth = FakeAuthRepository(
      saved: const StoredSession(
        tokens: AuthTokens(accessToken: 'a', refreshToken: 'r'),
        user: AppSession(userId: 'admin-1', name: 'Admin User', role: UserRole.admin),
      ),
    );
    await pumpSiteWorkApp(
      tester,
      auth: auth,
      health: () => Future.error(const NetworkException()),
      api: FakeApi()..offline = true,
    );

    expect(find.text("You're offline. Check your internet connection and try again."), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
    expect(find.text('Payments'), findsOneWidget);

    await tester.tap(find.byTooltip('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Admin User'), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);
  });

  testWidgets('an unknown link shows a friendly page that leads back home', (tester) async {
    await pumpSiteWorkApp(tester);
    await signIn(tester, '+919000000101', FakeAuthRepository.password);

    GoRouter.of(tester.element(find.text('Home').first)).go('/staff/no-such-page');
    await tester.pumpAndSettle();
    expect(find.text("This page isn't available"), findsOneWidget);

    await tapText(tester, 'Go to home');
    expect(find.text("This page isn't available"), findsNothing);
    expect(find.text('Attendance'), findsWidgets);
  });

  testWidgets('development builds offer one-tap seeded sign-in; others do not', (tester) async {
    await pumpSiteWorkApp(
      tester,
      devLogins: const [DevLogin(label: 'Staff', identifier: '+919000000101', password: FakeAuthRepository.password)],
    );
    await tapText(tester, 'Staff');
    expect(find.text('Attendance'), findsOneWidget);
  });

  testWidgets('forgot password asks for the identifier and confirms', (tester) async {
    await pumpSiteWorkApp(tester, environment: AppEnvironment.prod);
    expect(find.text('Quick sign-in (development build)'), findsNothing);

    await tapText(tester, 'Forgot password?');
    await tester.enterText(find.byType(TextFormField), '+919000000101');
    await tapText(tester, 'Send code');
    expect(find.text('We have sent a code if possible.'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'I have a code'), findsOneWidget);
  });
}
