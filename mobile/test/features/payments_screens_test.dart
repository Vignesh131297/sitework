import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sitework/core/models/enums.dart';

import '../helpers/admin_fixtures.dart';
import '../helpers/fake_api.dart';
import '../helpers/pump_app.dart';

Map<String, Object?> moneyTotals({String overdue = '300000.00', int overdueCount = 1}) => {
  'contract': '2500000.00',
  'received': '1000000.00',
  'pending': '1500000.00',
  'overdue': overdue,
  'overdueCount': overdueCount,
};

Map<String, Object?> paymentJson({String id = 'pay-1', bool voided = false}) => {
  'id': id,
  'amount': '250000.00',
  'paidOn': '2026-10-01',
  'method': 'UPI',
  'reference': 'UTR123',
  'remarks': null,
  'site': {'id': 'site-1', 'code': 'SITE-001', 'name': 'ABC Apartment Project'},
  'client': {'id': 'client-1', 'name': 'Mr. Rajesh'},
  'recordedBy': {'id': 'admin-1', 'name': 'Admin User'},
  'createdAt': '2026-10-01T06:00:00.000Z',
  'voidedAt': voided ? '2026-10-02T06:00:00.000Z' : null,
  'voidedBy': voided ? {'id': 'admin-1', 'name': 'Admin User'} : null,
  'voidReason': voided ? 'Entered twice' : null,
};

Map<String, Object?> siteMoneyJson() => {
  'site': {'id': 'site-1', 'code': 'SITE-001', 'name': 'ABC Apartment Project', 'status': 'IN_PROGRESS'},
  'client': {'id': 'client-1', 'name': 'Mr. Rajesh'},
  'financials': siteDetailJson()['financials'],
};

FakeApi paymentsApi() {
  var voided = false;
  return adminApi()
    ..on(
      'GET',
      '/payments/summary',
      (_) => {
        'totals': moneyTotals(),
        'sites': [
          {
            'site': {'id': 'site-1', 'code': 'SITE-001', 'name': 'ABC Apartment Project', 'status': 'IN_PROGRESS'},
            'client': {'id': 'client-1', 'name': 'Mr. Rajesh'},
            'financials': moneyTotals(),
            'nextDue':
                ((siteDetailJson()['financials']! as Map<String, Object?>)['milestones']! as List<Object?>).first,
          },
          {
            'site': {'id': 'site-2', 'code': 'SITE-002', 'name': 'Green Villa', 'status': 'IN_PROGRESS'},
            'client': {'id': 'client-2', 'name': 'Mrs. Priya'},
            'financials': moneyTotals(overdue: '0.00', overdueCount: 0),
            'nextDue': null,
          },
        ],
      },
    )
    ..on('GET', '/payments', (_) => FakePage([paymentJson(voided: voided)]))
    ..on('POST', '/sites/:id/payments', (_) => paymentJson(id: 'pay-2'))
    ..on('POST', '/sites/:id/milestones', (_) => siteMoneyJson())
    ..on('POST', '/payments/:id/void', (_) {
      voided = true;
      return paymentJson(voided: true);
    });
}

Future<FakeApi> openSitePayments(WidgetTester tester, {FakeApi? api}) async {
  final fake = api ?? paymentsApi();
  await pumpSiteWorkApp(tester, auth: signedInAdmin(), api: fake, screenSize: const Size(1080, 6000));
  unawaited(GoRouter.of(tester.element(find.byType(NavigationBar))).push('/admin/sites/site-1?tab=payments'));
  await tester.pumpAndSettle();
  return fake;
}

Future<void> tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the Payments tab shows totals and each site, most overdue first', (tester) async {
    await pumpSiteWorkApp(tester, auth: signedInAdmin(), api: paymentsApi(), screenSize: const Size(1080, 6000));
    await tap(tester, find.descendant(of: find.byType(NavigationBar), matching: find.text('Payments')));

    expect(find.text('₹25,00,000'), findsOneWidget);
    expect(find.text('Overdue ₹3,00,000'), findsOneWidget);
    expect(find.textContaining('Next: Foundation · ₹3,00,000 due 30 Sep 2026'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('ABC Apartment Project')).dy,
      lessThan(tester.getTopLeft(find.text('Green Villa')).dy),
    );

    await tap(tester, find.text('All payments'));
    expect(find.text('₹2,50,000'), findsOneWidget);
    expect(find.text('UPI · 1 Oct 2026 · UTR123\nABC Apartment Project · Mr. Rajesh'), findsOneWidget);
  });

  testWidgets('a payment is recorded with the details the server needs', (tester) async {
    final api = await openSitePayments(tester);
    expect(find.text('Foundation'), findsOneWidget);
    expect(find.text('Payments received'), findsOneWidget);

    await tap(tester, find.widgetWithText(FilledButton, 'Record payment'));
    await tester.enterText(find.widgetWithText(TextFormField, 'Amount'), '150000');
    await tester.enterText(find.widgetWithText(TextFormField, 'Reference (cheque or UTR no.)'), 'CHQ 000123');
    await tap(tester, find.byType(DropdownButtonFormField<PaymentMethod>));
    await tap(tester, find.text('Cheque').last);
    await tap(tester, find.widgetWithText(FilledButton, 'Record payment'));

    final body = api.sent('POST', '/sites/site-1/payments').single.json;
    expect(body, containsPair('amount', '150000'));
    expect(body, containsPair('method', 'CHEQUE'));
    expect(body, containsPair('reference', 'CHQ 000123'));
    expect(body['paidOn'], matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
    expect(body.containsKey('remarks'), isFalse);
    expect(find.text('Payment recorded.'), findsOneWidget);
  });

  testWidgets('a payment above the contract is refused and explained', (tester) async {
    final api = paymentsApi()
      ..on(
        'POST',
        '/sites/:id/payments',
        (_) => throw const FakeApiError(
          400,
          'PAYMENT_EXCEEDS_CONTRACT',
          'This is more than the ₹15,00,000 left on the contract.',
        ),
      );
    await openSitePayments(tester, api: api);
    await tap(tester, find.widgetWithText(FilledButton, 'Record payment'));
    await tester.enterText(find.widgetWithText(TextFormField, 'Amount'), '9900000');
    await tap(tester, find.widgetWithText(FilledButton, 'Record payment'));

    expect(find.text('This is more than the ₹15,00,000 left on the contract.'), findsOneWidget);
  });

  testWidgets('milestones are added from the schedule', (tester) async {
    final api = await openSitePayments(tester);
    await tap(tester, find.text('Add milestone'));
    await tester.enterText(find.widgetWithText(TextFormField, 'Title'), 'Roof slab');
    await tester.enterText(find.widgetWithText(TextFormField, 'Amount'), '400000');
    await tap(tester, find.text('Due date'));
    await tap(tester, find.text('OK'));
    await tap(tester, find.widgetWithText(FilledButton, 'Save'));

    final body = api.sent('POST', '/sites/site-1/milestones').single.json;
    expect(body, containsPair('title', 'Roof slab'));
    expect(body, containsPair('amount', '400000'));
    expect(find.text('Milestone saved.'), findsOneWidget);
  });

  testWidgets('a payment is voided with a reason, never deleted', (tester) async {
    final api = await openSitePayments(tester);
    await tap(tester, find.text('₹2,50,000'));
    await tap(tester, find.widgetWithText(OutlinedButton, 'Void payment'));
    await tester.enterText(find.widgetWithText(TextFormField, 'Reason'), 'Entered twice');
    await tap(tester, find.widgetWithText(FilledButton, 'Void payment'));

    expect(api.sent('POST', '/payments/pay-1/void').single.json, {'reason': 'Entered twice'});
    expect(find.text('Payment voided.'), findsOneWidget);
    expect(find.text('Void'), findsOneWidget, reason: 'the list shows it voided');
  });
}
