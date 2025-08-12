import 'dart:io';

import 'package:flutter/material.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/constants/app_constants.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/services/routes.dart';
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

const _DISABLED_NOTIFICATIONS = ['Wesley de Ridder', 'Lance DuBos', 'Shane Egelund'];
const _ENABLED_NOTIFICATIONS = ['adjust_club_details', 'edit_club_courses', 'control_other_relevant_club_data'];

Future<void> courseManagementDialog() async {
  var context = navigatorKey.currentState!.context;
  // sl<AppAnalytics>().screenView('course-management-popup');
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Course Management Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().topToBottom,
    pageBuilder: (buildContext, anim1, anim2) => PopScopeNavigator(canPop: false, child: Align(child: _DialogView())),
  );
}

class _DialogView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.height,
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
              const SizedBox(height: 24),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 15.height,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: SvgImage(image: Assets.svg3.training, color: mediumBlue, height: 15.height),
                  ),
                  Positioned(
                    top: -8,
                    right: -8,
                    child: InkWell(
                      onTap: backToPrevious,
                      child: SvgImage(image: Assets.svg1.close_1, color: skyBlue, height: 22),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                '${'do_you_want_to_be_admin_for'.recast} Singapore disc golf Club?',
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
                itemBuilder: (context, index) => _successItemCard(_ENABLED_NOTIFICATIONS[index].recast, index),
              ),
              SizedBox(height: 3.height),
              Text(
                '${'currently_the_club_admins_are'.recast}:',
                textAlign: TextAlign.start,
                style: TextStyles.text16_600.copyWith(color: lightBlue, fontWeight: w500),
              ),
              const SizedBox(height: 16),
              if ('rafi' != 'rafi')
                Padding(
                  padding: EdgeInsets.only(bottom: 6.height),
                  child: Text('there_are_currently_no_admins_of_this_club'.recast, style: TextStyles.text14_400.copyWith(color: lightBlue)),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  clipBehavior: Clip.antiAlias,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _DISABLED_NOTIFICATIONS.length,
                  padding: EdgeInsets.only(left: 6.width, right: 20),
                  separatorBuilder: (context, index) => SizedBox(height: index == _DISABLED_NOTIFICATIONS.length - 1 ? 0 : 10),
                  itemBuilder: (context, index) => _successItemCard(_DISABLED_NOTIFICATIONS[index], index),
                ),
              SizedBox(height: 4.height),
              Text(
                'all_club_maintenance_will_be_done_inside_a_web_administration'.recast,
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
          onTap: _onWebAdmin,
          label: 'go_to_web_admin'.recast.toUpper,
          textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  void _onWebAdmin() {
    backToPrevious();
    Routes.system.webview(title: 'course_management'.recast, url: COURSE_MANAGEMENT).push();
  }

  Widget _successItemCard(String item, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgImage(image: Assets.svg1.tick, height: 20, color: const Color(0xFF09AD00)),
        const SizedBox(width: 06),
        Expanded(child: Text(item, style: TextStyles.text14_400.copyWith(color: lightBlue, height: 1.35)))
      ],
    );
  }
}
