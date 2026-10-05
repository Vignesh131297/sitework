import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_health.freezed.dart';
part 'server_health.g.dart';

/// Response of `GET /health`. [serverTime] is the clock the app trusts for
/// business rules, never the phone's.
@freezed
abstract class ServerHealth with _$ServerHealth {
  const factory ServerHealth({
    required String status,
    required String environment,
    required String version,
    required DateTime serverTime,
    required String timeZone,
    required String businessDate,
  }) = _ServerHealth;

  factory ServerHealth.fromJson(Map<String, dynamic> json) => _$ServerHealthFromJson(json);
}
