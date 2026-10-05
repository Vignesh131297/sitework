import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../features/auth/presentation/change_password_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/reset_password_screen.dart';
import '../../features/auth/presentation/session_controller.dart';
import '../../features/auth/presentation/splash_screen.dart';
import 'app_routes.dart';
import 'role_routes.dart';
import 'route_guard.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  // Re-runs the redirect whenever the session changes (sign-in, sign-out, expiry).
  final sessionChanges = ValueNotifier<Object?>(null);
  ref.listen(sessionProvider, (_, next) => sessionChanges.value = next);

  final router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: sessionChanges,
    redirect: (context, state) => redirectFor(session: ref.read(sessionProvider), location: state.uri.path),
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: AppRoutes.login, builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) =>
            ForgotPasswordScreen(initialIdentifier: state.uri.queryParameters['identifier'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) => ResetPasswordScreen(identifier: state.uri.queryParameters['identifier'] ?? ''),
      ),
      GoRoute(path: AppRoutes.changePassword, builder: (context, state) => const ChangePasswordScreen()),
      ...adminRoutes,
      ...engineerRoutes,
      ...staffRoutes,
    ],
  );

  ref.onDispose(() {
    router.dispose();
    sessionChanges.dispose();
  });
  return router;
});
