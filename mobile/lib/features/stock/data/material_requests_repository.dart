import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/revision.dart';
import '../../../core/models/enums.dart';
import '../../../core/network/api_client.dart';
import '../domain/stock_models.dart';

/// Material requests: a site asks, an admin approves (choosing the godown and
/// quantities) or rejects, the godown's manager sends it, and the site closes
/// it. Deliveries against a request go through [StockRepository.submit].
class MaterialRequestsRepository {
  MaterialRequestsRepository(this._api);

  final ApiClient _api;

  /// Waiting first (pending, then being sent), newest first. [open] keeps
  /// pending and approved ones.
  Future<PageResult<MaterialRequest>> list({
    required int page,
    MaterialRequestStatus? status,
    bool open = false,
    String? siteId,
    String? godownId,
    String? search,
    int limit = 20,
  }) => _api.getPage(
    '/material-requests',
    query: {
      'page': page,
      'limit': limit,
      'status': status?.apiValue,
      'open': open ? 'true' : null,
      'siteId': siteId,
      'godownId': godownId,
      'q': search,
    },
    item: MaterialRequest.fromJson,
  );

  /// One request with its deliveries and returns.
  Future<MaterialRequest> get(String id) => _api.get('/material-requests/$id', decode: _request);

  /// [requestId] is made once per form, so a retry never asks twice.
  Future<MaterialRequest> create({
    required String requestId,
    required String siteId,
    required List<({String materialId, String quantity})> lines,
    String? neededBy,
    String? note,
  }) => _api.post(
    '/material-requests',
    body: {
      'requestId': requestId,
      'siteId': siteId,
      'lines': [
        for (final line in lines) {'materialId': line.materialId, 'quantity': line.quantity},
      ],
      'neededBy': ?neededBy,
      'note': ?note,
    },
    decode: _request,
  );

  /// [approved] maps each requested material to the quantity approved ("0":
  /// not supplied).
  Future<MaterialRequest> approve(
    String id, {
    required String godownId,
    required Map<String, String> approved,
    String? note,
  }) => _api.post(
    '/material-requests/$id/approve',
    body: {
      'godownId': godownId,
      'lines': [
        for (final MapEntry(:key, :value) in approved.entries) {'materialId': key, 'approvedQuantity': value},
      ],
      'note': ?note,
    },
    decode: _request,
  );

  Future<MaterialRequest> reject(String id, String reason) =>
      _api.post('/material-requests/$id/reject', body: {'reason': reason}, decode: _request);

  Future<MaterialRequest> cancel(String id) => _api.post('/material-requests/$id/cancel', decode: _request);

  /// The site is done: everything used, or [returned] goes back to the
  /// request's godown (recorded as a return the godown confirms).
  Future<MaterialRequest> close(
    String id, {
    required MaterialRequestOutcome outcome,
    String? note,
    String? returnRequestId,
    List<({String materialId, String quantity})> returned = const [],
  }) => _api.post(
    '/material-requests/$id/close',
    body: {
      'outcome': outcome.apiValue,
      'note': ?note,
      if (outcome == MaterialRequestOutcome.leftoverReturned) ...{
        'returnRequestId': returnRequestId,
        'lines': [
          for (final line in returned) {'materialId': line.materialId, 'quantity': line.quantity},
        ],
      },
    },
    decode: _request,
  );

  static MaterialRequest _request(Object? data) => MaterialRequest.fromJson(data! as Map<String, dynamic>);
}

final materialRequestsRepositoryProvider = Provider<MaterialRequestsRepository>(
  (ref) => MaterialRequestsRepository(ref.watch(apiClientProvider)),
);

final materialRequestProvider = FutureProvider.autoDispose.family<MaterialRequest, String>((ref, id) {
  ref.watch(revisionProvider(DataSet.stock));
  return ref.watch(materialRequestsRepositoryProvider).get(id);
});

/// A site's open requests, for its Stock tab.
final siteOpenRequestsProvider = FutureProvider.autoDispose.family<List<MaterialRequest>, String>((ref, siteId) async {
  ref.watch(revisionProvider(DataSet.stock));
  final page = await ref.watch(materialRequestsRepositoryProvider).list(page: 1, siteId: siteId, open: true);
  return page.items;
});
