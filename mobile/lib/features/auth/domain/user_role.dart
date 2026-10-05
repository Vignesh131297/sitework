import 'package:json_annotation/json_annotation.dart';

import '../../../core/routing/app_routes.dart';

/// The three roles. JSON values match the API's `Role` enum.
@JsonEnum(valueField: 'apiValue')
enum UserRole {
  admin(
    apiValue: 'ADMIN',
    areaPath: AppRoutes.adminArea,
    homePath: AppRoutes.adminDashboard,
    profilePath: AppRoutes.adminProfile,
  ),
  engineer(
    apiValue: 'ENGINEER',
    areaPath: AppRoutes.engineerArea,
    homePath: AppRoutes.engineerDashboard,
    profilePath: AppRoutes.engineerProfile,
  ),
  staff(
    apiValue: 'STAFF',
    areaPath: AppRoutes.staffArea,
    homePath: AppRoutes.staffHome,
    profilePath: AppRoutes.staffProfile,
  );

  const UserRole({required this.apiValue, required this.areaPath, required this.homePath, required this.profilePath});

  final String apiValue;

  /// Every screen for this role lives under this path.
  final String areaPath;
  final String homePath;
  final String profilePath;
}
