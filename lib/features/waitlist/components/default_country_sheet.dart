import 'package:flutter/material.dart';

import 'package:app/animations/fade_animation.dart';
import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/buttons/outline_button.dart';
import 'package:app/components/headers/sheet_header_1.dart';
import 'package:app/components/menus/prefix_menu.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/system/default_country.dart';
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

Future<void> defaultCountriesSheet({required DefaultCountry? country, required Function(DefaultCountry) onChanged}) async {
  var context = navigatorKey.currentState!.context;
  var padding = MediaQuery.of(context).viewInsets;
  var child = _BottomSheetView(country, onChanged);
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
  final DefaultCountry? country;
  final Function(DefaultCountry) onChanged;
  const _BottomSheetView(this.country, this.onChanged);

  @override
  State<_BottomSheetView> createState() => _BottomSheetViewState();
}

class _BottomSheetViewState extends State<_BottomSheetView> {
  var _country = null as DefaultCountry?;
  var _focusNode = FocusNode();
  var _search = TextEditingController();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('default-country-sheet');
    _focusNode.addListener(() => setState(() {}));
    if (widget.country != null) _country = widget.country!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.height,
      width: SizeConfig.width,
      decoration: BoxDecoration(color: primary, borderRadius: SHEET_RADIUS),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SheetHeader1(label: 'select_your_country'.recast),
          const SizedBox(height: 16),
          InputField(
            padding: 20,
            cursorHeight: 14,
            controller: _search,
            fillColor: skyBlue,
            focusNode: _focusNode,
            onChanged: (v) => setState(() {}),
            hintText: 'search_your_country'.recast,
            prefixIcon: PrefixMenu(icon: Assets.svg1.search_2, isFocus: _focusNode.hasFocus),
          ),
          Expanded(child: _screenView(context)),
          NavButtonBox(childHeight: 42, child: _actionButtons),
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
    if (_country == null) return FlushPopup.onWarning(message: 'please_select_your_country'.recast);
    widget.onChanged(_country!);
    backToPrevious();
  }

  Widget _screenView(BuildContext context) {
    var countries = DefaultCountry.countries_by_name(_search.text);
    if (countries.isEmpty) return _NoCountryFound();
    return ListView(
      shrinkWrap: true,
      controller: ScrollController(),
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const SizedBox(height: 20),
        RawScrollbar(
          thickness: 04,
          thumbColor: lightBlue,
          thumbVisibility: true,
          trackVisibility: true,
          radius: const Radius.circular(04),
          padding: const EdgeInsets.only(right: 02),
          scrollbarOrientation: ScrollbarOrientation.right,
          child: _DefaultCountriesList(countries: countries, selectedItem: _country, onChanged: (v) => setState(() => _country = v)),
        ),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }
}

class _DefaultCountriesList extends StatelessWidget {
  final DefaultCountry? selectedItem;
  final List<DefaultCountry> countries;
  final Function(DefaultCountry) onChanged;
  const _DefaultCountriesList({required this.onChanged, this.selectedItem, this.countries = const []});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      itemCount: countries.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: _countryItemCard,
    );
  }

  Widget _countryItemCard(BuildContext context, int index) {
    var item = countries[index];
    var length = countries.length;
    var selected = selectedItem != null && selectedItem!.id == item.id;
    var checkIcon = SvgImage(image: Assets.svg1.tick, color: lightBlue, height: 18);
    var border = const Border(bottom: BorderSide(color: lightBlue, width: 0.5));
    return InkWell(
      onTap: () => onChanged(item),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: index == 0 ? 0 : 12, bottom: index == length - 1 ? 0 : 12),
        decoration: BoxDecoration(border: index == length - 1 ? null : border),
        child: Row(
          children: [
            Image.asset(item.image, height: 22),
            const SizedBox(width: 12),
            Expanded(child: Text(item.name, style: TextStyles.text14_400.copyWith(color: lightBlue, height: 1.1))),
            if (selected) const SizedBox(width: 12),
            if (selected) FadeAnimation(fadeKey: item.code, duration: DURATION_1000, child: checkIcon),
          ],
        ),
      ),
    );
  }
}

class _NoCountryFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 4.height),
          SvgImage(image: Assets.svg3.not_found, height: 16.height, color: lightBlue, fit: BoxFit.cover),
          const SizedBox(height: 28),
          Text('${'no_country_found'.recast}!', textAlign: TextAlign.center, style: TextStyles.text16_600.copyWith(color: lightBlue)),
          const SizedBox(height: 04),
          Text('no_countries_available_now_please_tray_again_later'.recast, style: TextStyles.text14_400.copyWith(color: lightBlue)),
        ],
      ),
    );
  }
}
