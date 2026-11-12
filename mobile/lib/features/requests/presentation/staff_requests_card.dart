import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/models/enums.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';

/// Staff "Home": ask for leave, money, food or material in one tap, or see
/// what they asked for.
class StaffRequestsCard extends StatelessWidget {
  const StaffRequestsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    const area = AppRoutes.staffArea;
    Widget action(IconData icon, String label, String path) => Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(path),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.secondaryContainer,
                foregroundColor: theme.colorScheme.onSecondaryContainer,
                child: Icon(icon),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(label, textAlign: TextAlign.center, style: theme.textTheme.labelMedium),
            ],
          ),
        ),
      ),
    );

    return Card(
      margin: const EdgeInsets.only(top: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.sm, AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.requestsMyTitle,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton(onPressed: () => context.push(AppRoutes.myRequests(area)), child: Text(l10n.requestsSeeAll)),
              ],
            ),
            Row(
              children: [
                action(Icons.event_busy_outlined, l10n.requestKindLeave, AppRoutes.leaveNew(area)),
                action(
                  Icons.currency_rupee,
                  l10n.requestKindMoney,
                  AppRoutes.staffRequestNew(area, StaffRequestKind.money),
                ),
                action(
                  Icons.restaurant_outlined,
                  l10n.requestKindFood,
                  AppRoutes.staffRequestNew(area, StaffRequestKind.food),
                ),
                action(Icons.add_shopping_cart, l10n.requestKindMaterial, AppRoutes.requestNew(area)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
