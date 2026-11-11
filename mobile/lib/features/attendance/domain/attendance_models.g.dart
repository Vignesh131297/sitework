// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceRecord _$AttendanceRecordFromJson(Map<String, dynamic> json) => _AttendanceRecord(
  id: json['id'] as String,
  workDate: json['workDate'] as String,
  status: $enumDecode(_$AttendanceStatusEnumMap, json['status']),
  staff: IdName.fromJson(json['staff'] as Map<String, dynamic>),
  site: IdName.fromJson(json['site'] as Map<String, dynamic>),
  checkInAt: json['checkInAt'] == null ? null : DateTime.parse(json['checkInAt'] as String),
  checkInLocationFlag: $enumDecodeNullable(_$LocationFlagEnumMap, json['checkInLocationFlag']),
  checkOutAt: json['checkOutAt'] == null ? null : DateTime.parse(json['checkOutAt'] as String),
  checkOutLocationFlag: $enumDecodeNullable(_$LocationFlagEnumMap, json['checkOutLocationFlag']),
  workedMinutes: (json['workedMinutes'] as num?)?.toInt(),
  correctionNote: json['correctionNote'] as String?,
);

Map<String, dynamic> _$AttendanceRecordToJson(_AttendanceRecord instance) => <String, dynamic>{
  'id': instance.id,
  'workDate': instance.workDate,
  'status': _$AttendanceStatusEnumMap[instance.status]!,
  'staff': instance.staff,
  'site': instance.site,
  'checkInAt': instance.checkInAt?.toIso8601String(),
  'checkInLocationFlag': _$LocationFlagEnumMap[instance.checkInLocationFlag],
  'checkOutAt': instance.checkOutAt?.toIso8601String(),
  'checkOutLocationFlag': _$LocationFlagEnumMap[instance.checkOutLocationFlag],
  'workedMinutes': instance.workedMinutes,
  'correctionNote': instance.correctionNote,
};

const _$AttendanceStatusEnumMap = {
  AttendanceStatus.present: 'PRESENT',
  AttendanceStatus.late: 'LATE',
  AttendanceStatus.halfDay: 'HALF_DAY',
  AttendanceStatus.absent: 'ABSENT',
  AttendanceStatus.onLeave: 'ON_LEAVE',
};

const _$LocationFlagEnumMap = {
  LocationFlag.ok: 'OK',
  LocationFlag.permissionDenied: 'PERMISSION_DENIED',
  LocationFlag.unavailable: 'UNAVAILABLE',
  LocationFlag.mocked: 'MOCKED',
  LocationFlag.outsideSite: 'OUTSIDE_SITE',
};
