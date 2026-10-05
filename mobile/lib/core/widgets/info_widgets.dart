import 'package:material_ui/material_ui.dart';

import '../theme/app_spacing.dart';
import '../theme/status_colors.dart';

/// A number with a label, e.g. "Active sites 12".
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.tone = StatusTone.info,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final StatusTone tone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.tone(tone);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(color: colors.background, shape: BoxShape.circle),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Icon(icon, size: 20, color: colors.foreground),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// Icon, label and value: used on detail screens.
class DetailRow extends StatelessWidget {
  const DetailRow({super.key, required this.icon, required this.label, required this.value, this.onTap, this.trailing});

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onTap,
      leading: Icon(icon),
      title: Text(label, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      subtitle: Text(value, style: theme.textTheme.bodyLarge),
      trailing: trailing,
    );
  }
}

/// A labelled amount with a coloured accent, e.g. "Received ₹24,50,000".
class AmountTile extends StatelessWidget {
  const AmountTile({super.key, required this.label, required this.amount, required this.tone, this.caption});

  final String label;
  final String amount;
  final StatusTone tone;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.tone(tone);
    return Row(
      children: [
        Container(
          width: 4,
          height: 36,
          decoration: BoxDecoration(color: colors.foreground, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              if (caption != null) Text(caption!, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
        Text(amount, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }
}
