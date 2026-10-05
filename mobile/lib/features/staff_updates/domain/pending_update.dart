import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/enums.dart';

part 'pending_update.freezed.dart';
part 'pending_update.g.dart';

enum PendingState { waiting, sending, failed }

/// An update saved on the phone until the server accepts it. Kept as a JSON
/// file next to its photo, so it survives the app being closed or killed.
@freezed
abstract class PendingUpdate with _$PendingUpdate {
  const factory PendingUpdate({
    /// Also the clientSubmissionId: the server saves it at most once.
    required String id,

    /// Only the person who took it can send it.
    required String userId,
    required TimeSlot slot,
    required String workDate,
    required String description,

    /// When the photo was taken, by the server's clock (see ServerClock).
    required DateTime capturedAt,
    required PhotoSource photoSource,

    /// From `LocationResult.toApiFields()`.
    required Map<String, Object> location,
    required String photoPath,
    @Default(PendingState.waiting) PendingState state,
    @Default(0) int attempts,

    /// Why the server refused it (API code and message), when [state] is failed.
    String? errorCode,
    String? errorMessage,
  }) = _PendingUpdate;

  factory PendingUpdate.fromJson(Map<String, dynamic> json) => _$PendingUpdateFromJson(json);
}
