/// Purpose: Centralize responsive layout thresholds to avoid magic numbers.
class LayoutConfig {
  LayoutConfig._();

  static const double compactScreenWidthThreshold = 360;
  static const double compactMapHeaderWidthThreshold = 300;
  static const double compactMapActionWidthThreshold = 340;
  static const double compactTextScaleThreshold = 1.2;
  static const double readableContentMaxWidth = 760;
  static const double webReadableContentMaxWidth = 860;
  static const double webAppFrameMaxWidth = 1180;
  static const double webHorizontalPadding = 16;
  static const double webWideHorizontalPadding = 28;
  static const double webWideBreakpoint = 1280;
}
