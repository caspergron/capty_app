import 'package:flutter/material.dart';

import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/svg_image.dart';

class NoDiscFound extends StatelessWidget {
  final double height;
  final String label;
  final String name;
  final String description;

  const NoDiscFound({
    this.name = '',
    this.height = 40,
    this.label = 'no_disc_found',
    this.description = 'you_have_no_disc_available_now_please_add_your_disc',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: height),
          SvgImage(image: Assets.svg3.empty_box, height: 34.width, color: primary),
          const SizedBox(height: 24),
          Text(label.recast, textAlign: TextAlign.center, style: TextStyles.text16_600.copyWith(color: primary)),
          const SizedBox(height: 02),
          Text('$name${description.recast}'.trim(), textAlign: TextAlign.center, style: TextStyles.text14_400.copyWith(color: primary)),
        ],
      ),
    );
  }
}
