import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/enums.dart';
import '../../../core/network/api_client.dart';
import '../domain/attendance_models.dart';

class AttendanceRepository {
  AttendanceRepository(this._api);

  final ApiClient _api;

  /// [location] comes from `LocationResult.toApiFields()`.
  Future<AttendanceRecord> checkIn(Map<String, Object> location) =>
      _api.post('/attendance/check-in', body: location, decode: _record);

  Future<AttendanceRecord> checkOut(Map<String, Object> location) =>
      _api.post('/attendance/check-out', body: location, decode: _record);

  /// Staff get their own days; engineers their sites'; admins everyone's.
  Future<PageResult<AttendanceRecord>> list({
    required int page,
    String? date,
    String? from,
    String? to,
    String? siteId,
    String? staffId,
    AttendanceStatus? status,
    String? search,
    int limit = 20,
  }) => _api.getPage(
    '/attendance',
    query: {
      'page': page,
      'limit': limit,
      'date': date,
      'from': from,
      'to': to,
      'siteId': siteId,
      'staffId': staffId,
      'status': status?.apiValue,
      'q': search,
    },
    item: AttendanceRecord.fromJson,
  );

  static AttendanceRecord _record(Object? data) => AttendanceRecord.fromJson(data! as Map<String, dynamic>);
}

final attendanceRepositoryProvider = Provider<AttendanceRepository>(
  (ref) => AttendanceRepository(ref.watch(apiClientProvider)),
);
