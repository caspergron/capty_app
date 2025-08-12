import 'package:flutter/material.dart';

import 'package:app/extensions/string_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';

class NoPgdaInfo extends StatelessWidget {
  final Color background;
  final double margin;

  const NoPgdaInfo({this.background = skyBlue, this.margin = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: margin, right: margin),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(08)),
      child: Text(
        'no_pdga_description'.recast,
        textAlign: TextAlign.center,
        style: TextStyles.text14_600.copyWith(color: background == primary ? lightBlue : primary),
      ),
    );
  }
}
