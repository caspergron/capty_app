import 'dart:async';

import 'package:flutter/material.dart';

import 'package:share_plus/share_plus.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/sheets_loader/all_set_loader_sheet.dart';
import 'package:app/constants/app_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/share_module.dart';
import 'package:app/models/user/user.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';

class SignedUpScreen extends StatefulWidget {
  final User user;
  const SignedUpScreen({required this.user});

  @override
  State<SignedUpScreen> createState() => _SignedUpScreenState();
}

class _SignedUpScreenState extends State<SignedUpScreen> {
  var loader = false;

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('signed-up-screen');
    Future.delayed(const Duration(milliseconds: 500), () => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, automaticallyImplyLeading: false, title: Text('profile'.recast)),
      body: Container(
        width: SizeConfig.width,
        height: SizeConfig.height,
        decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
        child: Stack(children: [_screenView(context), if (loader) const ScreenLoader()]),
      ),
    );
  }

  Widget _screenView(BuildContext context) {
    var user = widget.user;
    var radius = const Radius.circular(12);
    var borderSide = const BorderSide(color: primary, width: 2);
    var borderAll = Border.all(color: primary, width: 2);
    var isRatingSection = user.is_pdga_or_total_club;
    return Column(
      children: [
        const SizedBox(height: 20),
        TweenListItem(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: isRatingSection ? 36.height : 40.height,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                margin: EdgeInsets.symmetric(horizontal: 12.width),
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(Assets.png_image.winner_cup_2), fit: BoxFit.fill),
                  borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
                  border: Border(left: borderSide, right: borderSide, top: borderSide),
                ),
                child: SvgImage(image: Assets.svg3.shield, height: 40.height, color: primary),
              ),
              if (isRatingSection)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: -60,
                  child: Container(
                    height: 64,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 12.width),
                    padding: const EdgeInsets.symmetric(vertical: 04, horizontal: 12),
                    decoration: BoxDecoration(
                      color: skyBlue,
                      borderRadius: BorderRadius.only(bottomLeft: radius, bottomRight: radius),
                      border: Border(left: borderSide, right: borderSide, bottom: borderSide),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _ProfileInfo(label: 'pdga_rating'.recast, value: (user.pdgaRating ?? 0).toDouble()),
                        SizedBox(width: 10.width),
                        _ProfileInfo(label: 'total_club'.recast, value: (user.totalClub ?? 0).toDouble()),
                      ],
                    ),
                  ),
                ),
              Positioned(
                left: 0,
                right: 0,
                top: isRatingSection ? 6.2.height : 7.5.height,
                child: Column(
                  children: [
                    CircleImage(
                      radius: isRatingSection ? 22.width : 25.width,
                      borderWidth: 02,
                      borderColor: primary,
                      backgroundColor: skyBlue,
                      image: user.media?.url,
                      placeholder: const FadingCircle(size: 60),
                      errorWidget: SvgImage(image: Assets.svg1.coach, color: primary, height: 32.width),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 44.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(color: skyBlue, border: borderAll, borderRadius: BorderRadius.circular(06)),
                      child: Text(
                        user.first_name,
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
        ),
        SizedBox(height: (isRatingSection ? 70 : 10) + 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.width),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user.is_joined_club ? 'you_have_joined'.recast : 'your_account_has_been_created'.recast,
                textAlign: TextAlign.center,
                style: TextStyles.text20_500.copyWith(color: primary),
              ),
              if (user.is_joined_club)
                Text(
                  user.clubName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyles.text20_500.copyWith(color: primary, fontWeight: w700),
                ),
              const SizedBox(height: 16),
              SvgImage(image: Assets.app.capty, color: primary, height: 08.height),
              const SizedBox(height: 16),
              Text(
                user.is_joined_club
                    ? 'the_club_is_more_fun_when_your_club_members_are_here'.recast
                    : 'the_app_is_more_fun_when_your_friends_are_here'.recast,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyles.text20_500.copyWith(color: primary),
              )
            ],
          ),
        ),
        const Spacer(),
        Center(
          child: ElevateButton(
            radius: 04,
            height: 34,
            padding: 24,
            onTap: _onShare,
            label: 'invite_your_friends'.recast.toUpper,
            textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
          ),
        ),
        const SizedBox(height: 14),
        InkWell(
          onTap: _onDashboard,
          child: Text(
            'go_to_dashboard'.recast.toUpper,
            style: TextStyles.text12_600.copyWith(color: lightBlue, decoration: TextDecoration.underline, decorationThickness: 2),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  void _onShare() {
    var user = widget.user;
    var isClub = user.clubName != null;
    var name = user.name ?? 'your_friend'.recast.firstLetterCapital;
    var title = 'capty_a_disc_golf_marketplace'.recast;
    var messageLine1 =
        '${name.allFirstLetterCapital} ${'just_signed_up_in_capty'.recast} ${!isClub ? '' : '${'and_joined_the_club'.recast} ${user.clubName.allFirstLetterCapital}'}'
            .trim();
    var messageLine2 = '${'join'.recast} ${name.allFirstLetterCapital} ${'and_compare_pdga_rank_and_buy_sell_disc'.recast}'.trim();
    var message = '$messageLine1. $messageLine2\n$DEEPLINK_WELCOME';
    var params = ShareParams(title: title, text: message, previewThumbnail: XFile(Assets.app.capty));
    sl<ShareModule>().shareUrl(params: params);
  }

  Future<void> _onDashboard() async {
    unawaited(allSetLoaderSheet(desc: 'redirecting_to_your_homepage'));
    await Future.delayed(const Duration(milliseconds: 2500));
    backToPrevious();
    unawaited(Routes.user.landing().pushAndRemove());
  }
}

class _ProfileInfo extends StatelessWidget {
  final String label;
  final double value;

  const _ProfileInfo({this.value = 0, this.label = ''});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.formatDouble,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyles.text24_600.copyWith(color: primary, fontWeight: w500),
        ),
        Text(
          label,
          maxLines: 1,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.text12_600.copyWith(color: primary, fontWeight: w400),
        ),
      ],
    );
  }
}
