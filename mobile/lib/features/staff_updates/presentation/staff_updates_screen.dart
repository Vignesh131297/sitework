import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state.dart';
import 'pending_updates_card.dart';
import 'staff_home_screen.dart';
import 'today_slots.dart';

/// Staff "Updates": today's three slots and anything waiting to send.
class StaffUpdatesScreen extends StatelessWidget {
  const StaffUpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navUpdates)),
      body: StaffTodayView(
        builder: (today) => [
          if (today.assignment == null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xl),
              child: EmptyState(icon: Icons.apartment_outlined, title: l10n.staffNotAssigned),
            )
          else
            TodaySlots(today: today),
          const PendingUpdatesCard(),
        ],
      ),
    );
  }
}
