import 'package:flutter/material.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';

Future<void> leaderboardDialog({String menu = ''}) async {
  final context = navigatorKey.currentState!.context;
  // sl<AppAnalytics>().screenView('leaderboard-popup');
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Leaderboard Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().topToBottom,
    pageBuilder: (buildContext, anim1, anim2) => PopScopeNavigator(canPop: false, child: Align(child: _DialogView(menu: menu))),
  );
}

class _DialogView extends StatelessWidget {
  final String menu;
  const _DialogView({this.menu = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.dialog_width,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding, vertical: Dimensions.dialog_padding),
      decoration: BoxDecoration(color: primary, borderRadius: DIALOG_RADIUS, boxShadow: const [SHADOW_2]),
      child: Material(color: transparent, child: _screenView(context), shape: DIALOG_SHAPE),
    );
  }

  Widget _screenView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 02),
        // InkWell(onTap: backToPrevious, child: SvgImage(image: Assets.svg1.close_1, height: 20, color: lightBlue)),
        Text(_popupLabel.recast, style: TextStyles.text20_500.copyWith(color: lightBlue, height: 1)),
        const SizedBox(height: 16),
        Text('what_does_it_show'.recast, style: TextStyles.text14_700.copyWith(color: lightBlue)),
        const SizedBox(height: 02),
        Text(_labelDesc1.recast, style: TextStyles.text14_400.copyWith(color: lightBlue)),
        const SizedBox(height: 12),
        Text('how_is_it_calculated'.recast, style: TextStyles.text14_700.copyWith(color: lightBlue)),
        const SizedBox(height: 02),
        Text(_labelDesc2.recast, style: TextStyles.text14_400.copyWith(color: lightBlue)),
        const SizedBox(height: 12),
        Text('where_do_the_data_come_from'.recast, style: TextStyles.text14_700.copyWith(color: lightBlue)),
        const SizedBox(height: 02),
        Text(_labelDesc3.recast, style: TextStyles.text14_400.copyWith(color: lightBlue)),
        const SizedBox(height: 12),
        Text('how_often_is_it_updated'.recast, style: TextStyles.text14_700.copyWith(color: lightBlue)),
        const SizedBox(height: 02),
        Text(_labelDesc4.recast, style: TextStyles.text14_400.copyWith(color: lightBlue)),
        const SizedBox(height: 12),
        Text('how_do_i_improve_my_rank'.recast, style: TextStyles.text14_700.copyWith(color: lightBlue)),
        const SizedBox(height: 02),
        Text(_labelDesc5.recast, style: TextStyles.text14_400.copyWith(color: lightBlue)),
        const SizedBox(height: 12),
        Text('i_do_not_want_to_be_on_the_leaderboard'.recast, style: TextStyles.text14_700.copyWith(color: lightBlue)),
        const SizedBox(height: 02),
        Text(_labelDesc6.recast, style: TextStyles.text14_400.copyWith(color: lightBlue)),
        const SizedBox(height: 12),
        Text('i_want_to_be_on_the_leaderboard'.recast, style: TextStyles.text14_700.copyWith(color: lightBlue)),
        const SizedBox(height: 02),
        Text(_labelDesc7.recast, style: TextStyles.text14_400.copyWith(color: lightBlue)),
        const SizedBox(height: 16),
        ElevateButton(
          height: 40,
          width: double.infinity,
          label: 'okay_i_understand'.recast.toUpper,
          onTap: backToPrevious,
          textStyle: TextStyles.text14_600.copyWith(color: lightBlue, height: 1.2, fontSize: 15),
        ),
        const SizedBox(height: 02),
      ],
    );
  }

  String get _popupLabel {
    if (menu.toKey == 'yearly_improvement'.toKey) {
      return 'pdga_yearly_improvement';
    } else if (menu.toKey == 'improvement'.toKey) {
      return 'pdga_monthly_improvement';
    } else {
      return 'pdga_leaderboard';
    }
  }

  String get _labelDesc1 {
    if (menu.toKey == 'yearly_improvement'.toKey) {
      return 'the_people_with_the_best_yearly_improvement_shows_in_top';
    } else if (menu.toKey == 'improvement'.toKey) {
      return 'the_people_with_the_best_monthly_improvement_shows_in_top';
    } else {
      return 'we_list_people_based_on_who_has_the_best_pdga_rating';
    }
  }

  String get _labelDesc2 {
    if (menu.toKey == 'yearly_improvement'.toKey) {
      return 'we_grab_the_pdga_rating_you_had_last_year_and_then_we_calculate_your_improvement';
    } else if (menu.toKey == 'improvement'.toKey) {
      return 'we_grab_the_pdga_rating_you_had_last_month_and_then_we_calculate_your_improvement';
    } else {
      return 'it_is_not_calculated_but_we_get_the_data_from_pdga';
    }
  }

  String get _labelDesc3 {
    if (menu.toKey == 'yearly_improvement'.toKey) {
      return 'data_is_being_pulled_from_pdga';
    } else {
      return 'data_is_being_pulled_from_pdga';
    }
  }

  String get _labelDesc4 {
    if (menu.toKey == 'yearly_improvement'.toKey) {
      return 'on_every_second_tuesday_of_the_month_pdga_update_the_data_and_we_then_also_update_them_here';
    } else {
      return 'on_every_second_tuesday_of_the_month_pdga_update_the_data_and_we_then_also_update_them_here';
    }
  }

  String get _labelDesc5 {
    if (menu.toKey == 'yearly_improvement'.toKey) {
      return 'play_more_play_better';
    } else {
      return 'play_more_play_better';
    }
  }

  String get _labelDesc6 {
    if (menu.toKey == 'yearly_improvement'.toKey) {
      return 'you_can_go_to_settings_and_turn_this_off';
    } else {
      return 'you_can_go_to_settings_and_turn_this_off';
    }
  }

  String get _labelDesc7 {
    if (menu.toKey == 'yearly_improvement'.toKey) {
      return 'you_can_go_to_settings_and_find_your_profile_and_enter_your_pdga_number';
    } else {
      return 'you_can_go_to_settings_and_find_your_profile_and_enter_your_pdga_number';
    }
  }
}
