import 'package:flutter/material.dart';
import 'package:sample_project/shared/utils.dart';

@immutable
class AppTheme extends ThemeExtension<AppTheme> {
  final String fontFamily;
  final MaterialColor textColor;
  final MaterialColor primary;
  final MaterialColor secondary;
  final MaterialColor accent;
  final MaterialColor success;
  final MaterialColor danger;
  final MaterialColor warning;
  final MaterialColor info;
  final MaterialColor sidebar;
  final BorderRadius cardBorderRadius;

  const AppTheme({
    required this.fontFamily,
    required this.textColor,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.success,
    required this.danger,
    required this.warning,
    required this.info,
    required this.sidebar,
    required this.cardBorderRadius,
  });

  static AppTheme of(BuildContext context) {
    return Theme.of(context).extension<AppTheme>()!;
  }

  @override
  AppTheme copyWith({
    String? fontFamily,
    MaterialColor? textColor,
    MaterialColor? primary,
    MaterialColor? secondary,
    MaterialColor? accent,
    MaterialColor? success,
    MaterialColor? danger,
    MaterialColor? warning,
    MaterialColor? info,
    MaterialColor? sidebar,
    BorderRadius? cardBorderRadius,
    Color? messageOwnerColor,
  }) {
    return AppTheme(
      fontFamily: fontFamily ?? this.fontFamily,
      textColor: textColor ?? this.textColor,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      success: success ?? this.success,
      danger: danger ?? this.danger,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      sidebar: sidebar ?? this.sidebar,
      cardBorderRadius: cardBorderRadius ?? this.cardBorderRadius,
    );
  }

  @override
  AppTheme lerp(AppTheme other, double t) {
    return AppTheme(
      fontFamily: t < 0.5 ? fontFamily : other.fontFamily,
      textColor: MaterialColorGenerator.from(Color.lerp(textColor, other.textColor, t)!),
      primary: MaterialColorGenerator.from(Color.lerp(primary, other.primary, t)!),
      secondary: MaterialColorGenerator.from(Color.lerp(secondary, other.secondary, t)!),
      accent: MaterialColorGenerator.from(Color.lerp(accent, other.accent, t)!),
      success: MaterialColorGenerator.from(Color.lerp(success, other.success, t)!),
      danger: MaterialColorGenerator.from(Color.lerp(danger, other.danger, t)!),
      warning: MaterialColorGenerator.from(Color.lerp(warning, other.warning, t)!),
      info: MaterialColorGenerator.from(Color.lerp(info, other.info, t)!),
      sidebar: MaterialColorGenerator.from(Color.lerp(sidebar, other.sidebar, t)!),
      cardBorderRadius: BorderRadius.lerp(cardBorderRadius, other.cardBorderRadius, t)!,
    );
  }
}
