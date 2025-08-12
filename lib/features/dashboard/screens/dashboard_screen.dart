import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/dialogs/app_exit_dialog.dart';
import 'package:app/components/drawers/app_drawer.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/auth_menu.dart';
import 'package:app/components/menus/capty_menu.dart';
import 'package:app/components/menus/hamburger_menu.dart';
import 'package:app/components/sheets/country_sheet.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/dashboard/view_models/dashboard_view_model.dart';
import 'package:app/helpers/enums.dart';
import 'package:app/models/public/country.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/label_placeholder.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var _viewModel = DashboardViewModel();
  var _modelData = DashboardViewModel();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('notification-preference-screen');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    SizeConfig.initMediaQuery(context);
    _viewModel = Provider.of<DashboardViewModel>(context, listen: false);
    _modelData = Provider.of<DashboardViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return PopScopeNavigator(
      canPop: false,
      onPop: appExitDialog,
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: AppDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: CaptyMenu(),
          actions: [const AuthMenu(), ACTION_GAP, HamburgerMenu(scaffoldKey: _scaffoldKey), ACTION_SIZE],
        ),
        body: Container(
          width: SizeConfig.width,
          height: SizeConfig.height,
          decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
          child: Stack(children: [_screenView(context), if (_modelData.loader) const ScreenLoader()]),
        ),
      ),
    );
  }

  Widget _screenView(BuildContext context) {
    var stats = _modelData.statistics;
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _DashboardInfoBox(
                iconSize: 10.5.height,
                label: 'countries'.recast,
                icon: Assets.svg3.pgda_rating_1,
                value: stats.totalCountry.nullToInt,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _DashboardInfoBox(
                iconSize: 10.5.height,
                label: 'clubs'.recast,
                icon: Assets.svg3.training,
                value: stats.totalClub.nullToInt,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _DashboardInfoBox(
                iconSize: 09.5.height,
                label: 'users'.recast,
                icon: Assets.svg3.circle_putting,
                value: stats.totalUser.nullToInt,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _DashboardInfoBox(
                iconSize: 10.height,
                icon: Assets.svg1.disc_2,
                value: stats.totalSalesAdds.nullToInt,
                label: 'sales_ads'.recast.allFirstLetterCapital,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        TweenListItem(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('sales_ads_from_your_countries'.recast, style: TextStyles.text16_700.copyWith(color: lightBlue)),
                const SizedBox(height: 02),
                Text('select_your_country_to_see_sales_ads'.recast, style: TextStyles.text12_400.copyWith(color: lightBlue)),
                const SizedBox(height: 12),
                LabelPlaceholder(
                  height: 44,
                  background: lightBlue,
                  hint: 'select_country',
                  label: _modelData.country.id == null ? '' : _modelData.country.name ?? '',
                  endIcon: SvgImage(image: Assets.svg1.caret_down_1, height: 20, color: dark),
                  onTap: () => countriesSheet(country: Country(), onChanged: _onCountry),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        TweenListItem(
          index: 1,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('login_to_continue'.recast, style: TextStyles.text16_700.copyWith(color: lightBlue)),
                const SizedBox(height: 02),
                Text('create_your_own_account_to_explore_more'.recast, style: TextStyles.text12_400.copyWith(color: lightBlue)),
                const SizedBox(height: 16),
                ElevateButton(
                  radius: 04,
                  height: 40,
                  padding: 40,
                  width: double.infinity,
                  label: 'create_account'.recast.toUpper,
                  textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
                  onTap: Routes.auth.sign_in().push,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  void _onCountry(Country item) {
    if (item.currency != null) UserPreferences.currency = item.currency!;
    if (item.currency?.code != null) UserPreferences.currencyCode = item.currency!.code!;
    Routes.public.public_marketplace(country: item).push();
  }
}

class _DashboardInfoBox extends StatelessWidget {
  final String label;
  final int value;
  final String icon;
  final double iconSize;

  const _DashboardInfoBox({this.value = 0, this.label = '', this.icon = '', this.iconSize = 150});

  @override
  Widget build(BuildContext context) {
    return TweenListItem(
      twinAnim: TwinAnim.right_to_left,
      child: Stack(
        children: [
          Container(
            height: 14.height,
            width: double.infinity,
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
            child: SvgImage(image: icon, height: iconSize, color: skyBlue.colorOpacity(0.25)),
          ),
          Container(
            height: 14.height,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyles.text18_600.copyWith(color: lightBlue, fontWeight: w500)),
                SizedBox(height: SizeConfig.isSmall ? 1.2.height : 1.5.height),
                Text(
                  value.formatInt,
                  style: TextStyles.text40_700.copyWith(color: lightBlue, fontWeight: w700, fontSize: SizeConfig.isSmall ? 22.sp : 30.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
