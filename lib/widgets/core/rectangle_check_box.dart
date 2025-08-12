import 'package:flutter/material.dart';

import 'package:app/animations/fade_animation.dart';
import 'package:app/themes/colors.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/widgets/library/svg_image.dart';

class RectangleCheckBox extends StatelessWidget {
  final Color color;
  final Color selectedColor;
  final bool isChecked;
  final String label;
  final TextStyle? style;
  final double size;
  final Function()? onTap;

  const RectangleCheckBox({
    this.size = 20,
    this.label = '',
    this.style,
    this.onTap,
    this.color = offWhite4,
    this.selectedColor = primary,
    this.isChecked = false,
  });

  @override
  Widget build(BuildContext context) {
    var iconColor = isChecked ? selectedColor : color;
    var icon = isChecked ? Assets.svg1.check_square : Assets.svg1.square;
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeAnimation(duration: DURATION_1000, fadeKey: '$isChecked', child: SvgImage(image: icon, height: size, color: iconColor)),
          const SizedBox(width: 06),
          Flexible(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: style)),
        ],
      ),
    );
  }
}
