import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/revision.dart';
import '../../../core/network/api_client.dart';
import '../domain/notification_models.dart';

class NotificationsRepository {
  NotificationsRepository(this._api);

  final ApiClient _api;

  Future<PageResult<AppNotification>> list({required int page, bool unreadOnly = false, int limit = 20}) =>
      _api.getPage(
        '/notifications',
        query: {'page': page, 'limit': limit, 'unreadOnly': unreadOnly ? 'true' : null},
        item: AppNotification.fromJson,
      );

  Future<int> unreadCount() =>
      _api.get('/notifications/unread-count', decode: (data) => (data! as Map<String, dynamic>)['count'] as int);

  Future<void> markRead(String id) => _api.post('/notifications/$id/read', decode: (_) {});

  Future<void> markAllRead() => _api.post('/notifications/read-all', decode: (_) {});
}

final notificationsRepositoryProvider = Provider<NotificationsRepository>(
  (ref) => NotificationsRepository(ref.watch(apiClientProvider)),
);

/// The badge on Alerts. Reloads when notifications change or are polled.
final unreadCountProvider = FutureProvider.autoDispose<int>((ref) {
  ref.watch(revisionProvider(DataSet.notifications));
  return ref.watch(notificationsRepositoryProvider).unreadCount();
});
