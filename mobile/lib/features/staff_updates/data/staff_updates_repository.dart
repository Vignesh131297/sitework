import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/revision.dart';
import '../../../core/models/enums.dart';
import '../../../core/network/api_client.dart';
import '../../../core/time/server_clock.dart';
import '../domain/pending_update.dart';
import '../domain/staff_update_models.dart';

class StaffUpdatesRepository {
  StaffUpdatesRepository(this._api);

  final ApiClient _api;

  Future<StaffToday> today() =>
      _api.get('/me/today', decode: (data) => StaffToday.fromJson(data! as Map<String, dynamic>));

  /// Sends one saved update with its photo (multipart). Resending the same
  /// [PendingUpdate.id] is safe: the server returns the update it already has.
  Future<StaffUpdate> submit(PendingUpdate update, {ProgressCallback? onSendProgress}) {
    final form = FormData.fromMap({
      'slot': update.slot.apiValue,
      'description': update.description,
      'clientSubmissionId': update.id,
      'capturedAt': update.capturedAt.toUtc().toIso8601String(),
      'photoSource': update.photoSource.apiValue,
      for (final MapEntry(:key, :value) in update.location.entries) key: '$value',
      'photo': MultipartFile.fromFileSync(
        update.photoPath,
        filename: 'photo.jpg',
        contentType: DioMediaType('image', 'jpeg'),
      ),
    });
    return _api.post('/staff-updates', body: form, decode: _update, onSendProgress: onSendProgress);
  }

  Future<PageResult<StaffUpdate>> list({
    required int page,
    String? date,
    String? from,
    String? to,
    String? siteId,
    String? staffId,
    TimeSlot? slot,
    String? search,
    bool pendingReview = false,
    int limit = 20,
  }) => _api.getPage(
    '/staff-updates',
    query: {
      'page': page,
      'limit': limit,
      'date': date,
      'from': from,
      'to': to,
      'siteId': siteId,
      'staffId': staffId,
      'slot': slot?.apiValue,
      'q': search,
      'pendingReview': pendingReview ? 'true' : null,
    },
    item: StaffUpdate.fromJson,
  );

  Future<StaffUpdate> get(String id) => _api.get('/staff-updates/$id', decode: _update);

  /// A short-lived link to the photo. Fails with IMAGE_DELETED once it is gone.
  Future<ImageLink> imageLink(String id) =>
      _api.get('/staff-updates/$id/image', decode: (data) => ImageLink.fromJson(data! as Map<String, dynamic>));

  /// Tells the server the photo was shown to this reviewer.
  Future<StaffUpdate> recordView(String id) => _api.post('/staff-updates/$id/views', decode: _update);

  static StaffUpdate _update(Object? data) => StaffUpdate.fromJson(data! as Map<String, dynamic>);
}

final staffUpdatesRepositoryProvider = Provider<StaffUpdatesRepository>(
  (ref) => StaffUpdatesRepository(ref.watch(apiClientProvider)),
);

/// The staff home screen. Reloads after check-in/out and sent updates.
final staffTodayProvider = FutureProvider.autoDispose<StaffToday>((ref) async {
  ref.watch(revisionProvider(DataSet.attendance));
  ref.watch(revisionProvider(DataSet.staffUpdates));
  final today = await ref.watch(staffUpdatesRepositoryProvider).today();
  ref.read(serverClockProvider.notifier).observe(today.serverTime);
  return today;
});

final staffUpdateProvider = FutureProvider.autoDispose.family<StaffUpdate, String>((ref, id) {
  ref.watch(revisionProvider(DataSet.staffUpdates));
  return ref.watch(staffUpdatesRepositoryProvider).get(id);
});
