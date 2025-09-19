import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/disc_management/add_wishlist/components/add_to_wishlist_dialog.dart';
import 'package:app/features/disc_management/add_wishlist/components/edit_wishlist_dialog.dart';
import 'package:app/features/disc_management/add_wishlist/units/parent_disc_category_list.dart';
import 'package:app/features/disc_management/add_wishlist/view_models/pgda_discs_view_model.dart';
import 'package:app/models/disc/parent_disc.dart';
import 'package:app/models/disc/wishlist.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/exception/no_disc_found.dart';

class PgdaDiscsScreen extends StatefulWidget {
  @override
  State<PgdaDiscsScreen> createState() => _PgdaDiscsScreenState();
}

class _PgdaDiscsScreenState extends State<PgdaDiscsScreen> {
  var _viewModel = PgdaDiscsViewModel();
  var _modelData = PgdaDiscsViewModel();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('pgda-discs-screen');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<PgdaDiscsViewModel>(context, listen: false);
    _modelData = Provider.of<PgdaDiscsViewModel>(context);
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
        title: Text('pgda_approved_discs'.recast),
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
    if (_modelData.loader.initial) return const SizedBox.shrink();
    const subLabel = 'no_pdga_discs_are_available_now_please_try_again_later';
    if (_modelData.categories.isEmpty) return NoDiscFound(height: 15.height, description: subLabel);
    final label = 'browse_in_all_pgda_approved_discs'.recast;
    final gap = EdgeInsets.symmetric(horizontal: Dimensions.screen_padding);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(padding: gap, child: Text(label, style: TextStyles.text16_400.copyWith(color: primary))),
        const SizedBox(height: 8),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 4),
              ParentDiscCategoryList(categories: _modelData.categories, onFavDisc: _onWishlist),
              SizedBox(height: BOTTOM_GAP),
            ],
          ),
        ),
      ],
    );
  }

  void _onWishlist(ParentDisc item, int index) {
    final added = item.is_wishListed;
    final wishlist = Wishlist(id: item.wishlistId, disc: item);
    addToWishlistDialog(
      wishlist: wishlist,
      added: added,
      onRemove: () => _viewModel.onRemoveFromWishlist(item, index),
      onEdit: () => editWishlistDisc(wishlist: wishlist, isUpdateAndAdd: true, onSave: (w, s) => _viewModel.onUpdateAndAddWishList(w)),
      // onAdd: () => _viewModel.onAddedToWishlist(item, index),
      // onEdit: () => editWishlistDisc(wishlist: wishlist, isUpdateAndAdd: true, onSave: (w, s) => _viewModel.onUpdateAndAddWishList(w)),
    );
  }
}
