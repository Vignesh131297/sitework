// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SiteSummary _$SiteSummaryFromJson(Map<String, dynamic> json) => _SiteSummary(
  id: json['id'] as String,
  code: json['code'] as String,
  name: json['name'] as String,
  status: $enumDecode(_$SiteStatusEnumMap, json['status']),
  progressPercent: (json['progressPercent'] as num).toInt(),
  address: json['address'] as String,
  client: IdName.fromJson(json['client'] as Map<String, dynamic>),
  engineers:
      (json['engineers'] as List<dynamic>?)?.map((e) => IdName.fromJson(e as Map<String, dynamic>)).toList() ??
      const <IdName>[],
  staffCount: (json['staffCount'] as num).toInt(),
  startDate: json['startDate'] as String,
  expectedCompletionDate: json['expectedCompletionDate'] as String?,
  contractAmount: json['contractAmount'] as String?,
);

Map<String, dynamic> _$SiteSummaryToJson(_SiteSummary instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'name': instance.name,
  'status': _$SiteStatusEnumMap[instance.status]!,
  'progressPercent': instance.progressPercent,
  'address': instance.address,
  'client': instance.client,
  'engineers': instance.engineers,
  'staffCount': instance.staffCount,
  'startDate': instance.startDate,
  'expectedCompletionDate': instance.expectedCompletionDate,
  'contractAmount': instance.contractAmount,
};

const _$SiteStatusEnumMap = {
  SiteStatus.notStarted: 'NOT_STARTED',
  SiteStatus.inProgress: 'IN_PROGRESS',
  SiteStatus.onHold: 'ON_HOLD',
  SiteStatus.completed: 'COMPLETED',
};

_SiteClient _$SiteClientFromJson(Map<String, dynamic> json) => _SiteClient(
  id: json['id'] as String,
  name: json['name'] as String,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
);

Map<String, dynamic> _$SiteClientToJson(_SiteClient instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'phone': instance.phone,
  'email': instance.email,
};

_SiteStaffMember _$SiteStaffMemberFromJson(Map<String, dynamic> json) => _SiteStaffMember(
  id: json['id'] as String,
  name: json['name'] as String,
  phone: json['phone'] as String,
  designation: $enumDecodeNullable(_$DesignationEnumMap, json['designation']),
  engineer: IdName.fromJson(json['engineer'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SiteStaffMemberToJson(_SiteStaffMember instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'phone': instance.phone,
  'designation': _$DesignationEnumMap[instance.designation],
  'engineer': instance.engineer,
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

_MilestoneView _$MilestoneViewFromJson(Map<String, dynamic> json) => _MilestoneView(
  id: json['id'] as String,
  title: json['title'] as String,
  amount: json['amount'] as String,
  dueDate: json['dueDate'] as String,
  paid: json['paid'] as String,
  outstanding: json['outstanding'] as String,
  status: $enumDecode(_$MilestoneStatusEnumMap, json['status']),
);

Map<String, dynamic> _$MilestoneViewToJson(_MilestoneView instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'amount': instance.amount,
  'dueDate': instance.dueDate,
  'paid': instance.paid,
  'outstanding': instance.outstanding,
  'status': _$MilestoneStatusEnumMap[instance.status]!,
};

const _$MilestoneStatusEnumMap = {
  MilestoneStatus.paid: 'PAID',
  MilestoneStatus.partiallyPaid: 'PARTIALLY_PAID',
  MilestoneStatus.pending: 'PENDING',
  MilestoneStatus.overdue: 'OVERDUE',
};

_SiteFinancials _$SiteFinancialsFromJson(Map<String, dynamic> json) => _SiteFinancials(
  contract: json['contract'] as String,
  received: json['received'] as String,
  pending: json['pending'] as String,
  overdue: json['overdue'] as String,
  overdueCount: (json['overdueCount'] as num).toInt(),
  milestones:
      (json['milestones'] as List<dynamic>?)?.map((e) => MilestoneView.fromJson(e as Map<String, dynamic>)).toList() ??
      const <MilestoneView>[],
);

Map<String, dynamic> _$SiteFinancialsToJson(_SiteFinancials instance) => <String, dynamic>{
  'contract': instance.contract,
  'received': instance.received,
  'pending': instance.pending,
  'overdue': instance.overdue,
  'overdueCount': instance.overdueCount,
  'milestones': instance.milestones,
};

_SiteDetail _$SiteDetailFromJson(Map<String, dynamic> json) => _SiteDetail(
  id: json['id'] as String,
  code: json['code'] as String,
  name: json['name'] as String,
  status: $enumDecode(_$SiteStatusEnumMap, json['status']),
  progressPercent: (json['progressPercent'] as num).toInt(),
  address: json['address'] as String,
  client: SiteClient.fromJson(json['client'] as Map<String, dynamic>),
  engineers:
      (json['engineers'] as List<dynamic>?)?.map((e) => IdName.fromJson(e as Map<String, dynamic>)).toList() ??
      const <IdName>[],
  staffCount: (json['staffCount'] as num).toInt(),
  startDate: json['startDate'] as String,
  expectedCompletionDate: json['expectedCompletionDate'] as String?,
  contractAmount: json['contractAmount'] as String?,
  contactName: json['contactName'] as String?,
  contactPhone: json['contactPhone'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  geofenceRadiusM: (json['geofenceRadiusM'] as num?)?.toInt(),
  staff:
      (json['staff'] as List<dynamic>?)?.map((e) => SiteStaffMember.fromJson(e as Map<String, dynamic>)).toList() ??
      const <SiteStaffMember>[],
  financials: json['financials'] == null ? null : SiteFinancials.fromJson(json['financials'] as Map<String, dynamic>),
  openIssues: (json['openIssues'] as num).toInt(),
);

Map<String, dynamic> _$SiteDetailToJson(_SiteDetail instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'name': instance.name,
  'status': _$SiteStatusEnumMap[instance.status]!,
  'progressPercent': instance.progressPercent,
  'address': instance.address,
  'client': instance.client,
  'engineers': instance.engineers,
  'staffCount': instance.staffCount,
  'startDate': instance.startDate,
  'expectedCompletionDate': instance.expectedCompletionDate,
  'contractAmount': instance.contractAmount,
  'contactName': instance.contactName,
  'contactPhone': instance.contactPhone,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'geofenceRadiusM': instance.geofenceRadiusM,
  'staff': instance.staff,
  'financials': instance.financials,
  'openIssues': instance.openIssues,
};
