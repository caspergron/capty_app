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
import 'package:flutter/material.dart';

Future<void> addHomeAddressDialog({Function()? onProceed}) async {
  var context = navigatorKey.currentState!.context;
  // sl<AppAnalytics>().screenView('add-home-address-popup');
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Add Home Address Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().topToBottom,
    pageBuilder: (buildContext, anim1, anim2) => PopScopeNavigator(canPop: false, child: Align(child: _DialogView(onProceed))),
  );
}

class _DialogView extends StatelessWidget {
  final Function()? onProceed;
  const _DialogView(this.onProceed);

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
          'add_home_address'.recast,
          textAlign: TextAlign.center,
          style: TextStyles.text18_700.copyWith(color: lightBlue, height: 1),
        ),
        const SizedBox(height: 16),
        const Divider(color: mediumBlue),
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.width),
          child: Text(
            'before_you_can_create_your_first_sales_ad_please_add_your_shipping_address'.recast,
            textAlign: TextAlign.center,
            style: TextStyles.text14_400.copyWith(color: lightBlue, fontSize: 15),
          ),
        ),
        const SizedBox(height: 32),
        ElevateButton(
          radius: 04,
          height: 38,
          padding: 30,
          onTap: _onProceed,
          label: 'go_to_seller_settings'.recast.toUpper,
          textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontSize: 15, fontWeight: w600, height: 1.15),
        ),
      ],
    );
  }

  void _onProceed() {
    if (onProceed == null) return;
    backToPrevious();
    onProceed!();
  }
}
