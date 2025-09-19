import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/drawers/app_drawer.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/add_friend_menu.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/components/menus/bell_menu.dart';
import 'package:app/components/menus/capty_menu.dart';
import 'package:app/components/menus/hamburger_menu.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/friends/units/friend_request_list.dart';
import 'package:app/features/friends/units/friends_list.dart';
import 'package:app/features/friends/view_models/friends_view_model.dart';
import 'package:app/models/system/data_model.dart';
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

// const _TABS_LIST = ['friends', 'card_mates'];
const _TABS_LIST = ['friends', 'requests'];

class FriendsScreen extends StatefulWidget {
  final bool isHome;
  final int index;
  const FriendsScreen({required this.isHome, required this.index});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> with SingleTickerProviderStateMixin {
  var _viewModel = FriendsViewModel();
  var _modelData = FriendsViewModel();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;

  @override
  void initState() {
    sl<AppAnalytics>().screenView('friends-screen');
    _tabController = TabController(length: _TABS_LIST.length, vsync: this);
    _tabController.index = widget.index;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<FriendsViewModel>(context, listen: false);
    _modelData = Provider.of<FriendsViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _viewModel.disposeViewModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeBasedMenus = [const BellMenu(), ACTION_GAP, HamburgerMenu(scaffoldKey: _scaffoldKey), ACTION_SIZE];
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: AppDrawer(),
      appBar: AppBar(
        centerTitle: true,
        leading: widget.isHome ? null : const BackMenu(),
        automaticallyImplyLeading: false,
        title: widget.isHome ? CaptyMenu() : Text('friends'.recast),
        actions: !widget.isHome ? [if (_modelData.friends.isNotEmpty) AddFriendMenu(), ACTION_SIZE] : homeBasedMenus,
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
    return Column(
      children: [
        const SizedBox(height: 16),
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
        const SizedBox(height: 16),
        TweenListItem(index: -1, child: _yourFriendCard),
        const SizedBox(height: 10),
        if (!_modelData.loader.initial)
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: [_friendsView, _cardMatesView],
            ),
          ),
      ],
    );
  }

  Widget get _yourFriendCard {
    if (_modelData.friends.isEmpty) return const SizedBox.shrink();
    final style = TextStyles.text14_500.copyWith(color: lightBlue, height: 1);
    return Container(
      width: double.infinity,
      key: const Key('player--1'),
      margin: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          SvgImage(image: Assets.svg1.users, color: lightBlue, height: 24),
          const SizedBox(width: 12),
          Expanded(child: Text('your_friends'.recast, maxLines: 1, overflow: TextOverflow.ellipsis, style: style)),
          const SizedBox(width: 4),
          Text(_modelData.friends.length.formatInt, style: TextStyles.text18_700.copyWith(color: lightBlue, height: 1)),
        ],
      ),
    );
  }

  Widget get _friendsView {
    if (_modelData.friends.isEmpty) return _NoFriendFound(model: _FRIEND_NOT_FOUND);
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
      children: [
        const SizedBox(height: 04),
        Text('friends'.recast, style: TextStyles.text18_700.copyWith(color: primary)),
        const SizedBox(height: 16),
        FriendsList(
          friends: _modelData.friends,
          onDelete: _viewModel.onDeleteFriend,
          onItem: (item) => Routes.user.player_profile(playerId: item.id!).push(),
        ),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  Widget get _cardMatesView {
    if (_modelData.friendRequests.isEmpty) return _NoFriendFound(model: _REQUEST_NOT_FOUND);
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
      children: [
        // const SizedBox(height: 0),
        FriendRequestList(
          friends: _modelData.friendRequests,
          onConfirm: _viewModel.onAcceptRequest,
          onReject: _viewModel.onRejectRequest,
        ),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }
}

final _FRIEND_NOT_FOUND = DataModel(label: 'no_friend_found', value: 'you_have_not_added_any_friends_yet_add_your_first_friend_now');
final _REQUEST_NOT_FOUND = DataModel(label: 'no_request_found', value: 'no_requests_are_available_in_your_list_please_add_your_friend');

class _NoFriendFound extends StatelessWidget {
  final DataModel model;
  const _NoFriendFound({required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 40),
          SvgImage(image: Assets.svg1.coach_plus, height: 34.width, color: primary.colorOpacity(0.7)),
          const SizedBox(height: 14),
          Text(model.label.recast, textAlign: TextAlign.center, style: TextStyles.text16_600.copyWith(color: primary)),
          const SizedBox(height: 02),
          Text(model.value.recast, textAlign: TextAlign.center, style: TextStyles.text14_400.copyWith(color: primary)),
          const SizedBox(height: 14),
          ElevateButton(
            radius: 04,
            height: 40,
            width: 160,
            label: 'add_friend'.recast.toUpper,
            onTap: Routes.user.add_friend().push,
            textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
          )
        ],
      ),
    );
  }
}
