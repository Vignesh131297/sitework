import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/revision.dart';
import '../../../core/network/api_client.dart';
import '../domain/admin_dashboard.dart';

class DashboardRepository {
  DashboardRepository(this._api);

  final ApiClient _api;

  Future<AdminDashboard> admin() =>
      _api.get('/dashboard/admin', decode: (data) => AdminDashboard.fromJson(data! as Map<String, dynamic>));

  Future<EngineerDashboard> engineer() =>
      _api.get('/dashboard/engineer', decode: (data) => EngineerDashboard.fromJson(data! as Map<String, dynamic>));
}

final dashboardRepositoryProvider = Provider<DashboardRepository>(
  (ref) => DashboardRepository(ref.watch(apiClientProvider)),
);

/// Reloads whenever anything it summarizes changes.
final adminDashboardProvider = FutureProvider.autoDispose<AdminDashboard>((ref) {
  for (final set in [DataSet.sites, DataSet.people, DataSet.payments, DataSet.staffUpdates, DataSet.issues]) {
    ref.watch(revisionProvider(set));
  }
  return ref.watch(dashboardRepositoryProvider).admin();
});

final engineerDashboardProvider = FutureProvider.autoDispose<EngineerDashboard>((ref) {
  for (final set in [DataSet.sites, DataSet.staffUpdates, DataSet.engineerUpdates, DataSet.issues]) {
    ref.watch(revisionProvider(set));
  }
  return ref.watch(dashboardRepositoryProvider).engineer();
});
