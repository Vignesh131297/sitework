import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/enums.dart';
import '../../../core/models/refs.dart';
import '../../stock/domain/stock_models.dart';

part 'report_models.freezed.dart';
part 'report_models.g.dart';

/// The reports the server offers. Engineer and payment reports are admin-only.
enum ReportKind {
  sites('sites'),
  staff('staff'),
  engineers('engineers'),
  payments('payments'),
  stock('stock');

  const ReportKind(this.path);
  final String path;

  bool get adminOnly => this == engineers || this == payments;
}

/// A date range of business dates, both ends included ("2026-10-01".."2026-10-31").
typedef ReportRange = ({String from, String to});

@freezed
abstract class UpdateCounts with _$UpdateCounts {
  const factory UpdateCounts({
    required int submitted,
    required int missed,
    required int offline,
    required int locationFlagged,

    /// Submitted of (submitted + missed); null when nothing was due.
    int? compliancePercent,
  }) = _UpdateCounts;

  factory UpdateCounts.fromJson(Map<String, dynamic> json) => _$UpdateCountsFromJson(json);
}

@freezed
abstract class AttendanceCounts with _$AttendanceCounts {
  const factory AttendanceCounts({required int present, required int late, required int halfDay, required int absent}) =
      _AttendanceCounts;

  factory AttendanceCounts.fromJson(Map<String, dynamic> json) => _$AttendanceCountsFromJson(json);
}

@freezed
abstract class ReportSite with _$ReportSite {
  const factory ReportSite({required String id, required String code, required String name, SiteStatus? status}) =
      _ReportSite;

  factory ReportSite.fromJson(Map<String, dynamic> json) => _$ReportSiteFromJson(json);
}

@freezed
abstract class SiteIssueCounts with _$SiteIssueCounts {
  const factory SiteIssueCounts({required int opened, required int resolved, required int openNow}) = _SiteIssueCounts;

  factory SiteIssueCounts.fromJson(Map<String, dynamic> json) => _$SiteIssueCountsFromJson(json);
}

@freezed
abstract class SiteReportRow with _$SiteReportRow {
  const factory SiteReportRow({
    required ReportSite site,
    required IdName client,
    required UpdateCounts updates,
    required AttendanceCounts attendance,
    required int engineerUpdates,
    required SiteIssueCounts issues,

    /// Received in the range; null for engineers, who don't see money.
    String? received,
  }) = _SiteReportRow;

  factory SiteReportRow.fromJson(Map<String, dynamic> json) => _$SiteReportRowFromJson(json);
}

@freezed
abstract class ReportPerson with _$ReportPerson {
  const factory ReportPerson({
    required String id,
    required String name,
    required String employeeCode,
    Designation? designation,
    required bool isActive,
  }) = _ReportPerson;

  factory ReportPerson.fromJson(Map<String, dynamic> json) => _$ReportPersonFromJson(json);
}

@freezed
abstract class StaffReportRow with _$StaffReportRow {
  const factory StaffReportRow({
    required ReportPerson staff,

    /// Where they are assigned now.
    IdName? site,
    required AttendanceCounts attendance,
    required UpdateCounts updates,
  }) = _StaffReportRow;

  factory StaffReportRow.fromJson(Map<String, dynamic> json) => _$StaffReportRowFromJson(json);
}

@freezed
abstract class EngineerIssueCounts with _$EngineerIssueCounts {
  const factory EngineerIssueCounts({required int reported, required int resolved}) = _EngineerIssueCounts;

  factory EngineerIssueCounts.fromJson(Map<String, dynamic> json) => _$EngineerIssueCountsFromJson(json);
}

@freezed
abstract class ReviewCounts with _$ReviewCounts {
  const factory ReviewCounts({
    required int photos,
    required int reviewed,
    int? reviewRatePercent,

    /// From the photo being sent to the engineer opening it.
    int? averageMinutes,
  }) = _ReviewCounts;

  factory ReviewCounts.fromJson(Map<String, dynamic> json) => _$ReviewCountsFromJson(json);
}

@freezed
abstract class EngineerReportRow with _$EngineerReportRow {
  const factory EngineerReportRow({
    required ReportPerson engineer,
    required int sites,
    required int engineerUpdates,
    required EngineerIssueCounts issues,
    required ReviewCounts reviews,
  }) = _EngineerReportRow;

  factory EngineerReportRow.fromJson(Map<String, dynamic> json) => _$EngineerReportRowFromJson(json);
}

@freezed
abstract class PaymentReportTotals with _$PaymentReportTotals {
  const factory PaymentReportTotals({
    required String received,
    required int count,

    /// Amount per method; methods with nothing received are left out.
    @Default(<String, String>{}) Map<String, String> byMethod,
  }) = _PaymentReportTotals;

  factory PaymentReportTotals.fromJson(Map<String, dynamic> json) => _$PaymentReportTotalsFromJson(json);
}

@freezed
abstract class PaymentReportSite with _$PaymentReportSite {
  const factory PaymentReportSite({
    required ReportSite site,
    required IdName client,
    required String receivedInRange,
    required String contract,
    required String receivedToDate,
    required String pending,
    required String overdue,
  }) = _PaymentReportSite;

  factory PaymentReportSite.fromJson(Map<String, dynamic> json) => _$PaymentReportSiteFromJson(json);
}

@freezed
abstract class PaymentReportLine with _$PaymentReportLine {
  const factory PaymentReportLine({
    required String id,
    required String paidOn,
    required String amount,
    @JsonKey(unknownEnumValue: PaymentMethod.other) required PaymentMethod method,
    String? reference,
    required IdName site,
    required IdName client,
  }) = _PaymentReportLine;

  factory PaymentReportLine.fromJson(Map<String, dynamic> json) => _$PaymentReportLineFromJson(json);
}

@freezed
abstract class PaymentReport with _$PaymentReport {
  const factory PaymentReport({
    required PaymentReportTotals totals,
    required List<PaymentReportSite> sites,
    required List<PaymentReportLine> payments,
  }) = _PaymentReport;

  factory PaymentReport.fromJson(Map<String, dynamic> json) => _$PaymentReportFromJson(json);
}

/// One report's result, whichever kind it is.
sealed class ReportResult {
  const ReportResult();
}

class SitesReport extends ReportResult {
  const SitesReport(this.rows);
  final List<SiteReportRow> rows;
}

class StaffReport extends ReportResult {
  const StaffReport(this.rows);
  final List<StaffReportRow> rows;
}

class EngineersReport extends ReportResult {
  const EngineersReport(this.rows);
  final List<EngineerReportRow> rows;
}

class PaymentsReport extends ReportResult {
  const PaymentsReport(this.report);
  final PaymentReport report;
}

class StockReport extends ReportResult {
  const StockReport(this.rows);
  final List<StockReportRow> rows;
}
