import 'package:material_ui/material_ui.dart';

/// Semantic tones for status chips, badges and stat cards.
enum StatusTone { success, warning, danger, info, neutral }

@immutable
class ToneColors {
  const ToneColors({required this.foreground, required this.background});

  final Color foreground;
  final Color background;

  static ToneColors lerp(ToneColors a, ToneColors b, double t) => ToneColors(
    foreground: Color.lerp(a.foreground, b.foreground, t)!,
    background: Color.lerp(a.background, b.background, t)!,
  );
}

@immutable
class StatusColors extends ThemeExtension<StatusColors> {
  const StatusColors(this._tones);

  final Map<StatusTone, ToneColors> _tones;

  ToneColors of(StatusTone tone) => _tones[tone]!;

  static const light = StatusColors({
    StatusTone.success: ToneColors(foreground: Color(0xFF1B6B3A), background: Color(0xFFDDF3E4)),
    StatusTone.warning: ToneColors(foreground: Color(0xFF8A5300), background: Color(0xFFFFEBC7)),
    StatusTone.danger: ToneColors(foreground: Color(0xFFB3261E), background: Color(0xFFFADBD8)),
    StatusTone.info: ToneColors(foreground: Color(0xFF1F5B99), background: Color(0xFFDCEAF9)),
    StatusTone.neutral: ToneColors(foreground: Color(0xFF4A5560), background: Color(0xFFE7EBEF)),
  });

  static const dark = StatusColors({
    StatusTone.success: ToneColors(foreground: Color(0xFF8FD8A8), background: Color(0xFF1E3B29)),
    StatusTone.warning: ToneColors(foreground: Color(0xFFFFC66B), background: Color(0xFF4A3410)),
    StatusTone.danger: ToneColors(foreground: Color(0xFFFFB4AB), background: Color(0xFF5C1A16)),
    StatusTone.info: ToneColors(foreground: Color(0xFFA6CCF5), background: Color(0xFF1B3550)),
    StatusTone.neutral: ToneColors(foreground: Color(0xFFC3CCD5), background: Color(0xFF2C343B)),
  });

  @override
  StatusColors copyWith({Map<StatusTone, ToneColors>? tones}) => StatusColors(tones ?? _tones);

  @override
  StatusColors lerp(StatusColors? other, double t) {
    if (other == null) return this;
    return StatusColors({for (final tone in StatusTone.values) tone: ToneColors.lerp(of(tone), other.of(tone), t)});
  }
}

extension StatusColorsContext on BuildContext {
  ToneColors tone(StatusTone tone) => Theme.of(this).extension<StatusColors>()!.of(tone);
}
