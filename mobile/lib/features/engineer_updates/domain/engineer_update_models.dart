import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/enums.dart';
import '../../../core/models/refs.dart';

part 'engineer_update_models.freezed.dart';
part 'engineer_update_models.g.dart';

/// A kept photo (engineer updates and issues) behind a short-lived link.
@freezed
abstract class Attachment with _$Attachment {
  const factory Attachment({
    required String id,
    required String mime,
    required String url,
    required DateTime expiresAt,
  }) = _Attachment;

  factory Attachment.fromJson(Map<String, dynamic> json) => _$AttachmentFromJson(json);
}

/// An engineer's report to the admin.
@freezed
abstract class EngineerUpdate with _$EngineerUpdate {
  const factory EngineerUpdate({
    required String id,
    required EngineerUpdateType type,
    required Priority priority,
    String? title,
    required String description,
    int? progressPercent,
    required IdName site,
    required IdName engineer,
    required DateTime createdAt,
    DateTime? adminViewedAt,
    required int attachmentCount,

    /// Detail responses only.
    @Default(<Attachment>[]) List<Attachment> attachments,
  }) = _EngineerUpdate;

  factory EngineerUpdate.fromJson(Map<String, dynamic> json) => _$EngineerUpdateFromJson(json);
}
