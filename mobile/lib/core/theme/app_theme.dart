import 'package:material_ui/material_ui.dart';

import 'app_spacing.dart';
import 'status_colors.dart';

/// Brand colours: a deep navy for trust and a safety orange accent.
abstract final class AppColors {
  static const navy = Color(0xFF1F3A5F);
  static const safetyOrange = Color(0xFFE8770E);
  static const safetyOrangeLight = Color(0xFFFFB77C);
}

abstract final class AppTheme {
  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final scheme = ColorScheme.fromSeed(seedColor: AppColors.navy, brightness: brightness).copyWith(
      primary: isLight ? AppColors.navy : null,
      tertiary: isLight ? AppColors.safetyOrange : AppColors.safetyOrangeLight,
    );
    final base = ThemeData(colorScheme: scheme, useMaterial3: true);
    final text = base.textTheme;
    final buttonShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md));
    const buttonSize = Size(64, kLargeTouchTarget);
    final buttonText = text.titleMedium?.copyWith(fontWeight: FontWeight.w600);

    return base.copyWith(
      extensions: [isLight ? StatusColors.light : StatusColors.dark],
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarThemeData(
        centerTitle: false,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        scrolledUnderElevation: 1,
        titleTextStyle: text.titleLarge?.copyWith(color: scheme.onSurface, fontWeight: FontWeight.w600),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(minimumSize: buttonSize, shape: buttonShape, textStyle: buttonText),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(minimumSize: buttonSize, shape: buttonShape, textStyle: buttonText),
      ),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(minimumSize: const Size(48, 48))),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: scheme.secondaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        minVerticalPadding: AppSpacing.md,
      ),
    );
  }
}
