import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/data/revision.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/models/enums.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/info_widgets.dart';
import '../../../core/widgets/paged_list_view.dart';
import '../../../core/widgets/profile_action.dart';
import '../../../core/widgets/status_chip.dart';
import '../../dashboard/domain/admin_dashboard.dart';
import '../data/payments_repository.dart';
import '../domain/payment_models.dart';
import 'payment_widgets.dart';

/// Admin "Payments": totals, then every site with what is received, pending
/// and late, most urgent first.
class PaymentsScreen extends ConsumerWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navPayments), actions: const [ProfileAction()]),
      body: AsyncValueView(
        value: ref.watch(paymentsSummaryProvider),
        onRetry: () => ref.invalidate(paymentsSummaryProvider),
        data: (summary) => RefreshIndicator(
          onRefresh: () => ref.refresh(paymentsSummaryProvider.future),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xxl),
            children: [
              _TotalsCard(totals: summary.totals),
              const SizedBox(height: AppSpacing.md),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.receipt_long_outlined),
                  title: Text(l10n.paymentsAll),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.adminPaymentsAll),
                ),
              ),
              SectionHeader(l10n.paymentsBySite),
              if (summary.sites.isEmpty) EmptyState(icon: Icons.apartment_outlined, title: l10n.paymentsNoSites),
              for (final row in summary.sites) _SiteMoneyTile(row: row),
            ],
          ),
        ),
      ),
    );
  }
}

class _TotalsCard extends StatelessWidget {
  const _TotalsCard({required this.totals});

  final MoneyTotals totals;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = totals;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            AmountTile(label: l10n.paymentsContract, amount: formatInr(t.contract), tone: StatusTone.neutral),
            const SizedBox(height: AppSpacing.md),
            AmountTile(label: l10n.paymentsReceived, amount: formatInr(t.received), tone: StatusTone.success),
            const SizedBox(height: AppSpacing.md),
            AmountTile(label: l10n.paymentsPending, amount: formatInr(t.pending), tone: StatusTone.warning),
            const SizedBox(height: AppSpacing.md),
            AmountTile(
              label: l10n.paymentsOverdue,
              amount: formatInr(t.overdue),
              tone: StatusTone.danger,
              caption: t.overdueCount > 0 ? l10n.paymentsOverdueCount(t.overdueCount) : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _SiteMoneyTile extends StatelessWidget {
  const _SiteMoneyTile({required this.row});

  final SiteMoneyRow row;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final f = row.financials;
    final contract = double.parse(f.contract);
    final received = double.parse(f.received);
    final next = row.nextDue;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.site(AppRoutes.adminArea, row.site.id, tab: 'payments')),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(row.site.name, style: theme.textTheme.titleMedium),
                        Text('${row.site.code} · ${row.client.name}', style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  if (f.overdueCount > 0)
                    Flexible(
                      child: StatusChip(
                        label: '${l10n.paymentsOverdue} ${formatInr(f.overdue)}',
                        tone: StatusTone.danger,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(l10n.paymentsReceivedOf(formatInr(f.received), formatInr(f.contract))),
              const SizedBox(height: AppSpacing.xs),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(value: contract == 0 ? 0 : received / contract, minHeight: 6),
              ),
              if (next != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.paymentsNextDue(next.title, formatInr(next.outstanding), formatDate(next.dueDate)),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: next.status == MilestoneStatus.overdue
                        ? theme.colorScheme.error
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Every payment, newest first; voided ones on request.
class AllPaymentsScreen extends ConsumerStatefulWidget {
  const AllPaymentsScreen({super.key, this.clientId});

  final String? clientId;

  @override
  ConsumerState<AllPaymentsScreen> createState() => _AllPaymentsScreenState();
}

class _AllPaymentsScreenState extends ConsumerState<AllPaymentsScreen> {
  var _includeVoided = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final revision = ref.watch(revisionProvider(DataSet.payments));
    final repository = ref.watch(paymentsRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.paymentsAll),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: FilterChip(
              label: Text(l10n.paymentsShowVoided),
              selected: _includeVoided,
              onSelected: (on) => setState(() => _includeVoided = on),
            ),
          ),
        ],
      ),
      body: PagedListView<Payment>(
        key: ValueKey('payments-$revision-$_includeVoided-${widget.clientId}'),
        fetch: (page) => repository.list(page: page, clientId: widget.clientId, includeVoided: _includeVoided),
        itemBuilder: (context, payment) =>
            PaymentTile(payment: payment, onTap: () => showPaymentSheet(context, payment)),
        empty: EmptyList(icon: Icons.receipt_long_outlined, message: l10n.paymentsEmpty),
      ),
    );
  }
}
