// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_health.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServerHealth _$ServerHealthFromJson(Map<String, dynamic> json) => _ServerHealth(
  status: json['status'] as String,
  environment: json['environment'] as String,
  version: json['version'] as String,
  serverTime: DateTime.parse(json['serverTime'] as String),
  timeZone: json['timeZone'] as String,
  businessDate: json['businessDate'] as String,
);

Map<String, dynamic> _$ServerHealthToJson(_ServerHealth instance) => <String, dynamic>{
  'status': instance.status,
  'environment': instance.environment,
  'version': instance.version,
  'serverTime': instance.serverTime.toIso8601String(),
  'timeZone': instance.timeZone,
  'businessDate': instance.businessDate,
};
