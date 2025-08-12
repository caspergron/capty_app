import 'package:flutter/material.dart';

import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/themes/colors.dart';

class AnimationBox extends StatelessWidget {
  final Widget animation;
  const AnimationBox({required this.animation});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54.width,
      height: 54.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: white.colorOpacity(0.15), shape: BoxShape.circle),
      child: Container(
        width: 41.width,
        height: 41.width,
        child: animation,
        alignment: Alignment.center,
        decoration: const BoxDecoration(color: white, shape: BoxShape.circle),
      ),
    );
  }
}
