// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'engineer_update_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Attachment _$AttachmentFromJson(Map<String, dynamic> json) => _Attachment(
  id: json['id'] as String,
  mime: json['mime'] as String,
  url: json['url'] as String,
  expiresAt: DateTime.parse(json['expiresAt'] as String),
);

Map<String, dynamic> _$AttachmentToJson(_Attachment instance) => <String, dynamic>{
  'id': instance.id,
  'mime': instance.mime,
  'url': instance.url,
  'expiresAt': instance.expiresAt.toIso8601String(),
};

_EngineerUpdate _$EngineerUpdateFromJson(Map<String, dynamic> json) => _EngineerUpdate(
  id: json['id'] as String,
  type: $enumDecode(_$EngineerUpdateTypeEnumMap, json['type']),
  priority: $enumDecode(_$PriorityEnumMap, json['priority']),
  title: json['title'] as String?,
  description: json['description'] as String,
  progressPercent: (json['progressPercent'] as num?)?.toInt(),
  site: IdName.fromJson(json['site'] as Map<String, dynamic>),
  engineer: IdName.fromJson(json['engineer'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  adminViewedAt: json['adminViewedAt'] == null ? null : DateTime.parse(json['adminViewedAt'] as String),
  attachmentCount: (json['attachmentCount'] as num).toInt(),
  attachments:
      (json['attachments'] as List<dynamic>?)?.map((e) => Attachment.fromJson(e as Map<String, dynamic>)).toList() ??
      const <Attachment>[],
);

Map<String, dynamic> _$EngineerUpdateToJson(_EngineerUpdate instance) => <String, dynamic>{
  'id': instance.id,
  'type': _$EngineerUpdateTypeEnumMap[instance.type]!,
  'priority': _$PriorityEnumMap[instance.priority]!,
  'title': instance.title,
  'description': instance.description,
  'progressPercent': instance.progressPercent,
  'site': instance.site,
  'engineer': instance.engineer,
  'createdAt': instance.createdAt.toIso8601String(),
  'adminViewedAt': instance.adminViewedAt?.toIso8601String(),
  'attachmentCount': instance.attachmentCount,
  'attachments': instance.attachments,
};

const _$EngineerUpdateTypeEnumMap = {
  EngineerUpdateType.progress: 'PROGRESS',
  EngineerUpdateType.completedWork: 'COMPLETED_WORK',
  EngineerUpdateType.materialsRequired: 'MATERIALS_REQUIRED',
  EngineerUpdateType.safetyConcern: 'SAFETY_CONCERN',
  EngineerUpdateType.clientRequirement: 'CLIENT_REQUIREMENT',
  EngineerUpdateType.remark: 'REMARK',
  EngineerUpdateType.dailyReport: 'DAILY_REPORT',
};

const _$PriorityEnumMap = {
  Priority.low: 'LOW',
  Priority.medium: 'MEDIUM',
  Priority.high: 'HIGH',
  Priority.critical: 'CRITICAL',
};
