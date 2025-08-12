import 'package:flutter/material.dart';

import 'package:upgrader/upgrader.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/toasts_popups.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';

Future<void> appUpdateDialog({required Upgrader upgrader}) async {
  var context = navigatorKey.currentState!.context;
  // sl<AppAnalytics>().screenView('app-update-popup');
  await showGeneralDialog(
    context: context,
    barrierLabel: 'App Update Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().topToBottom,
    pageBuilder: (buildContext, anim1, anim2) => PopScopeNavigator(canPop: false, child: Align(child: _DialogView(upgrader))),
  );
}

class _DialogView extends StatelessWidget {
  final Upgrader upgrader;
  const _DialogView(this.upgrader);

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
        Text('update_available'.recast, textAlign: TextAlign.center, style: TextStyles.text18_700.copyWith(color: lightBlue, height: 1)),
        const SizedBox(height: 16),
        const Divider(color: mediumBlue),
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.width),
          child: Text(
            'a_new_version_of_the_app_is_available_please_update_to_continue'.recast,
            textAlign: TextAlign.center,
            style: TextStyles.text14_400.copyWith(color: lightBlue, fontSize: 15),
          ),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding),
          child: ElevateButton(
            radius: 04,
            height: 38,
            onTap: _onUpdate,
            width: double.infinity,
            label: 'update_now'.recast.toUpper,
            textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
          ),
        ),
      ],
    );
  }

  Future<void> _onUpdate() async {
    try {
      await upgrader.sendUserToAppStore();
    } catch (e) {
      ToastPopup.onError(message: 'unable_to_update_now_please_try_again_later'.recast);
      backToPrevious();
    }
  }
}
