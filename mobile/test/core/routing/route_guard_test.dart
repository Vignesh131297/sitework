import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sitework/core/routing/app_routes.dart';
import 'package:sitework/core/routing/route_guard.dart';
import 'package:sitework/features/auth/domain/app_session.dart';
import 'package:sitework/features/auth/domain/user_role.dart';

void main() {
  const admin = AppSession(userId: 'a', name: 'Admin User', role: UserRole.admin);
  const staff = AppSession(userId: 's', name: 'Ravi', role: UserRole.staff);
  const signedOut = AsyncData<AppSession?>(null);

  String? go(AsyncValue<AppSession?> session, String location) => redirectFor(session: session, location: location);

  group('redirectFor', () {
    test('shows the splash screen while the saved session is read', () {
      const loading = AsyncLoading<AppSession?>();
      expect(go(loading, AppRoutes.login), AppRoutes.splash);
      expect(go(loading, AppRoutes.splash), isNull);
    });

    test('treats an unreadable saved session as signed out', () {
      final failed = AsyncError<AppSession?>(Exception('broken'), StackTrace.empty);
      expect(go(failed, AppRoutes.splash), AppRoutes.login);
    });

    test('lets signed-out users reach only the public screens', () {
      expect(go(signedOut, AppRoutes.adminDashboard), AppRoutes.login);
      expect(go(signedOut, AppRoutes.splash), AppRoutes.login);
      expect(go(signedOut, AppRoutes.login), isNull);
      expect(go(signedOut, AppRoutes.forgotPassword), isNull);
      expect(go(signedOut, AppRoutes.resetPassword), isNull);
      expect(go(signedOut, AppRoutes.changePassword), AppRoutes.login);
    });

    test('sends signed-in users from splash and public screens to their home', () {
      expect(go(const AsyncData(admin), AppRoutes.splash), AppRoutes.adminDashboard);
      expect(go(const AsyncData(staff), AppRoutes.login), AppRoutes.staffHome);
    });

    test('holds a user with a temporary password on the change-password screen', () {
      final pending = AsyncData<AppSession?>(staff.copyWith(mustChangePassword: true));
      expect(go(pending, AppRoutes.staffHome), AppRoutes.changePassword);
      expect(go(pending, AppRoutes.changePassword), isNull);
    });

    test('keeps users inside their own area, plus voluntary password change', () {
      expect(go(const AsyncData(staff), AppRoutes.adminPayments), AppRoutes.staffHome);
      expect(go(const AsyncData(admin), AppRoutes.staffHistory), AppRoutes.adminDashboard);
      expect(go(const AsyncData(staff), '/staffing'), AppRoutes.staffHome);
      expect(go(const AsyncData(staff), AppRoutes.staffHistory), isNull);
      expect(go(const AsyncData(admin), AppRoutes.changePassword), isNull);
    });
  });
}
