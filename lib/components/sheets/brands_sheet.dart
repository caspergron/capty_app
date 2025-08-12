import 'package:flutter/material.dart';

import 'package:app/components/app_lists/brands_list.dart';
import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/buttons/outline_button.dart';
import 'package:app/components/headers/sheet_header_1.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/prefix_menu.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/common/brand.dart';
import 'package:app/preferences/app_preferences.dart';
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
  var _selectedBrands = <Brand>[];
  var _focusNode = FocusNode();
  var _search = TextEditingController();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('brands-sheet');
    _focusNode.addListener(() => setState(() {}));
    if (widget.brands.isNotEmpty) _selectedBrands = widget.brands;
    _fetchAllBrands();
    super.initState();
  }

  Future<void> _fetchAllBrands() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await AppPreferences.fetchBrands();
    setState(() => _loader = false);
  }

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
          if (AppPreferences.countries.isNotEmpty)
            InputField(
              padding: 20,
              cursorHeight: 14,
              controller: _search,
              fillColor: skyBlue,
              hintText: 'search_by_brand_name'.recast,
              focusNode: _focusNode,
              onChanged: (v) => setState(() {}),
              prefixIcon: PrefixMenu(icon: Assets.svg1.search_2, isFocus: _focusNode.hasFocus),
            ),
          Expanded(child: Stack(children: [_screenView(context), if (_loader) const ScreenLoader()])),
          if (AppPreferences.countries.isNotEmpty) NavButtonBox(loader: _loader, childHeight: 42, child: _actionButtons),
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
    if (AppPreferences.brands.isEmpty) return _NoBrandFound();
    var brands = Brand.brands_by_name(AppPreferences.brands, _search.text);
    return ListView(
      shrinkWrap: true,
      controller: ScrollController(),
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: brands.isEmpty
          ? [
              const SizedBox(height: 20),
              _NoBrandFound(),
              SizedBox(height: BOTTOM_GAP),
            ]
          : [
              const SizedBox(height: 20),
              BrandsList(brands: brands, selectedItems: _selectedBrands, onChanged: _onSelectBrand),
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
