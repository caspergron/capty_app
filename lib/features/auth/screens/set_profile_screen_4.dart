import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/auth/view_models/set_profile_view_model.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/circle_memory_image.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/nav_button_box.dart';

class SetProfileScreen4 extends StatelessWidget {
  final Map<String, dynamic> data;
  const SetProfileScreen4({required this.data});

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
            onTap: () => Provider.of<SetProfileViewModel>(context, listen: false).onSignUp(data),
            textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
          ),
        ),
      ],
    );
  }

  Widget _screenView(BuildContext context) {
    final modelData = Provider.of<SetProfileViewModel>(context);
    final isImage = modelData.avatar.unit8List != null;
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
        Text('upload_profile_photo'.recast, textAlign: TextAlign.center, style: TextStyles.text24_600.copyWith(color: lightBlue)),
        const SizedBox(height: 20),
        Text(
          'please_insert_a_picture_for_a_better_experience'.recast,
          textAlign: TextAlign.center,
          style: TextStyles.text14_400.copyWith(color: lightBlue),
        ),
        const SizedBox(height: 40),
        Center(
          child: CircleMemoryImage(
            radius: 88,
            borderWidth: 2,
            image: modelData.avatar.unit8List,
            errorWidget: Center(child: SvgImage(image: Assets.svg1.camera, color: mediumBlue, height: 100)),
          ),
        ),
        const SizedBox(height: 28),
        Center(
          child: ElevateButton(
            radius: 06,
            height: 38,
            padding: 20,
            background: skyBlue,
            label: isImage ? 'cancel_photo'.recast.toUpper : 'upload_new'.recast.toUpper,
            icon: SvgImage(height: 16, image: Assets.svg1.image_square, color: isImage ? error : primary),
            textStyle: TextStyles.text14_700.copyWith(color: isImage ? error : primary, height: 1.1),
            onTap: () => Provider.of<SetProfileViewModel>(context, listen: false).onUpload(),
          ),
        ),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }
}
