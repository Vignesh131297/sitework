import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/revision.dart';
import '../../../core/models/enums.dart';
import '../../../core/network/api_client.dart';
import '../domain/request_models.dart';

/// Leave (`/leave-requests`) and staff money and food requests (`/staff-requests`).
class RequestsRepository {
  RequestsRepository(this._api);

  final ApiClient _api;

  /// Waiting first, then the latest leave. [mine] keeps the caller's own;
  /// [toReview] keeps waiting leave the caller may decide.
  Future<PageResult<LeaveRequest>> leave({
    required int page,
    ApprovalStatus? status,
    bool mine = false,
    bool toReview = false,
    int limit = 20,
  }) => _api.getPage(
    '/leave-requests',
    query: {
      'page': page,
      'limit': limit,
      'status': status?.apiValue,
      'mine': mine ? 'true' : null,
      'toReview': toReview ? 'true' : null,
    },
    item: LeaveRequest.fromJson,
  );

  Future<LeaveRequest> leaveRequest(String id) => _api.get('/leave-requests/$id', decode: _leave);

  /// [requestId] is made once per form, so a retry never asks twice.
  Future<LeaveRequest> askLeave({
    required String requestId,
    required LeaveType type,
    required String fromDate,
    required String toDate,
    required String reason,
  }) => _api.post(
    '/leave-requests',
    body: {
      'requestId': requestId,
      'type': type.apiValue,
      'fromDate': fromDate,
      'toDate': toDate,
      'reason': reason,
    },
    decode: _leave,
  );

  Future<LeaveRequest> approveLeave(String id, {String? note}) =>
      _api.post('/leave-requests/$id/approve', body: {'note': ?note}, decode: _leave);

  Future<LeaveRequest> rejectLeave(String id, String reason) =>
      _api.post('/leave-requests/$id/reject', body: {'reason': reason}, decode: _leave);

  Future<LeaveRequest> cancelLeave(String id) => _api.post('/leave-requests/$id/cancel', decode: _leave);

  /// Waiting first, newest first.
  Future<PageResult<StaffRequest>> staffRequests({
    required int page,
    ApprovalStatus? status,
    bool toReview = false,
    int limit = 20,
  }) => _api.getPage(
    '/staff-requests',
    query: {'page': page, 'limit': limit, 'status': status?.apiValue, 'toReview': toReview ? 'true' : null},
    item: StaffRequest.fromJson,
  );

  Future<StaffRequest> staffRequest(String id) => _api.get('/staff-requests/$id', decode: _staffRequest);

  /// Money needs [amount]; food needs [forDate] and [meal].
  Future<StaffRequest> ask({
    required String requestId,
    required StaffRequestKind kind,
    String? amount,
    String? forDate,
    Meal? meal,
    String? note,
  }) => _api.post(
    '/staff-requests',
    body: {
      'requestId': requestId,
      'kind': kind.apiValue,
      'amount': ?amount,
      'forDate': ?forDate,
      'meal': ?meal?.apiValue,
      'note': ?note,
    },
    decode: _staffRequest,
  );

  Future<StaffRequest> approveStaffRequest(String id, {String? note}) =>
      _api.post('/staff-requests/$id/approve', body: {'note': ?note}, decode: _staffRequest);

  Future<StaffRequest> rejectStaffRequest(String id, String reason) =>
      _api.post('/staff-requests/$id/reject', body: {'reason': reason}, decode: _staffRequest);

  Future<StaffRequest> cancelStaffRequest(String id) =>
      _api.post('/staff-requests/$id/cancel', decode: _staffRequest);

  static LeaveRequest _leave(Object? data) => LeaveRequest.fromJson(data! as Map<String, dynamic>);

  static StaffRequest _staffRequest(Object? data) => StaffRequest.fromJson(data! as Map<String, dynamic>);
}

final requestsRepositoryProvider = Provider<RequestsRepository>(
  (ref) => RequestsRepository(ref.watch(apiClientProvider)),
);

final leaveRequestProvider = FutureProvider.autoDispose.family<LeaveRequest, String>((ref, id) {
  ref.watch(revisionProvider(DataSet.requests));
  return ref.watch(requestsRepositoryProvider).leaveRequest(id);
});

final staffRequestProvider = FutureProvider.autoDispose.family<StaffRequest, String>((ref, id) {
  ref.watch(revisionProvider(DataSet.requests));
  return ref.watch(requestsRepositoryProvider).staffRequest(id);
});

/// Leave and money or food requests waiting for the caller (admins and engineers).
final requestsToReviewProvider = FutureProvider.autoDispose<int>((ref) async {
  ref.watch(revisionProvider(DataSet.requests));
  final repository = ref.watch(requestsRepositoryProvider);
  final totals = await Future.wait([
    repository.leave(page: 1, limit: 1, toReview: true).then((page) => page.total),
    repository.staffRequests(page: 1, limit: 1, toReview: true).then((page) => page.total),
  ]);
  return totals[0] + totals[1];
});
