import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/revision.dart';
import '../../../core/models/enums.dart';
import '../../../core/network/api_client.dart';
import '../domain/engineer_update_models.dart';

/// Photo files for a multipart form, read when the request is sent.
List<MultipartFile> photoParts(List<String> paths) => [
  for (final (i, path) in paths.indexed)
    MultipartFile.fromFileSync(path, filename: 'photo$i.jpg', contentType: DioMediaType('image', 'jpeg')),
];

class EngineerUpdatesRepository {
  EngineerUpdatesRepository(this._api);

  final ApiClient _api;

  Future<PageResult<EngineerUpdate>> list({
    required int page,
    String? siteId,
    EngineerUpdateType? type,
    String? search,
    int limit = 20,
  }) => _api.getPage(
    '/engineer-updates',
    query: {'page': page, 'limit': limit, 'siteId': siteId, 'type': type?.apiValue, 'q': search},
    item: EngineerUpdate.fromJson,
  );

  Future<EngineerUpdate> get(String id) => _api.get('/engineer-updates/$id', decode: _update);

  Future<EngineerUpdate> create({
    required String siteId,
    required EngineerUpdateType type,
    required Priority priority,
    String? title,
    required String description,
    int? progressPercent,
    List<String> photoPaths = const [],
    ProgressCallback? onSendProgress,
  }) => _api.post(
    '/engineer-updates',
    body: FormData.fromMap({
      'siteId': siteId,
      'type': type.apiValue,
      'priority': priority.apiValue,
      'title': ?title,
      'description': description,
      'progressPercent': ?progressPercent,
      'photos': photoParts(photoPaths),
    }),
    decode: _update,
    onSendProgress: onSendProgress,
  );

  /// Admin opened it.
  Future<EngineerUpdate> markViewed(String id) => _api.post('/engineer-updates/$id/views', decode: _update);

  static EngineerUpdate _update(Object? data) => EngineerUpdate.fromJson(data! as Map<String, dynamic>);
}

final engineerUpdatesRepositoryProvider = Provider<EngineerUpdatesRepository>(
  (ref) => EngineerUpdatesRepository(ref.watch(apiClientProvider)),
);

final engineerUpdateProvider = FutureProvider.autoDispose.family<EngineerUpdate, String>((ref, id) {
  ref.watch(revisionProvider(DataSet.engineerUpdates));
  return ref.watch(engineerUpdatesRepositoryProvider).get(id);
});
