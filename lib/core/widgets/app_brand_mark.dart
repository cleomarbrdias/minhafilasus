import 'package:flutter/material.dart';

class AppBrandMark extends StatelessWidget {
  const AppBrandMark({
    super.key,
    this.size = 86,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    final Color secondary = const Color(0xFF4CA66A);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Icon(
            Icons.health_and_safety_rounded,
            size: size,
            color: primary,
          ),
          Positioned(
            top: size * 0.34,
            child: Icon(
              Icons.favorite_rounded,
              size: size * 0.22,
              color: const Color(0xFFE56353),
            ),
          ),
          Positioned(
            bottom: size * 0.17,
            right: size * 0.18,
            child: Icon(
              Icons.place_rounded,
              size: size * 0.16,
              color: secondary,
            ),
          ),
        ],
      ),
    );
  }
}
