import 'package:flutter/material.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/club/club.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/lottie_animation.dart';

Future<void> clubCreatedDialog({required Club club}) async {
  var context = navigatorKey.currentState!.context;
  // sl<AppAnalytics>().screenView('club-created-popup');
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Club Created Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().topToBottom,
    pageBuilder: (buildContext, anim1, anim2) => PopScopeNavigator(canPop: false, child: Align(child: _DialogView(club))),
  );
}

class _DialogView extends StatelessWidget {
  final Club club;
  const _DialogView(this.club);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.dialog_width,
      padding: EdgeInsets.symmetric(vertical: Dimensions.dialog_padding, horizontal: Dimensions.dialog_padding),
      decoration: BoxDecoration(color: primary, borderRadius: DIALOG_RADIUS, boxShadow: const [SHADOW_2]),
      child: Material(color: transparent, shape: DIALOG_SHAPE, child: _screenView(context)),
    );
  }

  Widget _screenView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        Container(
          width: 40.width,
          height: 40.width,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: white.colorOpacity(0.15), shape: BoxShape.circle),
          child: Container(
            width: 30.width,
            height: 30.width,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: white, shape: BoxShape.circle),
            child: LottieAnimation(animPath: Assets.anim.rocket, height: 24.width),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'your_disc_golf_club_has_been_created'.recast,
          textAlign: TextAlign.center,
          style: TextStyles.text24_600.copyWith(color: lightBlue, fontWeight: w600),
        ),
        const SizedBox(height: 20),
        Text(
          'please_share_this_link_with_your_club_members_so_they_can_join_the_club'.recast,
          textAlign: TextAlign.center,
          style: TextStyles.text14_400.copyWith(color: lightBlue),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: _onShareLink,
          child: Text(
            'link_for_the_club'.recast,
            textAlign: TextAlign.center,
            style: TextStyles.text16_600.copyWith(color: orange, decoration: TextDecoration.underline),
          ),
        ),
        const SizedBox(height: 36),
        ElevateButton(
          radius: 04,
          height: 42,
          padding: 30,
          onTap: _onDashboard,
          label: 'go_to_dashboard'.recast.toUpper,
          textStyle: TextStyles.text14_700.copyWith(fontSize: 15, color: lightBlue, fontWeight: w600, height: 1.15),
        ),
        const SizedBox(height: 06),
      ],
    );
  }

  void _onShareLink() {}

  Future<void> _onDashboard() async {
    backToPrevious();
    backToPrevious();
  }
}
