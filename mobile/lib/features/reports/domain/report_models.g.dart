// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateCounts _$UpdateCountsFromJson(Map<String, dynamic> json) => _UpdateCounts(
  submitted: (json['submitted'] as num).toInt(),
  missed: (json['missed'] as num).toInt(),
  offline: (json['offline'] as num).toInt(),
  locationFlagged: (json['locationFlagged'] as num).toInt(),
  compliancePercent: (json['compliancePercent'] as num?)?.toInt(),
);

Map<String, dynamic> _$UpdateCountsToJson(_UpdateCounts instance) => <String, dynamic>{
  'submitted': instance.submitted,
  'missed': instance.missed,
  'offline': instance.offline,
  'locationFlagged': instance.locationFlagged,
  'compliancePercent': instance.compliancePercent,
};

_AttendanceCounts _$AttendanceCountsFromJson(Map<String, dynamic> json) => _AttendanceCounts(
  present: (json['present'] as num).toInt(),
  late: (json['late'] as num).toInt(),
  halfDay: (json['halfDay'] as num).toInt(),
  absent: (json['absent'] as num).toInt(),
);

Map<String, dynamic> _$AttendanceCountsToJson(_AttendanceCounts instance) => <String, dynamic>{
  'present': instance.present,
  'late': instance.late,
  'halfDay': instance.halfDay,
  'absent': instance.absent,
};

_ReportSite _$ReportSiteFromJson(Map<String, dynamic> json) => _ReportSite(
  id: json['id'] as String,
  code: json['code'] as String,
  name: json['name'] as String,
  status: $enumDecodeNullable(_$SiteStatusEnumMap, json['status']),
);

Map<String, dynamic> _$ReportSiteToJson(_ReportSite instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'name': instance.name,
  'status': _$SiteStatusEnumMap[instance.status],
};

const _$SiteStatusEnumMap = {
  SiteStatus.notStarted: 'NOT_STARTED',
  SiteStatus.inProgress: 'IN_PROGRESS',
  SiteStatus.onHold: 'ON_HOLD',
  SiteStatus.completed: 'COMPLETED',
};

_SiteIssueCounts _$SiteIssueCountsFromJson(Map<String, dynamic> json) => _SiteIssueCounts(
  opened: (json['opened'] as num).toInt(),
  resolved: (json['resolved'] as num).toInt(),
  openNow: (json['openNow'] as num).toInt(),
);

Map<String, dynamic> _$SiteIssueCountsToJson(_SiteIssueCounts instance) => <String, dynamic>{
  'opened': instance.opened,
  'resolved': instance.resolved,
  'openNow': instance.openNow,
};

_SiteReportRow _$SiteReportRowFromJson(Map<String, dynamic> json) => _SiteReportRow(
  site: ReportSite.fromJson(json['site'] as Map<String, dynamic>),
  client: IdName.fromJson(json['client'] as Map<String, dynamic>),
  updates: UpdateCounts.fromJson(json['updates'] as Map<String, dynamic>),
  attendance: AttendanceCounts.fromJson(json['attendance'] as Map<String, dynamic>),
  engineerUpdates: (json['engineerUpdates'] as num).toInt(),
  issues: SiteIssueCounts.fromJson(json['issues'] as Map<String, dynamic>),
  received: json['received'] as String?,
);

Map<String, dynamic> _$SiteReportRowToJson(_SiteReportRow instance) => <String, dynamic>{
  'site': instance.site,
  'client': instance.client,
  'updates': instance.updates,
  'attendance': instance.attendance,
  'engineerUpdates': instance.engineerUpdates,
  'issues': instance.issues,
  'received': instance.received,
};

_ReportPerson _$ReportPersonFromJson(Map<String, dynamic> json) => _ReportPerson(
  id: json['id'] as String,
  name: json['name'] as String,
  employeeCode: json['employeeCode'] as String,
  designation: $enumDecodeNullable(_$DesignationEnumMap, json['designation']),
  isActive: json['isActive'] as bool,
);

Map<String, dynamic> _$ReportPersonToJson(_ReportPerson instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'employeeCode': instance.employeeCode,
  'designation': _$DesignationEnumMap[instance.designation],
  'isActive': instance.isActive,
};

const _$DesignationEnumMap = {
  Designation.mason: 'MASON',
  Designation.helper: 'HELPER',
  Designation.electrician: 'ELECTRICIAN',
  Designation.carpenter: 'CARPENTER',
  Designation.plumber: 'PLUMBER',
  Designation.supervisor: 'SUPERVISOR',
  Designation.painter: 'PAINTER',
  Designation.generalWorker: 'GENERAL_WORKER',
};

_StaffReportRow _$StaffReportRowFromJson(Map<String, dynamic> json) => _StaffReportRow(
  staff: ReportPerson.fromJson(json['staff'] as Map<String, dynamic>),
  site: json['site'] == null ? null : IdName.fromJson(json['site'] as Map<String, dynamic>),
  attendance: AttendanceCounts.fromJson(json['attendance'] as Map<String, dynamic>),
  updates: UpdateCounts.fromJson(json['updates'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StaffReportRowToJson(_StaffReportRow instance) => <String, dynamic>{
  'staff': instance.staff,
  'site': instance.site,
  'attendance': instance.attendance,
  'updates': instance.updates,
};

_EngineerIssueCounts _$EngineerIssueCountsFromJson(Map<String, dynamic> json) =>
    _EngineerIssueCounts(reported: (json['reported'] as num).toInt(), resolved: (json['resolved'] as num).toInt());

Map<String, dynamic> _$EngineerIssueCountsToJson(_EngineerIssueCounts instance) => <String, dynamic>{
  'reported': instance.reported,
  'resolved': instance.resolved,
};

_ReviewCounts _$ReviewCountsFromJson(Map<String, dynamic> json) => _ReviewCounts(
  photos: (json['photos'] as num).toInt(),
  reviewed: (json['reviewed'] as num).toInt(),
  reviewRatePercent: (json['reviewRatePercent'] as num?)?.toInt(),
  averageMinutes: (json['averageMinutes'] as num?)?.toInt(),
);

Map<String, dynamic> _$ReviewCountsToJson(_ReviewCounts instance) => <String, dynamic>{
  'photos': instance.photos,
  'reviewed': instance.reviewed,
  'reviewRatePercent': instance.reviewRatePercent,
  'averageMinutes': instance.averageMinutes,
};

_EngineerReportRow _$EngineerReportRowFromJson(Map<String, dynamic> json) => _EngineerReportRow(
  engineer: ReportPerson.fromJson(json['engineer'] as Map<String, dynamic>),
  sites: (json['sites'] as num).toInt(),
  engineerUpdates: (json['engineerUpdates'] as num).toInt(),
  issues: EngineerIssueCounts.fromJson(json['issues'] as Map<String, dynamic>),
  reviews: ReviewCounts.fromJson(json['reviews'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EngineerReportRowToJson(_EngineerReportRow instance) => <String, dynamic>{
  'engineer': instance.engineer,
  'sites': instance.sites,
  'engineerUpdates': instance.engineerUpdates,
  'issues': instance.issues,
  'reviews': instance.reviews,
};

_PaymentReportTotals _$PaymentReportTotalsFromJson(Map<String, dynamic> json) => _PaymentReportTotals(
  received: json['received'] as String,
  count: (json['count'] as num).toInt(),
  byMethod:
      (json['byMethod'] as Map<String, dynamic>?)?.map((k, e) => MapEntry(k, e as String)) ?? const <String, String>{},
);

Map<String, dynamic> _$PaymentReportTotalsToJson(_PaymentReportTotals instance) => <String, dynamic>{
  'received': instance.received,
  'count': instance.count,
  'byMethod': instance.byMethod,
};

_PaymentReportSite _$PaymentReportSiteFromJson(Map<String, dynamic> json) => _PaymentReportSite(
  site: ReportSite.fromJson(json['site'] as Map<String, dynamic>),
  client: IdName.fromJson(json['client'] as Map<String, dynamic>),
  receivedInRange: json['receivedInRange'] as String,
  contract: json['contract'] as String,
  receivedToDate: json['receivedToDate'] as String,
  pending: json['pending'] as String,
  overdue: json['overdue'] as String,
);

Map<String, dynamic> _$PaymentReportSiteToJson(_PaymentReportSite instance) => <String, dynamic>{
  'site': instance.site,
  'client': instance.client,
  'receivedInRange': instance.receivedInRange,
  'contract': instance.contract,
  'receivedToDate': instance.receivedToDate,
  'pending': instance.pending,
  'overdue': instance.overdue,
};

_PaymentReportLine _$PaymentReportLineFromJson(Map<String, dynamic> json) => _PaymentReportLine(
  id: json['id'] as String,
  paidOn: json['paidOn'] as String,
  amount: json['amount'] as String,
  method: $enumDecode(_$PaymentMethodEnumMap, json['method'], unknownValue: PaymentMethod.other),
  reference: json['reference'] as String?,
  site: IdName.fromJson(json['site'] as Map<String, dynamic>),
  client: IdName.fromJson(json['client'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PaymentReportLineToJson(_PaymentReportLine instance) => <String, dynamic>{
  'id': instance.id,
  'paidOn': instance.paidOn,
  'amount': instance.amount,
  'method': _$PaymentMethodEnumMap[instance.method]!,
  'reference': instance.reference,
  'site': instance.site,
  'client': instance.client,
};

const _$PaymentMethodEnumMap = {
  PaymentMethod.cash: 'CASH',
  PaymentMethod.upi: 'UPI',
  PaymentMethod.bankTransfer: 'BANK_TRANSFER',
  PaymentMethod.cheque: 'CHEQUE',
  PaymentMethod.other: 'OTHER',
};

_PaymentReport _$PaymentReportFromJson(Map<String, dynamic> json) => _PaymentReport(
  totals: PaymentReportTotals.fromJson(json['totals'] as Map<String, dynamic>),
  sites: (json['sites'] as List<dynamic>).map((e) => PaymentReportSite.fromJson(e as Map<String, dynamic>)).toList(),
  payments: (json['payments'] as List<dynamic>)
      .map((e) => PaymentReportLine.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PaymentReportToJson(_PaymentReport instance) => <String, dynamic>{
  'totals': instance.totals,
  'sites': instance.sites,
  'payments': instance.payments,
};
