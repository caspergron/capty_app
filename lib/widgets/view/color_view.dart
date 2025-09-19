import 'package:flutter/material.dart';

import 'package:app/components/dialogs/color_picker_dialog.dart';
import 'package:app/themes/colors.dart';
import 'package:app/utils/dimensions.dart';

class ColorView extends StatelessWidget {
  final Color color;
  final Size size;
  final Function(Color)? onColor;

  const ColorView({this.size = const Size(60, 60), this.color = mediumBlue, this.onColor});

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(color: color, borderRadius: BorderRadius.circular(4));
    return InkWell(
      onTap: () => onColor == null ? null : colorPickerDialog(color: color, onChanged: (v) => onColor!(v)),
      child: AnimatedContainer(width: 60, height: 60, duration: DURATION_700, decoration: decoration),
    );
  }
}
