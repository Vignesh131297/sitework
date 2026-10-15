import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/revision.dart';
import '../../../core/models/enums.dart';
import '../../../core/network/api_client.dart';
import '../../engineer_updates/data/engineer_updates_repository.dart';
import '../domain/stock_models.dart';

/// Godowns, materials, each place's stock and the entries between them.
/// Quantities travel as strings; every balance and value is the server's.
class StockRepository {
  StockRepository(this._api);

  final ApiClient _api;

  Future<StockOverview> overview() =>
      _api.get('/stock/overview', decode: (data) => StockOverview.fromJson(data! as Map<String, dynamic>));

  Future<GodownStock> godown(String id) =>
      _api.get('/stock/godowns/$id', decode: (data) => GodownStock.fromJson(data! as Map<String, dynamic>));

  Future<SiteStock> site(String siteId) =>
      _api.get('/sites/$siteId/stock', decode: (data) => SiteStock.fromJson(data! as Map<String, dynamic>));

  Future<MaterialDetail> material(String id) => _api.get('/materials/$id', decode: _material);

  Future<MaterialDetail> createMaterial({
    required String name,
    required String unit,
    String? category,
    String? minStock,
  }) => _api.post(
    '/materials',
    body: {'name': name, 'unit': unit, 'category': ?category, 'minStock': ?minStock},
    decode: _material,
  );

  /// [body] uses the API's field names; null clears category and minimum.
  Future<MaterialDetail> updateMaterial(String id, Map<String, Object?> body) =>
      _api.patch('/materials/$id', body: body, decode: _material);

  Future<Godown> createGodown({required String name, String? address}) =>
      _api.post('/godowns', body: {'name': name, 'address': ?address}, decode: _godown);

  Future<Godown> updateGodown(String id, Map<String, Object?> body) =>
      _api.patch('/godowns/$id', body: body, decode: _godown);

  /// Newest first. [receivable] keeps what the user can confirm now.
  Future<PageResult<StockEntry>> entries({
    required int page,
    String? siteId,
    String? godownId,
    String? materialId,
    StockMovementStatus? status,
    bool receivable = false,
    String? search,
    int limit = 20,
  }) => _api.getPage(
    '/stock/entries',
    query: {
      'page': page,
      'limit': limit,
      'siteId': siteId,
      'godownId': godownId,
      'materialId': materialId,
      'status': status?.apiValue,
      'receivable': receivable ? 'true' : null,
      'q': search,
    },
    item: StockEntry.fromJson,
  );

  /// One entry with links to its photos.
  Future<StockEntry> entry(String id) => _api.get('/stock/entries/$id', decode: _entry);

  /// Purchases and transfers go as multipart forms with their photos.
  Future<StockEntry> submit(StockForm form, {ProgressCallback? onSendProgress}) {
    final body = form.toJson();
    return _api.post(
      form.kind.path,
      body: form.kind.withPhotos
          ? FormData.fromMap({
              for (final MapEntry(:key, :value) in body.entries)
                if (value != null) key: value is String ? value : jsonEncode(value),
              'photos': photoParts(form.photoPaths),
            })
          : body,
      decode: _entry,
      onSendProgress: onSendProgress,
    );
  }

  /// Confirms a delivery: what arrived of each material, with photos.
  Future<StockEntry> receive(
    String id, {
    required Map<String, String> received,
    String? note,
    required List<String> photoPaths,
    ProgressCallback? onSendProgress,
  }) => _api.post(
    '/stock/entries/$id/receive',
    body: FormData.fromMap({
      'lines': jsonEncode([
        for (final MapEntry(:key, :value) in received.entries) {'materialId': key, 'receivedQuantity': value},
      ]),
      'note': ?note,
      'photos': photoParts(photoPaths),
    }),
    decode: _entry,
    onSendProgress: onSendProgress,
  );

  Future<StockEntry> cancel(String id, String reason) =>
      _api.post('/stock/entries/$id/void', body: {'reason': reason}, decode: _entry);

  static MaterialDetail _material(Object? data) => MaterialDetail.fromJson(data! as Map<String, dynamic>);
  static Godown _godown(Object? data) => Godown.fromJson(data! as Map<String, dynamic>);
  static StockEntry _entry(Object? data) => StockEntry.fromJson(data! as Map<String, dynamic>);
}

final stockRepositoryProvider = Provider<StockRepository>((ref) => StockRepository(ref.watch(apiClientProvider)));

final stockOverviewProvider = FutureProvider.autoDispose<StockOverview>((ref) {
  ref.watch(revisionProvider(DataSet.stock));
  return ref.watch(stockRepositoryProvider).overview();
});

final godownStockProvider = FutureProvider.autoDispose.family<GodownStock, String>((ref, id) {
  ref.watch(revisionProvider(DataSet.stock));
  return ref.watch(stockRepositoryProvider).godown(id);
});

final siteStockProvider = FutureProvider.autoDispose.family<SiteStock, String>((ref, siteId) {
  ref.watch(revisionProvider(DataSet.stock));
  return ref.watch(stockRepositoryProvider).site(siteId);
});

final materialDetailProvider = FutureProvider.autoDispose.family<MaterialDetail, String>((ref, id) {
  ref.watch(revisionProvider(DataSet.stock));
  return ref.watch(stockRepositoryProvider).material(id);
});

final stockEntryProvider = FutureProvider.autoDispose.family<StockEntry, String>((ref, id) {
  ref.watch(revisionProvider(DataSet.stock));
  return ref.watch(stockRepositoryProvider).entry(id);
});

/// A material's latest entries, for its page.
final materialEntriesProvider = FutureProvider.autoDispose.family<List<StockEntry>, String>((ref, id) async {
  ref.watch(revisionProvider(DataSet.stock));
  return (await ref.watch(stockRepositoryProvider).entries(page: 1, materialId: id, limit: 10)).items;
});
