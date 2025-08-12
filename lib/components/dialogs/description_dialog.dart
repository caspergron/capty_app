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

Future<void> descriptionDialog({required String description}) async {
  var context = navigatorKey.currentState!.context;
  // sl<AppAnalytics>().screenView('description-popup');
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Description Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().topToBottom,
    pageBuilder: (buildContext, anim1, anim2) => PopScopeNavigator(canPop: false, child: Align(child: _DialogView(description))),
  );
}

class _DialogView extends StatelessWidget {
  final String description;
  const _DialogView(this.description);

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
        Text('about_the_disc'.recast, textAlign: TextAlign.center, style: TextStyles.text18_700.copyWith(color: lightBlue, height: 1)),
        const SizedBox(height: 16),
        const Divider(color: mediumBlue),
        const SizedBox(height: 20),
        Container(
          height: 55.height,
          padding: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Text(description, textAlign: TextAlign.start, style: TextStyles.text12_400.copyWith(color: lightBlue, fontSize: 13)),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding),
          child: ElevateButton(
            radius: 04,
            height: 38,
            width: double.infinity,
            label: 'close'.recast.toUpper,
            onTap: backToPrevious,
            textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
          ),
        ),
      ],
    );
  }
}
