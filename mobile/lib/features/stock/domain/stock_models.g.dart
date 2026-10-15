// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StockMaterial _$StockMaterialFromJson(Map<String, dynamic> json) => _StockMaterial(
  id: json['id'] as String,
  name: json['name'] as String,
  unit: json['unit'] as String,
  category: json['category'] as String?,
  minStock: json['minStock'] as String?,
  isActive: json['isActive'] as bool,
);

Map<String, dynamic> _$StockMaterialToJson(_StockMaterial instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'unit': instance.unit,
  'category': instance.category,
  'minStock': instance.minStock,
  'isActive': instance.isActive,
};

_MaterialRef _$MaterialRefFromJson(Map<String, dynamic> json) =>
    _MaterialRef(id: json['id'] as String, name: json['name'] as String, unit: json['unit'] as String);

Map<String, dynamic> _$MaterialRefToJson(_MaterialRef instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'unit': instance.unit,
};

_Godown _$GodownFromJson(Map<String, dynamic> json) => _Godown(
  id: json['id'] as String,
  name: json['name'] as String,
  address: json['address'] as String?,
  isActive: json['isActive'] as bool,
);

Map<String, dynamic> _$GodownToJson(_Godown instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'address': instance.address,
  'isActive': instance.isActive,
};

_StockPlaceRef _$StockPlaceRefFromJson(Map<String, dynamic> json) => _StockPlaceRef(
  place: $enumDecode(_$StockPlaceEnumMap, json['place']),
  site: json['site'] == null ? null : SiteRef.fromJson(json['site'] as Map<String, dynamic>),
  godown: json['godown'] == null ? null : IdName.fromJson(json['godown'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StockPlaceRefToJson(_StockPlaceRef instance) => <String, dynamic>{
  'place': _$StockPlaceEnumMap[instance.place]!,
  'site': instance.site,
  'godown': instance.godown,
};

const _$StockPlaceEnumMap = {
  StockPlace.supplier: 'SUPPLIER',
  StockPlace.godown: 'GODOWN',
  StockPlace.site: 'SITE',
  StockPlace.used: 'USED',
  StockPlace.waste: 'WASTE',
  StockPlace.adjustment: 'ADJUSTMENT',
};

_StockLine _$StockLineFromJson(Map<String, dynamic> json) => _StockLine(
  id: json['id'] as String,
  material: MaterialRef.fromJson(json['material'] as Map<String, dynamic>),
  quantity: json['quantity'] as String,
  receivedQuantity: json['receivedQuantity'] as String?,
  shortQuantity: json['shortQuantity'] as String?,
  rate: json['rate'] as String?,
  amount: json['amount'] as String?,
);

Map<String, dynamic> _$StockLineToJson(_StockLine instance) => <String, dynamic>{
  'id': instance.id,
  'material': instance.material,
  'quantity': instance.quantity,
  'receivedQuantity': instance.receivedQuantity,
  'shortQuantity': instance.shortQuantity,
  'rate': instance.rate,
  'amount': instance.amount,
};

_StockPhoto _$StockPhotoFromJson(Map<String, dynamic> json) => _StockPhoto(
  id: json['id'] as String,
  mime: json['mime'] as String,
  url: json['url'] as String,
  expiresAt: DateTime.parse(json['expiresAt'] as String),
  stage: $enumDecode(_$StockPhotoStageEnumMap, json['stage']),
);

Map<String, dynamic> _$StockPhotoToJson(_StockPhoto instance) => <String, dynamic>{
  'id': instance.id,
  'mime': instance.mime,
  'url': instance.url,
  'expiresAt': instance.expiresAt.toIso8601String(),
  'stage': _$StockPhotoStageEnumMap[instance.stage]!,
};

const _$StockPhotoStageEnumMap = {StockPhotoStage.sent: 'SENT', StockPhotoStage.received: 'RECEIVED'};

_RequestRef _$RequestRefFromJson(Map<String, dynamic> json) =>
    _RequestRef(id: json['id'] as String, code: json['code'] as String);

Map<String, dynamic> _$RequestRefToJson(_RequestRef instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
};

_StockEntry _$StockEntryFromJson(Map<String, dynamic> json) => _StockEntry(
  id: json['id'] as String,
  requestId: json['requestId'] as String,
  kind: $enumDecode(_$StockKindEnumMap, json['kind']),
  from: StockPlaceRef.fromJson(json['from'] as Map<String, dynamic>),
  to: StockPlaceRef.fromJson(json['to'] as Map<String, dynamic>),
  status: $enumDecode(_$StockMovementStatusEnumMap, json['status']),
  movedOn: json['movedOn'] as String,
  dcNumber: json['dcNumber'] as String?,
  supplier: json['supplier'] as String?,
  billNo: json['billNo'] as String?,
  note: json['note'] as String?,
  lines: (json['lines'] as List<dynamic>).map((e) => StockLine.fromJson(e as Map<String, dynamic>)).toList(),
  totalAmount: json['totalAmount'] as String?,
  receivedOn: json['receivedOn'] as String?,
  receivedAt: json['receivedAt'] == null ? null : DateTime.parse(json['receivedAt'] as String),
  receivedBy: json['receivedBy'] == null ? null : IdName.fromJson(json['receivedBy'] as Map<String, dynamic>),
  receiveNote: json['receiveNote'] as String?,
  createdBy: IdName.fromJson(json['createdBy'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  voidedAt: json['voidedAt'] == null ? null : DateTime.parse(json['voidedAt'] as String),
  voidedBy: json['voidedBy'] == null ? null : IdName.fromJson(json['voidedBy'] as Map<String, dynamic>),
  voidReason: json['voidReason'] as String?,
  photoCount: (json['photoCount'] as num?)?.toInt() ?? 0,
  request: json['request'] == null ? null : RequestRef.fromJson(json['request'] as Map<String, dynamic>),
  photos:
      (json['photos'] as List<dynamic>?)?.map((e) => StockPhoto.fromJson(e as Map<String, dynamic>)).toList() ??
      const <StockPhoto>[],
  canReceive: json['canReceive'] as bool? ?? false,
  canVoid: json['canVoid'] as bool? ?? false,
);

Map<String, dynamic> _$StockEntryToJson(_StockEntry instance) => <String, dynamic>{
  'id': instance.id,
  'requestId': instance.requestId,
  'kind': _$StockKindEnumMap[instance.kind]!,
  'from': instance.from,
  'to': instance.to,
  'status': _$StockMovementStatusEnumMap[instance.status]!,
  'movedOn': instance.movedOn,
  'dcNumber': instance.dcNumber,
  'supplier': instance.supplier,
  'billNo': instance.billNo,
  'note': instance.note,
  'lines': instance.lines,
  'totalAmount': instance.totalAmount,
  'receivedOn': instance.receivedOn,
  'receivedAt': instance.receivedAt?.toIso8601String(),
  'receivedBy': instance.receivedBy,
  'receiveNote': instance.receiveNote,
  'createdBy': instance.createdBy,
  'createdAt': instance.createdAt.toIso8601String(),
  'voidedAt': instance.voidedAt?.toIso8601String(),
  'voidedBy': instance.voidedBy,
  'voidReason': instance.voidReason,
  'photoCount': instance.photoCount,
  'request': instance.request,
  'photos': instance.photos,
  'canReceive': instance.canReceive,
  'canVoid': instance.canVoid,
};

const _$StockKindEnumMap = {
  StockKind.purchase: 'PURCHASE',
  StockKind.transfer: 'TRANSFER',
  StockKind.usage: 'USAGE',
  StockKind.writeOff: 'WRITE_OFF',
  StockKind.adjustment: 'ADJUSTMENT',
};

const _$StockMovementStatusEnumMap = {
  StockMovementStatus.inTransit: 'IN_TRANSIT',
  StockMovementStatus.done: 'DONE',
  StockMovementStatus.voided: 'VOIDED',
};

_HolderStockRow _$HolderStockRowFromJson(Map<String, dynamic> json) => _HolderStockRow(
  material: StockMaterial.fromJson(json['material'] as Map<String, dynamic>),
  onHand: json['onHand'] as String,
  received: json['received'] as String,
  used: json['used'] as String,
  sentOut: json['sentOut'] as String,
  wasted: json['wasted'] as String,
  adjusted: json['adjusted'] as String,
  usedValue: json['usedValue'] as String?,
  onHandValue: json['onHandValue'] as String?,
);

Map<String, dynamic> _$HolderStockRowToJson(_HolderStockRow instance) => <String, dynamic>{
  'material': instance.material,
  'onHand': instance.onHand,
  'received': instance.received,
  'used': instance.used,
  'sentOut': instance.sentOut,
  'wasted': instance.wasted,
  'adjusted': instance.adjusted,
  'usedValue': instance.usedValue,
  'onHandValue': instance.onHandValue,
};

_StockSite _$StockSiteFromJson(Map<String, dynamic> json) => _StockSite(
  id: json['id'] as String,
  code: json['code'] as String,
  name: json['name'] as String,
  status: $enumDecode(_$SiteStatusEnumMap, json['status']),
);

Map<String, dynamic> _$StockSiteToJson(_StockSite instance) => <String, dynamic>{
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

_StockValue _$StockValueFromJson(Map<String, dynamic> json) =>
    _StockValue(used: json['used'] as String?, onHand: json['onHand'] as String);

Map<String, dynamic> _$StockValueToJson(_StockValue instance) => <String, dynamic>{
  'used': instance.used,
  'onHand': instance.onHand,
};

_SiteStock _$SiteStockFromJson(Map<String, dynamic> json) => _SiteStock(
  site: StockSite.fromJson(json['site'] as Map<String, dynamic>),
  items: (json['items'] as List<dynamic>).map((e) => HolderStockRow.fromJson(e as Map<String, dynamic>)).toList(),
  arriving: (json['arriving'] as List<dynamic>).map((e) => StockEntry.fromJson(e as Map<String, dynamic>)).toList(),
  leaving: (json['leaving'] as List<dynamic>).map((e) => StockEntry.fromJson(e as Map<String, dynamic>)).toList(),
  usedToday: json['usedToday'] as bool? ?? false,
  value: json['value'] == null ? null : StockValue.fromJson(json['value'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SiteStockToJson(_SiteStock instance) => <String, dynamic>{
  'site': instance.site,
  'items': instance.items,
  'arriving': instance.arriving,
  'leaving': instance.leaving,
  'usedToday': instance.usedToday,
  'value': instance.value,
};

_GodownStock _$GodownStockFromJson(Map<String, dynamic> json) => _GodownStock(
  godown: Godown.fromJson(json['godown'] as Map<String, dynamic>),
  items: (json['items'] as List<dynamic>).map((e) => HolderStockRow.fromJson(e as Map<String, dynamic>)).toList(),
  arriving: (json['arriving'] as List<dynamic>).map((e) => StockEntry.fromJson(e as Map<String, dynamic>)).toList(),
  leaving: (json['leaving'] as List<dynamic>).map((e) => StockEntry.fromJson(e as Map<String, dynamic>)).toList(),
  value: json['value'] == null ? null : StockValue.fromJson(json['value'] as Map<String, dynamic>),
  managers:
      (json['managers'] as List<dynamic>?)?.map((e) => PersonRef.fromJson(e as Map<String, dynamic>)).toList() ??
      const <PersonRef>[],
);

Map<String, dynamic> _$GodownStockToJson(_GodownStock instance) => <String, dynamic>{
  'godown': instance.godown,
  'items': instance.items,
  'arriving': instance.arriving,
  'leaving': instance.leaving,
  'value': instance.value,
  'managers': instance.managers,
};

_GodownSummary _$GodownSummaryFromJson(Map<String, dynamic> json) => _GodownSummary(
  godown: Godown.fromJson(json['godown'] as Map<String, dynamic>),
  arriving: (json['arriving'] as num).toInt(),
);

Map<String, dynamic> _$GodownSummaryToJson(_GodownSummary instance) => <String, dynamic>{
  'godown': instance.godown,
  'arriving': instance.arriving,
};

_MaterialTotals _$MaterialTotalsFromJson(Map<String, dynamic> json) => _MaterialTotals(
  material: StockMaterial.fromJson(json['material'] as Map<String, dynamic>),
  inGodowns: json['inGodowns'] as String,
  onSites: json['onSites'] as String,
  low: json['low'] as bool,
);

Map<String, dynamic> _$MaterialTotalsToJson(_MaterialTotals instance) => <String, dynamic>{
  'material': instance.material,
  'inGodowns': instance.inGodowns,
  'onSites': instance.onSites,
  'low': instance.low,
};

_StockOverview _$StockOverviewFromJson(Map<String, dynamic> json) => _StockOverview(
  godowns: (json['godowns'] as List<dynamic>).map((e) => GodownSummary.fromJson(e as Map<String, dynamic>)).toList(),
  materials: (json['materials'] as List<dynamic>)
      .map((e) => MaterialTotals.fromJson(e as Map<String, dynamic>))
      .toList(),
  toReceive: (json['toReceive'] as num).toInt(),
  sites:
      (json['sites'] as List<dynamic>?)?.map((e) => SiteRef.fromJson(e as Map<String, dynamic>)).toList() ??
      const <SiteRef>[],
);

Map<String, dynamic> _$StockOverviewToJson(_StockOverview instance) => <String, dynamic>{
  'godowns': instance.godowns,
  'materials': instance.materials,
  'toReceive': instance.toReceive,
  'sites': instance.sites,
};

_GodownHolding _$GodownHoldingFromJson(Map<String, dynamic> json) =>
    _GodownHolding(godown: IdName.fromJson(json['godown'] as Map<String, dynamic>), onHand: json['onHand'] as String);

Map<String, dynamic> _$GodownHoldingToJson(_GodownHolding instance) => <String, dynamic>{
  'godown': instance.godown,
  'onHand': instance.onHand,
};

_SiteHolding _$SiteHoldingFromJson(Map<String, dynamic> json) =>
    _SiteHolding(site: StockSite.fromJson(json['site'] as Map<String, dynamic>), onHand: json['onHand'] as String);

Map<String, dynamic> _$SiteHoldingToJson(_SiteHolding instance) => <String, dynamic>{
  'site': instance.site,
  'onHand': instance.onHand,
};

_MaterialDetail _$MaterialDetailFromJson(Map<String, dynamic> json) => _MaterialDetail(
  material: StockMaterial.fromJson(json['material'] as Map<String, dynamic>),
  averageRate: json['averageRate'] as String?,
  godowns: (json['godowns'] as List<dynamic>).map((e) => GodownHolding.fromJson(e as Map<String, dynamic>)).toList(),
  sites: (json['sites'] as List<dynamic>).map((e) => SiteHolding.fromJson(e as Map<String, dynamic>)).toList(),
  inGodowns: json['inGodowns'] as String,
  onSites: json['onSites'] as String,
  inTransit: json['inTransit'] as String,
);

Map<String, dynamic> _$MaterialDetailToJson(_MaterialDetail instance) => <String, dynamic>{
  'material': instance.material,
  'averageRate': instance.averageRate,
  'godowns': instance.godowns,
  'sites': instance.sites,
  'inGodowns': instance.inGodowns,
  'onSites': instance.onSites,
  'inTransit': instance.inTransit,
};

_StockReportRow _$StockReportRowFromJson(Map<String, dynamic> json) => _StockReportRow(
  place: $enumDecode(_$StockPlaceEnumMap, json['place']),
  site: json['site'] == null ? null : SiteRef.fromJson(json['site'] as Map<String, dynamic>),
  godown: json['godown'] == null ? null : IdName.fromJson(json['godown'] as Map<String, dynamic>),
  material: MaterialRef.fromJson(json['material'] as Map<String, dynamic>),
  opening: json['opening'] as String,
  received: json['received'] as String,
  used: json['used'] as String,
  sentOut: json['sentOut'] as String,
  wasted: json['wasted'] as String,
  adjusted: json['adjusted'] as String,
  closing: json['closing'] as String,
  usedValue: json['usedValue'] as String?,
);

Map<String, dynamic> _$StockReportRowToJson(_StockReportRow instance) => <String, dynamic>{
  'place': _$StockPlaceEnumMap[instance.place]!,
  'site': instance.site,
  'godown': instance.godown,
  'material': instance.material,
  'opening': instance.opening,
  'received': instance.received,
  'used': instance.used,
  'sentOut': instance.sentOut,
  'wasted': instance.wasted,
  'adjusted': instance.adjusted,
  'closing': instance.closing,
  'usedValue': instance.usedValue,
};

_MaterialRequestLine _$MaterialRequestLineFromJson(Map<String, dynamic> json) => _MaterialRequestLine(
  material: MaterialRef.fromJson(json['material'] as Map<String, dynamic>),
  quantity: json['quantity'] as String,
  approvedQuantity: json['approvedQuantity'] as String?,
  sent: json['sent'] as String,
  received: json['received'] as String,
  onTheWay: json['onTheWay'] as String,
  leftToSend: json['leftToSend'] as String?,
);

Map<String, dynamic> _$MaterialRequestLineToJson(_MaterialRequestLine instance) => <String, dynamic>{
  'material': instance.material,
  'quantity': instance.quantity,
  'approvedQuantity': instance.approvedQuantity,
  'sent': instance.sent,
  'received': instance.received,
  'onTheWay': instance.onTheWay,
  'leftToSend': instance.leftToSend,
};

_MaterialRequest _$MaterialRequestFromJson(Map<String, dynamic> json) => _MaterialRequest(
  id: json['id'] as String,
  code: json['code'] as String,
  site: SiteRef.fromJson(json['site'] as Map<String, dynamic>),
  requestedBy: IdName.fromJson(json['requestedBy'] as Map<String, dynamic>),
  status: $enumDecode(_$MaterialRequestStatusEnumMap, json['status']),
  neededBy: json['neededBy'] as String?,
  note: json['note'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  godown: json['godown'] == null ? null : IdName.fromJson(json['godown'] as Map<String, dynamic>),
  reviewedBy: json['reviewedBy'] == null ? null : IdName.fromJson(json['reviewedBy'] as Map<String, dynamic>),
  reviewedAt: json['reviewedAt'] == null ? null : DateTime.parse(json['reviewedAt'] as String),
  reviewNote: json['reviewNote'] as String?,
  outcome: $enumDecodeNullable(_$MaterialRequestOutcomeEnumMap, json['outcome']),
  closedBy: json['closedBy'] == null ? null : IdName.fromJson(json['closedBy'] as Map<String, dynamic>),
  closedAt: json['closedAt'] == null ? null : DateTime.parse(json['closedAt'] as String),
  closeNote: json['closeNote'] as String?,
  lines: (json['lines'] as List<dynamic>).map((e) => MaterialRequestLine.fromJson(e as Map<String, dynamic>)).toList(),
  sentInFull: json['sentInFull'] as bool? ?? false,
  entries:
      (json['entries'] as List<dynamic>?)?.map((e) => StockEntry.fromJson(e as Map<String, dynamic>)).toList() ??
      const <StockEntry>[],
  canApprove: json['canApprove'] as bool? ?? false,
  canCancel: json['canCancel'] as bool? ?? false,
  canSend: json['canSend'] as bool? ?? false,
  canClose: json['canClose'] as bool? ?? false,
);

Map<String, dynamic> _$MaterialRequestToJson(_MaterialRequest instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'site': instance.site,
  'requestedBy': instance.requestedBy,
  'status': _$MaterialRequestStatusEnumMap[instance.status]!,
  'neededBy': instance.neededBy,
  'note': instance.note,
  'createdAt': instance.createdAt.toIso8601String(),
  'godown': instance.godown,
  'reviewedBy': instance.reviewedBy,
  'reviewedAt': instance.reviewedAt?.toIso8601String(),
  'reviewNote': instance.reviewNote,
  'outcome': _$MaterialRequestOutcomeEnumMap[instance.outcome],
  'closedBy': instance.closedBy,
  'closedAt': instance.closedAt?.toIso8601String(),
  'closeNote': instance.closeNote,
  'lines': instance.lines,
  'sentInFull': instance.sentInFull,
  'entries': instance.entries,
  'canApprove': instance.canApprove,
  'canCancel': instance.canCancel,
  'canSend': instance.canSend,
  'canClose': instance.canClose,
};

const _$MaterialRequestStatusEnumMap = {
  MaterialRequestStatus.pending: 'PENDING',
  MaterialRequestStatus.approved: 'APPROVED',
  MaterialRequestStatus.rejected: 'REJECTED',
  MaterialRequestStatus.cancelled: 'CANCELLED',
  MaterialRequestStatus.closed: 'CLOSED',
};

const _$MaterialRequestOutcomeEnumMap = {
  MaterialRequestOutcome.allUsed: 'ALL_USED',
  MaterialRequestOutcome.leftoverReturned: 'LEFTOVER_RETURNED',
};
