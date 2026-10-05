// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthTokens _$AuthTokensFromJson(Map<String, dynamic> json) =>
    _AuthTokens(accessToken: json['accessToken'] as String, refreshToken: json['refreshToken'] as String);

Map<String, dynamic> _$AuthTokensToJson(_AuthTokens instance) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
};

_AuthResult _$AuthResultFromJson(Map<String, dynamic> json) => _AuthResult(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  user: AppSession.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthResultToJson(_AuthResult instance) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'user': instance.user,
};

_StoredSession _$StoredSessionFromJson(Map<String, dynamic> json) => _StoredSession(
  tokens: AuthTokens.fromJson(json['tokens'] as Map<String, dynamic>),
  user: AppSession.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StoredSessionToJson(_StoredSession instance) => <String, dynamic>{
  'tokens': instance.tokens,
  'user': instance.user,
};

_StaffAssignmentInfo _$StaffAssignmentInfoFromJson(Map<String, dynamic> json) => _StaffAssignmentInfo(
  site: SiteRef.fromJson(json['site'] as Map<String, dynamic>),
  engineer: PersonRef.fromJson(json['engineer'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StaffAssignmentInfoToJson(_StaffAssignmentInfo instance) => <String, dynamic>{
  'site': instance.site,
  'engineer': instance.engineer,
};

_MeProfile _$MeProfileFromJson(Map<String, dynamic> json) => _MeProfile(
  id: json['id'] as String,
  name: json['name'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  phone: json['phone'] as String,
  email: json['email'] as String?,
  employeeCode: json['employeeCode'] as String,
  designation: $enumDecodeNullable(_$DesignationEnumMap, json['designation']),
  joiningDate: json['joiningDate'] as String?,
  mustChangePassword: json['mustChangePassword'] as bool,
  assignment: json['assignment'] == null
      ? null
      : StaffAssignmentInfo.fromJson(json['assignment'] as Map<String, dynamic>),
  sites:
      (json['sites'] as List<dynamic>?)?.map((e) => SiteRef.fromJson(e as Map<String, dynamic>)).toList() ??
      const <SiteRef>[],
);

Map<String, dynamic> _$MeProfileToJson(_MeProfile instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'role': _$UserRoleEnumMap[instance.role]!,
  'phone': instance.phone,
  'email': instance.email,
  'employeeCode': instance.employeeCode,
  'designation': _$DesignationEnumMap[instance.designation],
  'joiningDate': instance.joiningDate,
  'mustChangePassword': instance.mustChangePassword,
  'assignment': instance.assignment,
  'sites': instance.sites,
};

const _$UserRoleEnumMap = {UserRole.admin: 'ADMIN', UserRole.engineer: 'ENGINEER', UserRole.staff: 'STAFF'};

const _$DesignationEnumMap = {
  Designation.mason: 'MASON',
  Designation.helper: 'HELPER',
  Designation.electrician: 'ELECTRICIAN',
  Designation.carpenter: 'CARPENTER',
  Designation.plumber: 'PLUMBER',
  Designation.supervisor: 'SUPERVISOR',
  Designation.painter: 'PAINTER',
  Designation.generalWorker: 'GENERAL_WORKER',
};
