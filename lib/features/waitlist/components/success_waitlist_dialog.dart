import 'package:flutter/material.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/lottie_animation.dart';

Future<void> successWaitlistDialog({required String name}) async {
  final context = navigatorKey.currentState!.context;
  // sl<AppAnalytics>().screenView('success-waitlist-popup');
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Success Waitlist Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().topToBottom,
    pageBuilder: (buildContext, anim1, anim2) => PopScopeNavigator(canPop: false, child: Align(child: _DialogView(name))),
  );
}

class _DialogView extends StatelessWidget {
  final String name;
  const _DialogView(this.name);

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
        const SizedBox(height: 10),
        LottieAnimation(animPath: Assets.anim.rocket, height: 30.width),
        const SizedBox(height: 10),
        Text(
          '${'thank_you'.recast} ${name.allFirstLetterCapital}!',
          textAlign: TextAlign.center,
          style: TextStyles.text24_600.copyWith(color: white),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.width),
          child: Text(
            'added_waitlist_description'.recast,
            textAlign: TextAlign.center,
            style: TextStyles.text14_400.copyWith(color: lightBlue),
          ),
        ),
        const SizedBox(height: 32),
        ElevateButton(
          radius: 04,
          height: 38,
          padding: 36,
          onTap: _onContinue,
          label: 'continue'.recast.toUpper,
          textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
        ),
      ],
    );
  }

  void _onContinue() {
    backToPrevious();
    backToPrevious();
  }
}
