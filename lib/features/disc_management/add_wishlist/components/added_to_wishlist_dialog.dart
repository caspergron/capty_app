import 'package:flutter/material.dart';

import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
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
import 'package:app/widgets/library/svg_image.dart';

Future<void> addedToWishlistDialog() async {
  final context = navigatorKey.currentState!.context;
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Added To Wishlist Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().bottomToTop,
    pageBuilder: (buildContext, anim1, anim2) => PopScopeNavigator(canPop: false, child: Align(child: _DialogView())),
  );
}

class _DialogView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.dialog_width,
      padding: EdgeInsets.symmetric(vertical: Dimensions.dialog_padding, horizontal: 10.width),
      decoration: BoxDecoration(color: primary, borderRadius: DIALOG_RADIUS, boxShadow: const [SHADOW_2]),
      child: Material(color: transparent, child: _screenView(context), shape: DIALOG_SHAPE),
    );
  }

  Widget _screenView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 8.height),
        SvgImage(image: Assets.svg1.shield_check, color: lightBlue, height: 8.height),
        const SizedBox(height: 16),
        Text(
          '${'this_disc_has_been_added_to_your_wishlist'.recast}!',
          textAlign: TextAlign.center,
          style: TextStyles.text20_500.copyWith(color: lightBlue, fontWeight: w400),
        ),
        SizedBox(height: 8.height),
      ],
    );
  }
}
