import 'package:flutter/material.dart';

import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';

class ElevateButton extends StatelessWidget {
  final bool loader;
  final String label;
  final double? width;
  final double height;
  final double radius;
  final Color background;
  final double padding;
  final Function()? onTap;
  final Widget? icon;
  final TextStyle textStyle;

  const ElevateButton({
    this.label = '',
    this.width,
    this.icon,
    this.onTap,
    this.radius = 08,
    this.height = 48,
    this.padding = 12,
    this.loader = false,
    this.background = orange,
    this.textStyle = const TextStyle(fontSize: 16.5, fontWeight: w500, color: white, height: 1.2, fontFamily: roboto),
  });

  @override
  Widget build(BuildContext context) {
    final title = Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: textStyle);
    return InkWell(
      onTap: loader ? null : onTap,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: padding),
        decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(radius)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [if (icon != null) icon!, if (icon != null) const SizedBox(width: 08), Flexible(child: title)],
        ),
      ),
    );
  }
}
