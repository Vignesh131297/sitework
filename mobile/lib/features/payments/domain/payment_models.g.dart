// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Payment _$PaymentFromJson(Map<String, dynamic> json) => _Payment(
  id: json['id'] as String,
  amount: json['amount'] as String,
  paidOn: json['paidOn'] as String,
  method: $enumDecode(_$PaymentMethodEnumMap, json['method']),
  reference: json['reference'] as String?,
  remarks: json['remarks'] as String?,
  site: SiteRef.fromJson(json['site'] as Map<String, dynamic>),
  client: IdName.fromJson(json['client'] as Map<String, dynamic>),
  recordedBy: IdName.fromJson(json['recordedBy'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  voidedAt: json['voidedAt'] == null ? null : DateTime.parse(json['voidedAt'] as String),
  voidedBy: json['voidedBy'] == null ? null : IdName.fromJson(json['voidedBy'] as Map<String, dynamic>),
  voidReason: json['voidReason'] as String?,
);

Map<String, dynamic> _$PaymentToJson(_Payment instance) => <String, dynamic>{
  'id': instance.id,
  'amount': instance.amount,
  'paidOn': instance.paidOn,
  'method': _$PaymentMethodEnumMap[instance.method]!,
  'reference': instance.reference,
  'remarks': instance.remarks,
  'site': instance.site,
  'client': instance.client,
  'recordedBy': instance.recordedBy,
  'createdAt': instance.createdAt.toIso8601String(),
  'voidedAt': instance.voidedAt?.toIso8601String(),
  'voidedBy': instance.voidedBy,
  'voidReason': instance.voidReason,
};

const _$PaymentMethodEnumMap = {
  PaymentMethod.cash: 'CASH',
  PaymentMethod.upi: 'UPI',
  PaymentMethod.bankTransfer: 'BANK_TRANSFER',
  PaymentMethod.cheque: 'CHEQUE',
  PaymentMethod.other: 'OTHER',
};

_MoneySite _$MoneySiteFromJson(Map<String, dynamic> json) => _MoneySite(
  id: json['id'] as String,
  code: json['code'] as String,
  name: json['name'] as String,
  status: $enumDecode(_$SiteStatusEnumMap, json['status']),
);

Map<String, dynamic> _$MoneySiteToJson(_MoneySite instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'name': instance.name,
  'status': _$SiteStatusEnumMap[instance.status]!,
};

const _$SiteStatusEnumMap = {
  SiteStatus.notStarted: 'NOT_STARTED',
  SiteStatus.inProgress: 'IN_PROGRESS',
  SiteStatus.onHold: 'ON_HOLD',
  SiteStatus.completed: 'COMPLETED',
};

_SiteMoney _$SiteMoneyFromJson(Map<String, dynamic> json) => _SiteMoney(
  site: MoneySite.fromJson(json['site'] as Map<String, dynamic>),
  client: IdName.fromJson(json['client'] as Map<String, dynamic>),
  financials: SiteFinancials.fromJson(json['financials'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SiteMoneyToJson(_SiteMoney instance) => <String, dynamic>{
  'site': instance.site,
  'client': instance.client,
  'financials': instance.financials,
};

_SiteMoneyRow _$SiteMoneyRowFromJson(Map<String, dynamic> json) => _SiteMoneyRow(
  site: MoneySite.fromJson(json['site'] as Map<String, dynamic>),
  client: IdName.fromJson(json['client'] as Map<String, dynamic>),
  financials: SiteFinancials.fromJson(json['financials'] as Map<String, dynamic>),
  nextDue: json['nextDue'] == null ? null : MilestoneView.fromJson(json['nextDue'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SiteMoneyRowToJson(_SiteMoneyRow instance) => <String, dynamic>{
  'site': instance.site,
  'client': instance.client,
  'financials': instance.financials,
  'nextDue': instance.nextDue,
};

_PaymentsSummary _$PaymentsSummaryFromJson(Map<String, dynamic> json) => _PaymentsSummary(
  totals: MoneyTotals.fromJson(json['totals'] as Map<String, dynamic>),
  sites: (json['sites'] as List<dynamic>).map((e) => SiteMoneyRow.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$PaymentsSummaryToJson(_PaymentsSummary instance) => <String, dynamic>{
  'totals': instance.totals,
  'sites': instance.sites,
};
