import 'package:flutter/material.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/friend/friend_info.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';

Future<void> addedFriendDialog({required FriendInfo friend, Function()? onDelete}) async {
  final context = navigatorKey.currentState!.context;
  // sl<AppAnalytics>().screenView('added-friend-popup');
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Added Friend Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().topToBottom,
    pageBuilder: (buildContext, anim1, anim2) => PopScopeNavigator(canPop: false, child: Align(child: _DialogView(friend))),
  );
}

class _DialogView extends StatelessWidget {
  final FriendInfo friend;
  const _DialogView(this.friend);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.dialog_width,
      padding: EdgeInsets.symmetric(vertical: Dimensions.dialog_padding, horizontal: Dimensions.screen_padding),
      decoration: BoxDecoration(color: primary, borderRadius: DIALOG_RADIUS, boxShadow: const [SHADOW_2]),
      child: Material(color: transparent, child: _friendScreenView(context)),
      // child: Material(color: transparent, child: isFriend ? _friendScreenView(context) : _notFoundScreenView(context)),
    );
  }

  Widget _friendScreenView(BuildContext context) {
    const radius = Radius.circular(12);
    const borderSide = BorderSide(color: primary, width: 2);
    final borderAll = Border.all(color: primary, width: 2);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 02.width),
        Stack(
          children: [
            Container(
              height: 41.height,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: EdgeInsets.symmetric(horizontal: 02.width),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: radius, topRight: radius),
                border: const Border(left: borderSide, right: borderSide, top: borderSide),
                image: DecorationImage(image: AssetImage(Assets.png_image.winner_cup_2), fit: BoxFit.fill),
              ),
              child: SvgImage(image: Assets.svg3.shield, height: 40.height, color: primary),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 7.5.height,
              child: Column(
                children: [
                  CircleImage(
                    radius: 25.width,
                    borderWidth: 02,
                    borderColor: primary,
                    backgroundColor: skyBlue,
                    image: friend.media?.url,
                    placeholder: const FadingCircle(size: 60),
                    errorWidget: SvgImage(image: Assets.svg1.coach, color: primary, height: 31.width),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 44.width,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(color: skyBlue, border: borderAll, borderRadius: BorderRadius.circular(06)),
                    child: Text(
                      friend.name ?? '',
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.text16_700.copyWith(color: primary, height: 1, letterSpacing: 0.48),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            '${'your_friend'.recast} ${friend.name ?? ''} ${'has_been_added'.recast}',
            textAlign: TextAlign.center,
            style: TextStyles.text20_500.copyWith(color: lightBlue),
          ),
        ),
        const SizedBox(height: 24),
        ElevateButton(
          radius: 04,
          height: 42,
          width: 100.width,
          background: skyBlue,
          onTap: backToPrevious,
          label: 'go_back'.recast.toUpper,
          textStyle: TextStyles.text14_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
        ),
      ],
    );
  }

  /*Widget _notFoundScreenView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 02),
          child: InkWell(onTap: _onBack, child: SvgImage(image: Assets.svg1.close_1, height: 20, color: lightBlue)),
        ),
        const SizedBox(height: 08),
        SvgImage(image: Assets.svg1.coach_plus, height: 105, color: lightBlue),
        const SizedBox(height: 12),
        Text(
          'we_could_not_find_your_friend'.recast,
          textAlign: TextAlign.center,
          style: TextStyles.text20_500.copyWith(color: lightBlue),
        ),
        const SizedBox(height: 04),
        Text(
          'please_ask_your_friend_to_sign_up_in_capty'.recast,
          textAlign: TextAlign.center,
          style: TextStyles.text14_400.copyWith(color: lightBlue),
        ),
        const SizedBox(height: 24),
        ElevateButton(
          radius: 04,
          height: 40,
          padding: 24,
          onTap: backToPrevious,
          label: 'invite_again'.recast.toUpper,
          textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
        ),
        const SizedBox(height: 08),
      ],
    );
  }*/
}
