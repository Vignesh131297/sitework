import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../domain/report_models.dart';

/// What to report on: the kind, the dates (both included) and optionally one site.
typedef ReportQuery = ({ReportKind kind, String from, String to, String? siteId});

/// Read-only figures over a date range. Every count and total is the server's.
class ReportsRepository {
  ReportsRepository(this._api);

  final ApiClient _api;

  Future<ReportResult> fetch(ReportQuery query) => _api.get(
    '/reports/${query.kind.path}',
    query: _params(query),
    decode: (data) => switch (query.kind) {
      ReportKind.sites => SitesReport(_list(data, SiteReportRow.fromJson)),
      ReportKind.staff => StaffReport(_list(data, StaffReportRow.fromJson)),
      ReportKind.engineers => EngineersReport(_list(data, EngineerReportRow.fromJson)),
      ReportKind.payments => PaymentsReport(PaymentReport.fromJson(data! as Map<String, dynamic>)),
    },
  );

  /// The same report as a spreadsheet (UTF-8 CSV).
  Future<List<int>> csv(ReportQuery query) =>
      _api.download('/reports/${query.kind.path}', query: {..._params(query), 'format': 'csv'});

  /// The name the server gives the file, e.g. "sites-2026-10-01-to-2026-10-31.csv".
  static String fileName(ReportQuery query) => '${query.kind.path}-${query.from}-to-${query.to}.csv';

  static Map<String, Object?> _params(ReportQuery query) => {
    'from': query.from,
    'to': query.to,
    'siteId': query.kind == ReportKind.engineers ? null : query.siteId,
  };

  static List<T> _list<T>(Object? data, T Function(Map<String, dynamic>) item) => [
    for (final row in data! as List<Object?>) item(row! as Map<String, dynamic>),
  ];
}

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) => ReportsRepository(ref.watch(apiClientProvider)));

final reportProvider = FutureProvider.autoDispose.family<ReportResult, ReportQuery>(
  (ref, query) => ref.watch(reportsRepositoryProvider).fetch(query),
);
