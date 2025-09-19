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
import 'package:app/utils/size_config.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/svg_image.dart';

const _ENABLED_NOTIFICATIONS = [
  'see_used_discs_for_sale_close_to_where_you_are',
  'connect_with_disc_golfers_in_your_area_when_you_travel',
  'notify_you_if_you_are_in_close_proximity_of_a_great_course',
];

const _DISABLED_NOTIFICATIONS = [
  'sharing_with_third_party_where_you_are',
  'saving_any_history_of_your_location',
  'purposes_that_has_no_value_for_you',
];

Future<void> locationTrackingDialog({Function()? onAllow, Function()? onNotAllow}) async {
  final context = navigatorKey.currentState!.context;
  // sl<AppAnalytics>().screenView('location-tracking-popup');
  final child = Align(child: _DialogView(onAllow, onNotAllow));
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Location Tracking Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().topToBottom,
    pageBuilder: (buildContext, anim1, anim2) => PopScopeNavigator(canPop: false, child: child),
  );
}

class _DialogView extends StatelessWidget {
  final Function()? onAllow;
  final Function()? onNotAllow;
  const _DialogView(this.onAllow, this.onNotAllow);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.height,
      width: Dimensions.dialog_width + 10,
      margin: EdgeInsets.only(top: SizeConfig.statusBar + 20, bottom: 32),
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
              const SizedBox(height: 10),
              Center(child: SvgImage(image: Assets.svg3.stash_location, height: 136)),
              const SizedBox(height: 02),
              Text(
                'why_say_yes_to_tracking_location'.recast,
                textAlign: TextAlign.center,
                style: TextStyles.text24_600.copyWith(color: lightBlue, fontWeight: w500),
              ),
              SizedBox(height: 4.height),
              Text(
                '${'you_will_get_these_options'.recast.toUpper}:',
                textAlign: TextAlign.start,
                style: TextStyles.text16_600.copyWith(color: lightBlue, fontWeight: w500),
              ),
              SizedBox(height: 2.2.height),
              ListView.separated(
                shrinkWrap: true,
                clipBehavior: Clip.antiAlias,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _ENABLED_NOTIFICATIONS.length,
                padding: EdgeInsets.only(left: 6.width, right: 20),
                separatorBuilder: (context, index) => SizedBox(height: index == _ENABLED_NOTIFICATIONS.length - 1 ? 0 : 16),
                itemBuilder: (context, index) {
                  final item = _ENABLED_NOTIFICATIONS[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgImage(image: Assets.svg1.tick, height: 20, color: const Color(0xFF09AD00)),
                      const SizedBox(width: 06),
                      Expanded(child: Text(item.recast, style: TextStyles.text14_400.copyWith(color: lightBlue, height: 1.35)))
                    ],
                  );
                },
              ),
              SizedBox(height: 3.5.height),
              Text(
                '${'we_will_not_use_your_location_for'.recast.toUpper}:',
                textAlign: TextAlign.start,
                style: TextStyles.text16_600.copyWith(color: lightBlue, fontWeight: w500),
              ),
              SizedBox(height: 2.2.height),
              ListView.separated(
                shrinkWrap: true,
                clipBehavior: Clip.antiAlias,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _DISABLED_NOTIFICATIONS.length,
                padding: EdgeInsets.only(left: 6.width, right: 20),
                separatorBuilder: (context, index) => SizedBox(height: index == _ENABLED_NOTIFICATIONS.length - 1 ? 0 : 16),
                itemBuilder: (context, index) {
                  final item = _DISABLED_NOTIFICATIONS[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgImage(image: Assets.svg1.close_1, height: 20, color: const Color(0xFFF30808)),
                      const SizedBox(width: 06),
                      Expanded(child: Text(item.recast, style: TextStyles.text14_400.copyWith(color: lightBlue, height: 1.35)))
                    ],
                  );
                },
              ),
              SizedBox(height: 3.height),
              Text(
                'in_your_setting_area_you_will_always_be_able_to_turn_location_on_and_off'.recast,
                textAlign: TextAlign.center,
                style: TextStyles.text16_600.copyWith(color: lightBlue, fontWeight: w500),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ElevateButton(
          radius: 04,
          height: 42,
          width: 35.width,
          label: 'allow'.recast.toUpper,
          onTap: _onAllow,
          textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
        ),
        const SizedBox(height: 20),
        InkWell(
          onTap: onNotAllow == null ? backToPrevious : _onNotAllow,
          child: Text(
            'do_not_allow'.recast.toUpper,
            textAlign: TextAlign.center,
            style: TextStyles.text12_600.copyWith(color: lightBlue, fontWeight: w400, decoration: TextDecoration.underline),
          ),
        ),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  void _onAllow() {
    if (onAllow != null) onAllow!();
    backToPrevious();
  }

  void _onNotAllow() {
    backToPrevious();
    onNotAllow!();
  }
}
