import 'package:app/components/drawers/app_drawer.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/auth_menu.dart';
import 'package:app/components/menus/capty_menu.dart';
import 'package:app/components/menus/hamburger_menu.dart';
import 'package:app/components/menus/home_menu.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/features/dashboard/view_models/public_marketplace_view_model.dart';
import 'package:app/features/marketplace/units/marketplace_category_list.dart';
import 'package:app/models/public/country.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/exception/no_disc_found.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PublicMarketplaceScreen extends StatefulWidget {
  final Country country;
  const PublicMarketplaceScreen({required this.country});

  @override
  State<PublicMarketplaceScreen> createState() => _PublicMarketplaceScreenState();
}

class _PublicMarketplaceScreenState extends State<PublicMarketplaceScreen> {
  var _viewModel = PublicMarketplaceViewModel();
  var _modelData = PublicMarketplaceViewModel();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('notification-preference-screen');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel(widget.country));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<PublicMarketplaceViewModel>(context, listen: false);
    _modelData = Provider.of<PublicMarketplaceViewModel>(context);
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
      key: _scaffoldKey,
      endDrawer: AppDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: CaptyMenu(),
        leading: const AuthMenu(),
        actions: [const HomeMenu(), ACTION_GAP, HamburgerMenu(scaffoldKey: _scaffoldKey), ACTION_SIZE],
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
    if (_modelData.loader.initial) return const SizedBox.shrink();
    if (_modelData.categories.isEmpty) return NoDiscFound(height: 15.height);
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 14),
        MarketplaceCategoryList(
          isModifiedData: true,
          categories: _modelData.categories,
          onDiscItem: (v) => _viewModel.fetchMarketplaceDiscDetails(v),
        ),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }
}
