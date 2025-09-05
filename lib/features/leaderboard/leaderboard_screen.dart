import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:app/animations/fade_animation.dart';
import 'package:app/components/app_lists/data_model_menu_list.dart';
import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/constants/app_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/leaderboard/components/leaderboard_dialog.dart';
import 'package:app/features/leaderboard/leaderboard_view_model.dart';
import 'package:app/features/leaderboard/units/players_list.dart';
import 'package:app/libraries/share_module.dart';
import 'package:app/models/system/data_model.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/services/app_analytics.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/library/svg_image.dart';

const _TABS_LIST = ['your_club', 'your_friends'];

class LeaderboardScreen extends StatefulWidget {
  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with SingleTickerProviderStateMixin {
  var _tabIndex = 0;
  var _viewModel = LeaderboardViewModel();
  var _modelData = LeaderboardViewModel();
  late TabController _tabController;

  @override
  void initState() {
    sl<AppAnalytics>().screenView('leaderboard-screen');
    sl<AppAnalytics>().logEvent(name: 'leaderboard_view');
    _tabController = TabController(length: _TABS_LIST.length, vsync: this);
    _tabController.addListener(() => setState(() => _tabIndex = _tabController.index));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<LeaderboardViewModel>(context, listen: false);
    _modelData = Provider.of<LeaderboardViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _viewModel.disposeViewModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackMenu(),
        title: Text('leaderboard'.recast),
        automaticallyImplyLeading: false,
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
    var label = _tabIndex == 0 ? _modelData.clubMenu.label.recast : _modelData.friendMenu.label.recast;
    final menuValue = _tabIndex == 0 ? _modelData.clubMenu.value : _modelData.friendMenu.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            SizedBox(width: Dimensions.screen_padding),
            Text(label, style: TextStyles.text24_600.copyWith(color: primary, fontWeight: w500, height: 1)),
            const SizedBox(width: 10),
            InkWell(onTap: () => leaderboardDialog(menu: menuValue), child: SvgImage(image: Assets.svg1.info, color: primary, height: 24)),
            SizedBox(width: Dimensions.screen_padding),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          height: 38,
          margin: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
          decoration: BoxDecoration(color: lightBlue, borderRadius: BorderRadius.circular(60)),
          child: TabBar(
            labelColor: primary,
            unselectedLabelColor: primary,
            controller: _tabController,
            indicator: BoxDecoration(color: skyBlue, borderRadius: BorderRadius.circular(60), border: Border.all(color: primary)),
            tabs: List.generate(_TABS_LIST.length, (index) => Tab(text: _TABS_LIST[index].recast)).toList(),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: const BouncingScrollPhysics(),
            children: [_yourClubView(context), _yourFriendView(context)],
          ),
        ),
      ],
    );
  }

  Widget _yourClubView(BuildContext context) {
    if (_modelData.loader.initial) return const SizedBox.shrink();
    var topPlayers = _modelData.clubLeaderboard.topPlayers;
    var otherPlayers = _modelData.clubLeaderboard.otherPlayers;
    if (otherPlayers.isEmpty && topPlayers.isEmpty) return _noMemberFound;
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 02),
        DataModelMenuList(menu: _modelData.clubMenu, menuItems: LEADERBOARD_CATEGORY_LIST, onTap: _modelData.onClubMenu),
        const SizedBox(height: 14),
        PlayersList(
          topPlayers: topPlayers,
          players: otherPlayers,
          gap: Dimensions.screen_padding,
          isImprovement: _modelData.clubMenu.value.toKey != 'rating'.toKey,
          onItem: (item) => Routes.user.player_profile(playerId: item.id!).push(),
        ),
        if (otherPlayers.isEmpty) _inviteApplication(true),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  Widget _yourFriendView(BuildContext context) {
    if (_modelData.loader.initial) return const SizedBox.shrink();
    var topPlayers = _modelData.friendLeaderboard.topPlayers;
    var otherPlayers = _modelData.friendLeaderboard.otherPlayers;
    if (otherPlayers.isEmpty && topPlayers.isEmpty) return _noMemberFound;
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 02),
        DataModelMenuList(menu: _modelData.friendMenu, menuItems: LEADERBOARD_CATEGORY_LIST, onTap: _modelData.onFriendMenu),
        const SizedBox(height: 14),
        PlayersList(
          players: otherPlayers,
          topPlayers: topPlayers,
          gap: Dimensions.screen_padding,
          isImprovement: _modelData.friendMenu.value.toKey != 'rating'.toKey,
          onItem: (item) => Routes.user.player_profile(playerId: item.id!).push(),
        ),
        if (otherPlayers.isEmpty) _inviteApplication(false),
        // _inviteClubMember(context),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  Widget get _noMemberFound {
    var descStyle = TextStyles.text14_400.copyWith(color: primary, letterSpacing: 0.42);
    return FadeAnimation(
      fadeKey: 'no_member_found',
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding + 20),
        child: Column(
          children: [
            SizedBox(height: 13.height),
            SvgImage(image: Assets.svg3.training, height: 16.height, color: primary),
            const SizedBox(height: 10),
            Text('no_player_found'.recast, style: TextStyles.text24_600.copyWith(color: primary, fontWeight: w500)),
            const SizedBox(height: 4),
            Text('its_more_fun_to_play_with_club_member_or_friends'.recast, textAlign: TextAlign.center, style: descStyle),
          ],
        ),
      ),
    );
  }

  Widget _inviteApplication(bool isClub) {
    return FadeAnimation(
      fadeKey: 'invite-club-members',
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding + 20),
        child: Column(
          children: [
            SizedBox(height: 3.height),
            Text(
              isClub ? 'invite_club_members'.recast : 'invite_your_friend'.recast,
              textAlign: TextAlign.center,
              style: TextStyles.text24_600.copyWith(color: primary, fontWeight: w500),
            ),
            const SizedBox(height: 4),
            Text.rich(
              textAlign: TextAlign.center,
              style: TextStyles.text14_400.copyWith(color: primary),
              TextSpan(
                text: isClub ? 'share_the_app_with_other_members_of'.recast : 'share_the_app_with_your_friends'.recast,
                children: [
                  const TextSpan(text: ' '),
                  TextSpan(text: isClub ? (_modelData.clubLeaderboard.clubName ?? '') : ''),
                  const TextSpan(text: ' '),
                  TextSpan(text: 'to_see_more_people_on_this_leaderboard'.recast),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevateButton(
              radius: 04,
              height: 36,
              padding: 36,
              onTap: _onShareApp,
              label: 'share_capty'.recast.toUpper,
              textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
            ),
          ],
        ),
      ),
    );
  }

  void _onShareApp() {
    var name = UserPreferences.user.name ?? '';
    var line1 = '${name.allFirstLetterCapital} ${'has_joined_the_app_capty'.recast}';
    var line2 = 'please_follow_this_link_so_that_you_can_compare_ratings_and_buy_sell_and_swap_discs_among_eachother'.recast;
    var message = '$line1. $line2\n$DEEPLINK_WELCOME';
    var params = ShareParams(title: 'capty_disc_golf_app'.recast, text: message, previewThumbnail: XFile(Assets.app.capty));
    sl<ShareModule>().shareUrl(params: params);
  }
}
