import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/revision.dart';
import '../../../core/models/enums.dart';
import '../../../core/network/api_client.dart';
import '../../auth/domain/user_role.dart';
import '../domain/person_models.dart';

/// Engineers, staff, godown managers and admins. [role] picks the endpoint.
class PeopleRepository {
  PeopleRepository(this._api);

  final ApiClient _api;

  static String _path(UserRole role) => '/${personSegment(role)}';

  Future<PageResult<PersonSummary>> list(
    UserRole role, {
    required int page,
    String? search,
    bool? active,
    String? siteId,
    Designation? designation,
    bool unassignedOnly = false,
    int limit = 20,
  }) => _api.getPage(
    _path(role),
    query: {
      'page': page,
      'limit': limit,
      'q': search,
      'status': active == null ? null : (active ? 'active' : 'inactive'),
      'siteId': siteId,
      'designation': designation?.apiValue,
      'unassigned': unassignedOnly ? 'true' : null,
    },
    item: PersonSummary.fromJson,
  );

  Future<PersonDetail> get(UserRole role, String id) => _api.get('${_path(role)}/$id', decode: _detail);

  Future<CreatedPerson> create(UserRole role, Map<String, Object?> body) =>
      _api.post(_path(role), body: body, decode: (data) => CreatedPerson.fromJson(data! as Map<String, dynamic>));

  Future<PersonDetail> update(UserRole role, String id, Map<String, Object?> body) =>
      _api.patch('${_path(role)}/$id', body: body, decode: _detail);

  Future<PersonDetail> setActive(UserRole role, String id, {required bool active}) =>
      _api.patch('${_path(role)}/$id/status', body: {'isActive': active}, decode: _detail);

  Future<PersonDetail> assignStaff(String staffId, {required String siteId, required String engineerId}) =>
      _api.put('/staff/$staffId/assignment', body: {'siteId': siteId, 'engineerId': engineerId}, decode: _detail);

  Future<PersonDetail> unassignStaff(String staffId) => _api.delete('/staff/$staffId/assignment', decode: _detail);

  /// Returns a new temporary password to give to the person.
  Future<String> resetPassword(String userId) => _api.post(
    '/users/$userId/reset-password',
    decode: (data) => (data! as Map<String, dynamic>)['temporaryPassword'] as String,
  );

  static PersonDetail _detail(Object? data) => PersonDetail.fromJson(data! as Map<String, dynamic>);
}

/// The API path and app route segment for a role's people.
String personSegment(UserRole role) => switch (role) {
  UserRole.engineer => 'engineers',
  UserRole.staff => 'staff',
  UserRole.godownManager => 'godown-managers',
  UserRole.admin => 'admins',
};

final peopleRepositoryProvider = Provider<PeopleRepository>((ref) => PeopleRepository(ref.watch(apiClientProvider)));

typedef PersonKey = ({UserRole role, String id});

final personDetailProvider = FutureProvider.autoDispose.family<PersonDetail, PersonKey>((ref, key) {
  ref.watch(revisionProvider(DataSet.people));
  ref.watch(revisionProvider(DataSet.sites));
  return ref.watch(peopleRepositoryProvider).get(key.role, key.id);
});

/// Active staff without a site, for "Add staff" on a site.
final unassignedStaffProvider = FutureProvider.autoDispose<List<PersonSummary>>((ref) async {
  ref.watch(revisionProvider(DataSet.people));
  final page = await ref
      .watch(peopleRepositoryProvider)
      .list(UserRole.staff, page: 1, limit: 100, active: true, unassignedOnly: true);
  return page.items;
});

/// Active engineers for pickers.
final engineerPickerProvider = FutureProvider.autoDispose<List<PersonSummary>>((ref) async {
  ref.watch(revisionProvider(DataSet.people));
  final page = await ref.watch(peopleRepositoryProvider).list(UserRole.engineer, page: 1, limit: 100, active: true);
  return page.items;
});
