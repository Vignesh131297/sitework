// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_update_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateStaff _$UpdateStaffFromJson(Map<String, dynamic> json) => _UpdateStaff(
  id: json['id'] as String,
  name: json['name'] as String,
  designation: $enumDecodeNullable(_$DesignationEnumMap, json['designation']),
);

Map<String, dynamic> _$UpdateStaffToJson(_UpdateStaff instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
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

_UpdateLocation _$UpdateLocationFromJson(Map<String, dynamic> json) => _UpdateLocation(
  flag: $enumDecode(_$LocationFlagEnumMap, json['flag']),
  distanceFromSiteM: (json['distanceFromSiteM'] as num?)?.toInt(),
);

Map<String, dynamic> _$UpdateLocationToJson(_UpdateLocation instance) => <String, dynamic>{
  'flag': _$LocationFlagEnumMap[instance.flag]!,
  'distanceFromSiteM': instance.distanceFromSiteM,
};

const _$LocationFlagEnumMap = {
  LocationFlag.ok: 'OK',
  LocationFlag.permissionDenied: 'PERMISSION_DENIED',
  LocationFlag.unavailable: 'UNAVAILABLE',
  LocationFlag.mocked: 'MOCKED',
  LocationFlag.outsideSite: 'OUTSIDE_SITE',
};

_UpdateImage _$UpdateImageFromJson(Map<String, dynamic> json) => _UpdateImage(
  status: $enumDecode(_$ImageStatusEnumMap, json['status']),
  expiresAt: DateTime.parse(json['expiresAt'] as String),
  deletedAt: json['deletedAt'] == null ? null : DateTime.parse(json['deletedAt'] as String),
  deleteReason: $enumDecodeNullable(_$ImageDeleteReasonEnumMap, json['deleteReason']),
);

Map<String, dynamic> _$UpdateImageToJson(_UpdateImage instance) => <String, dynamic>{
  'status': _$ImageStatusEnumMap[instance.status]!,
  'expiresAt': instance.expiresAt.toIso8601String(),
  'deletedAt': instance.deletedAt?.toIso8601String(),
  'deleteReason': _$ImageDeleteReasonEnumMap[instance.deleteReason],
};

const _$ImageStatusEnumMap = {
  ImageStatus.available: 'AVAILABLE',
  ImageStatus.readyForDeletion: 'READY_FOR_DELETION',
  ImageStatus.deleted: 'DELETED',
};

const _$ImageDeleteReasonEnumMap = {ImageDeleteReason.allViewed: 'ALL_VIEWED', ImageDeleteReason.expired: 'EXPIRED'};

_StaffUpdate _$StaffUpdateFromJson(Map<String, dynamic> json) => _StaffUpdate(
  id: json['id'] as String,
  workDate: json['workDate'] as String,
  slot: $enumDecode(_$TimeSlotEnumMap, json['slot']),
  description: json['description'] as String,
  staff: UpdateStaff.fromJson(json['staff'] as Map<String, dynamic>),
  site: IdName.fromJson(json['site'] as Map<String, dynamic>),
  engineer: IdName.fromJson(json['engineer'] as Map<String, dynamic>),
  submittedAt: DateTime.parse(json['submittedAt'] as String),
  capturedAt: DateTime.parse(json['capturedAt'] as String),
  submittedOffline: json['submittedOffline'] as bool,
  location: UpdateLocation.fromJson(json['location'] as Map<String, dynamic>),
  photoSource: $enumDecode(_$PhotoSourceEnumMap, json['photoSource']),
  image: UpdateImage.fromJson(json['image'] as Map<String, dynamic>),
  engineerViewedAt: json['engineerViewedAt'] == null ? null : DateTime.parse(json['engineerViewedAt'] as String),
  adminViewedAt: json['adminViewedAt'] == null ? null : DateTime.parse(json['adminViewedAt'] as String),
);

Map<String, dynamic> _$StaffUpdateToJson(_StaffUpdate instance) => <String, dynamic>{
  'id': instance.id,
  'workDate': instance.workDate,
  'slot': _$TimeSlotEnumMap[instance.slot]!,
  'description': instance.description,
  'staff': instance.staff,
  'site': instance.site,
  'engineer': instance.engineer,
  'submittedAt': instance.submittedAt.toIso8601String(),
  'capturedAt': instance.capturedAt.toIso8601String(),
  'submittedOffline': instance.submittedOffline,
  'location': instance.location,
  'photoSource': _$PhotoSourceEnumMap[instance.photoSource]!,
  'image': instance.image,
  'engineerViewedAt': instance.engineerViewedAt?.toIso8601String(),
  'adminViewedAt': instance.adminViewedAt?.toIso8601String(),
};

const _$TimeSlotEnumMap = {TimeSlot.morning: 'MORNING', TimeSlot.afternoon: 'AFTERNOON', TimeSlot.evening: 'EVENING'};

const _$PhotoSourceEnumMap = {PhotoSource.camera: 'CAMERA', PhotoSource.gallery: 'GALLERY'};

_ImageLink _$ImageLinkFromJson(Map<String, dynamic> json) =>
    _ImageLink(url: json['url'] as String, expiresAt: DateTime.parse(json['expiresAt'] as String));

Map<String, dynamic> _$ImageLinkToJson(_ImageLink instance) => <String, dynamic>{
  'url': instance.url,
  'expiresAt': instance.expiresAt.toIso8601String(),
};

_SlotUpdateRef _$SlotUpdateRefFromJson(Map<String, dynamic> json) => _SlotUpdateRef(
  id: json['id'] as String,
  submittedAt: DateTime.parse(json['submittedAt'] as String),
  submittedOffline: json['submittedOffline'] as bool,
  imageStatus: $enumDecodeNullable(_$ImageStatusEnumMap, json['imageStatus']),
  engineerViewedAt: json['engineerViewedAt'] == null ? null : DateTime.parse(json['engineerViewedAt'] as String),
  adminViewedAt: json['adminViewedAt'] == null ? null : DateTime.parse(json['adminViewedAt'] as String),
);

Map<String, dynamic> _$SlotUpdateRefToJson(_SlotUpdateRef instance) => <String, dynamic>{
  'id': instance.id,
  'submittedAt': instance.submittedAt.toIso8601String(),
  'submittedOffline': instance.submittedOffline,
  'imageStatus': _$ImageStatusEnumMap[instance.imageStatus],
  'engineerViewedAt': instance.engineerViewedAt?.toIso8601String(),
  'adminViewedAt': instance.adminViewedAt?.toIso8601String(),
};

_DaySlot _$DaySlotFromJson(Map<String, dynamic> json) => _DaySlot(
  slot: $enumDecode(_$TimeSlotEnumMap, json['slot']),
  state: $enumDecode(_$SlotStateEnumMap, json['state']),
  start: DateTime.parse(json['start'] as String),
  end: DateTime.parse(json['end'] as String),
  closesAt: DateTime.parse(json['closesAt'] as String),
  update: json['update'] == null ? null : SlotUpdateRef.fromJson(json['update'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DaySlotToJson(_DaySlot instance) => <String, dynamic>{
  'slot': _$TimeSlotEnumMap[instance.slot]!,
  'state': _$SlotStateEnumMap[instance.state]!,
  'start': instance.start.toIso8601String(),
  'end': instance.end.toIso8601String(),
  'closesAt': instance.closesAt.toIso8601String(),
  'update': instance.update,
};

const _$SlotStateEnumMap = {
  SlotState.upcoming: 'UPCOMING',
  SlotState.pending: 'PENDING',
  SlotState.submitted: 'SUBMITTED',
  SlotState.missing: 'MISSING',
  SlotState.notExpected: 'NOT_EXPECTED',
};

_TodaySite _$TodaySiteFromJson(Map<String, dynamic> json) => _TodaySite(
  id: json['id'] as String,
  code: json['code'] as String,
  name: json['name'] as String,
  address: json['address'] as String,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  geofenceRadiusM: (json['geofenceRadiusM'] as num?)?.toInt(),
);

Map<String, dynamic> _$TodaySiteToJson(_TodaySite instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'name': instance.name,
  'address': instance.address,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'geofenceRadiusM': instance.geofenceRadiusM,
};

_TodayAssignment _$TodayAssignmentFromJson(Map<String, dynamic> json) => _TodayAssignment(
  site: TodaySite.fromJson(json['site'] as Map<String, dynamic>),
  engineer: PersonRef.fromJson(json['engineer'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TodayAssignmentToJson(_TodayAssignment instance) => <String, dynamic>{
  'site': instance.site,
  'engineer': instance.engineer,
};

_FieldRules _$FieldRulesFromJson(Map<String, dynamic> json) => _FieldRules(
  requireCheckIn: json['requireCheckIn'] as bool,
  allowGallery: json['allowGallery'] as bool,
  locationRequired: json['locationRequired'] as bool,
  fixTimeoutSeconds: (json['fixTimeoutSeconds'] as num).toInt(),
  maxUploadMb: (json['maxUploadMb'] as num).toDouble(),
  offlineAcceptanceMinutes: (json['offlineAcceptanceMinutes'] as num).toInt(),
  defaultGeofenceRadiusM: (json['defaultGeofenceRadiusM'] as num).toInt(),
);

Map<String, dynamic> _$FieldRulesToJson(_FieldRules instance) => <String, dynamic>{
  'requireCheckIn': instance.requireCheckIn,
  'allowGallery': instance.allowGallery,
  'locationRequired': instance.locationRequired,
  'fixTimeoutSeconds': instance.fixTimeoutSeconds,
  'maxUploadMb': instance.maxUploadMb,
  'offlineAcceptanceMinutes': instance.offlineAcceptanceMinutes,
  'defaultGeofenceRadiusM': instance.defaultGeofenceRadiusM,
};

_StaffToday _$StaffTodayFromJson(Map<String, dynamic> json) => _StaffToday(
  serverTime: DateTime.parse(json['serverTime'] as String),
  date: json['date'] as String,
  isWorkingDay: json['isWorkingDay'] as bool,
  holiday: json['holiday'] as String?,
  assignment: json['assignment'] == null ? null : TodayAssignment.fromJson(json['assignment'] as Map<String, dynamic>),
  attendance: json['attendance'] == null ? null : AttendanceRecord.fromJson(json['attendance'] as Map<String, dynamic>),
  slots: (json['slots'] as List<dynamic>).map((e) => DaySlot.fromJson(e as Map<String, dynamic>)).toList(),
  rules: FieldRules.fromJson(json['rules'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StaffTodayToJson(_StaffToday instance) => <String, dynamic>{
  'serverTime': instance.serverTime.toIso8601String(),
  'date': instance.date,
  'isWorkingDay': instance.isWorkingDay,
  'holiday': instance.holiday,
  'assignment': instance.assignment,
  'attendance': instance.attendance,
  'slots': instance.slots,
  'rules': instance.rules,
};
