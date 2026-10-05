import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/enums.dart';
import '../../../core/models/refs.dart';
import '../../attendance/domain/attendance_models.dart';

part 'staff_update_models.freezed.dart';
part 'staff_update_models.g.dart';

@freezed
abstract class UpdateStaff with _$UpdateStaff {
  const factory UpdateStaff({required String id, required String name, Designation? designation}) = _UpdateStaff;

  factory UpdateStaff.fromJson(Map<String, dynamic> json) => _$UpdateStaffFromJson(json);
}

@freezed
abstract class UpdateLocation with _$UpdateLocation {
  const factory UpdateLocation({required LocationFlag flag, int? distanceFromSiteM}) = _UpdateLocation;

  factory UpdateLocation.fromJson(Map<String, dynamic> json) => _$UpdateLocationFromJson(json);
}

/// Where the photo is in its life: kept until reviewed (or it expires), then deleted.
@freezed
abstract class UpdateImage with _$UpdateImage {
  const factory UpdateImage({
    required ImageStatus status,
    required DateTime expiresAt,
    DateTime? deletedAt,
    ImageDeleteReason? deleteReason,
  }) = _UpdateImage;

  factory UpdateImage.fromJson(Map<String, dynamic> json) => _$UpdateImageFromJson(json);
}

/// A staff member's photo update for one slot.
@freezed
abstract class StaffUpdate with _$StaffUpdate {
  const factory StaffUpdate({
    required String id,
    required String workDate,
    required TimeSlot slot,
    required String description,
    required UpdateStaff staff,
    required IdName site,
    required IdName engineer,
    required DateTime submittedAt,
    required DateTime capturedAt,
    required bool submittedOffline,
    required UpdateLocation location,
    required PhotoSource photoSource,
    required UpdateImage image,
    DateTime? engineerViewedAt,
    DateTime? adminViewedAt,
  }) = _StaffUpdate;

  factory StaffUpdate.fromJson(Map<String, dynamic> json) => _$StaffUpdateFromJson(json);
}

/// A short-lived link to read one photo.
@freezed
abstract class ImageLink with _$ImageLink {
  const factory ImageLink({required String url, required DateTime expiresAt}) = _ImageLink;

  factory ImageLink.fromJson(Map<String, dynamic> json) => _$ImageLinkFromJson(json);
}

@freezed
abstract class SlotUpdateRef with _$SlotUpdateRef {
  const factory SlotUpdateRef({
    required String id,
    required DateTime submittedAt,
    required bool submittedOffline,
    ImageStatus? imageStatus,
    DateTime? engineerViewedAt,
    DateTime? adminViewedAt,
  }) = _SlotUpdateRef;

  factory SlotUpdateRef.fromJson(Map<String, dynamic> json) => _$SlotUpdateRefFromJson(json);
}

/// One of the day's three slots, as judged by the server clock.
@freezed
abstract class DaySlot with _$DaySlot {
  const factory DaySlot({
    required TimeSlot slot,
    required SlotState state,
    required DateTime start,
    required DateTime end,

    /// The window's end plus grace: until then a late update still counts.
    required DateTime closesAt,
    SlotUpdateRef? update,
  }) = _DaySlot;

  factory DaySlot.fromJson(Map<String, dynamic> json) => _$DaySlotFromJson(json);
}

@freezed
abstract class TodaySite with _$TodaySite {
  const factory TodaySite({
    required String id,
    required String code,
    required String name,
    required String address,
    double? latitude,
    double? longitude,
    int? geofenceRadiusM,
  }) = _TodaySite;

  factory TodaySite.fromJson(Map<String, dynamic> json) => _$TodaySiteFromJson(json);
}

@freezed
abstract class TodayAssignment with _$TodayAssignment {
  const factory TodayAssignment({required TodaySite site, required PersonRef engineer}) = _TodayAssignment;

  factory TodayAssignment.fromJson(Map<String, dynamic> json) => _$TodayAssignmentFromJson(json);
}

/// Rules the app applies before asking the server (which checks them again).
@freezed
abstract class FieldRules with _$FieldRules {
  const factory FieldRules({
    required bool requireCheckIn,
    required bool allowGallery,
    required bool locationRequired,
    required int fixTimeoutSeconds,
    required double maxUploadMb,
    required int offlineAcceptanceMinutes,
    required int defaultGeofenceRadiusM,
  }) = _FieldRules;

  factory FieldRules.fromJson(Map<String, dynamic> json) => _$FieldRulesFromJson(json);
}

/// Response of `GET /me/today`: everything the staff home screen shows.
@freezed
abstract class StaffToday with _$StaffToday {
  const factory StaffToday({
    required DateTime serverTime,
    required String date,
    required bool isWorkingDay,
    String? holiday,
    TodayAssignment? assignment,
    AttendanceRecord? attendance,
    required List<DaySlot> slots,
    required FieldRules rules,
  }) = _StaffToday;

  const StaffToday._();

  factory StaffToday.fromJson(Map<String, dynamic> json) => _$StaffTodayFromJson(json);

  bool get checkedIn => attendance?.checkInAt != null;
  bool get checkedOut => attendance?.checkOutAt != null;
}
