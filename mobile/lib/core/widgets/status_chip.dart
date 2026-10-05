import 'package:material_ui/material_ui.dart';

import '../theme/app_spacing.dart';
import '../theme/status_colors.dart';

/// Compact coloured label for a status, e.g. "Submitted" or "Overdue".
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.label, required this.tone, this.icon});

  final String label;
  final StatusTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.tone(tone);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs + 2),
      decoration: BoxDecoration(color: colors.background, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 16, color: colors.foreground), const SizedBox(width: AppSpacing.xs)],
          // Wraps rather than overflowing with large accessibility font sizes.
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(color: colors.foreground, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
