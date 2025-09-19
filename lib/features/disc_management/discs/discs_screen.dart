import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

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
import 'package:app/features/disc_management/add_wishlist/components/add_to_wishlist_dialog.dart';
import 'package:app/features/disc_management/add_wishlist/components/edit_wishlist_dialog.dart';
import 'package:app/features/disc_management/discs/components/add_bag_dialog.dart';
import 'package:app/features/disc_management/discs/components/delete_bag_dialog.dart';
import 'package:app/features/disc_management/discs/discs_view_model.dart';
import 'package:app/features/disc_management/discs/units/disc_bags_list.dart';
import 'package:app/features/disc_management/discs/units/disc_grid_list.dart';
import 'package:app/features/disc_management/discs/units/wishlist_grid_list.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/disc/user_disc.dart';
import 'package:app/models/disc/wishlist.dart';
import 'package:app/models/disc_bag/disc_bag.dart';
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
import 'package:app/widgets/ui/icon_box.dart';

const _TABS_LIST = ['your_discs', 'wishlist'];
final _All_BAG = DiscBag(id: 1000001, name: 'all');
final _NEW_BAG = DiscBag(id: 1000002, name: 'plus_new_bag');

class DiscsScreen extends StatefulWidget {
  @override
  State<DiscsScreen> createState() => _DiscsScreenState();
}

class _DiscsScreenState extends State<DiscsScreen> with SingleTickerProviderStateMixin {
  var _tabIndex = 0;
  var _viewModel = DiscsViewModel();
  var _modelData = DiscsViewModel();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;

  @override
  void initState() {
    sl<AppAnalytics>().screenView('discs-screen');
    _tabController = TabController(length: _TABS_LIST.length, vsync: this);
    _tabController.addListener(() => setState(() => _tabIndex = _tabController.index));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<DiscsViewModel>(context, listen: false);
    _modelData = Provider.of<DiscsViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final selectedDiscs = _modelData.selectedDiscs;
    final loader = _modelData.loader.loader;
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: AppDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: CaptyMenu(),
        automaticallyImplyLeading: false,
        actions: [const BellMenu(), ACTION_GAP, HamburgerMenu(scaffoldKey: _scaffoldKey), ACTION_SIZE],
      ),
      body: Container(
        width: SizeConfig.width,
        height: SizeConfig.height,
        decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
        child: Stack(children: [_screenView(context), /*if (selectedDiscs.isNotEmpty) _navbarButtons,*/ if (loader) const ScreenLoader()]),
      ),
    );
  }

  Widget _screenView(BuildContext context) {
    final bagDiscs = _modelData.discBag.id == _All_BAG.id ? _modelData.allDiscs : _modelData.discBag.userDiscs ?? <UserDisc>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            SizedBox(width: Dimensions.screen_padding),
            Expanded(child: Text('your_discs'.recast, style: TextStyles.text24_600.copyWith(color: primary, fontWeight: w500, height: 1))),
            // if (_tabIndex == 0 && _modelData.selectedDiscs.isNotEmpty)
            /*IconBox(
                size: 28,
                background: primary,
                icon: SvgImage(image: Assets.svg1.delta, color: lightBlue, height: 19),
                onTap: Routes.user.flight_path(discs: _modelData.selectedDiscs).push,
              ),*/
            // if (_tabIndex == 0 && _modelData.selectedDiscs.isNotEmpty) const SizedBox(width: 10),
            if (_tabIndex == 0 && bagDiscs.isNotEmpty)
              IconBox(
                size: 28,
                background: primary,
                onTap: _onGridPath,
                icon: SvgImage(image: Assets.svg1.hash_1, color: lightBlue, height: 19),
              ),
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
        if (_tabIndex == 0)
          DiscBagsList(
            discBag: _modelData.discBag,
            discBags: [_All_BAG, ..._modelData.discBags, _NEW_BAG],
            onItem: (item) => _viewModel.onDiscBag(item),
            onAddBag: () => addDiscBagDialog(onSave: (params) => _viewModel.onCreateDisBag(params)),
            onAccept: (discItem, bagItem) => _onAcceptDragDisc(discItem.data, bagItem),
            onDelete: (bagItem) => deleteBagDialog(discBag: bagItem, onProceed: () => _viewModel.onDeleteBag(bagItem)),
          ),
        const SizedBox(height: 10),
        if (!_modelData.loader.initial)
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: [_yourDiscView, _wishlistView],
            ),
          ),
      ],
    );
  }

  void _onGridPath() {
    final allDiscs = _modelData.allDiscs;
    final allBag = DiscBag(id: 1000001, name: 'all_bag', displayName: 'all_bag', userDiscs: allDiscs, discCount: allDiscs.length);
    final bagsForGridPath = [allBag, ..._modelData.discBags];
    var bagIndex = 0;
    if (_modelData.discBag.id != _All_BAG.id) {
      final findIndex = _modelData.discBags.indexWhere((element) => element.id == _modelData.discBag.id);
      bagIndex = findIndex < 0 ? 0 : findIndex + 1;
    }
    Routes.user.grid_path(bags: bagsForGridPath, index: bagIndex).push();
  }

  void _onAcceptDragDisc(UserDisc disc, DiscBag targetBag) {
    final isInvalidBag = targetBag.id == _All_BAG.id || targetBag.id == _NEW_BAG.id;
    if (isInvalidBag) return FlushPopup.onInfo(message: 'you_can_not_move_disc_on_this_bag'.recast);
    final message = '${disc.name ?? 'this_disc'.recast} ${'already_in'.recast} ${targetBag.name ?? 'this_bag'.recast}';
    if (disc.bagId == targetBag.id) return FlushPopup.onInfo(message: message);
    final bodyParams = {'user_disc_id': disc.id, 'to_bag_id': targetBag.id};
    _viewModel.onMoveDiscToAnotherBag(bodyParams, targetBag.bag_menu_display_name);
  }

  Widget get _yourDiscView {
    final bagDiscs = _modelData.discBag.id == _All_BAG.id ? _modelData.allDiscs : _modelData.discBag.userDiscs ?? <UserDisc>[];
    if (bagDiscs.isEmpty) return _noDiscFound(tabIndex: 0);
    final discList = [UserDisc(id: DEFAULT_ID), if (bagDiscs.isNotEmpty) ...bagDiscs];
    return DiscGridList(
      discList: discList,
      gap: Dimensions.screen_padding,
      selectedItems: _modelData.selectedDiscs,
      // onSelect: _onSelectYourDisc,
      onAdd: Routes.user.search_disc(index: 0).push,
      onDisc: (item, index) => _viewModel.onDiscItem(item, index - 1),
    );
  }

  /*void _onSelectYourDisc(UserDisc item, int itemIndex) {
    final selectedItems = _modelData.selectedDiscs;
    final index = selectedItems.isEmpty ? -1 : selectedItems.indexWhere((element) => element.id == item.id);
    index < 0 ? _modelData.selectedDiscs.add(item) : _modelData.selectedDiscs.removeAt(index);
    setState(() {});
  }*/

  Widget get _wishlistView {
    final wishlistDiscs = _modelData.wishlistDiscs;
    if (wishlistDiscs.isEmpty) return _noDiscFound(tabIndex: 1);
    final discList = [Wishlist(id: DEFAULT_ID), if (wishlistDiscs.isNotEmpty) ...wishlistDiscs];
    return WishlistGridList(
      wishlistItems: discList,
      gap: Dimensions.screen_padding,
      onAdd: Routes.user.add_wishlist().push,
      onDisc: (item, index) => _onWishlistDiscItem(item, index - 1),
    );
  }

  void _onWishlistDiscItem(Wishlist item, int index) => addToWishlistDialog(
        added: true,
        wishlist: item,
        isEdit: true,
        onRemove: () => _viewModel.onRemoveFromWishlist(item, index),
        onEdit: () => editWishlistDisc(wishlist: item, onSave: (disc, isAddUpdate) => _viewModel.onUpdateWishlistDisc(index, disc)),
      );

  Widget _noDiscFound({required int tabIndex}) {
    final label = tabIndex == 0 ? 'no_disc_found' : 'no_wishlist_disc_found';
    final subLabel = tabIndex == 0
        ? 'you_have_no_disc_available_now_please_add_your_disc'
        : 'you_have_no_disc_available_now_please_add_your_wishlist_disc';
    final buttonLabel = tabIndex == 0 ? 'add_disc' : 'add_wishlist_disc';
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 04.height),
          SvgImage(image: Assets.svg3.empty_box, height: 34.width, color: primary),
          const SizedBox(height: 24),
          Text(label.recast, textAlign: TextAlign.center, style: TextStyles.text16_600.copyWith(color: primary)),
          const SizedBox(height: 02),
          Text(subLabel.recast, textAlign: TextAlign.center, style: TextStyles.text14_400.copyWith(color: primary)),
          const SizedBox(height: 12),
          Center(
            child: ElevateButton(
              radius: 04,
              height: 40,
              padding: 40,
              background: skyBlue,
              label: buttonLabel.recast.toUpper,
              onTap: tabIndex == 0 ? Routes.user.search_disc(index: 0).push : Routes.user.add_wishlist().push,
              textStyle: TextStyles.text14_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
            ),
          ),
        ],
      ),
    );
  }
}
