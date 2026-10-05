import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sitework/core/files/file_sharer.dart';
import 'package:sitework/features/reports/presentation/reports_screen.dart';

import '../helpers/admin_fixtures.dart';
import '../helpers/engineer_fixtures.dart';
import '../helpers/fake_api.dart';
import '../helpers/pump_app.dart';

Map<String, Object?> siteReportJson({String? received = '250000.00'}) => {
  'site': {'id': 'site-1', 'code': 'SITE-001', 'name': 'ABC Apartment Project', 'status': 'IN_PROGRESS'},
  'client': {'id': 'client-1', 'name': 'Mr. Rajesh'},
  'updates': {'submitted': 9, 'missed': 3, 'offline': 1, 'locationFlagged': 2, 'compliancePercent': 75},
  'attendance': {'present': 10, 'late': 2, 'halfDay': 0, 'absent': 1},
  'engineerUpdates': 4,
  'issues': {'opened': 1, 'resolved': 1, 'openNow': 2},
  'received': received,
};

Map<String, Object?> staffReportJson() => {
  'staff': {'id': 'staff-1', 'name': 'Ravi', 'employeeCode': 'EMP-101', 'designation': 'MASON', 'isActive': true},
  'site': {'id': 'site-1', 'name': 'ABC Apartment Project'},
  'attendance': {'present': 5, 'late': 0, 'halfDay': 0, 'absent': 1},
  'updates': {'submitted': 0, 'missed': 0, 'offline': 0, 'locationFlagged': 0, 'compliancePercent': null},
};

Map<String, Object?> engineerReportJson() => {
  'engineer': {'id': 'eng-1', 'name': 'Arun Kumar', 'employeeCode': 'ENG-001', 'isActive': true},
  'sites': 2,
  'engineerUpdates': 6,
  'issues': {'reported': 3, 'resolved': 2},
  'reviews': {'photos': 40, 'reviewed': 38, 'reviewRatePercent': 95, 'averageMinutes': 42},
};

Map<String, Object?> paymentReportJson() => {
  'totals': {
    'received': '350000.00',
    'count': 2,
    'byMethod': {'UPI': '250000.00', 'CASH': '100000.00'},
  },
  'sites': [
    {
      'site': {'id': 'site-1', 'code': 'SITE-001', 'name': 'ABC Apartment Project'},
      'client': {'id': 'client-1', 'name': 'Mr. Rajesh'},
      'receivedInRange': '350000.00',
      'contract': '2500000.00',
      'receivedToDate': '1000000.00',
      'pending': '1500000.00',
      'overdue': '300000.00',
    },
  ],
  'payments': [
    {
      'id': 'pay-1',
      'paidOn': '2026-10-01',
      'amount': '250000.00',
      'method': 'UPI',
      'reference': 'UTR123',
      'site': {'id': 'site-1', 'name': 'ABC Apartment Project'},
      'client': {'id': 'client-1', 'name': 'Mr. Rajesh'},
    },
  ],
};

FakeApi reportsApi(FakeApi base) => base
  ..on(
    'GET',
    '/reports/sites',
    (r) => r.query['format'] == 'csv' ? csv('Site ID,Site\r\nSITE-001,ABC\r\n') : [siteReportJson()],
  )
  ..on('GET', '/reports/staff', (_) => [staffReportJson()])
  ..on('GET', '/reports/engineers', (_) => [engineerReportJson()])
  ..on('GET', '/reports/payments', (_) => paymentReportJson());

FakeRaw csv(String body) => FakeRaw('\uFEFF$body', contentType: 'text/csv; charset=utf-8');

class FakeFileSharer implements FileSharer {
  final shared = <({String name, List<int> bytes, String mimeType})>[];

  @override
  Future<void> share({
    required String name,
    required List<int> bytes,
    required String mimeType,
    String? subject,
  }) async => shared.add((name: name, bytes: bytes, mimeType: mimeType));
}

Future<void> tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<({FakeApi api, FakeFileSharer sharer})> openAdminReports(WidgetTester tester) async {
  final api = reportsApi(adminApi());
  final sharer = FakeFileSharer();
  await pumpSiteWorkApp(
    tester,
    auth: signedInAdmin(),
    api: api,
    overrides: [fileSharerProvider.overrideWithValue(sharer)],
    screenSize: const Size(1080, 6000),
  );
  await tap(tester, find.text('Reports'));
  return (api: api, sharer: sharer);
}

void main() {
  group('reportRangeFor', () {
    final saturday = DateTime(2026, 10, 10, 18, 30);

    test('covers this week from Monday, this month, and all of last month', () {
      expect(reportRangeFor(ReportPeriod.thisWeek, saturday), (from: '2026-10-05', to: '2026-10-10'));
      expect(reportRangeFor(ReportPeriod.thisMonth, saturday), (from: '2026-10-01', to: '2026-10-10'));
      expect(reportRangeFor(ReportPeriod.lastMonth, saturday), (from: '2026-09-01', to: '2026-09-30'));
    });

    test('crosses the year in January and handles Monday itself', () {
      expect(reportRangeFor(ReportPeriod.lastMonth, DateTime(2027, 1, 4)), (from: '2026-12-01', to: '2026-12-31'));
      expect(reportRangeFor(ReportPeriod.thisWeek, DateTime(2027, 1, 4)), (from: '2027-01-04', to: '2027-01-04'));
    });
  });

  testWidgets('admin sees the site report for this month, with money', (tester) async {
    final (:api, sharer: _) = await openAdminReports(tester);

    expect(find.widgetWithText(ChoiceChip, 'Engineers'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'Payments'), findsOneWidget);
    expect(find.text('ABC Apartment Project'), findsWidgets);
    expect(find.text('75% sent'), findsOneWidget);
    expect(find.text('Received in these dates'), findsOneWidget);
    expect(find.text('₹2,50,000'), findsOneWidget);

    final month = reportRangeFor(ReportPeriod.thisMonth, DateTime.now());
    final request = api.sent('GET', '/reports/sites').last;
    expect(request.query, {'from': month.from, 'to': month.to});
  });

  testWidgets('switching period, site and kind asks the server again', (tester) async {
    final (:api, sharer: _) = await openAdminReports(tester);

    await tap(tester, find.widgetWithText(ChoiceChip, 'Last month'));
    final last = reportRangeFor(ReportPeriod.lastMonth, DateTime.now());
    expect(api.sent('GET', '/reports/sites').last.query, {'from': last.from, 'to': last.to});

    await tap(tester, find.text('All sites'));
    await tap(tester, find.text('Green Villa').last);
    expect(api.sent('GET', '/reports/sites').last.query['siteId'], 'site-2');

    await tap(tester, find.widgetWithText(ChoiceChip, 'Staff'));
    expect(api.sent('GET', '/reports/staff').last.query['siteId'], 'site-2');
    expect(find.text('Ravi'), findsOneWidget);
    expect(find.text('EMP-101 · Mason · ABC Apartment Project'), findsOneWidget);
    expect(find.text('Nothing due'), findsOneWidget);

    await tap(tester, find.widgetWithText(ChoiceChip, 'Engineers'));
    expect(find.text('Site'), findsNothing, reason: 'the engineer report has no site filter');
    expect(api.sent('GET', '/reports/engineers').last.query.containsKey('siteId'), isFalse);
    expect(find.text('95%'), findsOneWidget);
    expect(find.text('42'), findsOneWidget);

    await tap(tester, find.widgetWithText(ChoiceChip, 'Payments'));
    expect(find.text('₹3,50,000'), findsWidgets);
    expect(find.text('2 payments'), findsOneWidget);
    expect(find.text('UPI'), findsOneWidget);
    expect(find.text('₹3,00,000'), findsOneWidget);
    expect(find.text('1 Oct 2026 · UPI · ABC Apartment Project · UTR123'), findsOneWidget);
  });

  testWidgets('exports the report as CSV through the share sheet', (tester) async {
    final (:api, :sharer) = await openAdminReports(tester);

    await tap(tester, find.byTooltip('Export CSV'));

    final month = reportRangeFor(ReportPeriod.thisMonth, DateTime.now());
    expect(api.sent('GET', '/reports/sites').last.query, {'from': month.from, 'to': month.to, 'format': 'csv'});
    expect(sharer.shared, hasLength(1));
    expect(sharer.shared.single.name, 'sites-${month.from}-to-${month.to}.csv');
    expect(sharer.shared.single.mimeType, 'text/csv');
    final bytes = sharer.shared.single.bytes;
    expect(bytes.take(3), [0xEF, 0xBB, 0xBF], reason: 'a BOM, so spreadsheet apps read UTF-8');
    expect(utf8.decode(bytes.skip(3).toList()), 'Site ID,Site\r\nSITE-001,ABC\r\n');
  });

  testWidgets('shows the server message when a report fails', (tester) async {
    final (:api, sharer: _) = await openAdminReports(tester);
    api.on(
      'GET',
      '/reports/staff',
      (_) => throw const FakeApiError(400, 'VALIDATION_FAILED', 'Choose at most 366 days.'),
    );

    await tap(tester, find.widgetWithText(ChoiceChip, 'Staff'));
    expect(find.text('Choose at most 366 days.'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('engineers get site and staff reports only, without money', (tester) async {
    final api =
        reportsApi(
            FakeApi()
              ..on('GET', '/dashboard/engineer', (_) => engineerDashboardJson())
              ..on('GET', '/sites', (_) => FakePage([siteSummaryJson()])),
          )
          // Later answers win: engineers get no money.
          ..on('GET', '/reports/sites', (_) => [siteReportJson(received: null)]);
    await pumpSiteWorkApp(tester, auth: signedInEngineer(), api: api, screenSize: const Size(1080, 6000));
    unawaited(GoRouter.of(tester.element(find.byType(NavigationBar))).push('/engineer/reports'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ChoiceChip, 'Sites'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'Staff'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'Engineers'), findsNothing);
    expect(find.widgetWithText(ChoiceChip, 'Payments'), findsNothing);
    expect(find.text('75% sent'), findsOneWidget);
    expect(find.text('Received in these dates'), findsNothing);
  });
}
