import 'dart:io';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/dialogs/logout_dialog.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/components/menus/capty_menu.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/home/home_view_model.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var authStatus = sl<AuthService>().authStatus;
    return Drawer(
      elevation: 0,
      width: 70.width,
      backgroundColor: skyBlue,
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: 70.width,
        decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
        padding: const EdgeInsets.only(left: 24, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: SizeConfig.statusBar),
            SizedBox(height: Platform.isIOS ? 10 : 24),
            const SizedBox(height: 20),
            authStatus ? _userProfileInfo : Center(child: CaptyMenu()),
            const SizedBox(height: 16),
            const Divider(color: mediumBlue),
            const SizedBox(height: 12),
            Expanded(child: _screenView(context)),
            if (authStatus) const SizedBox(height: 04),
            if (authStatus)
              ElevateButton(
                radius: 04,
                height: 42,
                background: skyBlue,
                width: double.infinity,
                label: 'sign_out'.recast.toUpper,
                onTap: logoutDialog,
                textStyle: TextStyles.text14_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
              ),
            SizedBox(height: BOTTOM_GAP + 14),
          ],
        ),
      ),
    );
  }

  Widget get _userProfileInfo {
    var user = UserPreferences.user;
    return Row(
      children: [
        CircleImage(
          image: user.media?.url,
          color: popupBearer.colorOpacity(0.1),
          backgroundColor: primary,
          placeholder: const FadingCircle(size: 18, color: lightBlue),
          errorWidget: SvgImage(image: Assets.svg1.coach, height: 20, color: lightBlue),
          onTap: _onUser,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InkWell(
            onTap: _onUser,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.full_name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.text14_600.copyWith(color: primary),
                ),
                const SizedBox(height: 04),
                Text(
                  '${user.phone}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.text12_600.copyWith(color: primary, fontWeight: w400, height: 1),
                ),
              ],
            ),
          ),
        ),
        InkWell(onTap: _onUser, child: SvgImage(image: Assets.svg1.edit, height: 18, color: dark)),
      ],
    );
  }

  void _onUser() {
    backToPrevious();
    Routes.user.profile().push();
  }

  Widget _screenView(BuildContext context) {
    // var user = UserPreferences.user;
    var homeModel = Provider.of<HomeViewModel>(context);
    var isLeaderboard = homeModel.dashboardCount.is_pdga && homeModel.clubInfo.id != null;
    var authStatus = sl<AuthService>().authStatus;
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(height: 4),
        if (authStatus) ...[
          _DrawerItem(label: 'my_profile'.recast, icon: Assets.svg1.coach, onTap: Routes.user.profile().push),
          const SizedBox(height: 10),
          _DrawerItem(label: 'addresses'.recast, icon: Assets.svg1.map_pin, onTap: Routes.user.addresses().push),
          const SizedBox(height: 10),
          _DrawerItem(label: 'friends_cardmates'.recast, icon: Assets.svg1.buddies, onTap: Routes.user.friends().push),
          const SizedBox(height: 10),
          if (isLeaderboard) _DrawerItem(label: 'leaderboard'.recast, icon: Assets.svg1.ranking, onTap: Routes.user.leaderboard().push),
          if (isLeaderboard) const SizedBox(height: 10),
          // _DrawerItem(label: 'course_manager'.recast, icon: Assets.svg1.coach, onTap: courseManagementDialog),
          // const SizedBox(height: 10),
          // _DrawerItem(label: 'club_manager'.recast, icon: Assets.svg1.user_square, onTap: clubManagementDialog),
          // const SizedBox(height: 10),
          _DrawerItem(label: 'suggest_a_feature'.recast, icon: Assets.svg1.help, onTap: Routes.user.suggest_feature().push),
          const SizedBox(height: 10),
        ],
        _DrawerItem(label: 'report_a_problem'.recast, icon: Assets.svg1.re_vote, onTap: Routes.user.report_problem().push),
        const SizedBox(height: 10),
        _DrawerItem(label: 'faq'.recast, icon: Assets.svg1.question, onTap: Routes.system.faq().push),
        const SizedBox(height: 10),
        _DrawerItem(label: 'privacy_policy'.recast, icon: Assets.svg1.info, onTap: Routes.system.privacy_policy().push),
        const SizedBox(height: 10),
        _DrawerItem(label: 'terms_and_conditions'.recast, icon: Assets.svg1.info, onTap: Routes.system.terms_conditions().push),
        const SizedBox(height: 10),
        authStatus
            ? _DrawerItem(label: 'settings'.recast, icon: Assets.svg1.settings, onTap: Routes.user.settings().push)
            : _DrawerItem(label: 'login'.recast, icon: Assets.svg1.sign_in, onTap: Routes.auth.sign_in().push),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String label;
  final String icon;
  final Function()? onTap;

  const _DrawerItem({this.label = '', this.icon = '', this.onTap});

  @override
  Widget build(BuildContext context) {
    var style = TextStyles.text14_500.copyWith(color: dark, fontSize: 14, fontWeight: w400, height: 1.3);
    var textWidget = Text(label, maxLines: 1, overflow: TextOverflow.fade, style: style);
    return InkWell(
      onTap: onTap == null ? null : _onItemTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 08),
        decoration: BoxDecoration(color: skyBlue, borderRadius: BorderRadius.circular(4)),
        child: Row(children: [SvgImage(image: icon, color: dark, height: 20), const SizedBox(width: 12), Expanded(child: textWidget)]),
      ),
    );
  }

  void _onItemTap() {
    if (onTap == null) return;
    backToPrevious();
    onTap!();
  }
}
