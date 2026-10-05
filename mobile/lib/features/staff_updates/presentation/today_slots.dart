import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/info_widgets.dart';
import '../../auth/presentation/session_controller.dart';
import '../data/update_queue.dart';
import '../domain/pending_update.dart';
import '../domain/staff_update_models.dart';
import 'slot_tile.dart';

/// Today's three updates, with "Take photo" on the open one.
class TodaySlots extends ConsumerWidget {
  const TodaySlots({super.key, required this.today});

  final StaffToday today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final userId = ref.watch(sessionProvider).value?.userId;
    final saved = {
      for (final item in ref.watch(updateQueueProvider).value ?? const <PendingUpdate>[])
        if (item.userId == userId && item.workDate == today.date) item.slot,
    };
    final needsCheckIn = today.rules.requireCheckIn && !today.checkedIn;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(l10n.todayUpdatesTitle),
        for (final slot in today.slots)
          SlotTile(
            slot: slot,
            needsCheckIn: needsCheckIn,
            savedOnPhone: saved.contains(slot.slot),
            onTakePhoto: () => context.push(AppRoutes.staffCapture(slot.slot)),
          ),
      ],
    );
  }
}
