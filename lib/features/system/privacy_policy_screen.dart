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

class PrivacyPolicyScreen extends StatefulWidget {
  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  void initState() {
    // sl<AppAnalytics>().screenView('privacy-policy-screen');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final views = [_bannerImage, Expanded(child: _screenView)];
    return Scaffold(body: Container(width: SizeConfig.width, height: SizeConfig.height, child: Column(children: views)));
  }

  Widget get _bannerImage {
    final top = SizeConfig.statusBar + (Platform.isIOS ? 08 : 16);
    final bannerImage = Image.asset(Assets.png_image.privacy_policy, width: double.infinity, height: 36.height, fit: BoxFit.cover);
    return Stack(children: [bannerImage, Positioned(top: top, left: 16, child: const BackMenu(iconColor: dark))]);
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
        Text('privacy_policy'.recast, style: TextStyles.text20_500.copyWith(color: primary, fontWeight: w600)),
        const SizedBox(height: 08),
        Text('privacy_policy_0_0_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 04),
        Text('privacy_policy_0_0_2'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 10),
        Text('privacy_policy_1'.recast, style: TextStyles.text14_700.copyWith(color: primary, fontSize: 15)),
        const SizedBox(height: 04),
        Text('privacy_policy_1_0_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 02),
        Text('privacy_policy_1_0_2'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 02),
        Text('privacy_policy_1_0_3'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 02),
        Text('privacy_policy_1_0_4'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 02),
        Text('privacy_policy_1_0_5'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 10),
        Text('privacy_policy_2'.recast, style: TextStyles.text14_700.copyWith(color: primary, fontSize: 15)),
        const SizedBox(height: 06),
        Text('privacy_policy_2_1'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        Text('privacy_policy_2_1_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 04),
        BasicInfo(label: 'privacy_policy_2_1_2'.recast),
        const SizedBox(height: 02),
        BasicInfo(label: 'privacy_policy_2_1_3'.recast),
        const SizedBox(height: 02),
        BasicInfo(label: 'privacy_policy_2_1_4'.recast),
        const SizedBox(height: 02),
        BasicInfo(label: 'privacy_policy_2_1_5'.recast),
        const SizedBox(height: 02),
        BasicInfo(label: 'privacy_policy_2_1_6'.recast),
        const SizedBox(height: 02),
        BasicInfo(label: 'privacy_policy_2_1_7'.recast),
        const SizedBox(height: 04),
        Text('privacy_policy_2_1_8'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 08),
        Text('privacy_policy_2_2'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        Text('privacy_policy_2_2_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 08),
        Text('privacy_policy_2_3'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        Text('privacy_policy_2_3_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 04),
        BasicInfo(label: 'privacy_policy_2_3_2'.recast),
        const SizedBox(height: 02),
        BasicInfo(label: 'privacy_policy_2_3_3'.recast),
        const SizedBox(height: 02),
        BasicInfo(label: 'privacy_policy_2_3_4'.recast),
        const SizedBox(height: 02),
        BasicInfo(label: 'privacy_policy_2_3_5'.recast),
        const SizedBox(height: 10),
        Text('privacy_policy_3'.recast, style: TextStyles.text14_700.copyWith(color: primary, fontSize: 15)),
        const SizedBox(height: 08),
        Text('privacy_policy_3_1'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        Text('privacy_policy_3_1_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 08),
        Text('privacy_policy_3_2'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        Text('privacy_policy_3_2_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 08),
        Text('privacy_policy_3_3'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        Text('privacy_policy_3_3_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 04),
        BasicInfo(label: 'privacy_policy_3_3_2'.recast),
        const SizedBox(height: 02),
        BasicInfo(label: 'privacy_policy_3_3_3'.recast),
        const SizedBox(height: 02),
        BasicInfo(label: 'privacy_policy_3_3_4'.recast),
        const SizedBox(height: 08),
        Text('privacy_policy_3_4'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        Text('privacy_policy_3_4_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 04),
        BasicInfo(label: 'privacy_policy_3_4_2'.recast),
        const SizedBox(height: 02),
        BasicInfo(label: 'privacy_policy_3_4_3'.recast),
        const SizedBox(height: 10),
        Text('privacy_policy_4'.recast, style: TextStyles.text14_700.copyWith(color: primary, fontSize: 15)),
        const SizedBox(height: 08),
        Text('privacy_policy_4_1'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        Text('privacy_policy_4_1_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 08),
        Text('privacy_policy_4_2'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        Text('privacy_policy_4_2_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 08),
        Text('privacy_policy_4_3'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        Text('privacy_policy_4_3_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 02),
        Text('privacy_policy_4_3_2'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 02),
        Text('privacy_policy_4_3_3'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 10),
        Text('privacy_policy_5'.recast, style: TextStyles.text14_700.copyWith(color: primary, fontSize: 15)),
        const SizedBox(height: 08),
        Text('privacy_policy_5_1'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        Text('privacy_policy_5_1_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 04),
        BasicInfo(label: 'privacy_policy_5_1_2'.recast),
        const SizedBox(height: 02),
        BasicInfo(label: 'privacy_policy_5_1_3'.recast),
        const SizedBox(height: 02),
        BasicInfo(label: 'privacy_policy_5_1_4'.recast),
        const SizedBox(height: 08),
        Text('privacy_policy_5_2'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        Text('privacy_policy_5_2_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 08),
        Text('privacy_policy_5_3'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        Text('privacy_policy_5_3_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 10),
        Text('privacy_policy_6'.recast, style: TextStyles.text14_700.copyWith(color: primary, fontSize: 15)),
        const SizedBox(height: 04),
        Text('privacy_policy_6_0_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 04),
        BasicInfo(label: 'privacy_policy_6_0_2'.recast),
        const SizedBox(height: 02),
        BasicInfo(label: 'privacy_policy_6_0_3'.recast),
        const SizedBox(height: 04),
        Text('privacy_policy_6_0_4'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 10),
        Text('privacy_policy_7'.recast, style: TextStyles.text14_700.copyWith(color: primary, fontSize: 15)),
        const SizedBox(height: 04),
        Text('privacy_policy_7_0_1'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 04),
        Text('privacy_policy_7_0_2'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 02),
        Text('privacy_policy_7_0_3'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
        const SizedBox(height: 32),
      ],
    );
  }
}
