import 'package:flutter/material.dart';

class AppResponsiveBody extends StatelessWidget {
  const AppResponsiveBody({
    super.key,
    required this.child,
    this.maxWidth = 760,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final BoxConstraints contentConstraints = constraints.hasBoundedHeight
            ? BoxConstraints(
                maxWidth: maxWidth,
                minHeight: constraints.maxHeight,
              )
            : BoxConstraints(
                maxWidth: maxWidth,
              );

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: contentConstraints,
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
