import 'package:flutter/material.dart';

import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';

class LabelPlaceholder extends StatelessWidget {
  final double height;
  final String hint;
  final String label;
  final Widget? icon;
  final Widget? endIcon;
  final Color background;
  final Color border;
  final double radius;
  final double margin;
  final double fontSize;
  final Color? textColor;
  final Function()? onTap;

  const LabelPlaceholder({
    required this.label,
    this.hint = '',
    this.onTap,
    this.icon,
    this.endIcon,
    this.radius = 4,
    this.height = 46,
    this.margin = 0,
    this.background = offWhite2,
    this.border = transparent,
    this.textColor,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    var boxBorder = border == transparent ? null : Border.all(color: border);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: double.infinity,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.symmetric(horizontal: margin),
        decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(radius), border: boxBorder),
        child: Row(
          children: [
            if (icon != null) const SizedBox(width: 13),
            if (icon != null) icon!,
            SizedBox(width: icon != null ? 13 : 16),
            Expanded(
              child: Text(
                label.isEmpty ? hint.recast : label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColor ?? (label.isEmpty ? text.colorOpacity(0.7) : primary),
                  fontWeight: label.isEmpty ? w400 : w500,
                  fontSize: fontSize,
                  fontFamily: roboto,
                  height: 1,
                ),
              ),
            ),
            if (endIcon != null) const SizedBox(width: 12),
            if (endIcon != null) endIcon!,
            const SizedBox(width: 13),
          ],
        ),
      ),
    );
  }
}
