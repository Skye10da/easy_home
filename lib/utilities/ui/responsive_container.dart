import 'package:flutter/material.dart';

class Height {
  static const double? wrap = null;
  static const double fullScreen = double.infinity;
}

class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({
    super.key,
    this.maxWidth = 600,
    this.height = Height.fullScreen,
    this.wrapHeight = false,
    required this.child,
  });

  /// Max breakpoint width for the responsive container
  final double maxWidth;

  /// Specify a fixed height (Full Screen by default)
  /// height can be set to Height.wrap or Height.fullScreen or a fixed value
  final double? height;

  /// Force wrap container's height around content
  final bool wrapHeight;

  /// Your content
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: getAdaptivePadding(context)),
      child: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 20,
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
            width: getWidth(context),
            height: getHeight(context),
            child: SizedBox(width: maxWidth, child: child),
          ),
        ),
      ),
    );
  }

  double? getWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth > 400) ? null : double.infinity;
  }

  double? getHeight(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth > 400)
        ? (wrapHeight ? Height.wrap : height)
        : Height.fullScreen;
  }

  double getAdaptivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenWidth > 400 && screenHeight > 400) {
      return 20;
    }
    return 0;
  }
}
