import 'package:flutter/material.dart';

import 'package:app/extensions/string_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/size_config.dart';

class NoSupportView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: offWhite1,
      child: Container(
        width: SizeConfig.width,
        height: SizeConfig.height,
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(Assets.svg1_image.tab_support, width: 40.width),
            const SizedBox(height: 32),
            Text(
              'sorry_tab_view_not_supported_yet'.recast,
              textAlign: TextAlign.center,
              style: TextStyles.text24_700.copyWith(color: dark),
            ),
            const SizedBox(height: 16),
            Text(
              'we_will_soon_bring_the_tab_view_for_you'.recast,
              textAlign: TextAlign.center,
              style: TextStyles.text18_700.copyWith(color: text),
            ),
          ],
        ),
      ),
    );
  }
}
