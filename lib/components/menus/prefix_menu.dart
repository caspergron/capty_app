import 'package:flutter/material.dart';

import 'package:app/themes/colors.dart';
import 'package:app/widgets/library/svg_image.dart';

const _RADIUS = Radius.circular(08);

class PrefixMenu extends StatelessWidget {
  final String icon;
  final bool isFocus;
  final Color color;
  final Color focusColor;
  final Function()? onTap;
  const PrefixMenu({required this.icon, this.isFocus = true, this.onTap, this.color = mediumBlue, this.focusColor = primary});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 40,
        alignment: Alignment.center,
        child: SvgImage(image: icon, height: 20, color: isFocus ? focusColor : color),
        decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: _RADIUS, bottomLeft: _RADIUS)),
      ),
    );
  }
}
