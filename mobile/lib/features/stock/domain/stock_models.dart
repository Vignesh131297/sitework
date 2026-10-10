import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/enums.dart';
import '../../../core/models/refs.dart';

part 'stock_models.freezed.dart';
part 'stock_models.g.dart';

// Quantities travel as decimal strings ("60", "12.5") and money as rupee
// strings ("380.00"); every balance and value is the server's. Prices and
// values are null for everyone but admins.

/// Something kept in stock: cement, steel, sand…
@freezed
abstract class StockMaterial with _$StockMaterial {
  const factory StockMaterial({
    required String id,
    required String name,
    required String unit,
    String? category,

    /// Admins are alerted when all godowns together drop below this.
    String? minStock,
    required bool isActive,
  }) = _StockMaterial;

  factory StockMaterial.fromJson(Map<String, dynamic> json) => _$StockMaterialFromJson(json);
}

@freezed
abstract class MaterialRef with _$MaterialRef {
  const factory MaterialRef({required String id, required String name, required String unit}) = _MaterialRef;

  factory MaterialRef.fromJson(Map<String, dynamic> json) => _$MaterialRefFromJson(json);
}

/// Where the company keeps stock.
@freezed
abstract class Godown with _$Godown {
  const factory Godown({required String id, required String name, String? address, required bool isActive}) = _Godown;

  factory Godown.fromJson(Map<String, dynamic> json) => _$GodownFromJson(json);
}

/// A godown, a site, or the world outside (supplier, used, waste, count).
@freezed
abstract class StockPlaceRef with _$StockPlaceRef {
  const factory StockPlaceRef({required StockPlace place, SiteRef? site, IdName? godown}) = _StockPlaceRef;

  factory StockPlaceRef.fromJson(Map<String, dynamic> json) => _$StockPlaceRefFromJson(json);
}

/// One material on an entry.
@freezed
abstract class StockLine with _$StockLine {
  const factory StockLine({
    required String id,
    required MaterialRef material,
    required String quantity,
    String? receivedQuantity,

    /// Sent but never arrived, on a delivery that came up short.
    String? shortQuantity,

    /// Purchases, admins only.
    String? rate,
    String? amount,
  }) = _StockLine;

  factory StockLine.fromJson(Map<String, dynamic> json) => _$StockLineFromJson(json);
}

@freezed
abstract class StockPhoto with _$StockPhoto {
  const factory StockPhoto({
    required String id,
    required String mime,
    required String url,
    required DateTime expiresAt,
    required StockPhotoStage stage,
  }) = _StockPhoto;

  factory StockPhoto.fromJson(Map<String, dynamic> json) => _$StockPhotoFromJson(json);
}

/// A material request as other records refer to it: "MR-0012".
@freezed
abstract class RequestRef with _$RequestRef {
  const factory RequestRef({required String id, required String code}) = _RequestRef;

  factory RequestRef.fromJson(Map<String, dynamic> json) => _$RequestRefFromJson(json);
}

/// One stock form: a purchase, a delivery, a day's usage, a write-off or a count.
@freezed
abstract class StockEntry with _$StockEntry {
  const factory StockEntry({
    required String id,
    required String requestId,
    required StockKind kind,
    required StockPlaceRef from,
    required StockPlaceRef to,
    required StockMovementStatus status,
    required String movedOn,
    String? dcNumber,
    String? supplier,
    String? billNo,
    String? note,
    required List<StockLine> lines,

    /// Purchases, admins only.
    String? totalAmount,
    String? receivedOn,
    DateTime? receivedAt,
    IdName? receivedBy,
    String? receiveNote,
    required IdName createdBy,
    required DateTime createdAt,
    DateTime? voidedAt,
    IdName? voidedBy,
    String? voidReason,
    @Default(0) int photoCount,

    /// The material request it was sent against (or returned on).
    RequestRef? request,

    /// Detail responses only.
    @Default(<StockPhoto>[]) List<StockPhoto> photos,

    /// What the signed-in user may do with it now (the server decides).
    @Default(false) bool canReceive,
    @Default(false) bool canVoid,
  }) = _StockEntry;

  const StockEntry._();

  factory StockEntry.fromJson(Map<String, dynamic> json) => _$StockEntryFromJson(json);

  bool get isOnTheWay => status == StockMovementStatus.inTransit;
  bool get isVoided => status == StockMovementStatus.voided;
  bool get isShort => lines.any((line) => line.shortQuantity != null);
}

/// One material at a godown or site. Values are admins' only.
@freezed
abstract class HolderStockRow with _$HolderStockRow {
  const factory HolderStockRow({
    required StockMaterial material,
    required String onHand,
    required String received,
    required String used,
    required String sentOut,
    required String wasted,
    required String adjusted,
    String? usedValue,
    String? onHandValue,
  }) = _HolderStockRow;

  const HolderStockRow._();

  factory HolderStockRow.fromJson(Map<String, dynamic> json) => _$HolderStockRowFromJson(json);

  bool get hasStock => num.parse(onHand) > 0;
}

@freezed
abstract class StockSite with _$StockSite {
  const factory StockSite({
    required String id,
    required String code,
    required String name,
    required SiteStatus status,
  }) = _StockSite;

  factory StockSite.fromJson(Map<String, dynamic> json) => _$StockSiteFromJson(json);
}

@freezed
abstract class StockValue with _$StockValue {
  const factory StockValue({String? used, required String onHand}) = _StockValue;

  factory StockValue.fromJson(Map<String, dynamic> json) => _$StockValueFromJson(json);
}

/// Response of `GET /sites/:id/stock`.
@freezed
abstract class SiteStock with _$SiteStock {
  const factory SiteStock({
    required StockSite site,

    /// Every material the site has held, those on hand first.
    required List<HolderStockRow> items,

    /// Deliveries on the way, waiting for the site to confirm.
    required List<StockEntry> arriving,

    /// Sent from the site, not yet confirmed by the receiver.
    required List<StockEntry> leaving,
    @Default(false) bool usedToday,

    /// Admins only.
    StockValue? value,
  }) = _SiteStock;

  factory SiteStock.fromJson(Map<String, dynamic> json) => _$SiteStockFromJson(json);
}

/// Response of `GET /stock/godowns/:id`.
@freezed
abstract class GodownStock with _$GodownStock {
  const factory GodownStock({
    required Godown godown,
    required List<HolderStockRow> items,
    required List<StockEntry> arriving,
    required List<StockEntry> leaving,

    /// Admins only.
    StockValue? value,

    /// Who runs it: they send its stock and confirm what arrives.
    @Default(<PersonRef>[]) List<PersonRef> managers,
  }) = _GodownStock;

  factory GodownStock.fromJson(Map<String, dynamic> json) => _$GodownStockFromJson(json);
}

@freezed
abstract class GodownSummary with _$GodownSummary {
  const factory GodownSummary({required Godown godown, required int arriving}) = _GodownSummary;

  factory GodownSummary.fromJson(Map<String, dynamic> json) => _$GodownSummaryFromJson(json);
}

@freezed
abstract class MaterialTotals with _$MaterialTotals {
  const factory MaterialTotals({
    required StockMaterial material,
    required String inGodowns,
    required String onSites,

    /// All godowns together are below the material's minimum.
    required bool low,
  }) = _MaterialTotals;

  factory MaterialTotals.fromJson(Map<String, dynamic> json) => _$MaterialTotalsFromJson(json);
}

/// Response of `GET /stock/overview`.
@freezed
abstract class StockOverview with _$StockOverview {
  const factory StockOverview({
    required List<GodownSummary> godowns,
    required List<MaterialTotals> materials,

    /// Entries on the way that the user can confirm.
    required int toReceive,

    /// Sites the user can request material for (not completed): all of them
    /// for admins, their own for engineers.
    @Default(<SiteRef>[]) List<SiteRef> sites,
  }) = _StockOverview;

  factory StockOverview.fromJson(Map<String, dynamic> json) => _$StockOverviewFromJson(json);
}

@freezed
abstract class GodownHolding with _$GodownHolding {
  const factory GodownHolding({required IdName godown, required String onHand}) = _GodownHolding;

  factory GodownHolding.fromJson(Map<String, dynamic> json) => _$GodownHoldingFromJson(json);
}

@freezed
abstract class SiteHolding with _$SiteHolding {
  const factory SiteHolding({required StockSite site, required String onHand}) = _SiteHolding;

  factory SiteHolding.fromJson(Map<String, dynamic> json) => _$SiteHoldingFromJson(json);
}

/// Response of `GET /materials/:id`.
@freezed
abstract class MaterialDetail with _$MaterialDetail {
  const factory MaterialDetail({
    required StockMaterial material,

    /// Weighted average purchase price.
    String? averageRate,
    required List<GodownHolding> godowns,
    required List<SiteHolding> sites,
    required String inGodowns,
    required String onSites,
    required String inTransit,
  }) = _MaterialDetail;

  factory MaterialDetail.fromJson(Map<String, dynamic> json) => _$MaterialDetailFromJson(json);
}

/// One material at one place over a report's dates.
@freezed
abstract class StockReportRow with _$StockReportRow {
  const factory StockReportRow({
    required StockPlace place,
    SiteRef? site,
    IdName? godown,
    required MaterialRef material,
    required String opening,
    required String received,
    required String used,
    required String sentOut,
    required String wasted,

    /// Stock-count corrections; negative when the count came up short.
    required String adjusted,
    required String closing,

    /// Admins only: what was used, at the average purchase price.
    String? usedValue,
  }) = _StockReportRow;

  factory StockReportRow.fromJson(Map<String, dynamic> json) => _$StockReportRowFromJson(json);
}

/// One material on a request: asked for, approved, and how far it has got.
@freezed
abstract class MaterialRequestLine with _$MaterialRequestLine {
  const factory MaterialRequestLine({
    required MaterialRef material,
    required String quantity,

    /// Set once approved; "0" when it won't be supplied.
    String? approvedQuantity,
    required String sent,
    required String received,
    required String onTheWay,
    String? leftToSend,
  }) = _MaterialRequestLine;

  const MaterialRequestLine._();

  factory MaterialRequestLine.fromJson(Map<String, dynamic> json) => _$MaterialRequestLineFromJson(json);

  bool get hasLeftToSend => leftToSend != null && num.parse(leftToSend!) > 0;
}

/// A site's request for material: an engineer asks, an admin approves it from
/// a godown (or rejects it), the godown's manager sends it, and the site
/// closes it when done, returning any leftover.
@freezed
abstract class MaterialRequest with _$MaterialRequest {
  const factory MaterialRequest({
    required String id,

    /// "MR-0012"
    required String code,
    required SiteRef site,
    required IdName requestedBy,
    required MaterialRequestStatus status,
    String? neededBy,
    String? note,
    required DateTime createdAt,
    IdName? godown,
    IdName? reviewedBy,
    DateTime? reviewedAt,
    String? reviewNote,
    MaterialRequestOutcome? outcome,
    IdName? closedBy,
    DateTime? closedAt,
    String? closeNote,
    required List<MaterialRequestLine> lines,
    @Default(false) bool sentInFull,

    /// Detail responses only: deliveries and returns made against it.
    @Default(<StockEntry>[]) List<StockEntry> entries,

    /// What the signed-in user may do with it now (the server decides).
    @Default(false) bool canApprove,
    @Default(false) bool canCancel,
    @Default(false) bool canSend,
    @Default(false) bool canClose,
  }) = _MaterialRequest;

  const MaterialRequest._();

  factory MaterialRequest.fromJson(Map<String, dynamic> json) => _$MaterialRequestFromJson(json);

  bool get isOpen => status == MaterialRequestStatus.pending || status == MaterialRequestStatus.approved;

  /// A delivery is on its way to the site.
  bool get anythingOnTheWay => lines.any((line) => num.parse(line.onTheWay) > 0);
}

/// A godown or site, as a stock form's source or destination.
typedef StockHolder = ({StockPlace place, String id, String name});

/// One line of a stock form; [rate] for purchases only.
typedef StockFormLine = ({String materialId, String quantity, String? rate});

/// The stock forms, by the endpoint each one posts to.
enum StockFormKind {
  purchase('/stock/purchases'),
  transfer('/stock/transfers'),
  usage('/stock/usage'),
  writeOff('/stock/write-offs'),
  count('/stock/counts');

  const StockFormKind(this.path);
  final String path;

  /// Sent as a multipart form, with photos.
  bool get withPhotos => this == purchase || this == transfer;
}

/// A filled-in stock form. [requestId] is made once per form, so sending it
/// again after a dropped connection never records it twice.
class StockForm {
  const StockForm({
    required this.kind,
    required this.requestId,
    required this.movedOn,
    required this.lines,
    this.from,
    this.to,
    this.dcNumber,
    this.supplier,
    this.billNo,
    this.note,
    this.photoPaths = const [],
    this.materialRequestId,
  });

  final StockFormKind kind;
  final String requestId;
  final String movedOn;
  final List<StockFormLine> lines;

  /// Transfers: where it leaves; usage, write-offs and counts: where it is.
  final StockHolder? from;

  /// Transfers: where it goes. Purchases: the godown it is bought into.
  final StockHolder? to;
  final String? dcNumber;
  final String? supplier;
  final String? billNo;
  final String? note;
  final List<String> photoPaths;

  /// Transfers to a site: the approved request it is sent against.
  final String? materialRequestId;

  /// The request's fields, with `lines` as a list (JSON) — the repository
  /// turns it into a JSON string for multipart forms.
  Map<String, Object?> toJson() {
    String? id(StockHolder? holder, StockPlace place) => holder?.place == place ? holder!.id : null;
    return {
      'requestId': requestId,
      'movedOn': movedOn,
      'lines': [
        for (final line in lines)
          switch (kind) {
            StockFormKind.count => {'materialId': line.materialId, 'countedQuantity': line.quantity},
            StockFormKind.purchase => {'materialId': line.materialId, 'quantity': line.quantity, 'rate': line.rate},
            _ => {'materialId': line.materialId, 'quantity': line.quantity},
          },
      ],
      ...switch (kind) {
        StockFormKind.purchase => {'godownId': to?.id},
        StockFormKind.transfer => {
          'fromGodownId': ?id(from, StockPlace.godown),
          'fromSiteId': ?id(from, StockPlace.site),
          'toGodownId': ?id(to, StockPlace.godown),
          'toSiteId': ?id(to, StockPlace.site),
          'materialRequestId': ?materialRequestId,
        },
        _ => {'godownId': ?id(from, StockPlace.godown), 'siteId': ?id(from, StockPlace.site)},
      },
      'dcNumber': ?dcNumber,
      'supplier': ?supplier,
      'billNo': ?billNo,
      'note': ?note,
    };
  }
}
