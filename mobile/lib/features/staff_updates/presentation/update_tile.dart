import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/enums.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/status_chip.dart';
import '../domain/staff_update_models.dart';

/// Where a photo is in its life, in words.
String photoStatusText(UpdateImage image, AppLocalizations l10n) => switch (image.status) {
  ImageStatus.available => l10n.photoAwaitingReview,
  ImageStatus.readyForDeletion => l10n.photoReviewed,
  ImageStatus.deleted =>
    image.deleteReason == ImageDeleteReason.expired ? l10n.photoRemovedExpired : l10n.photoRemovedReviewed,
};

/// A sent update in a list: slot, when, what, and anything worth noticing.
class UpdateTile extends StatelessWidget {
  const UpdateTile({super.key, required this.update, this.showStaff = false, this.onTap});

  final StaffUpdate update;
  final bool showStaff;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final u = update;
    final title = showStaff
        ? '${u.staff.name} · ${u.slot.label(l10n)}'
        : '${u.slot.label(l10n)} · ${formatShortDate(DateTime.parse(u.workDate))}';
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
                  Text(formatTime(u.submittedAt), style: theme.textTheme.labelLarge),
                ],
              ),
              if (showStaff) Text(u.site.name, style: theme.textTheme.bodySmall),
              const SizedBox(height: AppSpacing.xs),
              Text(u.description, maxLines: 3, overflow: TextOverflow.ellipsis),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: [
                  StatusChip(
                    label: photoStatusText(u.image, l10n),
                    tone: u.image.status == ImageStatus.available ? StatusTone.info : StatusTone.neutral,
                    icon: u.image.status == ImageStatus.deleted ? Icons.hide_image_outlined : Icons.image_outlined,
                  ),
                  if (u.location.flag != LocationFlag.ok)
                    StatusChip(label: u.location.flag.label(l10n), tone: u.location.flag.tone),
                  if (u.submittedOffline) StatusChip(label: l10n.slotSentOffline, tone: StatusTone.neutral),
                  if (u.photoSource == PhotoSource.gallery)
                    StatusChip(label: l10n.photoFromGallery, tone: StatusTone.warning),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
