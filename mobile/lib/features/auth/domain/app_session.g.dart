// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSession _$AppSessionFromJson(Map<String, dynamic> json) => _AppSession(
  userId: json['id'] as String,
  name: json['name'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  mustChangePassword: json['mustChangePassword'] as bool? ?? false,
);

Map<String, dynamic> _$AppSessionToJson(_AppSession instance) => <String, dynamic>{
  'id': instance.userId,
  'name': instance.name,
  'role': _$UserRoleEnumMap[instance.role]!,
  'mustChangePassword': instance.mustChangePassword,
};

const _$UserRoleEnumMap = {
  UserRole.admin: 'ADMIN',
  UserRole.engineer: 'ENGINEER',
  UserRole.staff: 'STAFF',
  UserRole.godownManager: 'GODOWN_MANAGER',
};
