import 'package:flutter/material.dart';

import 'package:app/extensions/flutter_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/svg_image.dart';

class BackMenu extends StatelessWidget {
  final double size;
  final double iconSize;
  final Color iconColor;
  final Function()? onTap;

  const BackMenu({this.size = 36, this.iconSize = 20, this.onTap, this.iconColor = primary});

  @override
  Widget build(BuildContext context) {
    final icon = SvgImage(image: Assets.svg1.arrow_left, color: iconColor, height: iconSize);
    return InkWell(
      onTap: onTap ?? backToPrevious,
      child: Container(width: size, height: size, alignment: Alignment.center, child: icon),
    );
  }
}
