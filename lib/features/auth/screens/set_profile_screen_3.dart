import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/auth/view_models/set_profile_view_model.dart';
import 'package:app/features/home/units/nearest_clubs_list.dart';
import 'package:app/features/profile/units/profile_question_option.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/nav_button_box.dart';

class SetProfileScreen3 extends StatelessWidget {
  final Map<String, dynamic> data;
  const SetProfileScreen3({required this.data});

  @override
  Widget build(BuildContext context) {
    final modelData = Provider.of<SetProfileViewModel>(context);
    const borderRadius = BorderRadius.only(topLeft: Radius.circular(60));
    const decoration = BoxDecoration(color: primary, borderRadius: borderRadius);
    return Scaffold(
      backgroundColor: skyBlue,
      body: Container(
        width: SizeConfig.width,
        height: SizeConfig.height,
        padding: EdgeInsets.only(top: SizeConfig.statusBar),
        child: Stack(
          children: [
            Column(children: [SizedBox(height: 13.height), Expanded(child: Container(decoration: decoration))]),
            SizedBox(width: SizeConfig.width, height: SizeConfig.height, child: _screenView(context)),
            if (modelData.loader) const ScreenLoader(),
          ],
        ),
      ),
      bottomNavigationBar: NavButtonBox(childHeight: 42, loader: modelData.loader, child: _navButtonActions(context)),
    );
  }

  Widget _navButtonActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ElevateButton(
            radius: 04,
            height: 42,
            background: skyBlue,
            onTap: backToPrevious,
            label: 'back'.recast.toUpper,
            textStyle: TextStyles.text14_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
          ),
        ),
        const SizedBox(width: 08),
        Expanded(
          child: ElevateButton(
            radius: 04,
            height: 42,
            label: 'next'.recast.toUpper,
            onTap: () => Routes.auth.set_profile_4(data: data).push(),
            textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
          ),
        ),
      ],
    );
  }

  Widget _screenView(BuildContext context) {
    final modelData = Provider.of<SetProfileViewModel>(context);
    final showToggles = modelData.clubs.isEmpty || modelData.clubs.where((item) => item.is_member).toList().length == 0;
    final showClubs = modelData.clubs.isNotEmpty && (!modelData.isNoClub && !modelData.isNotMember);
    return Column(
      children: [
        SizedBox(height: 4.3.height),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgImage(image: Assets.app.capty, height: 32.5, color: primary),
            const SizedBox(width: 10),
            SvgImage(image: Assets.app.capty_name, height: 32, color: primary),
          ],
        ),
        SizedBox(height: 10.height),
        Text(
          'we_have_found_these_clubs'.recast,
          textAlign: TextAlign.center,
          style: TextStyles.text24_600.copyWith(color: lightBlue),
        ),
        Text(
          'are_you_a_member_in_any_of_these_clubs'.recast,
          textAlign: TextAlign.center,
          style: TextStyles.text14_400.copyWith(color: lightBlue),
        ),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            clipBehavior: Clip.antiAlias,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
            children: [
              const SizedBox(height: 20),
              if (showClubs)
                NearestClubsList(
                  clubs: modelData.clubs,
                  onJoin: modelData.onClubAction,
                  onLeft: modelData.onClubAction,
                ),
              const SizedBox(height: 24),
              if (showToggles)
                TweenListItem(
                  index: 1,
                  child: ProfileQuestionOption(
                    value: modelData.isNoClub,
                    label: 'my_club_is_not_here'.recast,
                    onToggle: (v) => modelData.onNoClub(),
                  ),
                ),
              if (showToggles) const SizedBox(height: 20),
              if (showToggles)
                TweenListItem(
                  index: 2,
                  child: ProfileQuestionOption(
                    value: modelData.isNotMember,
                    label: 'i_am_not_member_of_a_disc_golf_club'.recast,
                    onToggle: (v) => modelData.onNotAMember(),
                  ),
                ),
              SizedBox(height: BOTTOM_GAP),
            ],
          ),
        ),
      ],
    );
  }
}
