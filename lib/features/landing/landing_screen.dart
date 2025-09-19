import 'dart:io';

import 'package:flutter/material.dart';

import 'package:convex_bottom_bar/convex_bottom_bar.dart' as convex;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';

import 'package:app/components/dialogs/app_exit_dialog.dart';
import 'package:app/di.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/club/screens/club_screen.dart';
import 'package:app/features/disc_management/discs/discs_screen.dart';
import 'package:app/features/home/home_screeen.dart';
import 'package:app/features/landing/landing_view_model.dart';
import 'package:app/features/marketplace_management/marketplace/marketplace_screen.dart';
import 'package:app/libraries/app_updater.dart';
import 'package:app/libraries/cloud_notification.dart';
import 'package:app/libraries/permissions.dart';
import 'package:app/models/club/club.dart';
import 'package:app/models/system/data_model.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/core/spinner_menu.dart';
import 'package:app/widgets/library/svg_image.dart';

class LandingScreen extends StatefulWidget {
  static final GlobalKey<_LandingScreenState> landingKey = GlobalKey<_LandingScreenState>();
  final int index;
  const LandingScreen({required this.index, super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> with TickerProviderStateMixin {
  var _viewModel = LandingViewModel();
  var _modelData = LandingViewModel();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;

  @override
  void initState() {
    if (Platform.isAndroid) sl<CloudNotification>().getAndroidNotificationPermission();
    _tabController = TabController(length: BOTTOM_NAV_ITEMS.length, vsync: this);
    if (widget.index != 0) _tabController.animateTo(widget.index);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await sl<Permissions>().getLocationPermission();
      await sl<AppUpdater>().checkAppForceUpdate();
      final message = await FirebaseMessaging.instance.getInitialMessage();
      _viewModel.initViewModel(widget.index, message);
    });
    super.initState();
  }

  void changeTab(int index) {
    _tabController.animateTo(index);
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    SizeConfig.initMediaQuery(context);
    _viewModel = Provider.of<LandingViewModel>(context, listen: false);
    _modelData = Provider.of<LandingViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // log(sl<StorageService>().accessToken);
    return PopScopeNavigator(
      canPop: false,
      onPop: appExitDialog,
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedOpacity(
              curve: Curves.easeInOut,
              opacity: _modelData.expansion == 1 ? 0.8 : 1,
              duration: const Duration(milliseconds: 500),
              child: Builder(builder: (context) {
                if (_modelData.index == 0) {
                  return HomeScreen();
                } else if (_modelData.index == 1) {
                  return ClubScreen(club: Club(), isHome: true);
                  // return 1 == 1 ? ClubScreen(club: Club(), isHome: true) : const FriendsScreen(isHome: true);
                } else if (_modelData.index == 2) {
                  return Container();
                } else if (_modelData.index == 3) {
                  return DiscsScreen();
                } else if (_modelData.index == 4) {
                  return MarketplaceScreen();
                } else {
                  return Container();
                }
              }),
            ),
            if (_modelData.expansion == 1)
              InkWell(
                onTap: () => _viewModel.onSpinner(),
                child: Container(width: SizeConfig.width, height: SizeConfig.height, color: transparent),
              ),
            Positioned(
              bottom: -122,
              left: 0,
              right: 0,
              child: SpinnerMenu(
                height: 120,
                expansionStatus: _modelData.expansion,
                circleColors: const [lightBlue, white, orange],
                circleItems: SPINNER_MENU_ITEMS,
                itemOnTap: _viewModel.onSpinnerItem,
              ),
            ),
          ],
        ),
        bottomNavigationBar: MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          child: Container(
            color: primary,
            padding: EdgeInsets.only(bottom: BOTTOM_GAP_NAV),
            child: convex.StyleProvider(style: _ConvexStyle(), child: _bottomNavigationBar),
          ),
        ),
      ),
    );
  }

  convex.ConvexAppBar get _bottomNavigationBar {
    return convex.ConvexAppBar(
      height: 54,
      top: -24,
      controller: _tabController,
      elevation: 0,
      curveSize: 100,
      backgroundColor: primary,
      color: mediumBlue,
      activeColor: lightBlue,
      initialActiveIndex: _modelData.index,
      style: convex.TabStyle.fixedCircle,
      // disableDefaultTabController: true,
      items: _modelData.navItems.asMap().entries.map(_navbarItem).toList(),
      onTap: (index) => index == 2 ? null : _viewModel.updateView(index),
      disableDefaultTabController: true,
      onTabNotify: (i) {
        if (i == 2) _viewModel.onSpinner();
        return i != 2;
      },
    );
  }

  convex.TabItem<dynamic> _navbarItem(MapEntry<int, DataModel> entry) {
    final index = entry.key;
    final model = entry.value;
    if (index == 2) {
      const decoration = BoxDecoration(shape: BoxShape.circle, color: orange);
      final plusIcon = SvgImage(image: model.icon, height: 32, color: lightBlue);
      return convex.TabItem(icon: Container(decoration: decoration, alignment: Alignment.center, child: plusIcon));
    }
    const topGap = EdgeInsets.only(top: 04, bottom: 04);
    return convex.TabItem(
      title: model.label.recast,
      fontFamily: roboto,
      isIconBlend: true,
      icon: Padding(padding: topGap, child: SvgImage(image: model.icon, height: 24)),
      activeIcon: Padding(padding: topGap, child: SvgImage(image: model.icon, height: 24)),
    );
  }
}

class _ConvexStyle extends convex.StyleHook {
  @override
  double get activeIconSize => 24;

  @override
  double get activeIconMargin => 10;

  @override
  double get iconSize => 28;

  @override
  TextStyle textStyle(Color color, String? fontFamily) =>
      TextStyle(fontSize: 12, color: color, fontFamily: roboto, overflow: TextOverflow.ellipsis);
}
