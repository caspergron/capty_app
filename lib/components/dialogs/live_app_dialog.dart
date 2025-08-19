import 'package:flutter/material.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/services/api_status.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/svg_image.dart';

Future<void> liveAppDialog() async {
  var context = navigatorKey.currentState!.context;
  ApiStatus.instance.releasePopup = true;
  // sl<AppAnalytics>().screenView('app-exit-popup');
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Live App Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().topToBottom,
    pageBuilder: (buildContext, anim1, anim2) => PopScopeNavigator(canPop: false, child: Align(child: _DialogView())),
  );
}

class _DialogView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.dialog_width - 6.width,
      padding: EdgeInsets.only(top: Dimensions.dialog_padding),
      decoration: BoxDecoration(color: primary, borderRadius: DIALOG_RADIUS, boxShadow: const [SHADOW_2]),
      child: Material(color: transparent, child: _screenView(context), shape: DIALOG_SHAPE),
    );
  }

  Widget _screenView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 02),
        Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                'the_capty_app_is_live'.recast,
                textAlign: TextAlign.center,
                style: TextStyles.text18_700.copyWith(color: lightBlue, height: 1),
              ),
            ),
            Positioned(
              right: 20,
              top: -2,
              child: InkWell(onTap: backToPrevious, child: SvgImage(image: Assets.svg1.close_1, color: lightBlue, height: 18)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(color: mediumBlue),
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.width),
          child: Text(
            'you_have_installed_the_first_version_of_the_app'.recast,
            textAlign: TextAlign.center,
            style: TextStyles.text14_400.copyWith(color: lightBlue, fontSize: 14.5, fontWeight: w500),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.width),
          child: Text(
            'the_dream_is_to_create_an_app_that_some_day_in_future'.recast,
            textAlign: TextAlign.center,
            style: TextStyles.text14_400.copyWith(color: lightBlue, fontSize: 14.5),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.width),
          child: Text(
            'but_to_make_the_app_better_we_need_your_inputs'.recast,
            textAlign: TextAlign.center,
            style: TextStyles.text14_400.copyWith(color: lightBlue, fontSize: 14.5),
          ),
        ),
        /*const SizedBox(height: 32),
        ElevateButton(
          radius: 04,
          height: 38,
          padding: 30,
          onTap: _onProceed,
          label: 'go_to_feedback_page'.recast.toUpper,
          textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontSize: 15, fontWeight: w600, height: 1.15),
        ),*/
        const SizedBox(height: 28),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset(Assets.png_image.casper, height: 18.height),
            Expanded(
              child: Column(
                children: [
                  ElevateButton(
                    radius: 04,
                    height: 38,
                    onTap: _onProceed,
                    label: 'go_to_feedback_page'.recast.toUpper,
                    textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontSize: 15, fontWeight: w600, height: 1.15),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(bottom: 28, right: 08),
                    child: Text(
                      'Casper Grønbjerg\n${'founder'.recast}',
                      textAlign: TextAlign.center,
                      style: TextStyles.text18_600.copyWith(color: lightBlue, fontStyle: FontStyle.italic, fontWeight: w500),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  void _onProceed() {
    backToPrevious();
    Routes.user.report_problem().push();
  }
}
