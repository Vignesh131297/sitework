import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/revision.dart';
import '../../../core/models/enums.dart';
import '../../../core/network/api_client.dart';
import '../domain/site_day.dart';
import '../domain/site_models.dart';

class SitesRepository {
  SitesRepository(this._api);

  final ApiClient _api;

  Future<PageResult<SiteSummary>> list({
    required int page,
    String? search,
    SiteStatus? status,
    String? clientId,
    int limit = 20,
  }) => _api.getPage(
    '/sites',
    query: {'page': page, 'limit': limit, 'q': search, 'status': status?.apiValue, 'clientId': clientId},
    item: SiteSummary.fromJson,
  );

  Future<SiteDetail> get(String id) => _api.get('/sites/$id', decode: _detail);

  /// [body] uses the API's field names (see CreateSiteDto on the server).
  Future<SiteDetail> create(Map<String, Object?> body) => _api.post('/sites', body: body, decode: _detail);

  Future<SiteDetail> update(String id, Map<String, Object?> body) =>
      _api.patch('/sites/$id', body: body, decode: _detail);

  Future<SiteDetail> setEngineers(String id, List<String> engineerIds) =>
      _api.put('/sites/$id/engineers', body: {'engineerIds': engineerIds}, decode: _detail);

  /// The staff board for [date] (YYYY-MM-DD), or today by the server's calendar.
  Future<SiteDay> day(String id, {String? date}) => _api.get(
    '/sites/$id/day',
    query: {'date': date},
    decode: (data) => SiteDay.fromJson(data! as Map<String, dynamic>),
  );

  static SiteDetail _detail(Object? data) => SiteDetail.fromJson(data! as Map<String, dynamic>);
}

final sitesRepositoryProvider = Provider<SitesRepository>((ref) => SitesRepository(ref.watch(apiClientProvider)));

final siteDetailProvider = FutureProvider.autoDispose.family<SiteDetail, String>((ref, id) {
  ref.watch(revisionProvider(DataSet.sites));
  ref.watch(revisionProvider(DataSet.people));
  ref.watch(revisionProvider(DataSet.payments));
  return ref.watch(sitesRepositoryProvider).get(id);
});

/// Active sites for pickers (first 100 is plenty for a contractor).
final sitePickerProvider = FutureProvider.autoDispose<List<SiteSummary>>((ref) async {
  ref.watch(revisionProvider(DataSet.sites));
  final page = await ref.watch(sitesRepositoryProvider).list(page: 1, limit: 100);
  return page.items.where((site) => site.status != SiteStatus.completed).toList();
});

typedef SiteDayKey = ({String siteId, String? date});

final siteDayProvider = FutureProvider.autoDispose.family<SiteDay, SiteDayKey>((ref, key) {
  ref.watch(revisionProvider(DataSet.staffUpdates));
  ref.watch(revisionProvider(DataSet.attendance));
  return ref.watch(sitesRepositoryProvider).day(key.siteId, date: key.date);
});
