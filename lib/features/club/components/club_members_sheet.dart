import 'package:flutter/material.dart';

import 'package:app/components/headers/sheet_header_1.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/prefix_menu.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/club/units/club_members_list.dart';
import 'package:app/models/club/club.dart';
import 'package:app/models/user/user.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/repository/club_repo.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/svg_image.dart';

Future<void> clubMembersSheet({required Club club}) async {
  var context = navigatorKey.currentState!.context;
  var padding = MediaQuery.of(context).viewInsets;
  await showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: false,
    isScrollControlled: true,
    shape: BOTTOM_SHEET_SHAPE,
    clipBehavior: Clip.antiAlias,
    builder: (builder) => Padding(padding: padding, child: PopScopeNavigator(canPop: false, child: _BottomSheetView(club))),
  );
}

class _BottomSheetView extends StatefulWidget {
  final Club club;
  const _BottomSheetView(this.club);

  @override
  State<_BottomSheetView> createState() => _BottomSheetViewState();
}

class _BottomSheetViewState extends State<_BottomSheetView> {
  var _loader = true;
  var _focusNode = FocusNode();
  var _search = TextEditingController();
  var _members = <User>[];

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('club-members-sheet');
    _focusNode.addListener(() => setState(() {}));
    _fetchAllClubMembers();
    super.initState();
  }

  Future<void> _fetchAllClubMembers() async {
    var response = await sl<ClubRepository>().fetchClubMembers(widget.club.id!);
    if (response.isNotEmpty) _members = response;
    setState(() => _loader = false);
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
          SheetHeader1(label: 'club_members'.recast),
          const SizedBox(height: 16),
          if (_members.isNotEmpty)
            InputField(
              padding: 20,
              cursorHeight: 14,
              controller: _search,
              fillColor: skyBlue,
              hintText: 'search_by_name'.recast,
              focusNode: _focusNode,
              onChanged: (v) => setState(() {}),
              prefixIcon: PrefixMenu(icon: Assets.svg1.search_2, isFocus: _focusNode.hasFocus),
            ),
          Expanded(child: Stack(children: [_screenView(context), if (_loader) const ScreenLoader()])),
        ],
      ),
    );
  }

  Widget _screenView(BuildContext context) {
    if (_loader) return const SizedBox.shrink();
    if (_members.isEmpty) return _noMemberFound;
    var clubMembers = User.users_by_name(_members, _search.text);
    return ListView(
      shrinkWrap: true,
      controller: ScrollController(),
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: clubMembers.isEmpty
          ? [const SizedBox(height: 20), _noMemberFound, SizedBox(height: BOTTOM_GAP)]
          : [
              const SizedBox(height: 12),
              ClubMembersList(members: clubMembers, onViewProfile: _onViewProfile),
              SizedBox(height: BOTTOM_GAP)
            ],
    );
  }

  void _onViewProfile(User item) {
    backToPrevious();
    var isMe = UserPreferences.user.id == item.id;
    isMe ? Routes.user.profile().push() : Routes.user.player_profile(playerId: item.id!).push();
  }

  Widget get _noMemberFound {
    var description = 'club_member_not_found_please_recheck_entered_information'.recast;
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 4.height),
          SvgImage(image: Assets.svg3.not_found, height: 16.height, color: lightBlue),
          const SizedBox(height: 28),
          Text('${'no_club_member_found'.recast}!', textAlign: TextAlign.center, style: TextStyles.text16_600.copyWith(color: lightBlue)),
          const SizedBox(height: 04),
          Text(description, textAlign: TextAlign.center, style: TextStyles.text14_400.copyWith(color: lightBlue)),
        ],
      ),
    );
  }
}
