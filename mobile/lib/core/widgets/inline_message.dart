import 'package:material_ui/material_ui.dart';

import '../theme/app_spacing.dart';
import '../theme/status_colors.dart';

/// A coloured message block inside a form or card (errors, warnings, info).
class InlineMessage extends StatelessWidget {
  const InlineMessage({super.key, required this.message, this.tone = StatusTone.danger, this.icon});

  final String message;
  final StatusTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.tone(tone);
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(color: colors.background, borderRadius: BorderRadius.circular(AppRadius.md)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon ?? _defaultIcon, color: colors.foreground, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(message, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.foreground)),
            ),
          ],
        ),
      ),
    );
  }

  IconData get _defaultIcon => switch (tone) {
    StatusTone.success => Icons.check_circle_outline,
    StatusTone.warning => Icons.warning_amber_outlined,
    StatusTone.danger => Icons.error_outline,
    StatusTone.info || StatusTone.neutral => Icons.info_outline,
  };
}
