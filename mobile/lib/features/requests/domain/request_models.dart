import '../../../core/models/enums.dart';
import '../../../core/models/refs.dart';
import '../../auth/domain/user_role.dart';

// Leave, and staff members' money and food requests, as the API returns them.
// Plain classes: the screens only read them.

T _enum<T extends Enum>(List<T> values, Object? json, String Function(T value) apiValue) =>
    values.firstWhere((value) => apiValue(value) == json, orElse: () => throw FormatException('Unknown value: $json'));

IdName? _idNameOrNull(Object? json) => json == null ? null : IdName.fromJson(json as Map<String, dynamic>);

DateTime? _dateTimeOrNull(Object? json) => json == null ? null : DateTime.parse(json as String);

/// Someone who asked for leave: a staff member or an engineer.
class LeaveRequester {
  const LeaveRequester({required this.id, required this.name, required this.role, required this.employeeCode});

  factory LeaveRequester.fromJson(Map<String, dynamic> json) => LeaveRequester(
    id: json['id'] as String,
    name: json['name'] as String,
    role: _enum(UserRole.values, json['role'], (r) => r.apiValue),
    employeeCode: json['employeeCode'] as String,
  );

  final String id;
  final String name;
  final UserRole role;
  final String employeeCode;
}

class LeaveRequest {
  const LeaveRequest({
    required this.id,
    required this.code,
    required this.user,
    required this.site,
    required this.type,
    required this.fromDate,
    required this.toDate,
    required this.days,
    required this.reason,
    required this.status,
    required this.reviewedBy,
    required this.reviewedAt,
    required this.reviewNote,
    required this.createdAt,
    required this.canApprove,
    required this.canCancel,
  });

  factory LeaveRequest.fromJson(Map<String, dynamic> json) => LeaveRequest(
    id: json['id'] as String,
    code: json['code'] as String,
    user: LeaveRequester.fromJson(json['user'] as Map<String, dynamic>),
    site: _idNameOrNull(json['site']),
    type: _enum(LeaveType.values, json['type'], (t) => t.apiValue),
    fromDate: json['fromDate'] as String,
    toDate: json['toDate'] as String,
    days: json['days'] as int,
    reason: json['reason'] as String,
    status: _enum(ApprovalStatus.values, json['status'], (s) => s.apiValue),
    reviewedBy: _idNameOrNull(json['reviewedBy']),
    reviewedAt: _dateTimeOrNull(json['reviewedAt']),
    reviewNote: json['reviewNote'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    canApprove: json['canApprove'] as bool,
    canCancel: json['canCancel'] as bool,
  );

  final String id;

  /// "LV-0007"
  final String code;
  final LeaveRequester user;

  /// Staff: their site when they asked. Engineers: null.
  final IdName? site;
  final LeaveType type;

  /// ISO dates ("2026-10-05"), both included.
  final String fromDate;
  final String toDate;
  final int days;
  final String reason;
  final ApprovalStatus status;
  final IdName? reviewedBy;
  final DateTime? reviewedAt;
  final String? reviewNote;
  final DateTime createdAt;
  final bool canApprove;
  final bool canCancel;
}

/// Money (an advance) or a meal asked for by a staff member.
class StaffRequest {
  const StaffRequest({
    required this.id,
    required this.code,
    required this.kind,
    required this.staff,
    required this.site,
    required this.amount,
    required this.forDate,
    required this.meal,
    required this.note,
    required this.status,
    required this.reviewedBy,
    required this.reviewedAt,
    required this.reviewNote,
    required this.createdAt,
    required this.canApprove,
    required this.canCancel,
  });

  factory StaffRequest.fromJson(Map<String, dynamic> json) => StaffRequest(
    id: json['id'] as String,
    code: json['code'] as String,
    kind: _enum(StaffRequestKind.values, json['kind'], (k) => k.apiValue),
    staff: IdName.fromJson(json['staff'] as Map<String, dynamic>),
    site: IdName.fromJson(json['site'] as Map<String, dynamic>),
    amount: json['amount'] as String?,
    forDate: json['forDate'] as String?,
    meal: json['meal'] == null ? null : _enum(Meal.values, json['meal'], (m) => m.apiValue),
    note: json['note'] as String?,
    status: _enum(ApprovalStatus.values, json['status'], (s) => s.apiValue),
    reviewedBy: _idNameOrNull(json['reviewedBy']),
    reviewedAt: _dateTimeOrNull(json['reviewedAt']),
    reviewNote: json['reviewNote'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    canApprove: json['canApprove'] as bool,
    canCancel: json['canCancel'] as bool,
  );

  final String id;

  /// "RQ-0012"
  final String code;
  final StaffRequestKind kind;
  final IdName staff;
  final IdName site;

  /// Money: rupees as a decimal string ("1500.00").
  final String? amount;

  /// Food: the ISO day and the meal.
  final String? forDate;
  final Meal? meal;
  final String? note;
  final ApprovalStatus status;
  final IdName? reviewedBy;
  final DateTime? reviewedAt;
  final String? reviewNote;
  final DateTime createdAt;
  final bool canApprove;
  final bool canCancel;
}
