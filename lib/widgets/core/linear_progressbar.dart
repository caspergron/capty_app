import 'package:flutter/material.dart';

import 'package:app/themes/colors.dart';

class LinearProgressbar extends StatelessWidget {
  final double height;
  final double total;
  final double separator;
  final Color valueColor;
  final Color background;
  final double radius;
  final int duration;

  const LinearProgressbar({
    this.height = 6,
    this.valueColor = warning,
    this.background = offWhite2,
    this.separator = 1,
    this.total = 0,
    this.radius = 4,
    this.duration = 1000,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      curve: Curves.easeIn,
      duration: Duration(milliseconds: duration),
      tween: Tween<double>(begin: 0, end: total / separator),
      builder: (context, value, _) => ClipRRect(borderRadius: BorderRadius.circular(radius), child: _indicator(value)),
    );
  }

  Widget _indicator(double value) {
    var colorValue = AlwaysStoppedAnimation(valueColor);
    return LinearProgressIndicator(
      value: value.isFinite ? value : 0,
      minHeight: height,
      backgroundColor: background,
      valueColor: colorValue,
    );
  }
}
