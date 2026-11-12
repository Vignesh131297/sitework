import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/revision.dart';
import '../../../core/models/enums.dart';
import '../../../core/network/api_client.dart';
import '../domain/vehicle_models.dart';

/// Which vehicles a list shows.
enum VehicleFilter {
  given('GIVEN'),
  free('FREE'),
  inactive('INACTIVE');

  const VehicleFilter(this.apiValue);
  final String apiValue;
}

/// Company vehicles (`/vehicles`) and money asked for their repair
/// (`/vehicle-repair-requests`).
class VehiclesRepository {
  VehiclesRepository(this._api);

  final ApiClient _api;

  /// In use first, then by number. Admins only.
  Future<PageResult<Vehicle>> list({required int page, VehicleFilter? filter, String? search, int limit = 20}) =>
      _api.getPage(
        '/vehicles',
        query: {'page': page, 'limit': limit, 'status': filter?.apiValue, 'q': search},
        item: Vehicle.fromJson,
      );

  Future<VehicleDetail> get(String id) => _api.get('/vehicles/$id', decode: _detail);

  /// The vehicle the signed-in staff member or engineer holds, if any.
  Future<Vehicle?> mine() => _api.get(
    '/vehicles/mine',
    decode: (data) {
      final vehicle = (data! as Map<String, dynamic>)['vehicle'];
      return vehicle == null ? null : Vehicle.fromJson(vehicle as Map<String, dynamic>);
    },
  );

  Future<VehicleDetail> create({
    required VehicleType type,
    required String registrationNo,
    required String makeModel,
    String? note,
  }) => _api.post(
    '/vehicles',
    body: {'type': type.apiValue, 'registrationNo': registrationNo, 'makeModel': makeModel, 'note': ?note},
    decode: _detail,
  );

  Future<VehicleDetail> update(
    String id, {
    required VehicleType type,
    required String registrationNo,
    required String makeModel,
    required String? note,
  }) => _api.patch(
    '/vehicles/$id',
    body: {'type': type.apiValue, 'registrationNo': registrationNo, 'makeModel': makeModel, 'note': note ?? ''},
    decode: _detail,
  );

  /// Out of use, or back in use.
  Future<VehicleDetail> setActive(String id, {required bool active}) =>
      _api.patch('/vehicles/$id', body: {'isActive': active}, decode: _detail);

  /// Gives it to a staff member or an engineer.
  Future<VehicleDetail> give(String id, {required String userId, required String givenOn, String? note}) =>
      _api.post('/vehicles/$id/assign', body: {'userId': userId, 'givenOn': givenOn, 'note': ?note}, decode: _detail);

  Future<VehicleDetail> takeBack(String id, {required String returnedOn, String? note}) =>
      _api.post('/vehicles/$id/return', body: {'returnedOn': returnedOn, 'note': ?note}, decode: _detail);

  /// Waiting first, newest first. [mine] keeps the caller's own; [toReview]
  /// keeps waiting requests the caller may decide.
  Future<PageResult<RepairRequest>> repairRequests({
    required int page,
    ApprovalStatus? status,
    bool mine = false,
    bool toReview = false,
    String? vehicleId,
    int limit = 20,
  }) => _api.getPage(
    '/vehicle-repair-requests',
    query: {
      'page': page,
      'limit': limit,
      'status': status?.apiValue,
      'mine': mine ? 'true' : null,
      'toReview': toReview ? 'true' : null,
      'vehicleId': vehicleId,
    },
    item: RepairRequest.fromJson,
  );

  Future<RepairRequest> repairRequest(String id) => _api.get('/vehicle-repair-requests/$id', decode: _repair);

  /// [requestId] is made once per form, so a retry never asks twice.
  Future<RepairRequest> askRepairMoney({required String requestId, required String amount, required String note}) =>
      _api.post(
        '/vehicle-repair-requests',
        body: {'requestId': requestId, 'amount': amount, 'note': note},
        decode: _repair,
      );

  Future<RepairRequest> approveRepair(String id, {String? note}) =>
      _api.post('/vehicle-repair-requests/$id/approve', body: {'note': ?note}, decode: _repair);

  Future<RepairRequest> rejectRepair(String id, String reason) =>
      _api.post('/vehicle-repair-requests/$id/reject', body: {'reason': reason}, decode: _repair);

  Future<RepairRequest> cancelRepair(String id) => _api.post('/vehicle-repair-requests/$id/cancel', decode: _repair);

  static VehicleDetail _detail(Object? data) => VehicleDetail.fromJson(data! as Map<String, dynamic>);

  static RepairRequest _repair(Object? data) => RepairRequest.fromJson(data! as Map<String, dynamic>);
}

final vehiclesRepositoryProvider = Provider<VehiclesRepository>(
  (ref) => VehiclesRepository(ref.watch(apiClientProvider)),
);

final vehicleProvider = FutureProvider.autoDispose.family<VehicleDetail, String>((ref, id) {
  ref.watch(revisionProvider(DataSet.vehicles));
  return ref.watch(vehiclesRepositoryProvider).get(id);
});

/// The signed-in staff member's or engineer's company vehicle, if they hold one.
final myVehicleProvider = FutureProvider.autoDispose<Vehicle?>((ref) {
  ref.watch(revisionProvider(DataSet.vehicles));
  return ref.watch(vehiclesRepositoryProvider).mine();
});

/// Vehicles in use that nobody holds, for "Give a vehicle" on a person.
final freeVehiclesProvider = FutureProvider.autoDispose<List<Vehicle>>((ref) async {
  ref.watch(revisionProvider(DataSet.vehicles));
  final page = await ref.watch(vehiclesRepositoryProvider).list(page: 1, limit: 100, filter: VehicleFilter.free);
  return page.items;
});

final repairRequestProvider = FutureProvider.autoDispose.family<RepairRequest, String>((ref, id) {
  ref.watch(revisionProvider(DataSet.vehicles));
  return ref.watch(vehiclesRepositoryProvider).repairRequest(id);
});

/// Repair money requests waiting for an admin.
final repairRequestsToReviewProvider = FutureProvider.autoDispose<int>((ref) async {
  ref.watch(revisionProvider(DataSet.vehicles));
  final page = await ref.watch(vehiclesRepositoryProvider).repairRequests(page: 1, limit: 1, toReview: true);
  return page.total;
});
