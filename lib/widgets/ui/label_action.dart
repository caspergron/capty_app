import 'package:flutter/material.dart';

import 'package:app/extensions/string_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/widgets/library/svg_image.dart';

class LabelAction extends StatelessWidget {
  final String label;
  final String icon;
  final Color color;
  final Function() onTap;

  const LabelAction({required this.icon, required this.onTap, this.label = '', this.color = info});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(label.recast, style: TextStyles.text14_700.copyWith(color: color)),
          const SizedBox(width: 04),
          SvgImage(image: icon, height: 15, color: color),
        ],
      ),
    );
  }
}
