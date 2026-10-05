import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/enums.dart';
import '../../../core/models/refs.dart';
import 'app_session.dart';
import 'user_role.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

@freezed
abstract class AuthTokens with _$AuthTokens {
  const factory AuthTokens({required String accessToken, required String refreshToken}) = _AuthTokens;

  factory AuthTokens.fromJson(Map<String, dynamic> json) => _$AuthTokensFromJson(json);
}

/// Response of `POST /auth/login` and `POST /auth/refresh`.
@freezed
abstract class AuthResult with _$AuthResult {
  const factory AuthResult({required String accessToken, required String refreshToken, required AppSession user}) =
      _AuthResult;

  const AuthResult._();

  factory AuthResult.fromJson(Map<String, dynamic> json) => _$AuthResultFromJson(json);

  AuthTokens get tokens => AuthTokens(accessToken: accessToken, refreshToken: refreshToken);
}

/// What the device keeps between launches (in secure storage).
@freezed
abstract class StoredSession with _$StoredSession {
  const factory StoredSession({required AuthTokens tokens, required AppSession user}) = _StoredSession;

  factory StoredSession.fromJson(Map<String, dynamic> json) => _$StoredSessionFromJson(json);
}

/// A staff member's current site and responsible engineer.
@freezed
abstract class StaffAssignmentInfo with _$StaffAssignmentInfo {
  const factory StaffAssignmentInfo({required SiteRef site, required PersonRef engineer}) = _StaffAssignmentInfo;

  factory StaffAssignmentInfo.fromJson(Map<String, dynamic> json) => _$StaffAssignmentInfoFromJson(json);
}

/// Response of `GET /me`.
@freezed
abstract class MeProfile with _$MeProfile {
  const factory MeProfile({
    required String id,
    required String name,
    required UserRole role,
    required String phone,
    String? email,
    required String employeeCode,
    Designation? designation,
    String? joiningDate,
    required bool mustChangePassword,
    StaffAssignmentInfo? assignment,
    @Default(<SiteRef>[]) List<SiteRef> sites,
  }) = _MeProfile;

  const MeProfile._();

  factory MeProfile.fromJson(Map<String, dynamic> json) => _$MeProfileFromJson(json);

  AppSession toSession() => AppSession(userId: id, name: name, role: role, mustChangePassword: mustChangePassword);
}
