import '../../../core/models/enums.dart';
import '../../../core/models/refs.dart';
import '../../auth/domain/user_role.dart';

// Company vehicles, who holds them, and money asked for their repair, as the
// API returns them. Plain classes: the screens only read them.

T _enum<T extends Enum>(List<T> values, Object? json, String Function(T value) apiValue) =>
    values.firstWhere((value) => apiValue(value) == json, orElse: () => throw FormatException('Unknown value: $json'));

IdName? _idNameOrNull(Object? json) => json == null ? null : IdName.fromJson(json as Map<String, dynamic>);

/// A staff member or an engineer who holds a vehicle or asked for repair money.
class VehiclePerson {
  const VehiclePerson({required this.id, required this.name, required this.role, required this.employeeCode});

  factory VehiclePerson.fromJson(Map<String, dynamic> json) => VehiclePerson(
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

/// Who has the vehicle now.
class VehicleHolder {
  const VehicleHolder({required this.user, required this.givenOn, required this.note});

  factory VehicleHolder.fromJson(Map<String, dynamic> json) => VehicleHolder(
    user: VehiclePerson.fromJson(json['user'] as Map<String, dynamic>),
    givenOn: json['givenOn'] as String,
    note: json['note'] as String?,
  );

  final VehiclePerson user;

  /// ISO date ("2026-10-05").
  final String givenOn;
  final String? note;
}

class Vehicle {
  const Vehicle({
    required this.id,
    required this.code,
    required this.type,
    required this.registrationNo,
    required this.makeModel,
    required this.note,
    required this.isActive,
    required this.holder,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
    id: json['id'] as String,
    code: json['code'] as String,
    type: _enum(VehicleType.values, json['type'], (t) => t.apiValue),
    registrationNo: json['registrationNo'] as String,
    makeModel: json['makeModel'] as String,
    note: json['note'] as String?,
    isActive: json['isActive'] as bool,
    holder: json['holder'] == null ? null : VehicleHolder.fromJson(json['holder'] as Map<String, dynamic>),
  );

  final String id;

  /// "VH-0003"
  final String code;
  final VehicleType type;

  /// "TN09BK4821"
  final String registrationNo;

  /// "Hero Splendor Plus"
  final String makeModel;
  final String? note;

  /// False once it is out of use (sold, scrapped).
  final bool isActive;
  final VehicleHolder? holder;
}

/// One time the vehicle was with someone. The open one has no [returnedOn].
class VehicleHandover {
  const VehicleHandover({
    required this.id,
    required this.user,
    required this.givenOn,
    required this.returnedOn,
    required this.note,
    required this.returnNote,
    required this.givenBy,
    required this.returnedBy,
  });

  factory VehicleHandover.fromJson(Map<String, dynamic> json) => VehicleHandover(
    id: json['id'] as String,
    user: VehiclePerson.fromJson(json['user'] as Map<String, dynamic>),
    givenOn: json['givenOn'] as String,
    returnedOn: json['returnedOn'] as String?,
    note: json['note'] as String?,
    returnNote: json['returnNote'] as String?,
    givenBy: IdName.fromJson(json['givenBy'] as Map<String, dynamic>),
    returnedBy: _idNameOrNull(json['returnedBy']),
  );

  final String id;
  final VehiclePerson user;
  final String givenOn;
  final String? returnedOn;
  final String? note;
  final String? returnNote;
  final IdName givenBy;
  final IdName? returnedBy;
}

/// A vehicle with every hand-over, newest first.
class VehicleDetail {
  const VehicleDetail({required this.vehicle, required this.history});

  factory VehicleDetail.fromJson(Map<String, dynamic> json) => VehicleDetail(
    vehicle: Vehicle.fromJson(json),
    history: [
      for (final row in json['history'] as List<dynamic>) VehicleHandover.fromJson(row as Map<String, dynamic>),
    ],
  );

  final Vehicle vehicle;
  final List<VehicleHandover> history;
}

/// The vehicle a repair request is for.
class VehicleRef {
  const VehicleRef({
    required this.id,
    required this.code,
    required this.type,
    required this.registrationNo,
    required this.makeModel,
  });

  factory VehicleRef.fromJson(Map<String, dynamic> json) => VehicleRef(
    id: json['id'] as String,
    code: json['code'] as String,
    type: _enum(VehicleType.values, json['type'], (t) => t.apiValue),
    registrationNo: json['registrationNo'] as String,
    makeModel: json['makeModel'] as String,
  );

  final String id;
  final String code;
  final VehicleType type;
  final String registrationNo;
  final String makeModel;
}

/// Money for a repair, asked for by whoever holds the vehicle. An admin decides.
class RepairRequest {
  const RepairRequest({
    required this.id,
    required this.code,
    required this.vehicle,
    required this.user,
    required this.amount,
    required this.note,
    required this.status,
    required this.reviewedBy,
    required this.reviewNote,
    required this.createdAt,
    required this.canApprove,
    required this.canCancel,
  });

  factory RepairRequest.fromJson(Map<String, dynamic> json) => RepairRequest(
    id: json['id'] as String,
    code: json['code'] as String,
    vehicle: VehicleRef.fromJson(json['vehicle'] as Map<String, dynamic>),
    user: VehiclePerson.fromJson(json['user'] as Map<String, dynamic>),
    amount: json['amount'] as String,
    note: json['note'] as String,
    status: _enum(ApprovalStatus.values, json['status'], (s) => s.apiValue),
    reviewedBy: _idNameOrNull(json['reviewedBy']),
    reviewNote: json['reviewNote'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    canApprove: json['canApprove'] as bool,
    canCancel: json['canCancel'] as bool,
  );

  final String id;

  /// "VR-0012"
  final String code;
  final VehicleRef vehicle;
  final VehiclePerson user;

  /// Rupees as a decimal string ("850.00").
  final String amount;

  /// What needs repair.
  final String note;
  final ApprovalStatus status;
  final IdName? reviewedBy;
  final String? reviewNote;
  final DateTime createdAt;
  final bool canApprove;
  final bool canCancel;
}
