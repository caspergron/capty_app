import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/components/app_lists/marketplace_disc_list.dart';
import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/drawers/app_drawer.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/components/menus/bell_menu.dart';
import 'package:app/components/menus/capty_menu.dart';
import 'package:app/components/menus/hamburger_menu.dart';
import 'package:app/components/popup_menu/clubs_menu.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/club/components/club_members_sheet.dart';
import 'package:app/features/club/components/club_settings_dialog.dart';
import 'package:app/features/club/units/upcoming_events_list.dart';
import 'package:app/features/club/view_models/club_view_model.dart';
import 'package:app/features/home/components/joining_clubs_sheet.dart';
import 'package:app/features/landing/landing_screen.dart';
import 'package:app/features/landing/landing_view_model.dart';
import 'package:app/libraries/launchers.dart';
import 'package:app/models/club/club.dart';
import 'package:app/services/app_analytics.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/library/svg_image.dart';

const _SPACE20 = '    ';

// clubManagementDialog(club: _modelData.club, onJoin: () => joinAdministratorDialog(onProceed: () {})),
class ClubScreen extends StatefulWidget {
  final Club club;
  final bool isHome;
  const ClubScreen({required this.club, required this.isHome});

  @override
  State<ClubScreen> createState() => _ClubScreenState();
}

class _ClubScreenState extends State<ClubScreen> {
  var _viewModel = ClubViewModel();
  var _modelData = ClubViewModel();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    var club = widget.club;
    var isHome = widget.isHome;
    sl<AppAnalytics>().screenView('club-screen');
    WidgetsBinding.instance.addPostFrameCallback((c) => isHome ? _viewModel.initViewModelHome() : _viewModel.initViewModelClub(club));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<ClubViewModel>(context, listen: false);
    _modelData = Provider.of<ClubViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (!widget.isHome) _viewModel.disposeViewModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var club = _modelData.club;
    var clubs = _modelData.clubs;
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: AppDrawer(),
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: widget.isHome ? 100 : null,
        leading: !widget.isHome ? const BackMenu() : ClubsMenu(item: club, clubs: clubs, onSelect: _viewModel.onSelectClub),
        automaticallyImplyLeading: false,
        title: widget.isHome ? CaptyMenu() : const Text('Singapore Club'),
        actions: !widget.isHome ? null : [const BellMenu(), ACTION_GAP, HamburgerMenu(scaffoldKey: _scaffoldKey), ACTION_SIZE],
      ),
      body: Container(
        width: SizeConfig.width,
        height: SizeConfig.height,
        decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
        child: Stack(children: [_screenView(context), if (_modelData.loader.loader) const ScreenLoader()]),
      ),
      floatingActionButton: clubs.isEmpty || club.id == null ? null : _floatingButton,
      // bottomNavigationBar: widget.isHome ? null : NavButtonBox(childHeight: 42, loader: _modelData.loader.loader, child: _navbarActions),
    );
  }

  /*Widget get _navbarActions {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ElevateButton(
            radius: 04,
            height: 42,
            onTap: clubManagementDialog,
            label: 'club_maintenance'.recast.toUpper,
            textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
          ),
        ),
        const SizedBox(width: 12),
        IconBox(
          size: 42,
          background: skyBlue,
          icon: SvgImage(image: Assets.svg1.plus, color: primary, height: 28),
          onTap: () => scheduleEventDialog(club: _modelData.club, onSchedule: _viewModel.onScheduleEvent),
          // onTap: () => eventDetailsDialog(event: '', onComment: (v) {}),
        ),
      ],
    );
  }*/

  Widget _screenView(BuildContext context) {
    if (_modelData.loader.initial) return const SizedBox.shrink();
    if (_modelData.clubs.isEmpty || _modelData.club.id == null) return _NoClubView();
    var club = _modelData.club;
    var caretRight = SvgImage(image: Assets.svg1.caret_right, color: orange, height: 16);
    var totalMembers = club.totalMember.nullToInt > 0 ? '${'view_members'.recast.toUpper} (${club.totalMember.formatInt})' : 'n/a'.recast;
    var socialLink = club.socialLink.toKey.isNotEmpty ? 'open_channel'.recast.toUpper : 'n/a'.recast;
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      children: [
        if (widget.isHome) const SizedBox(height: 08),
        if (widget.isHome) Center(child: Text(club.name ?? 'n/a'.recast, style: TextStyles.text20_500.copyWith(color: dark))),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          margin: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
          decoration: BoxDecoration(color: primary, boxShadow: const [SHADOW_1], borderRadius: BorderRadius.circular(08)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgImage(image: Assets.svg1.users, height: 20, color: lightBlue),
                  const SizedBox(width: 06),
                  Expanded(child: Text('members'.recast.firstLetterCapital, style: TextStyles.text13_600.copyWith(color: lightBlue))),
                  const SizedBox(width: 06),
                  InkWell(
                    onTap: () => club.totalMember.nullToInt < 1 ? null : clubMembersSheet(club: _modelData.club),
                    child: Row(
                      children: [
                        Text(totalMembers, textAlign: TextAlign.right, style: TextStyles.text14_700.copyWith(color: orange)),
                        if (club.totalMember.nullToInt > 0) const SizedBox(width: 02),
                        if (club.totalMember.nullToInt > 0) Padding(padding: const EdgeInsets.only(top: 2), child: caretRight),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  SvgImage(image: Assets.svg1.comment, height: 20, color: lightBlue),
                  const SizedBox(width: 06),
                  Expanded(child: Text('communicate'.recast, style: TextStyles.text13_600.copyWith(color: lightBlue))),
                  const SizedBox(width: 06),
                  if (club.socialLink.toKey.isNotEmpty)
                    InkWell(
                      onTap: () => sl<Launchers>().launchInBrowser(url: club.socialLink!),
                      child: Row(
                        children: [
                          Text(socialLink, textAlign: TextAlign.right, style: TextStyles.text14_700.copyWith(color: orange)),
                          const SizedBox(width: 02),
                          Padding(padding: const EdgeInsets.only(top: 2), child: caretRight),
                        ],
                      ),
                    )
                  else
                    Text('n/a'.recast, style: TextStyles.text14_700.copyWith(color: lightBlue))
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  SvgImage(image: Assets.svg1.home, height: 20, color: lightBlue),
                  const SizedBox(width: 06),
                  Expanded(child: Text('home_course'.recast, style: TextStyles.text13_600.copyWith(color: lightBlue))),
                  const SizedBox(width: 06),
                  Text(club.homeCourse?.name ?? 'n/a'.recast, style: TextStyles.text14_700.copyWith(color: lightBlue))
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        // if (!_modelData.loader.initial || club.club_events.isNotEmpty) ..._clubActionsSection,
        if (!_modelData.loader.initial && club.club_events.isNotEmpty) ..._upcomingEventsSection,
        if (!_modelData.loader.initial && _modelData.salesAdDiscs.isNotEmpty) ..._salesAdDiscsSection,
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  /*List<Widget> get _clubActionsSection {
    return [
      Text('$_SPACE20${'club_action'.recast}', style: TextStyles.text18_600.copyWith(color: dark)),
      const SizedBox(height: 08),
      ClubActionList(actions: _modelData.clubActions),
      const SizedBox(height: 04),
    ];
  }*/

  List<Widget> get _upcomingEventsSection {
    var club = _modelData.club;
    return [
      Text('$_SPACE20${'upcoming_events'.recast}', style: TextStyles.text18_600.copyWith(color: dark)),
      const SizedBox(height: 08),
      UpcomingEventsList(events: club.club_events),
      const SizedBox(height: 04),
    ];
  }

  List<Widget> get _salesAdDiscsSection {
    final salesAds = _modelData.salesAdDiscs;
    final viewMoreStyle = TextStyles.text14_700.copyWith(color: primary);
    return [
      Row(
        children: [
          SizedBox(width: Dimensions.screen_padding),
          Expanded(child: Text('discs_for_sale_in_this_club'.recast, style: TextStyles.text18_600.copyWith(color: dark))),
          if (salesAds.length > 5) InkWell(onTap: _goToMarketplace, child: Text('view_more'.recast, style: viewMoreStyle)),
          SizedBox(width: Dimensions.screen_padding),
        ],
      ),
      const SizedBox(height: 08),
      MarketplaceDiscList(discs: _modelData.salesAdDiscs, onTap: (v) => Routes.user.market_details(salesAd: v).push()),
    ];
  }

  Widget get _floatingButton {
    var isOneClub = _modelData.clubs.length < 2;
    return FloatingActionButton(
      mini: true,
      backgroundColor: mediumBlue,
      child: Icon(isOneClub ? Icons.add : Icons.settings, color: dark, size: 24),
      // child: const Icon(Icons.more_vert, color: dark, size: 24),
      // onPressed: () => clubOptionsDialog(onSchedule: _onSchedule),
      onPressed: () =>
          isOneClub ? joiningClubsSheet() : clubSettingsDialog(clubs: _modelData.clubs, onLeave: _onLeaveClub, onJoin: joiningClubsSheet),
    );
  }

  void _onLeaveClub(List<Club> clubItems) => setState(() => _modelData.clubs = clubItems);
  // void _onSchedule() => scheduleEventDialog(club: _modelData.club, onSchedule: _viewModel.onScheduleEvent);

  void _goToMarketplace() {
    var context = navigatorKey.currentState!.context;
    LandingScreen.landingKey.currentState?.changeTab(4);
    Provider.of<LandingViewModel>(context, listen: false).updateView(4);
  }
}

class _NoClubView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var style = TextStyles.text20_500.copyWith(color: primary, fontWeight: w600);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Column(
        children: [
          SizedBox(height: 8.height),
          SvgImage(image: Assets.svg3.training, height: 15.height, color: primary.colorOpacity(0.8)),
          const SizedBox(height: 20),
          Text('are_you_a_member_of_a_disc_golf_club'.recast, textAlign: TextAlign.center, style: style),
          const SizedBox(height: 20),
          ElevateButton(
            radius: 04,
            height: 40,
            padding: 32,
            label: 'choose_a_club'.recast.toUpper,
            onTap: joiningClubsSheet,
            textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
          )
        ],
      ),
    );
  }
}
