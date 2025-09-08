import 'dart:async';

import 'package:app/components/app_lists/parent_disc_horizontal_list.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/components/menus/prefix_menu.dart';
import 'package:app/components/menus/suffix_menu.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/disc_management/add_wishlist/components/add_to_wishlist_dialog.dart';
import 'package:app/features/disc_management/add_wishlist/components/edit_wishlist_dialog.dart';
import 'package:app/features/disc_management/add_wishlist/view_models/add_wishlist_view_model.dart';
import 'package:app/models/disc/parent_disc.dart';
import 'package:app/models/disc/wishlist.dart';
import 'package:app/services/app_analytics.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddWishlistScreen extends StatefulWidget {
  @override
  State<AddWishlistScreen> createState() => _AddWishlistScreenState();
}

class _AddWishlistScreenState extends State<AddWishlistScreen> {
  var _focusNode = FocusNode();
  var _viewModel = AddWishlistViewModel();
  var _modelData = AddWishlistViewModel();
  var _search = TextEditingController();

  @override
  void initState() {
    sl<AppAnalytics>().screenView('add-wishlist-screen');
    _focusNode.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<AddWishlistViewModel>(context, listen: false);
    _modelData = Provider.of<AddWishlistViewModel>(context);
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
        title: Text('add_a_disc_to_wishlist'.recast),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: SizeConfig.width,
        height: SizeConfig.height,
        decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
        child: Stack(children: [_screenView(context), if (_modelData.loader) const ScreenLoader()]),
      ),
    );
  }

  Widget _screenView(BuildContext context) {
    var gap = Dimensions.screen_padding;
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(height: 16),
        Stack(
          children: [
            Container(
              height: 132,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: gap),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
            ),
            Positioned(right: 6, bottom: 0, child: SvgImage(image: Assets.svg3.circle_putting, height: 64, color: mediumBlue)),
            Positioned(
              top: 14,
              bottom: 14,
              left: gap + 14,
              right: gap + 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _searchDiscListItems,
              ),
            ),
          ],
        ),
        const SizedBox(height: 08),
        if (_modelData.discList.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: gap),
            child: Text('discs'.recast, style: TextStyles.text18_700.copyWith(color: primary, letterSpacing: 0.54)),
          ),
          const SizedBox(height: 08),
          ParentDiscHorizontalList(discs: _modelData.discList, onTap: _onWishlist, onFav: _onWishlist),
        ],
        const SizedBox(height: 06),
        /*Stack(
          children: [
            Container(
              height: 140,
              width: SizeConfig.width,
              margin: EdgeInsets.symmetric(horizontal: gap),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
            ),
            Positioned(right: 10, bottom: 0, child: SvgImage(image: Assets.svg3.pgda_rating_1, height: 105, color: mediumBlue)),
            Positioned(
              top: 14,
              bottom: 14,
              left: gap + 14,
              right: gap + 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _pgdaApprovedListItems,
              ),
            ),
          ],
        ),*/
        // const SizedBox(height: 16),
        /*Stack(
          children: [
            Container(
              height: 160,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: gap),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
            ),
            Positioned(right: 0, bottom: 0, child: SvgImage(image: Assets.svg3.training, height: 90, color: mediumBlue)),
            Positioned(
              top: 14,
              bottom: 14,
              left: gap + 14,
              right: gap + 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _askAiListItems,
              ),
            ),
          ],
        ),*/
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  Future<void> _onWishlist(ParentDisc item, int index) async {
    minimizeKeyboard();
    var added = item.is_wishListed;
    var wishlist = Wishlist(id: item.wishlistId, disc: item);
    await Future.delayed(const Duration(milliseconds: 200));
    unawaited(addToWishlistDialog(
      wishlist: wishlist,
      added: added,
      // onAdd: () => _viewModel.onAddedToWishlist(item, index),
      onRemove: () => _viewModel.onRemoveFromWishlist(item.wishlistId!, index),
      onEdit: () => editWishlistDisc(wishlist: wishlist, isUpdateAndAdd: true, onSave: (w, s) => _viewModel.onUpdateAndAddWishList(w)),
    ));
  }

  void _onClose() {
    _search.clear();
    _modelData.discList.clear();
    setState(() {});
  }

  List<Widget> get _searchDiscListItems {
    var isClose = _search.text.isNotEmpty;
    var title = Text('search_for_the_disc'.recast, style: TextStyles.text18_700.copyWith(color: white));
    var desc = 'use_the_search_field_and_search_for_the_disc_you_want_to_add'.recast;
    var subtitle = Text(desc, style: TextStyles.text12_400.copyWith(color: lightBlue));
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [title, const SizedBox(height: 04), subtitle],
      ),
      Container(
        margin: const EdgeInsets.only(right: 100),
        child: InputField(
          cursorHeight: 12,
          controller: _search,
          focusNode: _focusNode,
          fillColor: transparent,
          hintColor: skyBlue,
          textColor: lightBlue,
          cursorColor: lightBlue,
          enabledBorder: lightBlue,
          focusedBorder: lightBlue,
          // onChanged: (v) => setState(() {}),
          onChanged: (v) => _viewModel.onDebounceSearch(_search.text),
          hintText: 'search_by_discs_name'.recast,
          prefixIcon: PrefixMenu(icon: Assets.svg1.search_2, color: skyBlue, focusColor: lightBlue, isFocus: _focusNode.hasFocus),
          suffixIcon: !isClose ? null : SuffixMenu(icon: Assets.svg1.close_2, focusColor: lightBlue, isFocus: true, onTap: _onClose),
        ),
      ),
      /*Center(
        child: ElevateButton(
          radius: 04,
          height: 30,
          width: 36.width,
          label: 'search_disc'.recast.toUpper,
          // label: 'add_a_disc'.recast.toUpper,
          onTap: () => _viewModel.fetchSearchDiscs(_search.text),
          textStyle: TextStyles.text12_600.copyWith(color: lightBlue, fontSize: 13),
        ),
      )*/
    ];
  }

  /*List<Widget> get _pgdaApprovedListItems {
    var title = Text('browse_in_all_pdga_approved_discs'.recast, style: TextStyles.text18_700.copyWith(color: white));
    var subtitle = Text('be_nerdy_and_browse_in_all_discs'.recast, style: TextStyles.text12_400.copyWith(color: lightBlue));
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [title, const SizedBox(height: 04), subtitle],
      ),
      Center(
        child: ElevateButton(
          radius: 04,
          height: 30,
          width: 36.width,
          background: mediumBlue,
          label: 'open_browsing'.recast.toUpper,
          onTap: Routes.user.pgda_discs().push,
          textStyle: TextStyles.text12_600.copyWith(color: lightBlue, fontSize: 13),
        ),
      )
    ];
  }*/

  /*List<Widget> get _askAiListItems {
    var title = Text('ask_the_ai'.recast, style: TextStyles.text18_700.copyWith(color: white));
    var desc = 'answer_a_few_questions_and_ai_will_compare'.recast;
    var subtitle = Text(desc, style: TextStyles.text12_400.copyWith(color: lightBlue));
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [title, const SizedBox(height: 04), subtitle],
      ),
      Center(
        child: ElevateButton(
          radius: 04,
          height: 30,
          width: 36.width,
          background: mediumBlue,
          label: 'ask_the_ai'.recast.toUpper,
          onTap: Routes.user.ai_disc_suggestion().push,
          textStyle: TextStyles.text12_600.copyWith(color: lightBlue, fontSize: 13),
        ),
      )
    ];
  }*/
}
