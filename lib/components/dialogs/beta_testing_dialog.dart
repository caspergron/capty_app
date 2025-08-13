import 'package:flutter/material.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/services/api_status.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';

Future<void> betaTestingDialog() async {
  var context = navigatorKey.currentState!.context;
  ApiStatus.instance.betaPopup = true;
  // sl<AppAnalytics>().screenView('app-exit-popup');
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Beta Testing Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().topToBottom,
    pageBuilder: (buildContext, anim1, anim2) => PopScopeNavigator(canPop: false, child: Align(child: _DialogView())),
  );
}

class _DialogView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.dialog_width,
      padding: EdgeInsets.symmetric(vertical: Dimensions.dialog_padding),
      decoration: BoxDecoration(color: primary, borderRadius: DIALOG_RADIUS, boxShadow: const [SHADOW_2]),
      child: Material(color: transparent, child: _screenView(context), shape: DIALOG_SHAPE),
    );
  }

  Widget _screenView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 02),
        Text(
          'we_are_in_beta_mode'.recast,
          textAlign: TextAlign.center,
          style: TextStyles.text18_700.copyWith(color: lightBlue, height: 1),
        ),
        const SizedBox(height: 16),
        const Divider(color: mediumBlue),
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.width),
          child: Text(
            'you_have_installed_the_first_version_of_the_app_thank_you_for_your_help_testing'.recast,
            textAlign: TextAlign.center,
            style: TextStyles.text14_400.copyWith(color: lightBlue, fontSize: 14.5, fontWeight: w500),
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.width),
          child: Text(
            'we_expect_to_switch_from_beta_mode_to_normal_user_mode_between_august_and_september_2025'.recast,
            textAlign: TextAlign.center,
            style: TextStyles.text14_400.copyWith(color: lightBlue, fontSize: 14.5),
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.width),
          child: Text(
            'please_do_not_add_all_your_discs_at_this_point_but_send_us_as_much_feedback_as_possible'.recast,
            textAlign: TextAlign.center,
            style: TextStyles.text14_400.copyWith(color: lightBlue, fontSize: 14.5),
          ),
        ),
        const SizedBox(height: 32),
        ElevateButton(
          radius: 04,
          height: 38,
          padding: 30,
          onTap: backToPrevious,
          label: 'okay_i_understand'.recast.toUpper,
          textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontSize: 15, fontWeight: w600, height: 1.15),
        ),
        const SizedBox(height: 04),
      ],
    );
  }
}
