import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/app_lists/new_messages_list.dart';
import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/drawers/app_drawer.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/bell_menu.dart';
import 'package:app/components/menus/capty_menu.dart';
import 'package:app/components/menus/hamburger_menu.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/home/components/joining_clubs_sheet.dart';
import 'package:app/features/home/home_view_model.dart';
import 'package:app/features/home/units/closest_club_events.dart';
import 'package:app/features/landing/landing_screen.dart';
import 'package:app/features/landing/landing_view_model.dart';
import 'package:app/features/notification/notifications_view_model.dart';
import 'package:app/helpers/enums.dart';
import 'package:app/libraries/locations.dart';
import 'package:app/models/chat/chat_message.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _modelData = HomeViewModel();
  var _viewModel = HomeViewModel();
  var _notifyModel = NotificationsViewModel();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('home-screen');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<HomeViewModel>(context, listen: false);
    _modelData = Provider.of<HomeViewModel>(context);
    _notifyModel = Provider.of<NotificationsViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: AppDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: CaptyMenu(),
        actions: [const BellMenu(), ACTION_GAP, HamburgerMenu(scaffoldKey: _scaffoldKey), ACTION_SIZE],
      ),
      body: Container(
        width: SizeConfig.width,
        height: SizeConfig.height,
        decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
        child: Stack(children: [_screenView(context), if (_modelData.loader.loader) const ScreenLoader()]),
      ),
      // floatingActionButton: _modelData.clubInfo.id == null ? null : _floatingButton,
    );
  }

  /*Widget get _floatingButton {
    return const FloatingActionButton(
      mini: true,
      backgroundColor: mediumBlue,
      child: Icon(Icons.add, color: dark, size: 24),
      onPressed: joiningClubsSheet,
    );
  }*/

  Widget _screenView(BuildContext context) {
    var isClub = _modelData.clubInfo.id != null;
    var user = UserPreferences.user;
    var clubEvents = _modelData.clubEvents;
    var isInitLoad = _modelData.loader.initial;
    var colorFilter = const ColorFilter.mode(primary, BlendMode.lighten);
    var count = _modelData.dashboardCount;
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 14),
        Container(
          height: 120,
          width: double.infinity,
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(image: AssetImage(Assets.png_image.challenge_banner), fit: BoxFit.cover, colorFilter: colorFilter),
          ),
          child: Text.rich(
            TextSpan(
              text: 'hello'.recast + ' ',
              children: [
                TextSpan(text: '${user.first_name}!', recognizer: TapGestureRecognizer()..onTap = () => Routes.user.profile().push())
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.visible,
            style: TextStyles.text40_700.copyWith(color: lightBlue, fontWeight: w500),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: Dimensions.screen_padding),
            Expanded(
              child: Text(
                'your_club'.recast.allFirstLetterCapital,
                style: TextStyles.text18_700.copyWith(color: primary, letterSpacing: 0.54),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                count.is_pdga ? 'leaderboards'.recast : 'your_discs'.recast,
                style: TextStyles.text18_700.copyWith(color: primary, letterSpacing: 0.54),
              ),
            ),
            SizedBox(width: Dimensions.screen_padding),
          ],
        ),
        const SizedBox(height: 08),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: Dimensions.screen_padding),
            Expanded(
              child: isClub
                  ? _DummyCLubViewInfo()
                  /*_DashboardInfo(
                      label: 'club_points'.recast,
                      value: 24,
                      icon: Assets.svg3.pgda_rating_1,
                      iconSize: 14.height,
                      buttonLabel: 'open_club_view'.recast.toUpper,
                      buttonIcon: Assets.app.capty,
                      onTap: _goToClub,
                    )*/
                  : _NoClubView(),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _DashboardInfo(
                isLeft: false,
                iconSize: 12.height,
                icon: Assets.svg3.training,
                showArrow: count.is_pdga,
                isPositive: count.is_positive,
                value: count.is_pdga ? count.pgdaRating.nullToInt : count.totalDisc.nullToInt,
                buttonLabel: count.is_pdga ? 'open_leaderboards'.recast.toUpper : 'disc_management'.recast.toUpper,
                buttonIcon: count.is_pdga ? Assets.svg1.challenge : Assets.svg1.disc_1,
                onTap: count.is_pdga ? Routes.user.leaderboard().push : _goToDiscManagement,
                label: count.is_pdga ? 'pdga_rating'.recast : 'discs_in_bag'.recast,
              ),
            ),
            SizedBox(width: Dimensions.screen_padding),
          ],
        ),
        if (!isInitLoad) const SizedBox(height: 16),
        if (!isInitLoad && clubEvents.isNotEmpty) ClosestClubEvents(events: clubEvents, onShareLocation: _onShareLocation),
        if (!isInitLoad && clubEvents.isNotEmpty) const SizedBox(height: 04),
        if (!isInitLoad && _newMessages.isNotEmpty) NewMessagesList(messages: _newMessages, onTap: _onChatMessage),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  void _onChatMessage(ChatMessage item) {
    Routes.user.chat(buddy: item.chat_buddy).push();
    var context = navigatorKey.currentState!.context;
    Provider.of<NotificationsViewModel>(context, listen: false).setReadStatus(item);
  }

  List<ChatMessage> get _newMessages {
    var messages = _notifyModel.messageFeeds;
    if (messages.isEmpty) return [];
    var userId = UserPreferences.user.id.nullToInt;
    var newMessages = messages.where((item) => (item.senderId != userId) && (item.readTime == null)).toList();
    return newMessages;
  }

  /*void _goToClub() {
    LandingScreen.landingKey.currentState?.changeTab(1);
    Provider.of<LandingViewModel>(context, listen: false).updateView(1);
  }*/

  void _goToDiscManagement() {
    LandingScreen.landingKey.currentState?.changeTab(3);
    Provider.of<LandingViewModel>(context, listen: false).updateView(3);
  }

  Future<void> _onShareLocation() async {
    var coordinates = await sl<Locations>().fetchLocationPermission();
    if (!coordinates.is_coordinate) return;
  }
}

class _DashboardInfo extends StatelessWidget {
  final String label;
  final int value;
  final String icon;
  final double iconSize;
  final bool isLeft;
  final String buttonLabel;
  final String buttonIcon;
  final bool showArrow;
  final bool isPositive;
  final Function()? onTap;

  const _DashboardInfo({
    this.isLeft = true,
    this.value = 0,
    this.label = '',
    this.icon = '',
    this.iconSize = 150,
    this.buttonLabel = '',
    this.buttonIcon = '',
    this.showArrow = false,
    this.isPositive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var arrowIcon = isPositive ? Assets.svg1.arrow_up : Assets.svg1.arrow_down;
    return TweenListItem(
      twinAnim: TwinAnim.right_to_left,
      child: Stack(
        children: [
          Container(
            height: 22.height,
            width: double.infinity,
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
            child: SvgImage(image: icon, height: iconSize, color: skyBlue.colorOpacity(0.25)),
          ),
          Container(
            height: 22.height,
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('$value', style: TextStyles.text40_700.copyWith(color: lightBlue, fontWeight: w400)),
                    if (showArrow) const SizedBox(width: 5),
                    if (showArrow) SvgImage(image: arrowIcon, height: 28, color: isPositive ? success : error),
                  ],
                ),
                Text(label, style: TextStyles.text14_500.copyWith(color: lightBlue)),
                const Spacer(),
                ElevateButton(
                  radius: 04,
                  height: 26,
                  onTap: onTap,
                  width: double.infinity,
                  label: buttonLabel,
                  icon: SvgImage(image: buttonIcon, height: 18, color: lightBlue),
                  background: mediumBlue,
                  textStyle: TextStyles.text10_400.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DummyCLubViewInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TweenListItem(
      twinAnim: TwinAnim.right_to_left,
      child: Stack(
        children: [
          Container(
            height: 22.height,
            width: double.infinity,
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
            child: SvgImage(image: Assets.svg3.pgda_rating_1, height: 14.height, color: skyBlue.colorOpacity(0.25)),
          ),
          Container(
            height: 22.height,
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('⏳', style: TextStyle(fontSize: 36)),
                Text('under_development'.recast, style: TextStyles.text14_500.copyWith(color: lightBlue)),
                const Spacer(),
                ElevateButton(
                  radius: 04,
                  height: 26,
                  width: double.infinity,
                  label: 'open_club_view'.recast.toUpper,
                  icon: SvgImage(image: Assets.app.capty, height: 18, color: lightBlue),
                  background: mediumBlue,
                  textStyle: TextStyles.text10_400.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
                  onTap: () {
                    LandingScreen.landingKey.currentState?.changeTab(1);
                    Provider.of<LandingViewModel>(context, listen: false).updateView(1);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NoClubView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22.height,
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: skyBlue, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          SizedBox(height: 4.height),
          Text(
            'are_you_a_member_of_a_disc_golf_club'.recast,
            textAlign: TextAlign.center,
            style: TextStyles.text13_600.copyWith(color: primary),
          ),
          const Spacer(),
          ElevateButton(
            radius: 04,
            height: 22,
            padding: 20,
            background: mediumBlue,
            label: 'no_club'.recast.toUpper,
            textStyle: TextStyles.text10_400.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
          ),
          const SizedBox(height: 10),
          ElevateButton(
            radius: 04,
            height: 28,
            width: double.infinity,
            onTap: joiningClubsSheet,
            label: 'choose_a_club'.recast.toUpper,
            textStyle: TextStyles.text12_600.copyWith(color: lightBlue, height: 1.15),
          ),
        ],
      ),
    );
  }
}
