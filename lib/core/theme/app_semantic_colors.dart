import 'package:flutter/material.dart';

@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.warning,
    required this.danger,
    required this.emergencyBackground,
    required this.emergencyText,
  });

  final Color success;
  final Color warning;
  final Color danger;
  final Color emergencyBackground;
  final Color emergencyText;

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? warning,
    Color? danger,
    Color? emergencyBackground,
    Color? emergencyText,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      emergencyBackground: emergencyBackground ?? this.emergencyBackground,
      emergencyText: emergencyText ?? this.emergencyText,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) {
      return this;
    }

    return AppSemanticColors(
      success: Color.lerp(success, other.success, t) ?? success,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      danger: Color.lerp(danger, other.danger, t) ?? danger,
      emergencyBackground:
          Color.lerp(emergencyBackground, other.emergencyBackground, t) ??
          emergencyBackground,
      emergencyText:
          Color.lerp(emergencyText, other.emergencyText, t) ?? emergencyText,
    );
  }
}

extension AppSemanticColorsX on BuildContext {
  AppSemanticColors get semanticColors =>
      Theme.of(this).extension<AppSemanticColors>()!;
}
