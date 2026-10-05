import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/enums.dart';

part 'client_models.freezed.dart';
part 'client_models.g.dart';

@freezed
abstract class ClientSummary with _$ClientSummary {
  const factory ClientSummary({
    required String id,
    required String name,
    String? company,
    required String phone,
    String? email,
    String? address,
    String? notes,
    required int siteCount,
  }) = _ClientSummary;

  factory ClientSummary.fromJson(Map<String, dynamic> json) => _$ClientSummaryFromJson(json);
}

@freezed
abstract class ClientSite with _$ClientSite {
  const factory ClientSite({
    required String id,
    required String code,
    required String name,
    required SiteStatus status,
    required String contractAmount,
  }) = _ClientSite;

  factory ClientSite.fromJson(Map<String, dynamic> json) => _$ClientSiteFromJson(json);
}

@freezed
abstract class ClientDetail with _$ClientDetail {
  const factory ClientDetail({
    required String id,
    required String name,
    String? company,
    required String phone,
    String? email,
    String? address,
    String? notes,
    required int siteCount,
    @Default(<ClientSite>[]) List<ClientSite> sites,
  }) = _ClientDetail;

  factory ClientDetail.fromJson(Map<String, dynamic> json) => _$ClientDetailFromJson(json);
}
