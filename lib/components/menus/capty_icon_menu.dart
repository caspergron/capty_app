import 'package:flutter/material.dart';

import 'package:app/themes/colors.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/svg_image.dart';

class CaptyIconMenu extends StatelessWidget {
  final Color color;
  final Function()? onTap;
  const CaptyIconMenu({this.color = primary, this.onTap});

  @override
  Widget build(BuildContext context) {
    final icon = SvgImage(image: Assets.app.capty, color: color, height: 22);
    return InkWell(onTap: onTap, child: Center(child: icon));
  }
}
