import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/revision.dart';
import '../../../core/network/api_client.dart';
import '../domain/client_models.dart';

class ClientsRepository {
  ClientsRepository(this._api);

  final ApiClient _api;

  Future<PageResult<ClientSummary>> list({required int page, String? search, int limit = 20}) =>
      _api.getPage('/clients', query: {'page': page, 'limit': limit, 'q': search}, item: ClientSummary.fromJson);

  Future<ClientDetail> get(String id) => _api.get('/clients/$id', decode: _detail);

  Future<ClientDetail> create(Map<String, Object?> body) => _api.post('/clients', body: body, decode: _detail);

  Future<ClientDetail> update(String id, Map<String, Object?> body) =>
      _api.patch('/clients/$id', body: body, decode: _detail);

  static ClientDetail _detail(Object? data) => ClientDetail.fromJson(data! as Map<String, dynamic>);
}

final clientsRepositoryProvider = Provider<ClientsRepository>((ref) => ClientsRepository(ref.watch(apiClientProvider)));

final clientDetailProvider = FutureProvider.autoDispose.family<ClientDetail, String>((ref, id) {
  ref.watch(revisionProvider(DataSet.clients));
  ref.watch(revisionProvider(DataSet.sites));
  return ref.watch(clientsRepositoryProvider).get(id);
});

/// All clients for pickers.
final clientPickerProvider = FutureProvider.autoDispose<List<ClientSummary>>((ref) async {
  ref.watch(revisionProvider(DataSet.clients));
  return (await ref.watch(clientsRepositoryProvider).list(page: 1, limit: 100)).items;
});
