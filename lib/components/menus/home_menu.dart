import 'package:flutter/material.dart';

import 'package:app/extensions/flutter_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/svg_image.dart';

class HomeMenu extends StatelessWidget {
  final Color color;
  const HomeMenu({this.color = primary});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: backToPrevious,
      child: Center(child: SvgImage(image: Assets.svg1.home, color: color, height: 26)),
    );
  }
}
