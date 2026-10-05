import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_role.dart';

part 'app_session.freezed.dart';
part 'app_session.g.dart';

/// The signed-in user, as far as the app needs to know. Parsed from the API's
/// sign-in `user` object and cached with the tokens for offline starts.
@freezed
abstract class AppSession with _$AppSession {
  const factory AppSession({
    @JsonKey(name: 'id') required String userId,
    required String name,
    required UserRole role,
    @Default(false) bool mustChangePassword,
  }) = _AppSession;

  factory AppSession.fromJson(Map<String, dynamic> json) => _$AppSessionFromJson(json);
}
