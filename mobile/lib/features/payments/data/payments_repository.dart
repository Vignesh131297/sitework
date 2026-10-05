import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/revision.dart';
import '../../../core/models/enums.dart';
import '../../../core/network/api_client.dart';
import '../domain/payment_models.dart';

/// Admin money endpoints. Amounts travel as strings ("250000.00"); every total
/// is computed by the server.
class PaymentsRepository {
  PaymentsRepository(this._api);

  final ApiClient _api;

  Future<PaymentsSummary> summary() =>
      _api.get('/payments/summary', decode: (data) => PaymentsSummary.fromJson(data! as Map<String, dynamic>));

  Future<PageResult<Payment>> list({
    required int page,
    String? siteId,
    String? clientId,
    PaymentMethod? method,
    bool includeVoided = false,
    int limit = 20,
  }) => _api.getPage(
    '/payments',
    query: {
      'page': page,
      'limit': limit,
      'siteId': siteId,
      'clientId': clientId,
      'method': method?.apiValue,
      'includeVoided': includeVoided ? 'true' : null,
    },
    item: Payment.fromJson,
  );

  Future<SiteMoney> siteMoney(String siteId) => _api.get('/sites/$siteId/money', decode: _money);

  Future<Payment> record(
    String siteId, {
    required String amount,
    required String paidOn,
    required PaymentMethod method,
    String? reference,
    String? remarks,
  }) => _api.post(
    '/sites/$siteId/payments',
    body: {'amount': amount, 'paidOn': paidOn, 'method': method.apiValue, 'reference': ?reference, 'remarks': ?remarks},
    decode: _payment,
  );

  Future<Payment> voidPayment(String id, String reason) =>
      _api.post('/payments/$id/void', body: {'reason': reason}, decode: _payment);

  Future<SiteMoney> addMilestone(
    String siteId, {
    required String title,
    required String amount,
    required String dueDate,
    String? notes,
  }) => _api.post(
    '/sites/$siteId/milestones',
    body: {'title': title, 'amount': amount, 'dueDate': dueDate, 'notes': ?notes},
    decode: _money,
  );

  Future<SiteMoney> updateMilestone(String id, {String? title, String? amount, String? dueDate, String? notes}) =>
      _api.patch(
        '/milestones/$id',
        body: {'title': ?title, 'amount': ?amount, 'dueDate': ?dueDate, 'notes': notes},
        decode: _money,
      );

  Future<SiteMoney> deleteMilestone(String id) => _api.delete('/milestones/$id', decode: _money);

  static Payment _payment(Object? data) => Payment.fromJson(data! as Map<String, dynamic>);
  static SiteMoney _money(Object? data) => SiteMoney.fromJson(data! as Map<String, dynamic>);
}

final paymentsRepositoryProvider = Provider<PaymentsRepository>(
  (ref) => PaymentsRepository(ref.watch(apiClientProvider)),
);

final paymentsSummaryProvider = FutureProvider.autoDispose<PaymentsSummary>((ref) {
  ref.watch(revisionProvider(DataSet.payments));
  ref.watch(revisionProvider(DataSet.sites));
  return ref.watch(paymentsRepositoryProvider).summary();
});

/// A site's recent payments, voided ones included (marked), for its Payments tab.
final sitePaymentsProvider = FutureProvider.autoDispose.family<List<Payment>, String>((ref, siteId) async {
  ref.watch(revisionProvider(DataSet.payments));
  return (await ref.watch(paymentsRepositoryProvider).list(page: 1, limit: 50, siteId: siteId, includeVoided: true))
      .items;
});

/// A client's recent payments across their sites.
final clientPaymentsProvider = FutureProvider.autoDispose.family<List<Payment>, String>((ref, clientId) async {
  ref.watch(revisionProvider(DataSet.payments));
  return (await ref.watch(paymentsRepositoryProvider).list(page: 1, limit: 20, clientId: clientId)).items;
});
