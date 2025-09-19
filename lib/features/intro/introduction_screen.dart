import 'package:flutter/material.dart';

import 'package:app/animations/fade_animation.dart';
import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/system/data_model.dart';
import 'package:app/services/routes.dart';
import 'package:app/services/storage_service.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/svg_image.dart';

class IntroductionScreen extends StatefulWidget {
  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  var _index = 0;

  @override
  void didChangeDependencies() {
    // sl<AppAnalytics>().screenView('introduction-screen');
    SizeConfig.initMediaQuery(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.symmetric(horizontal: Dimensions.screen_padding);
    return PopScopeNavigator(
      canPop: false,
      child: Scaffold(
        backgroundColor: primary,
        body: Container(width: SizeConfig.width, height: SizeConfig.height, padding: padding, child: _screenView(context)),
      ),
    );
  }

  Widget _screenView(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.statusBar + 08.height),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgImage(image: Assets.app.capty, height: 33, color: white),
            const SizedBox(width: 10),
            SvgImage(image: Assets.app.capty_name, height: 32, color: white),
          ],
        ),
        SizedBox(height: 8.height),
        Expanded(
          child: PageView.builder(
            clipBehavior: Clip.antiAlias,
            itemCount: INTRODUCTION_LIST.length,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) => setState(() => _index = index),
            itemBuilder: _pageViewItemCard,
          ),
        ),
        Container(
          height: 10,
          child: ListView.builder(
            shrinkWrap: true,
            clipBehavior: Clip.antiAlias,
            itemCount: INTRODUCTION_LIST.length,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) => _pointerItemCard(index),
          ),
        ),
        SizedBox(height: 6.height),
        ElevateButton(
          radius: 04,
          height: 42,
          padding: 20,
          width: 50.width,
          onTap: _onGetStarted,
          label: 'get_started'.recast.toUpper,
          textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
        ),
        SizedBox(height: 10.height),
      ],
    );
  }

  Widget _pageViewItemCard(BuildContext context, int index) {
    final introItem = INTRODUCTION_LIST[_index];
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        FadeAnimation(fadeKey: '$_index', child: SvgImage(image: INTRODUCTION_LIST[_index].icon, height: 25.height, color: skyBlue)),
        Column(
          children: [
            Text(
              introItem.label.recast,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyles.text24_600.copyWith(color: lightBlue),
            ),
            const SizedBox(height: 08),
            Text(
              introItem.value.recast,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyles.text14_400.copyWith(color: lightBlue),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ],
    );
  }

  Widget _pointerItemCard(int index) {
    final selected = _index == index;
    final margin = EdgeInsets.only(right: index == INTRODUCTION_LIST.length - 1 ? 0 : 04);
    final decoration = BoxDecoration(color: selected ? lightBlue : mediumBlue, shape: BoxShape.circle);
    return InkWell(
      onTap: () => setState(() => _index = index),
      child: Container(width: 10, height: 10, margin: margin, decoration: decoration),
    );
  }

  void _onGetStarted() {
    sl<StorageService>().setOnboardStatus(true);
    Routes.public.dashboard().pushAndRemove();
  }
}
