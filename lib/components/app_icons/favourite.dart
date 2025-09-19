import 'package:flutter/material.dart';

import 'package:app/themes/colors.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/svg_image.dart';

class Favourite extends StatelessWidget {
  final double height;
  final Color color;
  final bool status;
  final Function()? onTap;

  const Favourite({this.height = 20, this.color = orange, this.status = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    final icon = status ? Assets.svg2.heart : Assets.svg1.heart;
    return GestureDetector(onTap: onTap, child: SvgImage(image: icon, height: height, color: color));
  }
}
