// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BoardStaff _$BoardStaffFromJson(Map<String, dynamic> json) => _BoardStaff(
  id: json['id'] as String,
  name: json['name'] as String,
  phone: json['phone'] as String,
  designation: $enumDecodeNullable(_$DesignationEnumMap, json['designation']),
);

Map<String, dynamic> _$BoardStaffToJson(_BoardStaff instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'phone': instance.phone,
  'designation': _$DesignationEnumMap[instance.designation],
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

_BoardAttendance _$BoardAttendanceFromJson(Map<String, dynamic> json) => _BoardAttendance(
  status: $enumDecode(_$AttendanceStatusEnumMap, json['status']),
  checkInAt: json['checkInAt'] == null ? null : DateTime.parse(json['checkInAt'] as String),
  checkOutAt: json['checkOutAt'] == null ? null : DateTime.parse(json['checkOutAt'] as String),
);

Map<String, dynamic> _$BoardAttendanceToJson(_BoardAttendance instance) => <String, dynamic>{
  'status': _$AttendanceStatusEnumMap[instance.status]!,
  'checkInAt': instance.checkInAt?.toIso8601String(),
  'checkOutAt': instance.checkOutAt?.toIso8601String(),
};

const _$AttendanceStatusEnumMap = {
  AttendanceStatus.present: 'PRESENT',
  AttendanceStatus.late: 'LATE',
  AttendanceStatus.halfDay: 'HALF_DAY',
  AttendanceStatus.absent: 'ABSENT',
  AttendanceStatus.onLeave: 'ON_LEAVE',
};

_StaffDay _$StaffDayFromJson(Map<String, dynamic> json) => _StaffDay(
  staff: BoardStaff.fromJson(json['staff'] as Map<String, dynamic>),
  site: IdName.fromJson(json['site'] as Map<String, dynamic>),
  engineer: IdName.fromJson(json['engineer'] as Map<String, dynamic>),
  attendance: json['attendance'] == null ? null : BoardAttendance.fromJson(json['attendance'] as Map<String, dynamic>),
  notCheckedIn: json['notCheckedIn'] as bool,
  slots: (json['slots'] as List<dynamic>).map((e) => DaySlot.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$StaffDayToJson(_StaffDay instance) => <String, dynamic>{
  'staff': instance.staff,
  'site': instance.site,
  'engineer': instance.engineer,
  'attendance': instance.attendance,
  'notCheckedIn': instance.notCheckedIn,
  'slots': instance.slots,
};

_SiteDay _$SiteDayFromJson(Map<String, dynamic> json) => _SiteDay(
  date: json['date'] as String,
  isWorkingDay: json['isWorkingDay'] as bool,
  holiday: json['holiday'] as String?,
  staff: (json['staff'] as List<dynamic>).map((e) => StaffDay.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$SiteDayToJson(_SiteDay instance) => <String, dynamic>{
  'date': instance.date,
  'isWorkingDay': instance.isWorkingDay,
  'holiday': instance.holiday,
  'staff': instance.staff,
};
