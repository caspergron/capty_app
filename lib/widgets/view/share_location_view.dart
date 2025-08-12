import 'package:flutter/material.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/dialogs/location_tracking_dialog.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';

class ShareLocationView extends StatelessWidget {
  final Color background;
  final double margin;
  final Function()? onShare;

  const ShareLocationView({this.background = skyBlue, this.margin = 0, this.onShare});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: margin, right: margin),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(08)),
      child: Column(
        children: [
          Text(
            'sorry_we_cant_show_you_the_nearest_sales_ads_to_your_location'.recast,
            textAlign: TextAlign.center,
            style: TextStyles.text14_600.copyWith(color: background == primary ? lightBlue : primary),
          ),
          const SizedBox(height: 10),
          ElevateButton(
            radius: 04,
            height: 38,
            width: double.infinity,
            label: 'share_location'.recast.toUpper,
            onTap: () => locationTrackingDialog(onAllow: onShare),
            textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
          ),
        ],
      ),
    );
  }
}
