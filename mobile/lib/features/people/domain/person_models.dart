import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/enums.dart';
import '../../../core/models/refs.dart';
import '../../auth/domain/auth_models.dart';
import '../../auth/domain/user_role.dart';

part 'person_models.freezed.dart';
part 'person_models.g.dart';

/// An engineer or staff member as listed by the API.
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
  }) = _PersonDetail;

  factory PersonDetail.fromJson(Map<String, dynamic> json) => _$PersonDetailFromJson(json);
}

/// Response of creating an engineer or staff member.
@freezed
abstract class CreatedPerson with _$CreatedPerson {
  const factory CreatedPerson({required PersonDetail person, required String temporaryPassword}) = _CreatedPerson;

  factory CreatedPerson.fromJson(Map<String, dynamic> json) => _$CreatedPersonFromJson(json);
}
