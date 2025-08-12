import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

class LottieAnimation extends StatelessWidget {
  final double? width;
  final double? height;
  final String animPath;
  final bool animate;
  final bool backgroundLoad;
  final bool repeat;
  final bool reverse;
  final BoxFit fit;

  const LottieAnimation({
    required this.animPath,
    this.height,
    this.width,
    this.reverse = false,
    this.animate = true,
    this.backgroundLoad = false,
    this.repeat = true,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      animPath,
      width: width,
      height: height,
      animate: animate,
      repeat: repeat,
      reverse: reverse,
      fit: fit,
      backgroundLoading: backgroundLoad,
    );
  }
}
