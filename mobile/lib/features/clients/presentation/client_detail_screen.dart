import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/launch.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/info_widgets.dart';
import '../../../core/widgets/status_chip.dart';
import '../../payments/data/payments_repository.dart';
import '../../payments/presentation/payment_widgets.dart';
import '../data/clients_repository.dart';
import '../domain/client_models.dart';

class ClientDetailScreen extends ConsumerWidget {
  const ClientDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final client = ref.watch(clientDetailProvider(id));
    return Scaffold(
      appBar: AppBar(
        title: Text(client.value?.name ?? ''),
        actions: [
          IconButton(
            tooltip: l10n.clientEdit,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push(AppRoutes.adminClientEdit(id)),
          ),
        ],
      ),
      body: AsyncValueView(
        value: client,
        onRetry: () => ref.invalidate(clientDetailProvider(id)),
        data: (client) => RefreshIndicator(
          onRefresh: () => ref.refresh(clientDetailProvider(id).future),
          child: _ClientBody(client: client),
        ),
      ),
    );
  }
}

class _ClientBody extends ConsumerWidget {
  const _ClientBody({required this.client});

  final ClientDetail client;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final payments = ref.watch(clientPaymentsProvider(client.id));
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      children: [
        if (client.company != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 0),
            child: Text(client.company!, style: theme.textTheme.titleMedium),
          ),
        DetailRow(
          icon: Icons.phone_outlined,
          label: l10n.fieldPhone,
          value: client.phone,
          trailing: IconButton(
            tooltip: l10n.commonCall,
            icon: const Icon(Icons.call_outlined),
            onPressed: () => callPhone(client.phone),
          ),
        ),
        if (client.email != null) DetailRow(icon: Icons.email_outlined, label: l10n.fieldEmail, value: client.email!),
        if (client.address != null)
          DetailRow(icon: Icons.place_outlined, label: l10n.fieldAddress, value: client.address!),
        if (client.notes != null) DetailRow(icon: Icons.notes_outlined, label: l10n.fieldNotes, value: client.notes!),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: SectionHeader(l10n.clientSites),
        ),
        if (client.sites.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(l10n.clientNoSites, style: theme.textTheme.bodyMedium),
          ),
        for (final site in client.sites)
          ListTile(
            leading: const Icon(Icons.apartment_outlined),
            title: Text(site.name),
            subtitle: Text('${site.code} · ${formatInr(site.contractAmount)}'),
            trailing: StatusChip(label: site.status.label(l10n), tone: site.status.tone),
            onTap: () => context.push(AppRoutes.adminSite(site.id)),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: SectionHeader(
            l10n.paymentsReceivedTitle,
            trailing: TextButton(
              onPressed: () => context.push('${AppRoutes.adminPaymentsAll}?clientId=${client.id}'),
              child: Text(l10n.paymentsAll),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: AsyncValueView(
            value: payments,
            onRetry: () => ref.invalidate(clientPaymentsProvider(client.id)),
            data: (payments) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (payments.isEmpty) Text(l10n.paymentsEmpty),
                for (final payment in payments)
                  PaymentTile(payment: payment, onTap: () => showPaymentSheet(context, payment)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
