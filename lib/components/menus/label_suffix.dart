import 'package:flutter/material.dart';

import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';

class LabelSuffix extends StatelessWidget {
  final double width;
  final String label;
  final Color textColor;
  const LabelSuffix({this.width = 100, this.label = '', this.textColor = dark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 14),
      child: Text(label, style: TextStyles.text12_400.copyWith(color: dark)),
    );
  }
}
