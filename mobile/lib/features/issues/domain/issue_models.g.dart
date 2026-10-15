// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IssueReporter _$IssueReporterFromJson(Map<String, dynamic> json) => _IssueReporter(
  id: json['id'] as String,
  name: json['name'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
);

Map<String, dynamic> _$IssueReporterToJson(_IssueReporter instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'role': _$UserRoleEnumMap[instance.role]!,
};

const _$UserRoleEnumMap = {
  UserRole.admin: 'ADMIN',
  UserRole.engineer: 'ENGINEER',
  UserRole.staff: 'STAFF',
  UserRole.godownManager: 'GODOWN_MANAGER',
};

_Issue _$IssueFromJson(Map<String, dynamic> json) => _Issue(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  priority: $enumDecode(_$PriorityEnumMap, json['priority']),
  status: $enumDecode(_$IssueStatusEnumMap, json['status']),
  site: IdName.fromJson(json['site'] as Map<String, dynamic>),
  reportedBy: IssueReporter.fromJson(json['reportedBy'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  resolvedAt: json['resolvedAt'] == null ? null : DateTime.parse(json['resolvedAt'] as String),
  resolvedBy: json['resolvedBy'] == null ? null : IdName.fromJson(json['resolvedBy'] as Map<String, dynamic>),
  resolutionNote: json['resolutionNote'] as String?,
  attachmentCount: (json['attachmentCount'] as num).toInt(),
  attachments:
      (json['attachments'] as List<dynamic>?)?.map((e) => Attachment.fromJson(e as Map<String, dynamic>)).toList() ??
      const <Attachment>[],
);

Map<String, dynamic> _$IssueToJson(_Issue instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'priority': _$PriorityEnumMap[instance.priority]!,
  'status': _$IssueStatusEnumMap[instance.status]!,
  'site': instance.site,
  'reportedBy': instance.reportedBy,
  'createdAt': instance.createdAt.toIso8601String(),
  'resolvedAt': instance.resolvedAt?.toIso8601String(),
  'resolvedBy': instance.resolvedBy,
  'resolutionNote': instance.resolutionNote,
  'attachmentCount': instance.attachmentCount,
  'attachments': instance.attachments,
};

const _$PriorityEnumMap = {
  Priority.low: 'LOW',
  Priority.medium: 'MEDIUM',
  Priority.high: 'HIGH',
  Priority.critical: 'CRITICAL',
};

const _$IssueStatusEnumMap = {
  IssueStatus.open: 'OPEN',
  IssueStatus.inProgress: 'IN_PROGRESS',
  IssueStatus.resolved: 'RESOLVED',
};
