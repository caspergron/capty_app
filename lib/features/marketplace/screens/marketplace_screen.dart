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
import 'package:app/features/marketplace/components/search_input_dialog.dart';
import 'package:app/features/marketplace/components/sold_info_dialog.dart';
import 'package:app/features/marketplace/components/tournament_tag_info_dialog.dart';
import 'package:app/features/marketplace/units/marketplace_category_list.dart';
import 'package:app/features/marketplace/units/sales_ad_grid_list.dart';
import 'package:app/features/marketplace/view_models/marketplace_view_model.dart';
import 'package:app/models/common/tag.dart';
import 'package:app/models/marketplace/marketplace_filter.dart';
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
import 'package:app/widgets/ui/icon_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const _TABS_LIST = ['disc_listings', 'your_ads', 'favourites'];

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
            if (_tabIndex == 0)
              Row(
                children: [
                  IconBox(
                    size: 28,
                    background: _modelData.searchKey.isEmpty ? orange : primary,
                    icon: SvgImage(image: Assets.svg1.funnel, color: lightBlue, height: 19),
                    onTap: () => marketplaceFilterSheet(filterOption: _modelData.filterOption, onFilter: _viewModel.onMarketplaceFilter),
                  ),
                  const SizedBox(width: 10),
                  IconBox(
                    size: 28,
                    background: _modelData.searchKey.isEmpty ? primary : orange,
                    icon: SvgImage(image: Assets.svg1.search_2, color: lightBlue, height: 19),
                    onTap: () => searchInputDialog(searchKey: _modelData.searchKey, onFilter: (v) => _viewModel.onSearch(v)),
                  ),
                ],
              )
            else if (_tabIndex == 1)
              const SizedBox.shrink()
            /*RowLabelPlaceholder(
                height: 28,
                background: skyBlue,
                border: mediumBlue,
                label: 'share_sales_ad'.recast,
                icon: SvgImage(image: Assets.svg1.share, color: primary, height: 16),
                onTap: () => _viewModel.onShareSalesAd(),
              )*/
            else
              const SizedBox.shrink(),
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
              children: [_discListingView, _yourAdsView, _favouriteDiscsView],
            ),
          ),
      ],
    );
  }

  Widget get _discListingView {
    var categories = _modelData.categories;
    var showTags = _modelData.tags.isNotEmpty && _modelData.searchKey.isEmpty;
    var searchLabel = '${'search_result_for'.recast}: ${_modelData.searchKey}';
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      children: [
        SizedBox(height: showTags ? 06 : 0),
        Builder(builder: (context) {
          if (showTags) return MenuHorizontalList(menuItems: _modelData.tags, menu: _modelData.tag, onTap: _onTag);
          return Row(
            children: [
              SizedBox(width: Dimensions.screen_padding),
              Expanded(child: Text(searchLabel, style: TextStyles.text18_600.copyWith(color: dark))),
              InkWell(onTap: _onClear, child: Text('clear_search'.recast, style: TextStyles.text16_600.copyWith(color: orange))),
              SizedBox(width: Dimensions.screen_padding),
            ],
          );
        }),
        const SizedBox(height: 04),
        if (categories.isNotEmpty)
          MarketplaceCategoryList(
            categories: categories,
            onSetFav: (item) => _viewModel.onSetAsFavourite(item),
            onRemoveFav: (item) => _viewModel.onRemoveFromFavourite(item),
            onDiscItem: (item) => Routes.user.market_details(salesAd: item).push(),
          )
        else
          const NoDiscFound(),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  void _onClear() {
    _modelData.searchKey = '';
    _modelData.filterOption = MarketplaceFilter(types: [], brands: [], tags: []);
    if (_modelData.tags.isNotEmpty) _modelData.tag = _modelData.tags.first;
    setState(() {});
    _modelData.generateFilterUrl(isLoader: true);
  }

  void _onTag(Tag item) {
    if (_modelData.tag.id.nullToInt == item.id.nullToInt) return;
    if (item.name.toKey == 'club'.toKey) {
      var clubs = _modelData.clubTournament.clubs ?? [];
      clubs.isEmpty ? _viewModel.onTag(item) : clubTagInfoDialog(clubs: clubs, onPositive: () => _viewModel.onTag(item));
    } else if (item.name.toKey == 'tournament') {
      var tournaments = _modelData.clubTournament.tournaments ?? [];
      if (tournaments.isEmpty) return _viewModel.onTag(item);
      tournamentTagInfoDialog(tournaments: tournaments, onPositive: () => _viewModel.onTag(item));
    } else {
      _viewModel.onTag(item);
    }
  }

  Widget get _yourAdsView {
    if (_modelData.salesAdDiscs.isEmpty) return _NoSalesAdFound();
    var discList = [SalesAd(id: DEFAULT_ID), if (_modelData.salesAdDiscs.isNotEmpty) ..._modelData.salesAdDiscs];
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      controller: _viewModel.salesAdScrollControl,
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
        onEdit: () => editSalesAdDiscDialog(marketplace: item, onSave: (p, d) => _viewModel.onUpdateSalesAdDisc(item, index - 1, p, d)),
        onRemove: () => _viewModel.onRemoveSalesAd(item, index),
      );

  Widget get _favouriteDiscsView {
    var categories = _modelData.favCategories;
    if (categories.isEmpty) return NoDiscFound(height: 09.height, label: 'no_favourite_disc_found');
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 04),
        MarketplaceCategoryList(
          categories: categories,
          onSetFav: (item) => _viewModel.onSetAsFavourite(item),
          onRemoveFav: (item) => _viewModel.onRemoveFromFavourite(item),
          onDiscItem: (v) => Routes.user.market_details(salesAd: v).push(),
        ),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }
}

class _NoSalesAdFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 05.height),
          SvgImage(image: Assets.svg3.empty_box, height: 34.width, color: primary),
          const SizedBox(height: 24),
          Text(
            'no_sales_ad_disc_found'.recast,
            textAlign: TextAlign.center,
            style: TextStyles.text16_600.copyWith(color: primary),
          ),
          const SizedBox(height: 02),
          Text(
            'you_have_no_disc_available_now_please_add_your_sales_ad_disc'.recast,
            textAlign: TextAlign.center,
            style: TextStyles.text14_400.copyWith(color: primary),
          ),
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
