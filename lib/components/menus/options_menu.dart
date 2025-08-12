import 'package:flutter/material.dart';

import 'package:app/themes/colors.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/svg_image.dart';

class TrashMenu extends StatelessWidget {
  final Color color;
  final Function()? onTap;
  const TrashMenu({this.color = warning, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: onTap, child: SvgImage(image: Assets.svg1.trash, color: color, height: 24));
  }
}
