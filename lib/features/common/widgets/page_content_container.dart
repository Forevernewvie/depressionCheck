import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vibemental_app/core/config/layout_config.dart';

class PageContentContainer extends StatelessWidget {
  const PageContentContainer({required this.child, super.key});

  final Widget child;

  @override
  /// Purpose: Keep long-form page content readable on wide web viewports.
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return child;
    }

    return Align(
      alignment: Alignment.topCenter,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding =
              constraints.maxWidth >= LayoutConfig.webWideBreakpoint
              ? LayoutConfig.webWideHorizontalPadding
              : LayoutConfig.webHorizontalPadding;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: LayoutConfig.webReadableContentMaxWidth,
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
