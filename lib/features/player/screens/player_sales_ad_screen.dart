import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/marketplace_management/marketplace/units/marketplace_category_list.dart';
import 'package:app/features/player/view_models/player_sales_ad_view_model.dart';
import 'package:app/models/user/user.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/exception/no_disc_found.dart';

class PlayerSalesAdScreen extends StatefulWidget {
  final User player;
  const PlayerSalesAdScreen({required this.player});

  @override
  State<PlayerSalesAdScreen> createState() => _PlayerSalesAdScreenState();
}

class _PlayerSalesAdScreenState extends State<PlayerSalesAdScreen> {
  var _viewModel = PlayerSalesAdViewModel();
  var _modelData = PlayerSalesAdViewModel();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('tournament-discs-screen');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel(widget.player));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<PlayerSalesAdViewModel>(context, listen: false);
    _modelData = Provider.of<PlayerSalesAdViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _viewModel.disposeViewModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isMe = widget.player.id != null && widget.player.id == UserPreferences.user.id;
    var name = isMe ? 'my'.recast : '${widget.player.first_name}${'extra_s'.recast}';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackMenu(),
        automaticallyImplyLeading: false,
        title: Text('$name ${'sales_ads'.recast.allFirstLetterCapital}'),
      ),
      body: Container(
        width: SizeConfig.width,
        height: SizeConfig.height,
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
        child: Stack(children: [_screenView, if (_modelData.loader.loader) const ScreenLoader()]),
      ),
    );
  }

  Widget get _screenView {
    if (_modelData.loader.initial) return const SizedBox.shrink();
    var isMe = widget.player.id != null && widget.player.id == UserPreferences.user.id;
    var name = isMe ? '' : (widget.player.first_name.isEmpty ? 'this_player'.recast : widget.player.first_name);
    var label = 'no_sales_ad_found';
    var description = isMe
        ? 'you_have_no_sales_ad_disc_in_marketplace_please_create_your_sales_ads'
        : 'has_no_available_disc_in_marketplace_please_check_back_later';
    if (_modelData.categories.isEmpty) return NoDiscFound(height: 10.height, description: description, label: label, name: name);
    return ListView(
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 12),
        MarketplaceCategoryList(
          categories: _modelData.categories,
          onSetFav: (item) => _viewModel.onSetAsFavourite(item),
          onRemoveFav: (item) => _viewModel.onRemoveFromFavourite(item),
          onDiscItem: (item) => Routes.user.market_details(salesAd: item).push(),
        ),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }
}
