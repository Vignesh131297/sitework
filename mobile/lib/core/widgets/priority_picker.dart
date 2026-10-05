import 'package:material_ui/material_ui.dart';

import '../l10n/generated/app_localizations.dart';
import '../l10n/labels.dart';
import '../models/enums.dart';
import '../theme/app_spacing.dart';

/// Low to critical as chips that wrap on narrow screens.
class PriorityPicker extends StatelessWidget {
  const PriorityPicker({super.key, required this.value, required this.onChanged});

  final Priority value;
  final ValueChanged<Priority>? onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.fieldPriority, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: [
            for (final priority in Priority.values)
              ChoiceChip(
                label: Text(priority.label(l10n)),
                selected: value == priority,
                onSelected: onChanged == null ? null : (_) => onChanged!(priority),
              ),
          ],
        ),
      ],
    );
  }
}
