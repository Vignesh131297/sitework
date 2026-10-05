import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/enums.dart';
import '../../../core/models/refs.dart';

part 'attendance_models.freezed.dart';
part 'attendance_models.g.dart';

/// One staff member's attendance for one business date.
@freezed
abstract class AttendanceRecord with _$AttendanceRecord {
  const factory AttendanceRecord({
    required String id,
    required String workDate,
    required AttendanceStatus status,
    required IdName staff,
    required IdName site,
    DateTime? checkInAt,
    LocationFlag? checkInLocationFlag,
    DateTime? checkOutAt,
    LocationFlag? checkOutLocationFlag,
    int? workedMinutes,
    String? correctionNote,
  }) = _AttendanceRecord;

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) => _$AttendanceRecordFromJson(json);
}
