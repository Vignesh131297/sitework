import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_spacing.dart';

/// Shown for the moment it takes to read the saved session.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(color: scheme.primary, borderRadius: BorderRadius.circular(AppRadius.lg)),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Icon(Icons.construction, size: 40, color: scheme.onPrimary),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 3)),
          ],
        ),
      ),
    );
  }
}
