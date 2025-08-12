import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/components/app_lists/nearest_clubs_list.dart';
import 'package:app/components/loaders/positioned_loader.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/club/view_models/club_view_model.dart';
import 'package:app/features/home/home_view_model.dart';
import 'package:app/libraries/locations.dart';
import 'package:app/models/club/club.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/repository/club_repo.dart';
import 'package:app/repository/public_repo.dart';
import 'package:app/repository/user_repo.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/label_placeholder.dart';

Future<void> joiningClubsSheet() async {
  var context = navigatorKey.currentState!.context;
  var padding = MediaQuery.of(context).viewInsets;
  await showModalBottomSheet(
    context: context,
    showDragHandle: false,
    isDismissible: false,
    isScrollControlled: true,
    shape: BOTTOM_SHEET_SHAPE,
    clipBehavior: Clip.antiAlias,
    builder: (builder) => Padding(padding: padding, child: PopScopeNavigator(canPop: false, child: _BottomSheetView())),
  );
}

class _BottomSheetView extends StatefulWidget {
  @override
  State<_BottomSheetView> createState() => _BottomSheetViewState();
}

class _BottomSheetViewState extends State<_BottomSheetView> {
  var _loader = DEFAULT_LOADER;
  var _state = 'null';
  var _focusNode = FocusNode();
  var _search = TextEditingController();
  var _clubs = <Club>[];
  var _searchedClubs = <Club>[];

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('joining-clubs-sheet');
    _focusNode.addListener(() => setState(() {}));
    _findNearbyClubs();
    super.initState();
  }

  Future<void> _findNearbyClubs() async {
    var coordinates = await sl<Locations>().fetchLocationPermission();
    if (!coordinates.is_coordinate) _onDisabledLocation(true);
    if (!coordinates.is_coordinate) return setState(() => _loader = Loader(initial: false, common: false));
    var response = await sl<PublicRepository>().findClubs(coordinates);
    if (response.isNotEmpty) _clubs = response;
    setState(() => _loader = Loader(initial: false, common: false));
  }

  @override
  void dispose() {
    _loader = DEFAULT_LOADER;
    _state = 'null';
    _focusNode.removeListener(() {});
    _focusNode.dispose();
    _search.dispose();
    _clubs.clear();
    _searchedClubs.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.height,
      width: double.infinity,
      decoration: BoxDecoration(color: skyBlue, borderRadius: SHEET_RADIUS),
      child: Stack(children: [_screenView(context), if (_loader.loader) const PositionedLoader()]),
    );
  }

  Widget _screenView(BuildContext context) {
    var decoration = BoxDecoration(color: mediumBlue, borderRadius: BorderRadius.circular(2));
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 06),
        Center(child: Container(height: 4, width: 28.width, decoration: decoration)),
        const SizedBox(height: 14),
        Row(
          children: [
            SizedBox(width: Dimensions.dialog_padding),
            Expanded(child: Text('clubs_you_can_join'.recast, style: TextStyles.text18_600.copyWith(color: primary))),
            const SizedBox(width: 10),
            InkWell(onTap: backToPrevious, child: const Icon(Icons.close, color: primary, size: 22)),
            SizedBox(width: Dimensions.dialog_padding),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(color: mediumBlue, height: 0.5, thickness: 0.5),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            clipBehavior: Clip.antiAlias,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding),
            children: [
              const SizedBox(height: 14),
              LabelPlaceholder(
                radius: 08,
                label: 'create_your_own_club'.recast,
                border: orange,
                background: transparent,
                textColor: orange,
                icon: SvgImage(image: Assets.svg1.coach, height: 20, color: orange),
                endIcon: SvgImage(image: Assets.svg1.caret_right, height: 20, color: orange),
                onTap: _onCreateClub,
              ),
              const SizedBox(height: 16),
              Text('search_for_your_club'.recast, style: TextStyles.text18_600.copyWith(color: primary)),
              const SizedBox(height: 08),
              InputField(
                cursorHeight: 14,
                controller: _search,
                fillColor: skyBlue,
                hintText: 'search_by_club_name'.recast,
                focusNode: _focusNode,
                onChanged: (v) => setState(() {}),
                onFieldSubmitted: (v) => _onSearch(),
                suffixIcon: InkWell(onTap: _onSearch, child: _searchSuffix),
              ),
              const SizedBox(height: 12),
              Builder(builder: (context) {
                if (_state == 'null' && _searchedClubs.isEmpty) return const SizedBox.shrink();
                if (_searchedClubs.isEmpty) return _noClub;
                return NearestClubsList(background: primary, clubs: _searchedClubs, onJoin: _onJoinClub, onLeft: _onLeftClub);
              }),
              const SizedBox(height: 16),
              if (!_loader.initial && _clubs.isNotEmpty) ..._locationBasedClubs,
              SizedBox(height: BOTTOM_GAP),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> get _locationBasedClubs {
    return [
      Text('we_have_found_these_clubs'.recast, style: TextStyles.text24_600.copyWith(color: primary, fontWeight: w500)),
      Text('are_you_a_member_in_any_of_these_clubs'.recast, style: TextStyles.text14_400.copyWith(color: primary)),
      const SizedBox(height: 16),
      NearestClubsList(background: primary, clubs: _clubs, onJoin: _onJoinClub, onLeft: _onLeftClub),
    ];
  }

  void _onCreateClub() {
    backToPrevious();
    Routes.user.create_club().push();
  }

  Future<void> _onSearch() async {
    minimizeKeyboard();
    if (_search.text.isEmpty) return;
    var coordinates = await sl<Locations>().fetchLocationPermission();
    if (!coordinates.is_coordinate) return _onDisabledLocation(false);
    setState(() => _loader.common = true);
    // var body = {'name': _search.text, 'latitude': '56.3876239', 'longitude': '9.7604105'};
    var body = {'name': _search.text, 'latitude': coordinates.lat, 'longitude': coordinates.lng};
    var response = await sl<ClubRepository>().searchClubs(body);
    _searchedClubs.clear();
    if (response.isNotEmpty) _searchedClubs = response;
    _state = 'true';
    _loader = Loader(initial: false, common: false);
    setState(() {});
  }

  void _onDisabledLocation(bool isLoader) {
    // var message = 'we_can_not_find_any_clubs_for_you_because_your_location_is_turned_off'.recast;
    // FlushPopup.onInfo(message: message);
    return setState(() => isLoader ? _loader.common = false : _state = 'true');
  }

  Future<void> _onJoinClub(Club item, int index) async {
    if (item.is_member) return;
    setState(() => _loader.common = true);
    var body = {'club_id': item.id};
    var response = await sl<ClubRepository>().joinClub(body);
    if (!response) return setState(() => _loader.common = false);
    _updateViewModels();
    _updateLocalState(item, true);
    setState(() => _loader.common = false);
  }

  Future<void> _onLeftClub(Club item, int index) async {
    if (!item.is_member) return;
    setState(() => _loader.common = true);
    var body = {'club_id': item.id};
    var response = await sl<ClubRepository>().leaveClub(body);
    if (!response) return setState(() => _loader.common = false);
    _updateViewModels();
    _updateLocalState(item, false);
    setState(() => _loader.common = false);
  }

  void _updateLocalState(Club item, bool value) {
    var clubIndex = _clubs.isEmpty ? -1 : _clubs.indexWhere((club) => club.id == item.id);
    var searchedIndex = _searchedClubs.isEmpty ? -1 : _searchedClubs.indexWhere((club) => club.id == item.id);
    if (clubIndex >= 0) {
      var totalMember = _clubs[clubIndex].totalMember.nullToInt;
      _clubs[clubIndex].isMember = value;
      _clubs[clubIndex].totalMember = value ? (totalMember + 1) : (totalMember < 1 ? 0 : totalMember - 1);
    }
    if (searchedIndex >= 0) {
      var totalMember = _searchedClubs[searchedIndex].totalMember.nullToInt;
      _searchedClubs[searchedIndex].isMember = value;
      _searchedClubs[searchedIndex].totalMember = value ? (totalMember + 1) : (totalMember < 1 ? 0 : totalMember - 1);
    }
    setState(() {});
  }

  void _updateViewModels() {
    var context = navigatorKey.currentState!.context;
    sl<UserRepository>().fetchProfileInfo();
    Provider.of<HomeViewModel>(context, listen: false).fetchDefaultClubInfo();
    Provider.of<ClubViewModel>(context, listen: false).fetchUserClubs(true);
  }

  Widget get _searchSuffix {
    var radius = const Radius.circular(06);
    var borderRadius = BorderRadius.only(topRight: radius, bottomRight: radius);
    return Container(
      width: 48,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: primary, borderRadius: borderRadius),
      child: SvgImage(image: Assets.svg1.search_2, color: lightBlue, height: 22),
    );
  }

  Widget get _noClub {
    return Column(
      children: [
        SizedBox(height: 5.height),
        SvgImage(image: Assets.svg3.not_found, height: 15.height),
        const SizedBox(height: 16),
        Text('no_club_found_please_try_again'.recast, style: TextStyles.text14_600.copyWith(color: primary, fontWeight: w500)),
      ],
    );
  }
}
