import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/enums.dart';
import '../../../core/models/refs.dart';
import '../../auth/domain/auth_models.dart';
import '../../auth/domain/user_role.dart';

part 'person_models.freezed.dart';
part 'person_models.g.dart';

/// A person as listed by the API: an engineer, staff member, godown manager or admin.
@freezed
abstract class PersonSummary with _$PersonSummary {
  const factory PersonSummary({
    required String id,
    required UserRole role,
    required String name,
    required String phone,
    String? email,
    required String employeeCode,
    Designation? designation,
    String? joiningDate,
    required bool isActive,
    DateTime? lastLoginAt,
    @Default(<SiteRef>[]) List<SiteRef> sites,
    @Default(0) int staffCount,
    StaffAssignmentInfo? assignment,

    /// Godown managers: the godowns they run.
    @Default(<IdName>[]) List<IdName> godowns,
  }) = _PersonSummary;

  factory PersonSummary.fromJson(Map<String, dynamic> json) => _$PersonSummaryFromJson(json);
}

@freezed
abstract class SupervisedStaff with _$SupervisedStaff {
  const factory SupervisedStaff({
    required String id,
    required String name,
    Designation? designation,
    required IdName site,
  }) = _SupervisedStaff;

  factory SupervisedStaff.fromJson(Map<String, dynamic> json) => _$SupervisedStaffFromJson(json);
}

/// The company vehicle a staff member or an engineer holds.
@freezed
abstract class PersonVehicle with _$PersonVehicle {
  const factory PersonVehicle({
    required String id,
    required String code,
    required VehicleType type,
    required String registrationNo,
    required String makeModel,
    required String givenOn,
  }) = _PersonVehicle;

  factory PersonVehicle.fromJson(Map<String, dynamic> json) => _$PersonVehicleFromJson(json);
}

@freezed
abstract class PersonDetail with _$PersonDetail {
  const factory PersonDetail({
    required String id,
    required UserRole role,
    required String name,
    required String phone,
    String? email,
    required String employeeCode,
    Designation? designation,
    String? joiningDate,
    required bool isActive,
    DateTime? lastLoginAt,
    @Default(<SiteRef>[]) List<SiteRef> sites,
    @Default(0) int staffCount,
    StaffAssignmentInfo? assignment,
    required bool mustChangePassword,
    @Default(<SupervisedStaff>[]) List<SupervisedStaff> supervisedStaff,

    /// Staff and engineers: the company vehicle they hold now.
    PersonVehicle? vehicle,

    /// Godown managers: the godowns they run.
    @Default(<IdName>[]) List<IdName> godowns,
  }) = _PersonDetail;

  factory PersonDetail.fromJson(Map<String, dynamic> json) => _$PersonDetailFromJson(json);
}

/// Response of creating a person.
@freezed
abstract class CreatedPerson with _$CreatedPerson {
  const factory CreatedPerson({required PersonDetail person, required String temporaryPassword}) = _CreatedPerson;

  factory CreatedPerson.fromJson(Map<String, dynamic> json) => _$CreatedPersonFromJson(json);
}
