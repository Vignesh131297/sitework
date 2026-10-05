import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/info_widgets.dart';
import '../../../core/widgets/status_chip.dart';
import '../../payments/data/payments_repository.dart';
import '../../payments/presentation/milestone_sheet.dart';
import '../../payments/presentation/payment_form_screen.dart';
import '../../payments/presentation/payment_widgets.dart';
import '../domain/site_models.dart';

/// A site's money: totals for everyone allowed to see them; the payment
/// schedule and payments, with their actions, for admins. Every figure comes
/// from the server.
class SitePaymentsTab extends ConsumerWidget {
  const SitePaymentsTab({super.key, required this.site, required this.isAdmin});

  final SiteDetail site;
  final bool isAdmin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final financials = site.financials;
    if (financials == null) {
      return ListView(
        children: [EmptyState(icon: Icons.lock_outline, title: l10n.errorForbidden)],
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xxl),
      children: [
        SiteMoneyCard(financials: financials),
        if (isAdmin) ...[
          const SizedBox(height: AppSpacing.md),
          FilledButton.icon(
            onPressed: () => PaymentFormScreen.open(context, siteId: site.id, siteName: site.name),
            icon: const Icon(Icons.add_card),
            label: Text(l10n.paymentsRecord),
          ),
          SectionHeader(
            l10n.milestonesTitle,
            trailing: TextButton.icon(
              onPressed: () => showMilestoneSheet(context, siteId: site.id),
              icon: const Icon(Icons.add),
              label: Text(l10n.milestoneAdd),
            ),
          ),
          if (financials.milestones.isEmpty) Text(l10n.siteNoMilestones),
          for (final milestone in financials.milestones)
            MilestoneTile(
              milestone: milestone,
              onTap: () => showMilestoneSheet(context, siteId: site.id, milestone: milestone),
            ),
          SectionHeader(l10n.paymentsReceivedTitle),
          AsyncValueView(
            value: ref.watch(sitePaymentsProvider(site.id)),
            onRetry: () => ref.invalidate(sitePaymentsProvider(site.id)),
            data: (payments) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (payments.isEmpty) Text(l10n.paymentsEmpty),
                for (final payment in payments)
                  PaymentTile(payment: payment, showSite: false, onTap: () => showPaymentSheet(context, payment)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class SiteMoneyCard extends StatelessWidget {
  const SiteMoneyCard({super.key, required this.financials});

  final SiteFinancials financials;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final f = financials;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            AmountTile(label: l10n.paymentsContract, amount: formatInr(f.contract), tone: StatusTone.neutral),
            const SizedBox(height: AppSpacing.md),
            AmountTile(label: l10n.paymentsReceived, amount: formatInr(f.received), tone: StatusTone.success),
            const SizedBox(height: AppSpacing.md),
            AmountTile(label: l10n.paymentsPending, amount: formatInr(f.pending), tone: StatusTone.warning),
            const SizedBox(height: AppSpacing.md),
            AmountTile(
              label: l10n.paymentsOverdue,
              amount: formatInr(f.overdue),
              tone: StatusTone.danger,
              caption: f.overdueCount > 0 ? l10n.paymentsOverdueCount(f.overdueCount) : null,
            ),
          ],
        ),
      ),
    );
  }
}

class MilestoneTile extends StatelessWidget {
  const MilestoneTile({super.key, required this.milestone, this.onTap});

  final MilestoneView milestone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final m = milestone;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        title: Text(m.title),
        subtitle: Text(
          '${l10n.milestoneDue(formatDate(m.dueDate))}\n'
          '${l10n.milestonePaidOf(formatInr(m.paid), formatInr(m.amount))}',
        ),
        isThreeLine: true,
        trailing: StatusChip(label: m.status.label(l10n), tone: m.status.tone),
      ),
    );
  }
}
