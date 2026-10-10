import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/models/enums.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/routing/area.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/status_chip.dart';
import '../domain/stock_models.dart';

/// Where a request is, in a few words: waiting for approval, to send, on the
/// way, at the site, or finished one way or another.
StatusChip requestChip(MaterialRequest request, AppLocalizations l10n) {
  final sentAny = request.lines.any((line) => num.parse(line.sent) > 0);
  return switch (request.status) {
    MaterialRequestStatus.pending => StatusChip(label: l10n.requestStagePending, tone: StatusTone.warning),
    MaterialRequestStatus.approved when request.anythingOnTheWay => StatusChip(
      label: l10n.requestStageOnTheWay,
      tone: StatusTone.warning,
    ),
    MaterialRequestStatus.approved when request.sentInFull => StatusChip(
      label: l10n.requestStageAtSite,
      tone: StatusTone.success,
    ),
    MaterialRequestStatus.approved => StatusChip(
      label: sentAny ? l10n.requestStagePartSent : l10n.requestStageToSend,
      tone: StatusTone.info,
    ),
    MaterialRequestStatus.rejected => StatusChip(label: l10n.requestStageRejected, tone: StatusTone.danger),
    MaterialRequestStatus.cancelled => StatusChip(label: l10n.requestStageWithdrawn, tone: StatusTone.neutral),
    MaterialRequestStatus.closed => StatusChip(label: l10n.requestStageClosed, tone: StatusTone.neutral),
  };
}

/// "Cement OPC 53 · 100 bag", plus how many other materials it asks for.
String requestSummary(MaterialRequest request, AppLocalizations l10n) {
  if (request.lines.isEmpty) return '';
  final first = request.lines.first;
  final text =
      '${first.material.name} · ${formatQuantity(first.approvedQuantity ?? first.quantity, first.material.unit)}';
  return request.lines.length == 1 ? text : l10n.stockAndMore(text, request.lines.length - 1);
}

/// A request in a list: its number and site, what it asks for, and where it is.
class RequestTile extends ConsumerWidget {
  const RequestTile({super.key, required this.request});

  final MaterialRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final area = ref.watch(areaPathProvider);
    final r = request;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: () => context.push(AppRoutes.request(area, r.id)),
        title: Text(
          '${r.code} · ${r.site.name}',
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(requestSummary(r, l10n)),
              Text(
                [
                  l10n.requestAskedBy(r.requestedBy.name, formatShortDate(r.createdAt.toLocal())),
                  if (r.godown case final godown?) l10n.requestFromGodown(godown.name),
                  if (r.neededBy case final date? when r.isOpen) l10n.requestNeededBy(formatDate(date)),
                ].join(' · '),
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.xs),
              requestChip(r, l10n),
            ],
          ),
        ),
      ),
    );
  }
}
