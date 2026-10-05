// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) => _AppNotification(
  id: json['id'] as String,
  type: $enumDecode(_$NotificationTypeEnumMap, json['type'], unknownValue: NotificationType.system),
  title: json['title'] as String,
  message: json['message'] as String,
  referenceType: $enumDecodeNullable(
    _$ReferenceTypeEnumMap,
    json['referenceType'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
  referenceId: json['referenceId'] as String?,
  data: (json['data'] as Map<String, dynamic>?)?.map((k, e) => MapEntry(k, e as String)),
  isRead: json['isRead'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$AppNotificationToJson(_AppNotification instance) => <String, dynamic>{
  'id': instance.id,
  'type': _$NotificationTypeEnumMap[instance.type]!,
  'title': instance.title,
  'message': instance.message,
  'referenceType': _$ReferenceTypeEnumMap[instance.referenceType],
  'referenceId': instance.referenceId,
  'data': instance.data,
  'isRead': instance.isRead,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$NotificationTypeEnumMap = {
  NotificationType.staffUpdate: 'STAFF_UPDATE',
  NotificationType.engineerUpdate: 'ENGINEER_UPDATE',
  NotificationType.missingUpdate: 'MISSING_UPDATE',
  NotificationType.payment: 'PAYMENT',
  NotificationType.issue: 'ISSUE',
  NotificationType.attendance: 'ATTENDANCE',
  NotificationType.system: 'SYSTEM',
};

const _$ReferenceTypeEnumMap = {
  ReferenceType.staffUpdate: 'STAFF_UPDATE',
  ReferenceType.missedUpdate: 'MISSED_UPDATE',
  ReferenceType.engineerUpdate: 'ENGINEER_UPDATE',
  ReferenceType.issue: 'ISSUE',
  ReferenceType.site: 'SITE',
  ReferenceType.paymentMilestone: 'PAYMENT_MILESTONE',
  ReferenceType.payment: 'PAYMENT',
  ReferenceType.attendance: 'ATTENDANCE',
};
