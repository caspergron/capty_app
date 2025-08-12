import 'package:flutter/material.dart';

import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/shadows.dart';

class OutlineButton extends StatelessWidget {
  final bool loader;
  final String label;
  final double? width;
  final double height;
  final double radius;
  final Color border;
  final Color background;
  final double padding;
  final List<BoxShadow> shadow;
  final Function()? onTap;
  final Widget? icon;
  final TextStyle textStyle;

  const OutlineButton({
    this.onTap,
    this.label = '',
    this.width,
    this.icon,
    this.radius = 08,
    this.height = 48,
    this.padding = 12,
    this.border = offWhite1,
    this.background = white,
    this.shadow = const [SHADOW_1],
    this.loader = false,
    this.textStyle = const TextStyle(fontSize: 16, fontWeight: w500, color: grey, height: 1, fontFamily: roboto),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loader ? null : onTap,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: padding),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: shadow,
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) icon!,
            if (icon != null) const SizedBox(width: 08),
            Flexible(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: textStyle)),
          ],
        ),
      ),
    );
  }
}
