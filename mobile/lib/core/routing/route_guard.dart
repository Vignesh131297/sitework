import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/domain/app_session.dart';
import 'app_routes.dart';

/// Where to send the user instead of [location], or null to let them through.
///
/// This only shapes navigation. The API checks every permission itself, so a
/// screen reached by mistake still can't load data the user isn't allowed to see.
String? redirectFor({required AsyncValue<AppSession?> session, required String location}) {
  final isPublic = AppRoutes.publicPaths.contains(location);
  if (!session.hasValue) {
    // Still restoring the saved session; if that failed, treat as signed out.
    if (session.hasError) return isPublic ? null : AppRoutes.login;
    return location == AppRoutes.splash ? null : AppRoutes.splash;
  }

  final user = session.value;
  if (user == null) return isPublic ? null : AppRoutes.login;
  // The server refuses everything else until a temporary password is replaced.
  if (user.mustChangePassword) {
    return location == AppRoutes.changePassword ? null : AppRoutes.changePassword;
  }
  if (location == AppRoutes.changePassword) return null;
  if (location == AppRoutes.splash || isPublic) return user.role.homePath;

  final area = user.role.areaPath;
  final inOwnArea = location == area || location.startsWith('$area/');
  return inOwnArea ? null : user.role.homePath;
}
