import 'package:flutter/material.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';

Future<void> discRequestDialog() async {
  var context = navigatorKey.currentState!.context;
  // sl<AppAnalytics>().screenView('app-exit-popup');
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Disc Request Dialog',
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
        Text('request_a_disc'.recast, textAlign: TextAlign.center, style: TextStyles.text18_700.copyWith(color: lightBlue, height: 1)),
        const SizedBox(height: 16),
        const Divider(color: mediumBlue),
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.width),
          child: Text(
            '${'if_your_disc_is_not_available_in_the_list_please_submit'.recast}?',
            textAlign: TextAlign.center,
            style: TextStyles.text14_400.copyWith(color: lightBlue),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: Dimensions.dialog_padding),
            Expanded(
              child: ElevateButton(
                radius: 04,
                height: 38,
                background: skyBlue,
                label: 'yes_please'.recast.toUpper,
                textStyle: TextStyles.text14_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
                onTap: _onProceed,
              ),
            ),
            const SizedBox(width: 08),
            Expanded(
              child: ElevateButton(
                radius: 04,
                height: 38,
                label: 'no_stay'.recast.toUpper,
                onTap: backToPrevious,
                textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
              ),
            ),
            SizedBox(width: Dimensions.dialog_padding),
          ],
        ),
      ],
    );
  }

  void _onProceed() {
    backToPrevious();
    Routes.user.request_disc().push();
  }
}
