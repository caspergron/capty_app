import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/components/app_lists/parent_disc_grid_list.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/components/menus/prefix_menu.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/disc_management/search_disc/components/disc_request_dialog.dart';
import 'package:app/features/disc_management/search_disc/search_disc_view_model.dart';
import 'package:app/models/disc/parent_disc.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/exception/no_disc_found.dart';
import 'package:app/widgets/library/svg_image.dart';

// index 0: add disc & index 1: create sales add
// const _TABS_LIST = ['search', 'pdga_disc'];

class SearchDiscScreen extends StatefulWidget {
  final int index;
  const SearchDiscScreen({required this.index});

  @override
  State<SearchDiscScreen> createState() => _SearchDiscScreenState();
}

class _SearchDiscScreenState extends State<SearchDiscScreen> with SingleTickerProviderStateMixin {
  var _focusNode = FocusNode();
  var _search = TextEditingController();
  // late TabController _tabController;
  var _viewModel = SearchDiscViewModel();
  var _modelData = SearchDiscViewModel();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('search-disc-screen');
    _focusNode.addListener(() => setState(() {}));
    // _tabController = TabController(length: _TABS_LIST.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<SearchDiscViewModel>(context, listen: false);
    _modelData = Provider.of<SearchDiscViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _viewModel.clearStates();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackMenu(),
        title: Text('search_discs'.recast),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: SizeConfig.width,
        height: SizeConfig.height,
        child: _searchDiscView,
        decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: mediumBlue,
        child: SvgImage(image: Assets.svg1.info, color: white, height: 25),
        onPressed: discRequestDialog,
      ),
    );
  }

  Widget get _searchDiscView {
    var padding = EdgeInsets.symmetric(horizontal: Dimensions.screen_padding);
    var label = widget.index == 0 ? 'search_for_the_disc_you_want_to_add_to_your_bag' : 'search_for_the_disc_you_want_to_add_to_your_bag';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        Padding(padding: padding, child: Text(label.recast, style: TextStyles.text16_600.copyWith(color: dark, fontSize: 15))),
        const SizedBox(height: 12),
        InputField(
          padding: 20,
          focusNode: _focusNode,
          controller: _search,
          hintColor: primary,
          textInputAction: TextInputAction.search,
          hintText: 'search_by_discs_name'.recast,
          onChanged: (v) => _viewModel.onDebounceSearch(_search.text),
          prefixIcon: PrefixMenu(icon: Assets.svg1.search_2),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: _modelData.searchedDisc.isEmpty
              ? (_modelData.isSearched ? const SingleChildScrollView(child: NoDiscFound()) : const SizedBox.shrink())
              : ParentDiscGridList(
                  gap: 20,
                  bottomGap: BOTTOM_GAP,
                  discList: _modelData.searchedDisc,
                  onItem: (item, index) => _onDiscItem(item),
                ),
        )
      ],
    );
  }

  void _onDiscItem(ParentDisc disc) {
    var index = widget.index;
    var userDisc = disc.parent_disc_to_user_disc;
    index == 0 ? Routes.user.add_disc(disc: disc).push() : Routes.user.create_sales_ad(tabIndex: index, disc: userDisc).push();
  }
}
