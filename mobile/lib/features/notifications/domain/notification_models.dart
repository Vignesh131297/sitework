import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/enums.dart';

part 'notification_models.freezed.dart';
part 'notification_models.g.dart';

@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    // Unknown types from a newer server still show, as general notices.
    @JsonKey(unknownEnumValue: NotificationType.system) required NotificationType type,
    required String title,
    required String message,
    @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) ReferenceType? referenceType,
    String? referenceId,
    Map<String, String>? data,
    required bool isRead,
    required DateTime createdAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) => _$AppNotificationFromJson(json);
}
