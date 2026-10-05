import 'package:freezed_annotation/freezed_annotation.dart';

part 'refs.freezed.dart';
part 'refs.g.dart';

// Small references to other records, as the API embeds them.

@freezed
abstract class IdName with _$IdName {
  const factory IdName({required String id, required String name}) = _IdName;

  factory IdName.fromJson(Map<String, dynamic> json) => _$IdNameFromJson(json);
}

@freezed
abstract class SiteRef with _$SiteRef {
  const factory SiteRef({required String id, required String code, required String name, String? address}) = _SiteRef;

  factory SiteRef.fromJson(Map<String, dynamic> json) => _$SiteRefFromJson(json);
}

@freezed
abstract class PersonRef with _$PersonRef {
  const factory PersonRef({required String id, required String name, String? phone}) = _PersonRef;

  factory PersonRef.fromJson(Map<String, dynamic> json) => _$PersonRefFromJson(json);
}

@freezed
abstract class TitledRef with _$TitledRef {
  const factory TitledRef({required String id, required String title}) = _TitledRef;

  factory TitledRef.fromJson(Map<String, dynamic> json) => _$TitledRefFromJson(json);
}
