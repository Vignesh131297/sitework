import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/enums.dart';
import '../../../core/models/refs.dart';
import '../../dashboard/domain/admin_dashboard.dart';
import '../../sites/domain/site_models.dart';

part 'payment_models.freezed.dart';
part 'payment_models.g.dart';

/// Money received for a site. Voided payments stay, marked, and don't count.
@freezed
abstract class Payment with _$Payment {
  const factory Payment({
    required String id,
    required String amount,
    required String paidOn,
    required PaymentMethod method,
    String? reference,
    String? remarks,
    required SiteRef site,
    required IdName client,
    required IdName recordedBy,
    required DateTime createdAt,
    DateTime? voidedAt,
    IdName? voidedBy,
    String? voidReason,
  }) = _Payment;

  const Payment._();

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

  bool get isVoided => voidedAt != null;
}

@freezed
abstract class MoneySite with _$MoneySite {
  const factory MoneySite({
    required String id,
    required String code,
    required String name,
    required SiteStatus status,
  }) = _MoneySite;

  factory MoneySite.fromJson(Map<String, dynamic> json) => _$MoneySiteFromJson(json);
}

/// One site's money: contract, received, schedule (milestones) and what is late.
@freezed
abstract class SiteMoney with _$SiteMoney {
  const factory SiteMoney({required MoneySite site, required IdName client, required SiteFinancials financials}) =
      _SiteMoney;

  factory SiteMoney.fromJson(Map<String, dynamic> json) => _$SiteMoneyFromJson(json);
}

@freezed
abstract class SiteMoneyRow with _$SiteMoneyRow {
  const factory SiteMoneyRow({
    required MoneySite site,
    required IdName client,
    required SiteFinancials financials,

    /// The earliest milestone not fully paid.
    MilestoneView? nextDue,
  }) = _SiteMoneyRow;

  factory SiteMoneyRow.fromJson(Map<String, dynamic> json) => _$SiteMoneyRowFromJson(json);
}

/// Response of `GET /payments/summary`: totals and every site, most urgent first.
@freezed
abstract class PaymentsSummary with _$PaymentsSummary {
  const factory PaymentsSummary({required MoneyTotals totals, required List<SiteMoneyRow> sites}) = _PaymentsSummary;

  factory PaymentsSummary.fromJson(Map<String, dynamic> json) => _$PaymentsSummaryFromJson(json);
}
