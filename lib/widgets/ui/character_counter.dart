import 'package:flutter/material.dart';

import 'package:app/extensions/string_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/svg_image.dart';

class CharacterCounter extends StatelessWidget {
  final int count;
  final int total;
  final Color color;

  const CharacterCounter({this.count = 0, this.total = 0, this.color = lightBlue});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgImage(image: Assets.svg2.info, height: 16, color: color),
        const SizedBox(width: 6),
        Expanded(child: Text('$count/$total ${'characters'.recast}', style: TextStyles.text12_600.copyWith(color: color))),
      ],
    );
  }
}
