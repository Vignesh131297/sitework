import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/status_chip.dart';
import '../domain/site_models.dart';

class SiteCard extends StatelessWidget {
  const SiteCard({super.key, required this.site, required this.onTap});

  final SiteSummary site;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant);
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(site.name, style: theme.textTheme.titleMedium),
                        Text('${site.code} · ${site.client.name}', style: muted),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  StatusChip(label: site.status.label(l10n), tone: site.status.tone),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(value: site.progressPercent / 100, minHeight: 6),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text('${site.progressPercent}%', style: theme.textTheme.labelLarge),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                [
                  if (site.engineers.isEmpty) l10n.siteNoEngineer else site.engineers.map((e) => e.name).join(', '),
                  l10n.staffCount(site.staffCount),
                ].join(' · '),
                style: muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
