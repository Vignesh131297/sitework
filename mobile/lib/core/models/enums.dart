import 'package:json_annotation/json_annotation.dart';

// API enums. JSON values match the server's (Prisma) enum values exactly.

@JsonEnum(valueField: 'apiValue')
enum SiteStatus {
  notStarted('NOT_STARTED'),
  inProgress('IN_PROGRESS'),
  onHold('ON_HOLD'),
  completed('COMPLETED');

  const SiteStatus(this.apiValue);
  final String apiValue;
}

@JsonEnum(valueField: 'apiValue')
enum Designation {
  mason('MASON'),
  helper('HELPER'),
  electrician('ELECTRICIAN'),
  carpenter('CARPENTER'),
  plumber('PLUMBER'),
  supervisor('SUPERVISOR'),
  painter('PAINTER'),
  generalWorker('GENERAL_WORKER');

  const Designation(this.apiValue);
  final String apiValue;
}

@JsonEnum(valueField: 'apiValue')
enum TimeSlot {
  morning('MORNING'),
  afternoon('AFTERNOON'),
  evening('EVENING');

  const TimeSlot(this.apiValue);
  final String apiValue;
}

@JsonEnum(valueField: 'apiValue')
enum SlotState {
  upcoming('UPCOMING'),
  pending('PENDING'),
  submitted('SUBMITTED'),
  missing('MISSING'),
  notExpected('NOT_EXPECTED');

  const SlotState(this.apiValue);
  final String apiValue;
}

@JsonEnum(valueField: 'apiValue')
enum AttendanceStatus {
  present('PRESENT'),
  late('LATE'),
  halfDay('HALF_DAY'),
  absent('ABSENT');

  const AttendanceStatus(this.apiValue);
  final String apiValue;
}

@JsonEnum(valueField: 'apiValue')
enum LocationFlag {
  ok('OK'),
  permissionDenied('PERMISSION_DENIED'),
  unavailable('UNAVAILABLE'),
  mocked('MOCKED'),
  outsideSite('OUTSIDE_SITE');

  const LocationFlag(this.apiValue);
  final String apiValue;
}

@JsonEnum(valueField: 'apiValue')
enum ImageStatus {
  available('AVAILABLE'),
  readyForDeletion('READY_FOR_DELETION'),
  deleted('DELETED');

  const ImageStatus(this.apiValue);
  final String apiValue;
}

@JsonEnum(valueField: 'apiValue')
enum PhotoSource {
  camera('CAMERA'),
  gallery('GALLERY');

  const PhotoSource(this.apiValue);
  final String apiValue;
}

@JsonEnum(valueField: 'apiValue')
enum EngineerUpdateType {
  progress('PROGRESS'),
  completedWork('COMPLETED_WORK'),
  materialsRequired('MATERIALS_REQUIRED'),
  safetyConcern('SAFETY_CONCERN'),
  clientRequirement('CLIENT_REQUIREMENT'),
  remark('REMARK'),
  dailyReport('DAILY_REPORT');

  const EngineerUpdateType(this.apiValue);
  final String apiValue;
}

@JsonEnum(valueField: 'apiValue')
enum Priority {
  low('LOW'),
  medium('MEDIUM'),
  high('HIGH'),
  critical('CRITICAL');

  const Priority(this.apiValue);
  final String apiValue;
}

@JsonEnum(valueField: 'apiValue')
enum IssueStatus {
  open('OPEN'),
  inProgress('IN_PROGRESS'),
  resolved('RESOLVED');

  const IssueStatus(this.apiValue);
  final String apiValue;
}

@JsonEnum(valueField: 'apiValue')
enum NotificationType {
  staffUpdate('STAFF_UPDATE'),
  engineerUpdate('ENGINEER_UPDATE'),
  missingUpdate('MISSING_UPDATE'),
  payment('PAYMENT'),
  issue('ISSUE'),
  attendance('ATTENDANCE'),
  system('SYSTEM'),
  stock('STOCK');

  const NotificationType(this.apiValue);
  final String apiValue;
}

@JsonEnum(valueField: 'apiValue')
enum ReferenceType {
  staffUpdate('STAFF_UPDATE'),
  missedUpdate('MISSED_UPDATE'),
  engineerUpdate('ENGINEER_UPDATE'),
  issue('ISSUE'),
  site('SITE'),
  paymentMilestone('PAYMENT_MILESTONE'),
  payment('PAYMENT'),
  attendance('ATTENDANCE'),
  stockEntry('STOCK_ENTRY'),
  materialRequest('MATERIAL_REQUEST');

  const ReferenceType(this.apiValue);
  final String apiValue;
}

@JsonEnum(valueField: 'apiValue')
enum PaymentMethod {
  cash('CASH'),
  upi('UPI'),
  bankTransfer('BANK_TRANSFER'),
  cheque('CHEQUE'),
  other('OTHER');

  const PaymentMethod(this.apiValue);
  final String apiValue;
}

@JsonEnum(valueField: 'apiValue')
enum MilestoneStatus {
  paid('PAID'),
  partiallyPaid('PARTIALLY_PAID'),
  pending('PENDING'),
  overdue('OVERDUE');

  const MilestoneStatus(this.apiValue);
  final String apiValue;
}

@JsonEnum(valueField: 'apiValue')
enum ImageDeleteReason {
  allViewed('ALL_VIEWED'),
  expired('EXPIRED');

  const ImageDeleteReason(this.apiValue);
  final String apiValue;
}

/// Where stock is, comes from or goes. Only godowns and sites hold stock.
@JsonEnum(valueField: 'apiValue')
enum StockPlace {
  supplier('SUPPLIER'),
  godown('GODOWN'),
  site('SITE'),
  used('USED'),
  waste('WASTE'),
  adjustment('ADJUSTMENT');

  const StockPlace(this.apiValue);
  final String apiValue;
}

@JsonEnum(valueField: 'apiValue')
enum StockMovementStatus {
  inTransit('IN_TRANSIT'),
  done('DONE'),
  voided('VOIDED');

  const StockMovementStatus(this.apiValue);
  final String apiValue;
}

/// What a stock movement is, as the server names it.
@JsonEnum(valueField: 'apiValue')
enum StockKind {
  purchase('PURCHASE'),
  transfer('TRANSFER'),
  usage('USAGE'),
  writeOff('WRITE_OFF'),
  adjustment('ADJUSTMENT');

  const StockKind(this.apiValue);
  final String apiValue;
}

/// Where a material request is: waiting for an admin, approved (being sent
/// and used), turned down, withdrawn, or closed by the site.
@JsonEnum(valueField: 'apiValue')
enum MaterialRequestStatus {
  pending('PENDING'),
  approved('APPROVED'),
  rejected('REJECTED'),
  cancelled('CANCELLED'),
  closed('CLOSED');

  const MaterialRequestStatus(this.apiValue);
  final String apiValue;
}

/// How the site closed a request.
@JsonEnum(valueField: 'apiValue')
enum MaterialRequestOutcome {
  allUsed('ALL_USED'),
  leftoverReturned('LEFTOVER_RETURNED');

  const MaterialRequestOutcome(this.apiValue);
  final String apiValue;
}

/// Who took a stock photo: the sender (DC, bill) or the receiver.
@JsonEnum(valueField: 'apiValue')
enum StockPhotoStage {
  sent('SENT'),
  received('RECEIVED');

  const StockPhotoStage(this.apiValue);
  final String apiValue;
}
