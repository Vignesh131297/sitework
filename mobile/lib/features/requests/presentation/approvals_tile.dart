import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/routing/area.dart';
import '../../../core/theme/status_colors.dart';
import '../../dashboard/presentation/dashboard_widgets.dart';
import '../data/requests_repository.dart';

/// Dashboard link to leave, money and food waiting for the admin or engineer,
/// with how many are waiting (none shown until it loads, or if it can't).
class ApprovalsTile extends ConsumerWidget {
  const ApprovalsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final area = ref.watch(areaPathProvider);
    final waiting = ref.watch(requestsToReviewProvider).value ?? 0;
    return CountTile(
      icon: Icons.event_note_outlined,
      tone: waiting > 0 ? StatusTone.warning : StatusTone.neutral,
      title: l10n.approvalsTitle,
      subtitle: waiting > 0 ? l10n.approvalsWaitingCount(waiting) : l10n.approvalsSubtitle,
      count: waiting > 0 ? waiting : null,
      onTap: () => context.push(AppRoutes.approvals(area)),
    );
  }
}
