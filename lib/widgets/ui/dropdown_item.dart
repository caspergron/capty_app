import 'package:flutter/material.dart';

import 'package:app/constants/data_constants.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';

class DropdownItem extends StatelessWidget {
  final String? label;
  final double fontSize;
  final Color color;
  const DropdownItem({this.label, this.color = dark, this.fontSize = 12});

  @override
  Widget build(BuildContext context) {
    var title = '$DROPDOWN_SPACE${label ?? ''}';
    return Text(
      title,
      textAlign: TextAlign.start,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyles.text12_600.copyWith(color: color, fontSize: fontSize, fontWeight: w400),
    );
  }
}
