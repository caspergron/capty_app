import 'dart:async';

import 'package:app/components/app_lists/brands_list.dart';
import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/buttons/outline_button.dart';
import 'package:app/components/headers/sheet_header_1.dart';
import 'package:app/components/loaders/button_loader.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/prefix_menu.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/common/brand.dart';
import 'package:app/models/system/paginate.dart';
import 'package:app/repository/public_repo.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/nav_button_box.dart';
import 'package:flutter/material.dart';

Future<void> brandsSheet({required List<Brand> brands, required Function(List<Brand>) onChanged}) async {
  var context = navigatorKey.currentState!.context;
  var padding = MediaQuery.of(context).viewInsets;
  var child = _BottomSheetView(brands, onChanged);
  await showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: false,
    isScrollControlled: true,
    shape: BOTTOM_SHEET_SHAPE,
    clipBehavior: Clip.antiAlias,
    builder: (builder) => Padding(padding: padding, child: PopScopeNavigator(canPop: false, child: child)),
  );
}

class _BottomSheetView extends StatefulWidget {
  final List<Brand> brands;
  final Function(List<Brand>) onChanged;
  const _BottomSheetView(this.brands, this.onChanged);

  @override
  State<_BottomSheetView> createState() => _BottomSheetViewState();
}

class _BottomSheetViewState extends State<_BottomSheetView> {
  var _loader = true;
  var _brands = <Brand>[];
  var _paginate = Paginate();
  var _selectedBrands = <Brand>[];
  var _focusNode = FocusNode();
  var _search = TextEditingController();
  var _scrollControl = ScrollController();
  var _searchCounter = 0;
  var _lastQuery = '';
  Timer? _debounceTimer;

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('brands-sheet');
    _focusNode.addListener(() => setState(() {}));
    if (widget.brands.isNotEmpty) _selectedBrands = widget.brands;
    _onInit();
    super.initState();
  }

  Future<void> _onInit() => Future.delayed(const Duration(milliseconds: 200), _fetchBrands);

  void _onDebounceSearch(String query) {
    _debounceTimer?.cancel();
    // if (query.trim().isEmpty || query.length < 2) return _clearStates();
    if (query == _lastQuery) return;
    _lastQuery = query;
    _debounceTimer = Timer(const Duration(milliseconds: 300), () => _fetchBrands(searchKey: query));
  }

  Future<void> _fetchBrands({String searchKey = '', bool isPaginate = false}) async {
    if (_paginate.pageLoader) return;
    _paginate.pageLoader = isPaginate;
    if (searchKey.isNotEmpty) _paginate = Paginate();
    setState(() {});
    final repository = sl<PublicRepository>();
    final currentRequest = ++_searchCounter;
    final query = _search.text.isEmpty ? '' : '&query=$searchKey';
    final params = '?size=$LENGTH_30&page=${_paginate.page}$query'.trim();
    final response = searchKey.isEmpty ? await repository.fetchAllBrands(params) : await repository.fetchSearchBrands(params);
    if (currentRequest != _searchCounter) return;
    if (_paginate.page == 1) _brands.clear();
    _paginate.length = response.length;
    if (_paginate.length >= LENGTH_30) _paginate.page++;
    if (response.isNotEmpty) _brands.addAll(response);
    _paginate.pageLoader = false;
    setState(() => _loader = false);
    _scrollControl.addListener(_brandPaginationCheck);
  }

  void _brandPaginationCheck() {
    // print(_scrollControl.hasClients);
    // if (!_scrollControl.hasClients) return;
    final position = _scrollControl.position;
    final isPosition70 = position.pixels >= position.maxScrollExtent * 0.75;
    if (isPosition70 && _paginate.length == LENGTH_30) _fetchBrands(isPaginate: true);
  }

  /*void _clearStates() {
    _brands.clear();
    _lastQuery = '';
    setState(() {});
  }*/

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.height,
      width: SizeConfig.width,
      decoration: BoxDecoration(color: primary, borderRadius: SHEET_RADIUS),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SheetHeader1(label: 'select_brands'.recast),
          const SizedBox(height: 16),
          InputField(
            padding: 20,
            cursorHeight: 14,
            controller: _search,
            fillColor: skyBlue,
            hintText: 'search_by_brand_name'.recast,
            focusNode: _focusNode,
            onChanged: _onDebounceSearch,
            prefixIcon: PrefixMenu(icon: Assets.svg1.search_2, isFocus: _focusNode.hasFocus),
          ),
          Expanded(child: Stack(children: [_screenView(context), if (_loader) const ScreenLoader()])),
          if (_brands.isNotEmpty) NavButtonBox(loader: _loader, childHeight: 42, child: _actionButtons),
        ],
      ),
    );
  }

  Widget get _actionButtons {
    return Row(
      children: [
        Expanded(
          child: OutlineButton(
            radius: 04,
            height: 42,
            background: skyBlue,
            onTap: backToPrevious,
            label: 'cancel'.recast.toUpper,
            textStyle: TextStyles.text14_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevateButton(
            radius: 04,
            height: 42,
            onTap: _onConfirm,
            label: 'confirm'.recast.toUpper,
            textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
          ),
        ),
      ],
    );
  }

  void _onConfirm() {
    if (_selectedBrands.isEmpty) return FlushPopup.onWarning(message: 'please_select_any_brand'.recast);
    backToPrevious();
    widget.onChanged(_selectedBrands);
  }

  Widget _screenView(BuildContext context) {
    if (_loader) return const SizedBox.shrink();
    if (_brands.isEmpty) return _NoBrandFound();
    // var brands = Brand.brands_by_name(AppPreferences.brands, _search.text);
    return ListView(
      shrinkWrap: true,
      controller: _scrollControl,
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: _brands.isEmpty
          ? [
              const SizedBox(height: 20),
              _NoBrandFound(),
              SizedBox(height: BOTTOM_GAP),
            ]
          : [
              const SizedBox(height: 20),
              BrandsList(brands: _brands, selectedItems: _selectedBrands, onChanged: _onSelectBrand),
              if (_paginate.pageLoader) const SizedBox(height: 24),
              if (_paginate.pageLoader) Center(child: ButtonLoader()),
              SizedBox(height: BOTTOM_GAP),
            ],
    );
  }

  void _onSelectBrand(Brand item) {
    var index = _selectedBrands.isEmpty ? -1 : _selectedBrands.indexWhere((element) => element.id == item.id);
    index < 0 ? _selectedBrands.add(item) : _selectedBrands.removeAt(index);
    setState(() {});
  }
}

class _NoBrandFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var description = 'we_could_not_find_any_brands_right_now_please_try_again_later'.recast;
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 4.height),
          SvgImage(image: Assets.svg3.not_found, height: 16.height, color: lightBlue),
          const SizedBox(height: 28),
          Text('${'no_brand_found'.recast}!', textAlign: TextAlign.center, style: TextStyles.text16_600.copyWith(color: lightBlue)),
          const SizedBox(height: 04),
          Text(description, textAlign: TextAlign.center, style: TextStyles.text14_400.copyWith(color: lightBlue)),
        ],
      ),
    );
  }
}
