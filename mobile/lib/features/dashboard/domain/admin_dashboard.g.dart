// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DayTotals _$DayTotalsFromJson(Map<String, dynamic> json) => _DayTotals(
  expected: (json['expected'] as num).toInt(),
  submitted: (json['submitted'] as num).toInt(),
  missing: (json['missing'] as num).toInt(),
  pending: (json['pending'] as num).toInt(),
  upcoming: (json['upcoming'] as num).toInt(),
  notCheckedIn: (json['notCheckedIn'] as num).toInt(),
);

Map<String, dynamic> _$DayTotalsToJson(_DayTotals instance) => <String, dynamic>{
  'expected': instance.expected,
  'submitted': instance.submitted,
  'missing': instance.missing,
  'pending': instance.pending,
  'upcoming': instance.upcoming,
  'notCheckedIn': instance.notCheckedIn,
};

_MoneyTotals _$MoneyTotalsFromJson(Map<String, dynamic> json) => _MoneyTotals(
  contract: json['contract'] as String,
  received: json['received'] as String,
  pending: json['pending'] as String,
  overdue: json['overdue'] as String,
  overdueCount: (json['overdueCount'] as num).toInt(),
);

Map<String, dynamic> _$MoneyTotalsToJson(_MoneyTotals instance) => <String, dynamic>{
  'contract': instance.contract,
  'received': instance.received,
  'pending': instance.pending,
  'overdue': instance.overdue,
  'overdueCount': instance.overdueCount,
};

_DashboardCounts _$DashboardCountsFromJson(Map<String, dynamic> json) => _DashboardCounts(
  activeSites: (json['activeSites'] as num).toInt(),
  clients: (json['clients'] as num).toInt(),
  engineers: (json['engineers'] as num).toInt(),
  staff: (json['staff'] as num).toInt(),
);

Map<String, dynamic> _$DashboardCountsToJson(_DashboardCounts instance) => <String, dynamic>{
  'activeSites': instance.activeSites,
  'clients': instance.clients,
  'engineers': instance.engineers,
  'staff': instance.staff,
};

_IssueCounts _$IssueCountsFromJson(Map<String, dynamic> json) =>
    _IssueCounts(open: (json['open'] as num).toInt(), critical: (json['critical'] as num).toInt());

Map<String, dynamic> _$IssueCountsToJson(_IssueCounts instance) => <String, dynamic>{
  'open': instance.open,
  'critical': instance.critical,
};

_StockCounts _$StockCountsFromJson(Map<String, dynamic> json) => _StockCounts(
  lowStock: (json['lowStock'] as num?)?.toInt() ?? 0,
  toReceive: (json['toReceive'] as num?)?.toInt() ?? 0,
  requestsToApprove: (json['requestsToApprove'] as num?)?.toInt() ?? 0,
  openRequests: (json['openRequests'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$StockCountsToJson(_StockCounts instance) => <String, dynamic>{
  'lowStock': instance.lowStock,
  'toReceive': instance.toReceive,
  'requestsToApprove': instance.requestsToApprove,
  'openRequests': instance.openRequests,
};

MissingUpdatesItem _$MissingUpdatesItemFromJson(Map<String, dynamic> json) => MissingUpdatesItem(
  site: IdName.fromJson(json['site'] as Map<String, dynamic>),
  count: (json['count'] as num).toInt(),
  staffNames: (json['staffNames'] as List<dynamic>).map((e) => e as String).toList(),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$MissingUpdatesItemToJson(MissingUpdatesItem instance) => <String, dynamic>{
  'site': instance.site,
  'count': instance.count,
  'staffNames': instance.staffNames,
  'type': instance.$type,
};

NotCheckedInItem _$NotCheckedInItemFromJson(Map<String, dynamic> json) => NotCheckedInItem(
  site: IdName.fromJson(json['site'] as Map<String, dynamic>),
  count: (json['count'] as num).toInt(),
  staffNames: (json['staffNames'] as List<dynamic>).map((e) => e as String).toList(),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$NotCheckedInItemToJson(NotCheckedInItem instance) => <String, dynamic>{
  'site': instance.site,
  'count': instance.count,
  'staffNames': instance.staffNames,
  'type': instance.$type,
};

OverduePaymentItem _$OverduePaymentItemFromJson(Map<String, dynamic> json) => OverduePaymentItem(
  site: IdName.fromJson(json['site'] as Map<String, dynamic>),
  milestone: TitledRef.fromJson(json['milestone'] as Map<String, dynamic>),
  outstanding: json['outstanding'] as String,
  dueDate: json['dueDate'] as String,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$OverduePaymentItemToJson(OverduePaymentItem instance) => <String, dynamic>{
  'site': instance.site,
  'milestone': instance.milestone,
  'outstanding': instance.outstanding,
  'dueDate': instance.dueDate,
  'type': instance.$type,
};

CriticalIssueItem _$CriticalIssueItemFromJson(Map<String, dynamic> json) => CriticalIssueItem(
  site: IdName.fromJson(json['site'] as Map<String, dynamic>),
  issue: TitledRef.fromJson(json['issue'] as Map<String, dynamic>),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$CriticalIssueItemToJson(CriticalIssueItem instance) => <String, dynamic>{
  'site': instance.site,
  'issue': instance.issue,
  'type': instance.$type,
};

UnknownAttentionItem _$UnknownAttentionItemFromJson(Map<String, dynamic> json) =>
    UnknownAttentionItem($type: json['type'] as String?);

Map<String, dynamic> _$UnknownAttentionItemToJson(UnknownAttentionItem instance) => <String, dynamic>{
  'type': instance.$type,
};

_ActivitySite _$ActivitySiteFromJson(Map<String, dynamic> json) => _ActivitySite(
  id: json['id'] as String,
  code: json['code'] as String,
  name: json['name'] as String,
  status: $enumDecode(_$SiteStatusEnumMap, json['status']),
);

Map<String, dynamic> _$ActivitySiteToJson(_ActivitySite instance) => <String, dynamic>{
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

_SiteActivity _$SiteActivityFromJson(Map<String, dynamic> json) => _SiteActivity(
  site: ActivitySite.fromJson(json['site'] as Map<String, dynamic>),
  engineers: (json['engineers'] as List<dynamic>).map((e) => e as String).toList(),
  staffCount: (json['staffCount'] as num).toInt(),
  updates: DayTotals.fromJson(json['updates'] as Map<String, dynamic>),
  lastActivityAt: json['lastActivityAt'] == null ? null : DateTime.parse(json['lastActivityAt'] as String),
);

Map<String, dynamic> _$SiteActivityToJson(_SiteActivity instance) => <String, dynamic>{
  'site': instance.site,
  'engineers': instance.engineers,
  'staffCount': instance.staffCount,
  'updates': instance.updates,
  'lastActivityAt': instance.lastActivityAt?.toIso8601String(),
};

_AdminDashboard _$AdminDashboardFromJson(Map<String, dynamic> json) => _AdminDashboard(
  date: json['date'] as String,
  isWorkingDay: json['isWorkingDay'] as bool,
  holiday: json['holiday'] as String?,
  counts: DashboardCounts.fromJson(json['counts'] as Map<String, dynamic>),
  payments: MoneyTotals.fromJson(json['payments'] as Map<String, dynamic>),
  updates: DayTotals.fromJson(json['updates'] as Map<String, dynamic>),
  toReview: (json['toReview'] as num?)?.toInt() ?? 0,
  issues: IssueCounts.fromJson(json['issues'] as Map<String, dynamic>),
  stock: json['stock'] == null ? const StockCounts() : StockCounts.fromJson(json['stock'] as Map<String, dynamic>),
  attention: (json['attention'] as List<dynamic>)
      .map((e) => AttentionItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  sites: (json['sites'] as List<dynamic>).map((e) => SiteActivity.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$AdminDashboardToJson(_AdminDashboard instance) => <String, dynamic>{
  'date': instance.date,
  'isWorkingDay': instance.isWorkingDay,
  'holiday': instance.holiday,
  'counts': instance.counts,
  'payments': instance.payments,
  'updates': instance.updates,
  'toReview': instance.toReview,
  'issues': instance.issues,
  'stock': instance.stock,
  'attention': instance.attention,
  'sites': instance.sites,
};

_EngineerDashboard _$EngineerDashboardFromJson(Map<String, dynamic> json) => _EngineerDashboard(
  date: json['date'] as String,
  isWorkingDay: json['isWorkingDay'] as bool,
  holiday: json['holiday'] as String?,
  updates: DayTotals.fromJson(json['updates'] as Map<String, dynamic>),
  toReview: (json['toReview'] as num).toInt(),
  issues: IssueCounts.fromJson(json['issues'] as Map<String, dynamic>),
  stock: json['stock'] == null ? const StockCounts() : StockCounts.fromJson(json['stock'] as Map<String, dynamic>),
  attention: (json['attention'] as List<dynamic>)
      .map((e) => AttentionItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  sites: (json['sites'] as List<dynamic>).map((e) => SiteActivity.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$EngineerDashboardToJson(_EngineerDashboard instance) => <String, dynamic>{
  'date': instance.date,
  'isWorkingDay': instance.isWorkingDay,
  'holiday': instance.holiday,
  'updates': instance.updates,
  'toReview': instance.toReview,
  'issues': instance.issues,
  'stock': instance.stock,
  'attention': instance.attention,
  'sites': instance.sites,
};

_GodownDashboard _$GodownDashboardFromJson(Map<String, dynamic> json) => _GodownDashboard(
  date: json['date'] as String,
  godowns: (json['godowns'] as List<dynamic>).map((e) => GodownSummary.fromJson(e as Map<String, dynamic>)).toList(),
  toSend: (json['toSend'] as num?)?.toInt() ?? 0,
  toReceive: (json['toReceive'] as num?)?.toInt() ?? 0,
  lowStock: (json['lowStock'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$GodownDashboardToJson(_GodownDashboard instance) => <String, dynamic>{
  'date': instance.date,
  'godowns': instance.godowns,
  'toSend': instance.toSend,
  'toReceive': instance.toReceive,
  'lowStock': instance.lowStock,
};
