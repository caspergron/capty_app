import 'package:flutter/material.dart';

import 'package:app/extensions/string_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';

class UnitSuffix extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 14),
      child: Text('gram'.recast, style: TextStyles.text12_400.copyWith(color: dark, height: 1)),
    );
  }
}
