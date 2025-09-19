import 'package:flutter/material.dart';

import 'package:app/components/app_lists/countries_list.dart';
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
import 'package:app/models/public/country.dart';
import 'package:app/preferences/app_preferences.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/exception/no_country_found.dart';
import 'package:app/widgets/ui/nav_button_box.dart';

Future<void> countriesSheet({required Country country, required Function(Country) onChanged}) async {
  final context = navigatorKey.currentState!.context;
  final padding = MediaQuery.of(context).viewInsets;
  final child = _BottomSheetView(country, onChanged);
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
  final Country country;
  final Function(Country) onChanged;
  const _BottomSheetView(this.country, this.onChanged);

  @override
  State<_BottomSheetView> createState() => _BottomSheetViewState();
}

class _BottomSheetViewState extends State<_BottomSheetView> {
  var _loader = true;
  var _country = Country();
  var _focusNode = FocusNode();
  var _search = TextEditingController();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('country-sheet');
    _focusNode.addListener(() => setState(() {}));
    if (widget.country.id != null) _country = widget.country;
    _fetchCountries();
    super.initState();
  }

  Future<void> _fetchCountries() async {
    await AppPreferences.fetchCountries();
    setState(() => _loader = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.height,
      width: SizeConfig.width,
      decoration: const BoxDecoration(color: primary, borderRadius: SHEET_RADIUS),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SheetHeader1(label: 'select_your_country'.recast),
          const SizedBox(height: 16),
          if (AppPreferences.countries.isNotEmpty)
            InputField(
              padding: 20,
              cursorHeight: 14,
              controller: _search,
              fillColor: skyBlue,
              hintText: 'search_your_country'.recast,
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
    if (_country.id == null) return FlushPopup.onWarning(message: 'please_select_your_country'.recast);
    backToPrevious();
    widget.onChanged(_country);
  }

  Widget _screenView(BuildContext context) {
    if (_loader) return const SizedBox.shrink();
    if (AppPreferences.countries.isEmpty) return NoCountryFound();
    final countries = Country.countries_by_name(AppPreferences.countries, _search.text);
    return ListView(
      shrinkWrap: true,
      controller: ScrollController(),
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: countries.isEmpty
          ? [
              const SizedBox(height: 20),
              NoCountryFound(),
              SizedBox(height: BOTTOM_GAP),
            ]
          : [
              const SizedBox(height: 20),
              CountriesList(country: _country, countries: countries, onChanged: (item) => setState(() => _country = item)),
              SizedBox(height: BOTTOM_GAP),
            ],
    );
  }
}
