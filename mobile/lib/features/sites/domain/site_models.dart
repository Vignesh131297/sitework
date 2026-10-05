import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/enums.dart';
import '../../../core/models/refs.dart';

part 'site_models.freezed.dart';
part 'site_models.g.dart';

@freezed
abstract class SiteSummary with _$SiteSummary {
  const factory SiteSummary({
    required String id,
    required String code,
    required String name,
    required SiteStatus status,
    required int progressPercent,
    required String address,
    required IdName client,
    @Default(<IdName>[]) List<IdName> engineers,
    required int staffCount,
    required String startDate,
    String? expectedCompletionDate,

    /// Null for staff, who never see money.
    String? contractAmount,
  }) = _SiteSummary;

  factory SiteSummary.fromJson(Map<String, dynamic> json) => _$SiteSummaryFromJson(json);
}

@freezed
abstract class SiteClient with _$SiteClient {
  const factory SiteClient({
    required String id,
    required String name,

    /// Staff get the client's name only.
    String? phone,
    String? email,
  }) = _SiteClient;

  factory SiteClient.fromJson(Map<String, dynamic> json) => _$SiteClientFromJson(json);
}

@freezed
abstract class SiteStaffMember with _$SiteStaffMember {
  const factory SiteStaffMember({
    required String id,
    required String name,
    required String phone,
    Designation? designation,
    required IdName engineer,
  }) = _SiteStaffMember;

  factory SiteStaffMember.fromJson(Map<String, dynamic> json) => _$SiteStaffMemberFromJson(json);
}

@freezed
abstract class MilestoneView with _$MilestoneView {
  const factory MilestoneView({
    required String id,
    required String title,
    required String amount,
    required String dueDate,
    required String paid,
    required String outstanding,
    required MilestoneStatus status,
  }) = _MilestoneView;

  factory MilestoneView.fromJson(Map<String, dynamic> json) => _$MilestoneViewFromJson(json);
}

/// Money figures, always calculated by the server.
@freezed
abstract class SiteFinancials with _$SiteFinancials {
  const factory SiteFinancials({
    required String contract,
    required String received,
    required String pending,
    required String overdue,
    required int overdueCount,
    @Default(<MilestoneView>[]) List<MilestoneView> milestones,
  }) = _SiteFinancials;

  factory SiteFinancials.fromJson(Map<String, dynamic> json) => _$SiteFinancialsFromJson(json);
}

@freezed
abstract class SiteDetail with _$SiteDetail {
  const factory SiteDetail({
    required String id,
    required String code,
    required String name,
    required SiteStatus status,
    required int progressPercent,
    required String address,
    required SiteClient client,
    @Default(<IdName>[]) List<IdName> engineers,
    required int staffCount,
    required String startDate,
    String? expectedCompletionDate,
    String? contractAmount,
    String? contactName,
    String? contactPhone,
    double? latitude,
    double? longitude,
    int? geofenceRadiusM,
    @Default(<SiteStaffMember>[]) List<SiteStaffMember> staff,
    SiteFinancials? financials,
    required int openIssues,
  }) = _SiteDetail;

  factory SiteDetail.fromJson(Map<String, dynamic> json) => _$SiteDetailFromJson(json);
}
