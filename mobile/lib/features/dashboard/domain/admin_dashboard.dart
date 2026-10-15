import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/enums.dart';
import '../../../core/models/refs.dart';
import '../../stock/domain/stock_models.dart';

part 'admin_dashboard.freezed.dart';
part 'admin_dashboard.g.dart';

@freezed
abstract class DayTotals with _$DayTotals {
  const factory DayTotals({
    required int expected,
    required int submitted,
    required int missing,
    required int pending,
    required int upcoming,
    required int notCheckedIn,
  }) = _DayTotals;

  factory DayTotals.fromJson(Map<String, dynamic> json) => _$DayTotalsFromJson(json);
}

@freezed
abstract class MoneyTotals with _$MoneyTotals {
  const factory MoneyTotals({
    required String contract,
    required String received,
    required String pending,
    required String overdue,
    required int overdueCount,
  }) = _MoneyTotals;

  factory MoneyTotals.fromJson(Map<String, dynamic> json) => _$MoneyTotalsFromJson(json);
}

@freezed
abstract class DashboardCounts with _$DashboardCounts {
  const factory DashboardCounts({
    required int activeSites,
    required int clients,
    required int engineers,
    required int staff,
  }) = _DashboardCounts;

  factory DashboardCounts.fromJson(Map<String, dynamic> json) => _$DashboardCountsFromJson(json);
}

@freezed
abstract class IssueCounts with _$IssueCounts {
  const factory IssueCounts({required int open, required int critical}) = _IssueCounts;

  factory IssueCounts.fromJson(Map<String, dynamic> json) => _$IssueCountsFromJson(json);
}

/// Stock needing attention: materials low in the godowns and requests to
/// approve (admins), open requests (engineers), and deliveries or returns on
/// the way for the user to confirm.
@freezed
abstract class StockCounts with _$StockCounts {
  const factory StockCounts({
    @Default(0) int lowStock,
    @Default(0) int toReceive,
    @Default(0) int requestsToApprove,
    @Default(0) int openRequests,
  }) = _StockCounts;

  factory StockCounts.fromJson(Map<String, dynamic> json) => _$StockCountsFromJson(json);
}

/// Something the admin should look at; unknown kinds from a newer server are ignored.
@Freezed(unionKey: 'type', unionValueCase: FreezedUnionCase.screamingSnake, fallbackUnion: 'unknown')
sealed class AttentionItem with _$AttentionItem {
  const factory AttentionItem.missingUpdates({
    required IdName site,
    required int count,
    required List<String> staffNames,
  }) = MissingUpdatesItem;

  const factory AttentionItem.notCheckedIn({
    required IdName site,
    required int count,
    required List<String> staffNames,
  }) = NotCheckedInItem;

  const factory AttentionItem.overduePayment({
    required IdName site,
    required TitledRef milestone,
    required String outstanding,
    required String dueDate,
  }) = OverduePaymentItem;

  const factory AttentionItem.criticalIssue({required IdName site, required TitledRef issue}) = CriticalIssueItem;

  const factory AttentionItem.unknown() = UnknownAttentionItem;

  factory AttentionItem.fromJson(Map<String, dynamic> json) => _$AttentionItemFromJson(json);
}

@freezed
abstract class ActivitySite with _$ActivitySite {
  const factory ActivitySite({
    required String id,
    required String code,
    required String name,
    required SiteStatus status,
  }) = _ActivitySite;

  factory ActivitySite.fromJson(Map<String, dynamic> json) => _$ActivitySiteFromJson(json);
}

@freezed
abstract class SiteActivity with _$SiteActivity {
  const factory SiteActivity({
    required ActivitySite site,
    required List<String> engineers,
    required int staffCount,
    required DayTotals updates,
    DateTime? lastActivityAt,
  }) = _SiteActivity;

  factory SiteActivity.fromJson(Map<String, dynamic> json) => _$SiteActivityFromJson(json);
}

@freezed
abstract class AdminDashboard with _$AdminDashboard {
  const factory AdminDashboard({
    required String date,
    required bool isWorkingDay,
    String? holiday,
    required DashboardCounts counts,
    required MoneyTotals payments,
    required DayTotals updates,

    /// Staff photos no admin has looked at yet.
    @Default(0) int toReview,
    required IssueCounts issues,
    @Default(StockCounts()) StockCounts stock,
    required List<AttentionItem> attention,
    required List<SiteActivity> sites,
  }) = _AdminDashboard;

  factory AdminDashboard.fromJson(Map<String, dynamic> json) => _$AdminDashboardFromJson(json);
}

/// The engineer's own sites; no money.
@freezed
abstract class EngineerDashboard with _$EngineerDashboard {
  const factory EngineerDashboard({
    required String date,
    required bool isWorkingDay,
    String? holiday,
    required DayTotals updates,

    /// Their staff's photos still waiting for their review.
    required int toReview,
    required IssueCounts issues,
    @Default(StockCounts()) StockCounts stock,
    required List<AttentionItem> attention,
    required List<SiteActivity> sites,
  }) = _EngineerDashboard;

  factory EngineerDashboard.fromJson(Map<String, dynamic> json) => _$EngineerDashboardFromJson(json);
}

/// A godown manager's day: their godowns, approved requests still to send,
/// returns on the way to confirm, and materials low across all godowns.
@freezed
abstract class GodownDashboard with _$GodownDashboard {
  const factory GodownDashboard({
    required String date,
    required List<GodownSummary> godowns,
    @Default(0) int toSend,
    @Default(0) int toReceive,
    @Default(0) int lowStock,
  }) = _GodownDashboard;

  factory GodownDashboard.fromJson(Map<String, dynamic> json) => _$GodownDashboardFromJson(json);
}
