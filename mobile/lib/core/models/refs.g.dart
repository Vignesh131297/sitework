// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IdName _$IdNameFromJson(Map<String, dynamic> json) => _IdName(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$IdNameToJson(_IdName instance) => <String, dynamic>{'id': instance.id, 'name': instance.name};

_SiteRef _$SiteRefFromJson(Map<String, dynamic> json) => _SiteRef(
  id: json['id'] as String,
  code: json['code'] as String,
  name: json['name'] as String,
  address: json['address'] as String?,
);

Map<String, dynamic> _$SiteRefToJson(_SiteRef instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'name': instance.name,
  'address': instance.address,
};

_PersonRef _$PersonRefFromJson(Map<String, dynamic> json) =>
    _PersonRef(id: json['id'] as String, name: json['name'] as String, phone: json['phone'] as String?);

Map<String, dynamic> _$PersonRefToJson(_PersonRef instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'phone': instance.phone,
};

_TitledRef _$TitledRefFromJson(Map<String, dynamic> json) =>
    _TitledRef(id: json['id'] as String, title: json['title'] as String);

Map<String, dynamic> _$TitledRefToJson(_TitledRef instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
};
