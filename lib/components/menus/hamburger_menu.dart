import 'package:flutter/material.dart';

import 'package:app/themes/colors.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/svg_image.dart';

class HamburgerMenu extends StatelessWidget {
  final Color color;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HamburgerMenu({required this.scaffoldKey, this.color = primary});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => scaffoldKey.currentState!.openEndDrawer(),
      child: SvgImage(image: Assets.svg1.hamburger, color: color, height: 24),
    );
  }
}
