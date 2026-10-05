import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/enums.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/status_chip.dart';
import '../domain/staff_update_models.dart';

/// One of today's three updates: its window, its state, and the action.
class SlotTile extends StatelessWidget {
  const SlotTile({
    super.key,
    required this.slot,
    required this.needsCheckIn,
    required this.savedOnPhone,
    required this.onTakePhoto,
  });

  final DaySlot slot;

  /// Open, but the rules want a check-in first.
  final bool needsCheckIn;

  /// An update for this slot is saved on the phone, waiting to be sent.
  final bool savedOnPhone;
  final VoidCallback onTakePhoto;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final s = slot;
    final (state, tone) = savedOnPhone ? (l10n.queueWaiting, StatusTone.info) : (s.state.label(l10n), s.state.tone);
    final open = s.state == SlotState.pending && !savedOnPhone;

    final String? note = switch (s.state) {
      _ when savedOnPhone => l10n.slotSavedOnPhone,
      SlotState.submitted => [
        l10n.slotSentAt(formatTime(s.update!.submittedAt)),
        if (s.update!.submittedOffline) l10n.slotSentOffline,
      ].join(' · '),
      SlotState.upcoming => l10n.slotOpensAt(formatTime(s.start)),
      SlotState.pending when needsCheckIn => l10n.slotCheckInFirst,
      SlotState.pending => l10n.slotDueBy(formatTime(s.end)),
      SlotState.missing || SlotState.notExpected => null,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_icon, color: context.tone(tone).foreground),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.slot.label(l10n), style: theme.textTheme.titleMedium),
                      Text(l10n.slotWindow(formatTime(s.start), formatTime(s.end)), style: muted),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: StatusChip(label: state, tone: tone),
                ),
              ],
            ),
            if (note != null) ...[const SizedBox(height: AppSpacing.sm), Text(note, style: muted)],
            if (open) ...[
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: needsCheckIn ? null : onTakePhoto,
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: Text(l10n.slotTakePhoto),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData get _icon => switch (slot.slot) {
    TimeSlot.morning => Icons.wb_twilight_outlined,
    TimeSlot.afternoon => Icons.wb_sunny_outlined,
    TimeSlot.evening => Icons.nights_stay_outlined,
  };
}
