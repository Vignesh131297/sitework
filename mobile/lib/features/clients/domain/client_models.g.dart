// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ClientSummary _$ClientSummaryFromJson(Map<String, dynamic> json) => _ClientSummary(
  id: json['id'] as String,
  name: json['name'] as String,
  company: json['company'] as String?,
  phone: json['phone'] as String,
  email: json['email'] as String?,
  address: json['address'] as String?,
  notes: json['notes'] as String?,
  siteCount: (json['siteCount'] as num).toInt(),
);

Map<String, dynamic> _$ClientSummaryToJson(_ClientSummary instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'company': instance.company,
  'phone': instance.phone,
  'email': instance.email,
  'address': instance.address,
  'notes': instance.notes,
  'siteCount': instance.siteCount,
};

_ClientSite _$ClientSiteFromJson(Map<String, dynamic> json) => _ClientSite(
  id: json['id'] as String,
  code: json['code'] as String,
  name: json['name'] as String,
  status: $enumDecode(_$SiteStatusEnumMap, json['status']),
  contractAmount: json['contractAmount'] as String,
);

Map<String, dynamic> _$ClientSiteToJson(_ClientSite instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'name': instance.name,
  'status': _$SiteStatusEnumMap[instance.status]!,
  'contractAmount': instance.contractAmount,
};

const _$SiteStatusEnumMap = {
  SiteStatus.notStarted: 'NOT_STARTED',
  SiteStatus.inProgress: 'IN_PROGRESS',
  SiteStatus.onHold: 'ON_HOLD',
  SiteStatus.completed: 'COMPLETED',
};

_ClientDetail _$ClientDetailFromJson(Map<String, dynamic> json) => _ClientDetail(
  id: json['id'] as String,
  name: json['name'] as String,
  company: json['company'] as String?,
  phone: json['phone'] as String,
  email: json['email'] as String?,
  address: json['address'] as String?,
  notes: json['notes'] as String?,
  siteCount: (json['siteCount'] as num).toInt(),
  sites:
      (json['sites'] as List<dynamic>?)?.map((e) => ClientSite.fromJson(e as Map<String, dynamic>)).toList() ??
      const <ClientSite>[],
);

Map<String, dynamic> _$ClientDetailToJson(_ClientDetail instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'company': instance.company,
  'phone': instance.phone,
  'email': instance.email,
  'address': instance.address,
  'notes': instance.notes,
  'siteCount': instance.siteCount,
  'sites': instance.sites,
};
