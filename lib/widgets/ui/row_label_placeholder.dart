import 'package:flutter/material.dart';

import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';

class RowLabelPlaceholder extends StatelessWidget {
  final double height;
  final String hint;
  final String label;
  final Widget? icon;
  final Widget? endIcon;
  final Color background;
  final Color border;
  final double radius;
  final double margin;
  final TextStyle style;
  final Function()? onTap;

  const RowLabelPlaceholder({
    required this.label,
    this.hint = '',
    this.onTap,
    this.icon,
    this.endIcon,
    this.radius = 4,
    this.height = 44,
    this.margin = 0,
    this.background = Colors.transparent,
    this.border = Colors.transparent,
    this.style = const TextStyle(fontSize: 14, fontWeight: w400, color: primary, fontFamily: roboto),
  });

  @override
  Widget build(BuildContext context) {
    final boxBorder = border == Colors.transparent ? null : Border.all(color: border);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.symmetric(horizontal: margin),
        decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(radius), border: boxBorder),
        child: Row(
          children: [
            const SizedBox(width: 12),
            if (icon != null) icon!,
            if (icon != null) const SizedBox(width: 04),
            Text(label.isEmpty ? hint : label, maxLines: 1, overflow: TextOverflow.ellipsis, style: style),
            if (endIcon != null) const SizedBox(width: 04),
            if (endIcon != null) endIcon!,
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
