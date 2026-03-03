import 'package:flutter/material.dart';
import 'package:vibemental_app/core/config/layout_config.dart';

class PageContentContainer extends StatelessWidget {
  const PageContentContainer({required this.child, super.key});

  final Widget child;

  @override
  /// Purpose: Keep long-form page content readable on wide web viewports.
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: LayoutConfig.readableContentMaxWidth,
        ),
        child: child,
      ),
    );
  }
}
