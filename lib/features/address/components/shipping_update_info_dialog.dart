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
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';

Future<void> shippingUpdateInfoDialog({bool isShipping = false, Function()? onProceed}) async {
  final context = navigatorKey.currentState!.context;
  // sl<AppAnalytics>().screenView('shipping-update-info-popup');
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Shipping Update Info Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().topToBottom,
    pageBuilder: (buildContext, anim1, anim2) => PopScopeNavigator(canPop: false, child: Align(child: _DialogView(isShipping, onProceed))),
  );
}

class _DialogView extends StatelessWidget {
  final bool isShipping;
  final Function()? onProceed;
  const _DialogView(this.isShipping, this.onProceed);

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
          'do_you_want_to_offer_shipping'.recast,
          textAlign: TextAlign.center,
          style: TextStyles.text18_700.copyWith(color: lightBlue, height: 1),
        ),
        const SizedBox(height: 16),
        const Divider(color: mediumBlue),
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.width),
          child: Text(
            'if_you_turn_this_option_on_you_are_telling_the_buyers_that_if_they_pay_you'.recast,
            textAlign: TextAlign.center,
            style: TextStyles.text14_400.copyWith(color: lightBlue, fontSize: 15),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: Dimensions.dialog_padding),
            Expanded(
              flex: 08,
              child: ElevateButton(
                radius: 04,
                height: 38,
                background: skyBlue,
                onTap: backToPrevious,
                label: 'close'.recast.toUpper,
                textStyle: TextStyles.text14_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
              ),
            ),
            const SizedBox(width: 08),
            Expanded(
              flex: 10,
              child: ElevateButton(
                radius: 04,
                height: 38,
                onTap: _onProceed,
                label: 'okay_understood'.recast.toUpper,
                textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
              ),
            ),
            SizedBox(width: Dimensions.dialog_padding),
          ],
        ),
      ],
    );
  }

  Future<void> _onProceed() async {
    if (onProceed == null) return;
    onProceed!();
    backToPrevious();
  }
}
