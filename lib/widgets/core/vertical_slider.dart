import 'package:flutter/material.dart';

import 'package:app/themes/colors.dart';

class VerticalSlider extends StatelessWidget {
  final double min;
  final double max;
  final double value;
  final double height;
  final Function(double)? onChanged;

  const VerticalSlider({this.height = 150, this.value = 8, this.min = 1, this.max = 30, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RotatedBox(
        quarterTurns: 3,
        child: Slider(
          value: value,
          min: min,
          max: max,
          activeColor: primary,
          inactiveColor: white,
          thumbColor: primary,
          onChanged: onChanged == null ? null : (value) => onChanged!(value),
        ),
      ),
    );
  }
}
