import 'package:app/components/app_lists/countries_list.dart';
import 'package:app/components/headers/sheet_header_1.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/prefix_menu.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/public/country.dart';
import 'package:app/models/user/user.dart';
import 'package:app/preferences/app_preferences.dart';
import 'package:app/themes/colors.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/exception/no_country_found.dart';
import 'package:flutter/material.dart';

Future<void> clubMembersSheet({List<User> members = const []}) async {
  var context = navigatorKey.currentState!.context;
  var padding = MediaQuery.of(context).viewInsets;
  var child = _BottomSheetView(members);
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
  final List<User> members;
  const _BottomSheetView(this.members);

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
    // sl<AppAnalytics>().screenView('club-members-sheet');
    _focusNode.addListener(() => setState(() {}));
    super.initState();
  }

  /*Future<void> _fetchCountries() async {
    await AppPreferences.fetchCountries();
    setState(() => _loader = false);
  }*/

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
          if (AppPreferences.countries.isNotEmpty) SizedBox(height: BOTTOM_GAP),
        ],
      ),
    );
  }

  Widget _screenView(BuildContext context) {
    if (_loader) return const SizedBox.shrink();
    if (AppPreferences.countries.isEmpty) return NoCountryFound();
    var countries = Country.countries_by_name(AppPreferences.countries, _search.text);
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
