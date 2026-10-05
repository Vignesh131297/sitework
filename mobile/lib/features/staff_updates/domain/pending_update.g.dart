// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PendingUpdate _$PendingUpdateFromJson(Map<String, dynamic> json) => _PendingUpdate(
  id: json['id'] as String,
  userId: json['userId'] as String,
  slot: $enumDecode(_$TimeSlotEnumMap, json['slot']),
  workDate: json['workDate'] as String,
  description: json['description'] as String,
  capturedAt: DateTime.parse(json['capturedAt'] as String),
  photoSource: $enumDecode(_$PhotoSourceEnumMap, json['photoSource']),
  location: (json['location'] as Map<String, dynamic>).map((k, e) => MapEntry(k, e as Object)),
  photoPath: json['photoPath'] as String,
  state: $enumDecodeNullable(_$PendingStateEnumMap, json['state']) ?? PendingState.waiting,
  attempts: (json['attempts'] as num?)?.toInt() ?? 0,
  errorCode: json['errorCode'] as String?,
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$PendingUpdateToJson(_PendingUpdate instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'slot': _$TimeSlotEnumMap[instance.slot]!,
  'workDate': instance.workDate,
  'description': instance.description,
  'capturedAt': instance.capturedAt.toIso8601String(),
  'photoSource': _$PhotoSourceEnumMap[instance.photoSource]!,
  'location': instance.location,
  'photoPath': instance.photoPath,
  'state': _$PendingStateEnumMap[instance.state]!,
  'attempts': instance.attempts,
  'errorCode': instance.errorCode,
  'errorMessage': instance.errorMessage,
};

const _$TimeSlotEnumMap = {TimeSlot.morning: 'MORNING', TimeSlot.afternoon: 'AFTERNOON', TimeSlot.evening: 'EVENING'};

const _$PhotoSourceEnumMap = {PhotoSource.camera: 'CAMERA', PhotoSource.gallery: 'GALLERY'};

const _$PendingStateEnumMap = {
  PendingState.waiting: 'waiting',
  PendingState.sending: 'sending',
  PendingState.failed: 'failed',
};
