import 'package:flutter/material.dart';

/// Purpose: Centralize reusable spacing values so UI layout stays consistent
/// and free from repeated magic numbers.
class AppSpacing {
  const AppSpacing._();

  static const double tiny = 2;
  static const double xxSmall = 4;
  static const double xSmall = 6;
  static const double small = 8;
  static const double smallPlus = 10;
  static const double medium = 12;
  static const double mediumPlus = 14;
  static const double large = 16;
  static const double largePlus = 18;
  static const double xLarge = 20;
  static const double xxLarge = 24;
}

/// Purpose: Centralize reusable edge insets so screens share the same spacing
/// semantics instead of redefining raw padding values locally.
class AppInsets {
  const AppInsets._();

  static const EdgeInsets screen = EdgeInsets.all(AppSpacing.xLarge);
  static const EdgeInsets screenBody = EdgeInsets.fromLTRB(
    AppSpacing.xLarge,
    AppSpacing.medium,
    AppSpacing.xLarge,
    AppSpacing.xxLarge,
  );
  static const EdgeInsets card = EdgeInsets.all(AppSpacing.largePlus);
  static const EdgeInsets section = EdgeInsets.all(AppSpacing.large);
  static const EdgeInsets inset = EdgeInsets.all(AppSpacing.mediumPlus);
  static const EdgeInsets button = EdgeInsets.symmetric(
    horizontal: AppSpacing.xLarge,
    vertical: AppSpacing.large,
  );
  static const EdgeInsets outlinedButton = EdgeInsets.symmetric(
    horizontal: AppSpacing.largePlus,
    vertical: AppSpacing.large,
  );
  static const EdgeInsets field = EdgeInsets.symmetric(
    horizontal: AppSpacing.large,
    vertical: AppSpacing.mediumPlus,
  );
  static const EdgeInsets chip = EdgeInsets.symmetric(
    horizontal: AppSpacing.medium,
    vertical: AppSpacing.small,
  );
  static const EdgeInsets compactChip = EdgeInsets.symmetric(
    horizontal: AppSpacing.smallPlus,
    vertical: AppSpacing.xSmall,
  );
  static const EdgeInsets pill = EdgeInsets.symmetric(
    horizontal: AppSpacing.smallPlus,
    vertical: AppSpacing.large,
  );
  static const EdgeInsets indicatorMargin = EdgeInsets.symmetric(
    horizontal: AppSpacing.xxSmall,
  );
  static const EdgeInsets cardMarginVertical = EdgeInsets.symmetric(
    vertical: AppSpacing.small,
  );
}

/// Purpose: Centralize animation durations so motion stays consistent and easy
/// to tune without touching individual widgets.
class AppMotion {
  const AppMotion._();

  static const Duration quick = Duration(milliseconds: 180);
  static const Duration standard = Duration(milliseconds: 240);
}
