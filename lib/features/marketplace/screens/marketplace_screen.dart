import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/components/app_lists/menu_horizontal_list.dart';
import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/drawers/app_drawer.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/bell_menu.dart';
import 'package:app/components/menus/capty_menu.dart';
import 'package:app/components/menus/hamburger_menu.dart';
import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/marketplace/components/club_tag_info_dialog.dart';
import 'package:app/features/marketplace/components/edit_sales_ad_dialog.dart';
import 'package:app/features/marketplace/components/marketplace_flter_sheet.dart';
import 'package:app/features/marketplace/components/sales_ad_dialog.dart';
import 'package:app/features/marketplace/components/sold_info_dialog.dart';
import 'package:app/features/marketplace/components/tournament_tag_info_dialog.dart';
import 'package:app/features/marketplace/units/marketplace_category_list.dart';
import 'package:app/features/marketplace/units/sales_ad_grid_list.dart';
import 'package:app/features/marketplace/view_models/marketplace_view_model.dart';
import 'package:app/models/common/tag.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/services/app_analytics.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/exception/no_disc_found.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/row_label_placeholder.dart';

const _TABS_LIST = ['disc_listings', 'your_ads'];

class MarketplaceScreen extends StatefulWidget {
  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> with SingleTickerProviderStateMixin {
  var _viewModel = MarketplaceViewModel();
  var _modelData = MarketplaceViewModel();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _tabIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    // List<String> fruits = ['Apple', 'Banana', 'Orange'];
    // print(fruits[5]);
    sl<AppAnalytics>().screenView('marketplace-screen');
    _tabController = TabController(length: _TABS_LIST.length, vsync: this);
    _tabController.addListener(() => setState(() => _tabIndex = _tabController.index));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<MarketplaceViewModel>(context, listen: false);
    _modelData = Provider.of<MarketplaceViewModel>(context);
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
    );
  }

  Widget _screenView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            SizedBox(width: Dimensions.screen_padding),
            Expanded(
              child: Text(
                'marketplace'.recast,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.text24_600.copyWith(color: primary, fontWeight: w500, height: 1),
              ),
            ),
            const SizedBox(width: 10),
            // SvgImage(image: Assets.svg1.funnel, height: 24, color: primary),
            AnimatedSize(
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 400),
              child: RowLabelPlaceholder(
                height: 28,
                background: skyBlue,
                border: mediumBlue,
                label: _tabIndex == 0 ? 'filter_in_marketplace'.recast : 'share_sales_ad'.recast,
                icon: SvgImage(image: _tabIndex == 0 ? Assets.svg1.funnel : Assets.svg1.share, color: primary, height: 16),
                onTap: () => _tabIndex != 0
                    ? _viewModel.onShareSalesAd()
                    : marketplaceFilterSheet(filterOption: _modelData.filterOption, onFilter: _viewModel.onMarketplaceFilter),
              ),
            ),
            SizedBox(width: Dimensions.screen_padding),
          ],
        ),
        const SizedBox(height: 14),
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
        SizedBox(height: _tabIndex == 0 ? 10 : 06),
        if (!_modelData.loader.initial)
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: [_discListingView, _yourAdsView],
            ),
          ),
      ],
    );
  }

  Widget get _discListingView {
    var categories = _modelData.categories;
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 08),
        if (_modelData.tags.isNotEmpty) MenuHorizontalList(menuItems: _modelData.tags, menu: _modelData.tag, onTap: _onTag),
        const SizedBox(height: 02),
        categories.isEmpty
            ? const NoDiscFound()
            : MarketplaceCategoryList(categories: categories, onDiscItem: (v) => Routes.user.market_details(salesAd: v).push()),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  void _onTag(Tag item) {
    if (_modelData.tag.id.nullToInt == item.id.nullToInt) return;
    if (item.name.toKey == 'club'.toKey) {
      var clubs = _modelData.clubTournament.clubs ?? [];
      clubs.isEmpty ? _viewModel.onTag(item) : clubTagInfoDialog(clubs: clubs, onPositive: () => _viewModel.onTag(item));
    } else if (item.name.toKey == 'tournament') {
      var tournaments = _modelData.clubTournament.tournaments ?? [];
      tournaments.isEmpty
          ? _viewModel.onTag(item)
          : tournamentTagInfoDialog(tournaments: tournaments, onPositive: () => _viewModel.onTag(item));
    } else {
      _viewModel.onTag(item);
    }
  }

  Widget get _yourAdsView {
    if (_modelData.salesAdDiscs.isEmpty) return _noSalesAdDisc;
    var discList = [SalesAd(id: DEFAULT_ID), if (_modelData.salesAdDiscs.isNotEmpty) ..._modelData.salesAdDiscs];
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 12),
        SalesAdGridList(discList: discList, onDisc: _onSalesAdItem, onAdd: Routes.user.search_disc(index: 1).push),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  void _onSalesAdItem(SalesAd item, int index) => salesAdDialog(
        marketplace: item,
        onPrice: (value) => _viewModel.onUpdatePrice(value, item, index - 1),
        onSold: () => soldInfoDialog(marketplace: item, onSave: (params) => _viewModel.onMarkAsSold(params, item, index - 1)),
        onEdit: () => editSalesAdDiscDialog(
            marketplace: item, onSave: (params, docFile) => _viewModel.onUpdateSalesAdDisc(item, index - 1, params, docFile)),
        onRemove: () => _viewModel.onRemoveSalesAd(item, index),
      );

  Widget get _noSalesAdDisc {
    var subLabel = 'you_have_no_disc_available_now_please_add_your_sales_ad_disc'.recast;
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 05.height),
          SvgImage(image: Assets.svg3.empty_box, height: 34.width, color: primary),
          const SizedBox(height: 24),
          Text('no_sales_ad_disc_found'.recast, textAlign: TextAlign.center, style: TextStyles.text16_600.copyWith(color: primary)),
          const SizedBox(height: 02),
          Text(subLabel, textAlign: TextAlign.center, style: TextStyles.text14_400.copyWith(color: primary)),
          const SizedBox(height: 12),
          Center(
            child: ElevateButton(
              radius: 04,
              height: 40,
              padding: 40,
              background: skyBlue,
              label: 'add_sales_ad_disc'.recast.toUpper,
              onTap: Routes.user.search_disc(index: 1).push,
              textStyle: TextStyles.text14_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
            ),
          ),
        ],
      ),
    );
  }
}

// ShareLocationView(background: primary, margin: Dimensions.screen_padding),
// SizedBox(height: BOTTOM_GAP),
// NoPgdaInfo(background: primary, margin: Dimensions.screen_padding),
/*MarketplaceGridList(
          discList: _modelData.marketplaceDiscs,
          gap: Dimensions.screen_padding,
          onItem: (item, index) => Routes.user.market_details(disc: item).push(),
        ),*/
