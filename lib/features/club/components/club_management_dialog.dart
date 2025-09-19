import 'dart:io';

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
import 'package:app/utils/size_config.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/svg_image.dart';

const _ENABLED_NOTIFICATIONS = ['adjust_club_details', 'edit_club_courses', 'control_other_relevant_club_data'];

Future<void> clubManagementDialog({required Club club, Function()? onJoin}) async {
  final context = navigatorKey.currentState!.context;
  // sl<AppAnalytics>().screenView('club-management-popup');
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Club Management Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().bottomToTop,
    pageBuilder: (buildContext, anim1, anim2) => PopScopeNavigator(canPop: false, child: Align(child: _DialogView(club, onJoin))),
  );
}

class _DialogView extends StatelessWidget {
  final Club club;
  final Function()? onJoin;
  const _DialogView(this.club, this.onJoin);

  @override
  Widget build(BuildContext context) {
    final _ADMINS = [];
    return Container(
      height: _ADMINS.isEmpty ? 82.height : SizeConfig.height,
      width: Dimensions.dialog_width + 10,
      margin: EdgeInsets.only(top: SizeConfig.statusBar + (Platform.isIOS ? 10 : 16), bottom: Platform.isIOS ? 32 : 20),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding + 10),
      decoration: BoxDecoration(color: primary, borderRadius: DIALOG_RADIUS, boxShadow: const [SHADOW_2]),
      child: Material(color: transparent, child: _screenView(context), shape: DIALOG_SHAPE),
    );
  }

  Widget _screenView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ListView(
            shrinkWrap: true,
            clipBehavior: Clip.antiAlias,
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 22),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(onTap: backToPrevious, child: SvgImage(image: Assets.svg1.close_1, color: skyBlue, height: 22)),
              ),
              SvgImage(image: Assets.svg3.training, color: mediumBlue, height: 16.height),
              const SizedBox(height: 24),
              Text(
                '${'do_you_want_to_be_admin_for'.recast} ${club.name ?? ''}?',
                textAlign: TextAlign.center,
                style: TextStyles.text20_500.copyWith(color: lightBlue, fontWeight: w500),
              ),
              SizedBox(height: 3.height),
              Text(
                '${'as_a_manager_you_will_be_able_to'.recast}:',
                textAlign: TextAlign.start,
                style: TextStyles.text16_600.copyWith(color: lightBlue, fontWeight: w500),
              ),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                clipBehavior: Clip.antiAlias,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _ENABLED_NOTIFICATIONS.length,
                padding: EdgeInsets.only(left: 6.width, right: 20),
                separatorBuilder: (context, index) => SizedBox(height: index == _ENABLED_NOTIFICATIONS.length - 1 ? 0 : 10),
                itemBuilder: (context, index) => _successItemCard(_ENABLED_NOTIFICATIONS[index].recast, index, lightBlue),
              ),
              SizedBox(height: 3.height),
              Text(
                '${'currently_the_club_admins_are'.recast}:',
                textAlign: TextAlign.start,
                style: TextStyles.text16_600.copyWith(color: lightBlue, fontWeight: w500),
              ),
              const SizedBox(height: 16), // 10
              if ('rafi' == 'rafi')
                Text(
                  'there_are_currently_no_admins_of_this_club'.recast,
                  style: TextStyles.text14_500.copyWith(color: orange, fontSize: 14.8),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  clipBehavior: Clip.antiAlias,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _ENABLED_NOTIFICATIONS.length,
                  padding: EdgeInsets.only(left: 6.width, right: 20),
                  separatorBuilder: (context, index) => SizedBox(height: index == _ENABLED_NOTIFICATIONS.length - 1 ? 0 : 10),
                  itemBuilder: (context, index) => _successItemCard(_ENABLED_NOTIFICATIONS[index], index, orange),
                ),
              SizedBox(height: 'rafi' == 'rafi' ? 6.height : 10.height),
              Text(
                'click_here_if_you_want_to_join_the_admin_team_for_the_club'.recast,
                textAlign: TextAlign.center,
                style: TextStyles.text14_600.copyWith(color: lightBlue),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ElevateButton(
          radius: 04,
          height: 42,
          padding: 24,
          onTap: _onJoinAdmin,
          label: 'join_as_administrator'.recast.toUpper,
          textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  void _onJoinAdmin() {
    if (onJoin == null) return;
    backToPrevious();
    onJoin!();
  }

  Widget _successItemCard(String item, int index, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgImage(image: Assets.svg1.tick, height: 20, color: success),
        const SizedBox(width: 06),
        Expanded(child: Text(item, style: TextStyles.text14_400.copyWith(color: color, fontWeight: w500, height: 1.35))),
      ],
    );
  }
}
