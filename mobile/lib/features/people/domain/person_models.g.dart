// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PersonSummary _$PersonSummaryFromJson(Map<String, dynamic> json) => _PersonSummary(
  id: json['id'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  name: json['name'] as String,
  phone: json['phone'] as String,
  email: json['email'] as String?,
  employeeCode: json['employeeCode'] as String,
  designation: $enumDecodeNullable(_$DesignationEnumMap, json['designation']),
  joiningDate: json['joiningDate'] as String?,
  isActive: json['isActive'] as bool,
  lastLoginAt: json['lastLoginAt'] == null ? null : DateTime.parse(json['lastLoginAt'] as String),
  sites:
      (json['sites'] as List<dynamic>?)?.map((e) => SiteRef.fromJson(e as Map<String, dynamic>)).toList() ??
      const <SiteRef>[],
  staffCount: (json['staffCount'] as num?)?.toInt() ?? 0,
  assignment: json['assignment'] == null
      ? null
      : StaffAssignmentInfo.fromJson(json['assignment'] as Map<String, dynamic>),
  godowns:
      (json['godowns'] as List<dynamic>?)?.map((e) => IdName.fromJson(e as Map<String, dynamic>)).toList() ??
      const <IdName>[],
);

Map<String, dynamic> _$PersonSummaryToJson(_PersonSummary instance) => <String, dynamic>{
  'id': instance.id,
  'role': _$UserRoleEnumMap[instance.role]!,
  'name': instance.name,
  'phone': instance.phone,
  'email': instance.email,
  'employeeCode': instance.employeeCode,
  'designation': _$DesignationEnumMap[instance.designation],
  'joiningDate': instance.joiningDate,
  'isActive': instance.isActive,
  'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
  'sites': instance.sites,
  'staffCount': instance.staffCount,
  'assignment': instance.assignment,
  'godowns': instance.godowns,
};

const _$UserRoleEnumMap = {
  UserRole.admin: 'ADMIN',
  UserRole.engineer: 'ENGINEER',
  UserRole.staff: 'STAFF',
  UserRole.godownManager: 'GODOWN_MANAGER',
};

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

_SupervisedStaff _$SupervisedStaffFromJson(Map<String, dynamic> json) => _SupervisedStaff(
  id: json['id'] as String,
  name: json['name'] as String,
  designation: $enumDecodeNullable(_$DesignationEnumMap, json['designation']),
  site: IdName.fromJson(json['site'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SupervisedStaffToJson(_SupervisedStaff instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'designation': _$DesignationEnumMap[instance.designation],
  'site': instance.site,
};

_PersonDetail _$PersonDetailFromJson(Map<String, dynamic> json) => _PersonDetail(
  id: json['id'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  name: json['name'] as String,
  phone: json['phone'] as String,
  email: json['email'] as String?,
  employeeCode: json['employeeCode'] as String,
  designation: $enumDecodeNullable(_$DesignationEnumMap, json['designation']),
  joiningDate: json['joiningDate'] as String?,
  isActive: json['isActive'] as bool,
  lastLoginAt: json['lastLoginAt'] == null ? null : DateTime.parse(json['lastLoginAt'] as String),
  sites:
      (json['sites'] as List<dynamic>?)?.map((e) => SiteRef.fromJson(e as Map<String, dynamic>)).toList() ??
      const <SiteRef>[],
  staffCount: (json['staffCount'] as num?)?.toInt() ?? 0,
  assignment: json['assignment'] == null
      ? null
      : StaffAssignmentInfo.fromJson(json['assignment'] as Map<String, dynamic>),
  mustChangePassword: json['mustChangePassword'] as bool,
  supervisedStaff:
      (json['supervisedStaff'] as List<dynamic>?)
          ?.map((e) => SupervisedStaff.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <SupervisedStaff>[],
  godowns:
      (json['godowns'] as List<dynamic>?)?.map((e) => IdName.fromJson(e as Map<String, dynamic>)).toList() ??
      const <IdName>[],
);

Map<String, dynamic> _$PersonDetailToJson(_PersonDetail instance) => <String, dynamic>{
  'id': instance.id,
  'role': _$UserRoleEnumMap[instance.role]!,
  'name': instance.name,
  'phone': instance.phone,
  'email': instance.email,
  'employeeCode': instance.employeeCode,
  'designation': _$DesignationEnumMap[instance.designation],
  'joiningDate': instance.joiningDate,
  'isActive': instance.isActive,
  'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
  'sites': instance.sites,
  'staffCount': instance.staffCount,
  'assignment': instance.assignment,
  'mustChangePassword': instance.mustChangePassword,
  'supervisedStaff': instance.supervisedStaff,
  'godowns': instance.godowns,
};

_CreatedPerson _$CreatedPersonFromJson(Map<String, dynamic> json) => _CreatedPerson(
  person: PersonDetail.fromJson(json['person'] as Map<String, dynamic>),
  temporaryPassword: json['temporaryPassword'] as String,
);

Map<String, dynamic> _$CreatedPersonToJson(_CreatedPerson instance) => <String, dynamic>{
  'person': instance.person,
  'temporaryPassword': instance.temporaryPassword,
};
