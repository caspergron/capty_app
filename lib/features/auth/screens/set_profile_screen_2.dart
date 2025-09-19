import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/dialogs/location_tracking_dialog.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/auth/view_models/set_profile_view_model.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/nav_button_box.dart';

class SetProfileScreen2 extends StatelessWidget {
  final Map<String, dynamic> data;
  const SetProfileScreen2({required this.data});

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
    final viewModel = Provider.of<SetProfileViewModel>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ElevateButton(
            radius: 04,
            height: 42,
            background: skyBlue,
            label: 'tell_me_more'.recast.toUpper,
            textStyle: TextStyles.text14_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
            onTap: () => locationTrackingDialog(onAllow: () => viewModel.onAllowLocation(data), onNotAllow: _onNotAllow),
          ),
        ),
        const SizedBox(width: 08),
        Expanded(
          child: ElevateButton(
            radius: 04,
            height: 42,
            label: 'allow'.recast.toUpper,
            onTap: () => viewModel.onAllowLocation(data),
            textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
          ),
        ),
      ],
    );
  }

  void _onNotAllow() => Routes.auth.set_profile_4(data: data).push();

  Widget _screenView(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'can_we_search_for_disc_golf_clubs_using_your_current_location'.recast,
            textAlign: TextAlign.center,
            style: TextStyles.text24_600.copyWith(color: lightBlue),
          ),
        ),
        const SizedBox(height: 28),
        SvgImage(image: Assets.svg3.direction, height: 150),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'we_would_like_to_use_your_location_to_search_for_disc_golf_clubs_in_your_area'.recast,
            textAlign: TextAlign.center,
            style: TextStyles.text14_400.copyWith(color: lightBlue),
          ),
        ),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }
}
