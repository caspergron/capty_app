import 'package:flutter/material.dart';

import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/svg_image.dart';

class ErrorNameInitial extends StatelessWidget {
  final String initial;
  final double fontSize;
  final double iconSize;
  final double fontHeight;
  const ErrorNameInitial({this.initial = '', this.fontSize = 20, this.iconSize = 24, this.fontHeight = 1.6});

  @override
  Widget build(BuildContext context) {
    if (initial.isEmpty) {
      return Center(child: SvgImage(image: Assets.svg1.user, height: iconSize, color: grey));
    } else {
      var style = TextStyles.text24_700.copyWith(height: fontHeight, color: grey, fontSize: fontSize, fontWeight: w600);
      return Center(child: Text(initial, style: style));
    }
  }
}
