import 'package:flutter/material.dart';

import 'package:app/extensions/string_ext.dart';
import 'package:app/models/disc/parent_disc.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';

class DiscInitialInfo extends StatelessWidget {
  final ParentDisc disc;
  const DiscInitialInfo({required this.disc});

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyles.text12_600.copyWith(color: dark);
    final valueStyle = TextStyles.text12_600.copyWith(color: dark, fontWeight: w400);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 08),
      decoration: BoxDecoration(
        color: lightBlue,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(width: 0.50, color: primary),
        boxShadow: const [SHADOW_1],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 20),
              Expanded(child: Text('disc_name'.recast, style: titleStyle)),
              const SizedBox(width: 08),
              Expanded(child: Text('manufacture'.recast, style: titleStyle)),
              const SizedBox(width: 08),
              Expanded(child: Text('disc_type'.recast, style: titleStyle)),
              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 08),
          const Divider(height: 1, color: primary, thickness: 0.5),
          const SizedBox(height: 07),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 20),
              Expanded(child: Text(disc.name ?? 'n/a'.recast, style: valueStyle)),
              const SizedBox(width: 08),
              Expanded(child: Text(disc.brand?.name ?? 'n/a'.recast, style: valueStyle)),
              const SizedBox(width: 08),
              Expanded(child: Text(disc.type ?? 'n/a'.recast, style: valueStyle)),
              const SizedBox(width: 20),
            ],
          ),
        ],
      ),
    );
  }
}
