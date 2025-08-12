import 'package:flutter/material.dart';

import 'package:app/extensions/string_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';

class NoResultFound extends StatelessWidget {
  final double height;
  const NoResultFound({this.height = 40});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: height),
          // Image.asset(Assets.png_image.not_found, height: 140),
          const SizedBox(height: 28),
          Text(
            'no_result_found'.recast,
            textAlign: TextAlign.center,
            style: TextStyles.text18_700.copyWith(color: grey),
          ),
          const SizedBox(height: 08),
          Text(
            'no_search_records_found_please_adjust_your_search_criteria'.recast,
            textAlign: TextAlign.center,
            style: TextStyles.text14_700.copyWith(color: grey),
          ),
        ],
      ),
    );
  }
}
