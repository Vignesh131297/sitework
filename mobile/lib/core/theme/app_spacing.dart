import 'package:material_ui/material_ui.dart';

/// Spacing scale used for all padding and gaps.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  static const EdgeInsets screen = EdgeInsets.all(lg);
}

abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
}

/// Minimum height for primary actions: large enough for gloved or hurried taps.
const double kLargeTouchTarget = 52;
