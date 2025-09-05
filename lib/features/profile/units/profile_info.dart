import 'package:app/extensions/number_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  final String label;
  final double value;

  const ProfileInfo({this.value = 0, this.label = ''});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.formatDouble,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyles.text24_600.copyWith(color: primary, fontWeight: w500),
        ),
        Text(
          label,
          maxLines: 1,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.text12_600.copyWith(color: primary, fontWeight: w400),
        ),
      ],
    );
  }
}
