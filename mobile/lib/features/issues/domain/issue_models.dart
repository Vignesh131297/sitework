import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/enums.dart';
import '../../../core/models/refs.dart';
import '../../auth/domain/user_role.dart';
import '../../engineer_updates/domain/engineer_update_models.dart';

part 'issue_models.freezed.dart';
part 'issue_models.g.dart';

@freezed
abstract class IssueReporter with _$IssueReporter {
  const factory IssueReporter({required String id, required String name, required UserRole role}) = _IssueReporter;

  factory IssueReporter.fromJson(Map<String, dynamic> json) => _$IssueReporterFromJson(json);
}

/// A site problem, followed until it is resolved.
@freezed
abstract class Issue with _$Issue {
  const factory Issue({
    required String id,
    required String title,
    required String description,
    required Priority priority,
    required IssueStatus status,
    required IdName site,
    required IssueReporter reportedBy,
    required DateTime createdAt,
    DateTime? resolvedAt,
    IdName? resolvedBy,
    String? resolutionNote,
    required int attachmentCount,

    /// Detail responses only.
    @Default(<Attachment>[]) List<Attachment> attachments,
  }) = _Issue;

  factory Issue.fromJson(Map<String, dynamic> json) => _$IssueFromJson(json);
}
