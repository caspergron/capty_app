import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/app_lists/sales_ads_list.dart';
import 'package:app/components/app_lists/upcoming_tournaments_list.dart';
import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/profile/view_models/player_profile_view_model.dart';
import 'package:app/preferences/user_preferences.dart';
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

class PlayerProfileScreen extends StatefulWidget {
  final int playerId;
  const PlayerProfileScreen({required this.playerId});

  @override
  State<PlayerProfileScreen> createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  var _modelData = PlayerProfileViewModel();
  var _viewModel = PlayerProfileViewModel();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('profile-screen');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel(widget.playerId));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<PlayerProfileViewModel>(context, listen: false);
    _modelData = Provider.of<PlayerProfileViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _viewModel.disposeViewModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var firstName = _modelData.player.first_name;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        leading: const BackMenu(),
        automaticallyImplyLeading: false,
        title: Text("$firstName ${firstName.isNotEmpty ? 'extra_s'.recast : ''} ${'profile'.recast}"),
      ),
      body: Container(
        width: SizeConfig.width,
        height: SizeConfig.height,
        decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
        child: Stack(children: [_screenView(context), if (_modelData.loader.loader) const ScreenLoader()]),
      ),
    );
  }

  Widget _screenView(BuildContext context) {
    var radius = const Radius.circular(12);
    var borderSide = const BorderSide(color: primary, width: 2);
    var borderAll = Border.all(color: primary, width: 2);
    var player = _modelData.player;
    var isRatingSection = player.is_pdga_or_total_club;
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 20),
        TweenListItem(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 41.height,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                margin: EdgeInsets.symmetric(horizontal: 12.width),
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(Assets.png_image.winner_cup_2), fit: BoxFit.fill),
                  borderRadius: BorderRadius.only(topLeft: radius, topRight: radius, bottomLeft: radius, bottomRight: radius),
                  border: Border(left: borderSide, right: borderSide, top: borderSide, bottom: borderSide),
                ),
                child: SvgImage(image: Assets.svg3.shield, height: 40.height, color: primary),
              ),
              if (isRatingSection)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: -62,
                  child: Container(
                    height: 70,
                    width: double.infinity,
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 12.width),
                    padding: const EdgeInsets.symmetric(vertical: 04, horizontal: 12),
                    decoration: BoxDecoration(
                      color: skyBlue,
                      borderRadius: BorderRadius.only(bottomLeft: radius, bottomRight: radius),
                      border: Border(left: borderSide, right: borderSide, bottom: borderSide),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _ProfileInfo(label: 'pdga_rating'.recast, value: (player.pdgaRating ?? 0).toDouble()),
                        _ProfileInfo(label: 'club_point'.recast),
                        _ProfileInfo(label: 'total_club'.recast, value: (player.totalClub ?? 0).toDouble()),
                      ],
                    ),
                  ),
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
                      image: _modelData.player.media?.url,
                      placeholder: const FadingCircle(size: 60),
                      errorWidget: SvgImage(image: Assets.svg1.coach, color: primary, height: 32.width),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 44.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(color: skyBlue, border: borderAll, borderRadius: BorderRadius.circular(06)),
                      child: Text(
                        _modelData.player.full_name,
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
        // const SizedBox(height: 10 + 10),
        SizedBox(height: (isRatingSection ? 70 : 10) + 10),
        if (UserPreferences.user.id == _modelData.player.id)
          Center(
            child: ElevateButton(
              radius: 04,
              height: 34,
              padding: 16,
              label: "${'view'.recast} ${'tournament_bag'.recast}".toUpper,
              onTap: _modelData.loader.loader ? null : Routes.user.tournament_discs(player: _modelData.player).push,
              textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
            ),
          )
        else
          Row(
            children: [
              SizedBox(width: 10.width),
              Expanded(
                child: ElevateButton(
                  radius: 04,
                  height: 34,
                  padding: 16,
                  label: "${'view'.recast} ${'tournament_bag'.recast}".toUpper,
                  onTap: _modelData.loader.loader ? null : Routes.user.tournament_discs(player: _modelData.player).push,
                  textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
                ),
              ),
              const SizedBox(width: 10),
              ElevateButton(
                radius: 04,
                height: 34,
                padding: 16,
                background: skyBlue,
                label: 'send_message'.recast.toUpper,
                onTap: _modelData.loader.loader ? null : Routes.user.chat(buddy: _modelData.player.chat_buddy).push,
                textStyle: TextStyles.text14_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
              ),
              SizedBox(width: 10.width),
            ],
          ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('club_name'.recast, style: TextStyles.text16_700.copyWith(color: lightBlue)),
                    const SizedBox(height: 06),
                    Text(
                      player.clubName ?? 'n/a'.recast,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.text14_400.copyWith(color: lightBlue),
                    ),
                    /*const SizedBox(height: 20),
                    Text('udisc_username'.recast, style: TextStyles.text16_700.copyWith(color: lightBlue)),
                    const SizedBox(height: 06),
                    Text(
                      player.uDiscUsername ?? 'n/a'.recast,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.text14_400.copyWith(color: lightBlue),
                    ),*/
                    const SizedBox(height: 02),
                  ],
                ),
              ),
              const SizedBox(width: 04),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('pdga_number'.recast, style: TextStyles.text16_700.copyWith(color: lightBlue)),
                  const SizedBox(height: 06),
                  Text(player.pdgaNumber ?? 'n/a'.recast, style: TextStyles.text14_400.copyWith(color: lightBlue)),
                  /*const SizedBox(height: 20),
                  Text('hand_expert'.recast, style: TextStyles.text16_700.copyWith(color: lightBlue)),
                  const SizedBox(height: 06),
                  Text(
                    player.handPref.toKey.isEmpty ? 'n/a'.recast : player.handPref.toKey.firstLetterCapital,
                    style: TextStyles.text14_400.copyWith(color: lightBlue),
                  ),*/
                  const SizedBox(height: 02),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        if (_modelData.upcomingTournaments.isNotEmpty)
          UpcomingTournamentsList(
            label: "${_modelData.player.first_name}'s",
            tournaments: _modelData.upcomingTournaments,
          ),
        if (_modelData.salesAdDiscs.isNotEmpty)
          SalesAdsList(
            label: "${_modelData.player.first_name}'s",
            salesAdsList: _modelData.salesAdDiscs,
            onItem: (item) => Routes.user.market_details(salesAd: item).push(),
          ),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
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

// casper Just signed up in Capty and joined the club Søhøjlandets Disc Golf. Join casper and compare PDGA rank and buy/sell disc
// https://www.capty.com/welcome
