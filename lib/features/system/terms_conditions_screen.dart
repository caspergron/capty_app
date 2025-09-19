import 'dart:io';

import 'package:flutter/material.dart';

import 'package:app/components/menus/back_menu.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/view/basic_info.dart';

class TermsConditionsScreen extends StatefulWidget {
  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  @override
  void initState() {
    // sl<AppAnalytics>().screenView('terms-and-conditions-screen');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final views = [_bannerImage, Expanded(child: _screenView)];
    return Scaffold(body: Container(width: SizeConfig.width, height: SizeConfig.height, child: Column(children: views)));
  }

  Widget get _bannerImage {
    final top = SizeConfig.statusBar + (Platform.isIOS ? 08 : 16);
    final bannerImage = Image.asset(Assets.png_image.terms_condition, width: double.infinity, height: 36.height, fit: BoxFit.cover);
    return Stack(children: [bannerImage, Positioned(top: top, left: 16, child: const BackMenu(iconColor: lightBlue))]);
  }

  Widget get _screenView {
    final capty = SvgImage(image: Assets.app.capty, height: 24, color: primary);
    final captyName = SvgImage(image: Assets.app.capty_name, height: 24, color: primary);
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
      children: [
        const SizedBox(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [capty, const SizedBox(width: 10), captyName]),
        const SizedBox(height: 24),
        Text('terms_and_conditions'.recast, style: TextStyles.text20_500.copyWith(color: primary, fontWeight: w600)),
        const SizedBox(height: 08),
        Text('terms_conditions_0_0_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 04),
        Text('terms_conditions_0_0_2'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 10),
        Text('terms_conditions_1'.recast, style: TextStyles.text14_700.copyWith(color: primary, fontSize: 15)),
        const SizedBox(height: 04),
        Text('terms_conditions_1_0_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 02),
        Text('terms_conditions_1_0_2'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 02),
        Text('terms_conditions_1_0_3'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 02),
        Text('terms_conditions_1_0_4'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 02),
        Text('terms_conditions_1_0_5'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 10),
        Text('terms_conditions_2'.recast, style: TextStyles.text14_700.copyWith(color: primary, fontSize: 15)),
        const SizedBox(height: 06),
        Text('terms_conditions_2_1'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        BasicInfo(label: 'terms_conditions_2_1_1'.recast),
        const SizedBox(height: 02),
        BasicInfo(label: 'terms_conditions_2_1_2'.recast),
        const SizedBox(height: 08),
        Text('terms_conditions_2_2'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        Text('terms_conditions_2_2_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 02),
        Text('terms_conditions_2_2_2'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 02),
        Text('terms_conditions_2_2_3'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 02),
        Text('terms_conditions_2_2_4'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 02),
        Text('terms_conditions_2_2_5'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 04),
        Text('terms_conditions_2_2_6'.recast, style: TextStyles.text14_400.copyWith(color: error)),
        const SizedBox(height: 08),
        Text('terms_conditions_2_3'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        Text('terms_conditions_2_3_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 08),
        Text('terms_conditions_2_4'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        Text('terms_conditions_2_4_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 08),
        Text('terms_conditions_2_5'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        Text('terms_conditions_2_5_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 04),
        BasicInfo(label: 'terms_conditions_2_5_2'.recast),
        const SizedBox(height: 02),
        BasicInfo(label: 'terms_conditions_2_5_3'.recast),
        const SizedBox(height: 10),
        Text('terms_conditions_3'.recast, style: TextStyles.text14_700.copyWith(color: primary, fontSize: 15)),
        const SizedBox(height: 06),
        Text('terms_conditions_3_1'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        BasicInfo(label: 'terms_conditions_3_1_1'.recast),
        const SizedBox(height: 02),
        BasicInfo(label: 'terms_conditions_3_1_2'.recast),
        const SizedBox(height: 08),
        Text('terms_conditions_3_2'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        BasicInfo(label: 'terms_conditions_3_2_1'.recast),
        const SizedBox(height: 02),
        BasicInfo(label: 'terms_conditions_3_2_2'.recast),
        const SizedBox(height: 08),
        Text('terms_conditions_3_3'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        Text('terms_conditions_3_3_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 04),
        Text('terms_conditions_3_3_2'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 04),
        BasicInfo(label: 'terms_conditions_3_3_3'.recast),
        const SizedBox(height: 02),
        BasicInfo(label: 'terms_conditions_3_3_4'.recast),
        const SizedBox(height: 10),
        Text('terms_conditions_4'.recast, style: TextStyles.text14_700.copyWith(color: primary, fontSize: 15)),
        const SizedBox(height: 06),
        Text('terms_conditions_4_1'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        Text('terms_conditions_4_1_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 02),
        Text('terms_conditions_4_1_2'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 02),
        Text('terms_conditions_4_1_3'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 02),
        Text('terms_conditions_4_1_4'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 08),
        Text('terms_conditions_4_2'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        Text('terms_conditions_4_2_1'.recast, style: TextStyles.text14_400.copyWith(color: error)),
        const SizedBox(height: 08),
        Text('terms_conditions_4_3'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        BasicInfo(label: 'terms_conditions_4_3_1'.recast),
        const SizedBox(height: 02),
        BasicInfo(label: 'terms_conditions_4_3_2'.recast),
        const SizedBox(height: 02),
        BasicInfo(label: 'terms_conditions_4_3_3'.recast),
        const SizedBox(height: 08),
        Text('terms_conditions_4_4'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        Text('terms_conditions_4_4_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 10),
        Text('terms_conditions_5'.recast, style: TextStyles.text14_700.copyWith(color: primary, fontSize: 15)),
        const SizedBox(height: 06),
        Text('terms_conditions_5_1'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        BasicInfo(label: 'terms_conditions_5_1_1'.recast),
        const SizedBox(height: 02),
        BasicInfo(label: 'terms_conditions_5_1_2'.recast),
        const SizedBox(height: 08),
        Text('terms_conditions_5_2'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        Text('terms_conditions_5_2_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 04),
        BasicInfo(label: 'terms_conditions_5_2_2'.recast),
        const SizedBox(height: 02),
        BasicInfo(label: 'terms_conditions_5_2_3'.recast),
        const SizedBox(height: 02),
        BasicInfo(label: 'terms_conditions_5_2_4'.recast),
        const SizedBox(height: 10),
        Text('terms_conditions_6'.recast, style: TextStyles.text14_700.copyWith(color: primary, fontSize: 15)),
        const SizedBox(height: 06),
        Text('terms_conditions_6_1'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        BasicInfo(label: 'terms_conditions_6_1_1'.recast),
        const SizedBox(height: 02),
        BasicInfo(label: 'terms_conditions_6_1_2'.recast),
        const SizedBox(height: 10),
        Text('terms_conditions_7'.recast, style: TextStyles.text14_700.copyWith(color: primary, fontSize: 15)),
        const SizedBox(height: 04),
        Text('terms_conditions_7_0_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 04),
        BasicInfo(label: 'terms_conditions_7_0_2'.recast),
        const SizedBox(height: 02),
        BasicInfo(label: 'terms_conditions_7_0_3'.recast),
        const SizedBox(height: 04),
        Text('terms_conditions_7_0_4'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 10),
        Text('terms_conditions_8'.recast, style: TextStyles.text14_700.copyWith(color: primary, fontSize: 15)),
        const SizedBox(height: 04),
        Text('terms_conditions_8_0_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 04),
        Text('terms_conditions_8_0_2'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 02),
        Text('terms_conditions_8_0_3'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 32),
      ],
    );
  }
}
