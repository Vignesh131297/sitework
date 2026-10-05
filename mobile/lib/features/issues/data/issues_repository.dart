import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/revision.dart';
import '../../../core/models/enums.dart';
import '../../../core/network/api_client.dart';
import '../../engineer_updates/data/engineer_updates_repository.dart';
import '../domain/issue_models.dart';

class IssuesRepository {
  IssuesRepository(this._api);

  final ApiClient _api;

  /// [unresolved] lists open and in-progress issues together.
  Future<PageResult<Issue>> list({
    required int page,
    String? siteId,
    IssueStatus? status,
    bool unresolved = false,
    String? search,
    int limit = 20,
  }) => _api.getPage(
    '/issues',
    query: {
      'page': page,
      'limit': limit,
      'siteId': siteId,
      'status': status?.apiValue,
      'unresolved': unresolved ? 'true' : null,
      'q': search,
    },
    item: Issue.fromJson,
  );

  Future<Issue> get(String id) => _api.get('/issues/$id', decode: _issue);

  Future<Issue> create({
    required String siteId,
    required String title,
    required String description,
    required Priority priority,
    List<String> photoPaths = const [],
    ProgressCallback? onSendProgress,
  }) => _api.post(
    '/issues',
    body: FormData.fromMap({
      'siteId': siteId,
      'title': title,
      'description': description,
      'priority': priority.apiValue,
      'photos': photoParts(photoPaths),
    }),
    decode: _issue,
    onSendProgress: onSendProgress,
  );

  Future<Issue> update(String id, {IssueStatus? status, Priority? priority, String? resolutionNote}) => _api.patch(
    '/issues/$id',
    body: {'status': ?status?.apiValue, 'priority': ?priority?.apiValue, 'resolutionNote': ?resolutionNote},
    decode: _issue,
  );

  static Issue _issue(Object? data) => Issue.fromJson(data! as Map<String, dynamic>);
}

final issuesRepositoryProvider = Provider<IssuesRepository>((ref) => IssuesRepository(ref.watch(apiClientProvider)));

final issueProvider = FutureProvider.autoDispose.family<Issue, String>((ref, id) {
  ref.watch(revisionProvider(DataSet.issues));
  return ref.watch(issuesRepositoryProvider).get(id);
});
