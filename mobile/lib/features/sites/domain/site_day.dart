import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/enums.dart';
import '../../../core/models/refs.dart';
import '../../staff_updates/domain/staff_update_models.dart';

part 'site_day.freezed.dart';
part 'site_day.g.dart';

@freezed
abstract class BoardStaff with _$BoardStaff {
  const factory BoardStaff({
    required String id,
    required String name,
    required String phone,
    Designation? designation,
  }) = _BoardStaff;

  factory BoardStaff.fromJson(Map<String, dynamic> json) => _$BoardStaffFromJson(json);
}

@freezed
abstract class BoardAttendance with _$BoardAttendance {
  const factory BoardAttendance({required AttendanceStatus status, DateTime? checkInAt, DateTime? checkOutAt}) =
      _BoardAttendance;

  factory BoardAttendance.fromJson(Map<String, dynamic> json) => _$BoardAttendanceFromJson(json);
}

/// One staff member's day on a site: attendance and the three slots.
@freezed
abstract class StaffDay with _$StaffDay {
  const factory StaffDay({
    required BoardStaff staff,
    required IdName site,
    required IdName engineer,
    BoardAttendance? attendance,

    /// The late threshold has passed without a check-in.
    required bool notCheckedIn,
    required List<DaySlot> slots,
  }) = _StaffDay;

  factory StaffDay.fromJson(Map<String, dynamic> json) => _$StaffDayFromJson(json);
}

/// Response of `GET /sites/:id/day`: the site's staff board for a date.
@freezed
abstract class SiteDay with _$SiteDay {
  const factory SiteDay({
    required String date,
    required bool isWorkingDay,
    String? holiday,
    required List<StaffDay> staff,
  }) = _SiteDay;

  factory SiteDay.fromJson(Map<String, dynamic> json) => _$SiteDayFromJson(json);
}
