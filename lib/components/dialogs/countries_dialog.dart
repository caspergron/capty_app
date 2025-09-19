import 'package:flutter/material.dart';

import 'package:app/components/app_lists/countries_list.dart';
import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/prefix_menu.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/public/country.dart';
import 'package:app/preferences/app_preferences.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/exception/no_country_found.dart';

Future<void> countriesDialog({required Country country, required Function(Country) onChanged}) async {
  final context = navigatorKey.currentState!.context;
  // sl<AppAnalytics>().screenView('club-management-popup');
  final child = Align(child: _DialogView(country, onChanged));
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Countries Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().bottomToTop,
    pageBuilder: (buildContext, anim1, anim2) => PopScopeNavigator(canPop: false, child: child),
  );
}

class _DialogView extends StatefulWidget {
  final Country country;
  final Function(Country) onChanged;
  const _DialogView(this.country, this.onChanged);

  @override
  State<_DialogView> createState() => _DialogViewState();
}

class _DialogViewState extends State<_DialogView> {
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
      width: 90.width,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding + 4),
      decoration: BoxDecoration(color: primary, borderRadius: DIALOG_RADIUS, boxShadow: const [SHADOW_2]),
      child: Material(color: transparent, child: _screenView(context), shape: DIALOG_SHAPE),
    );
  }

  Widget _screenView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        Text('select_your_country'.recast, style: TextStyles.text18_600.copyWith(color: lightBlue)),
        const SizedBox(height: 16),
        if (AppPreferences.countries.isNotEmpty)
          InputField(
            cursorHeight: 14,
            controller: _search,
            fillColor: skyBlue,
            hintText: 'search_your_country'.recast,
            focusNode: _focusNode,
            onChanged: (v) => setState(() {}),
            prefixIcon: PrefixMenu(icon: Assets.svg1.search_2, isFocus: _focusNode.hasFocus),
          ),
        Expanded(child: Stack(children: [_countriesView(context), if (_loader) const ScreenLoader()])),
        if (AppPreferences.countries.isNotEmpty) const SizedBox(height: 10),
        if (AppPreferences.countries.isNotEmpty)
          ElevateButton(
            radius: 04,
            height: 42,
            onTap: _onConfirm,
            width: double.infinity,
            label: 'confirm'.recast.toUpper,
            textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _onConfirm() {
    if (_country.id == null) return FlushPopup.onWarning(message: 'please_select_your_country'.recast);
    widget.onChanged(_country);
    backToPrevious();
  }

  Widget _countriesView(BuildContext context) {
    if (_loader) return const SizedBox.shrink();
    if (AppPreferences.countries.isEmpty) return NoCountryFound();
    final countries = Country.countries_by_name(AppPreferences.countries, _search.text);
    return ListView(
      shrinkWrap: true,
      controller: ScrollController(),
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(height: 20),
        if (countries.isEmpty)
          NoCountryFound()
        else
          CountriesList(country: _country, countries: countries, onChanged: (item) => setState(() => _country = item)),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }
}
