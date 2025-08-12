import 'package:flutter/material.dart';

class FadingImage extends StatelessWidget {
  final int valueKey;
  final String image;
  final double? width;
  final double? height;
  final BoxFit fit;

  const FadingImage({required this.image, this.valueKey = 0, this.width, this.height, this.fit = BoxFit.contain});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(seconds: 1),
      transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
      child: Image.asset(image, width: width, height: height, fit: fit, key: ValueKey<int>(valueKey)),
    );
  }
}
