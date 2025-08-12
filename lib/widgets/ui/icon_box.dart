import 'package:flutter/material.dart';

import 'package:app/themes/colors.dart';

class IconBox extends StatelessWidget {
  final double radius;
  final Color border;
  final double size;
  final Widget icon;
  final Color background;
  final BoxShape shape;
  final Function()? onTap;

  const IconBox({
    this.icon = const SizedBox.shrink(),
    this.onTap,
    this.radius = 4,
    this.size = 24,
    this.shape = BoxShape.rectangle,
    this.border = transparent,
    this.background = transparent,
  });

  @override
  Widget build(BuildContext context) {
    var borderAll = Border.all(color: border);
    var borderRadius = BorderRadius.circular(radius);
    return InkWell(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        child: icon,
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: background, shape: shape, borderRadius: borderRadius, border: borderAll),
      ),
    );
  }
}
