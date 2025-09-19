import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/components/dialogs/delete_account_dialog.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/settings/components/languges_sheet.dart';
import 'package:app/features/settings/settings_view_model.dart';
import 'package:app/preferences/app_preferences.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/flutter_switch.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/label_placeholder.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var _viewModel = SettingsViewModel();
  var _modelData = SettingsViewModel();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('settings-screen');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<SettingsViewModel>(context, listen: false);
    _modelData = Provider.of<SettingsViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _viewModel.disposeViewModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        leading: const BackMenu(),
        title: Text('settings'.recast),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: SizeConfig.width,
        height: SizeConfig.height,
        decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
        child: Stack(children: [_screenView(context), if (_modelData.loader.loader) const ScreenLoader()]),
      ),
    );
  }

  Widget _screenView(BuildContext context) {
    final user = UserPreferences.user;
    final language = AppPreferences.language;
    // final currency = _modelData.currency;
    // final measurement = _modelData.measurement;
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 16),
        _SettingsOption1(
          label: 'notification_preferences'.recast,
          description: 'receive_notifications_based_on_your_preferences'.recast,
          onTap: () => Routes.user.notify_pref(settings: _modelData.settings).push(),
        ),
        const SizedBox(height: 12),
        _SettingsOption1(
          label: 'language'.recast,
          description: '${'your_preferred_language_is'.recast} ${language.name}',
          onTap: () => languagesSheet(language: language, onLanguage: _viewModel.onLanguage),
          // onTap: () => Routes.user.club_settings(club: Provider.of<ClubViewModel>(context, listen: false).club).push(),
        ),
        const SizedBox(height: 12),
        /*_SettingsOption2(
          label: 'location'.recast,
          description: 'allow_location_access'.recast,
          value: settings.enable_location,
          onToggle: (v) => _viewModel.onLocation(v),
        ),
        const SizedBox(height: 12),*/
        Text('your_currency'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        LabelPlaceholder(
          radius: 08,
          height: 50,
          background: primary,
          textColor: lightBlue,
          label: UserPreferences.currency.label ?? '',
          icon: SvgImage(image: Assets.svg1.dollar_circle, height: 20, color: lightBlue),
          /*icon: UserPreferences.currency.symbol == null
              ? SvgImage(image: Assets.svg1.coach, height: 20, color: lightBlue)
              : Text(UserPreferences.currency.symbol ?? '', style: TextStyles.text18_700.copyWith(color: error, height: 1)),*/
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(6)),
          child: Row(
            children: [
              const Icon(Icons.leaderboard_outlined, color: lightBlue, size: 20),
              const SizedBox(width: 13),
              Expanded(child: _OptionLabels(label: 'leaderboard_sharing'.recast, description: 'leaderboard_sharing_sublabel'.recast)),
              const SizedBox(width: 08),
              FlutterSwitch(
                height: 22,
                width: 40,
                inactiveColor: mediumBlue,
                activeColor: mediumBlue,
                activeToggleColor: lightBlue,
                inactiveToggleColor: skyBlue,
                value: user.share_leaderboard,
                onToggle: _viewModel.onShareLeaderboard,
              ),
            ],
          ),
        ),
        const SizedBox(height: 04),
        Row(
          children: [
            SvgImage(image: Assets.svg1.info, color: dark, height: 14),
            const SizedBox(width: 04),
            Expanded(
              child: Text(
                'leaderboard_sharing_helper_text'.recast,
                style: TextStyles.text12_400.copyWith(color: dark, fontWeight: w500, fontSize: 12.5, height: 1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(color: primary.colorOpacity(.9), borderRadius: BorderRadius.circular(08)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('delete_account'.recast.toUpper, style: TextStyles.text14_700.copyWith(color: white, fontWeight: w900, height: 1.3)),
              const SizedBox(height: 20),
              InkWell(onTap: () => deleteAccountDialog(onDelete: () => _viewModel.onDeleteAccount()), child: _deleteButton),
            ],
          ),
        ),
      ],
    );
  }

  Widget get _deleteButton {
    final icon = SvgImage(image: Assets.svg1.trash, height: 20, color: lightBlue);
    final label = Text('delete'.recast.toUpper, style: TextStyles.text14_600.copyWith(color: white, height: 1));
    return Container(
      height: 44,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: error, borderRadius: BorderRadius.circular(08)),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [icon, const SizedBox(width: 08), label]),
    );
  }
}

class _SettingsOption1 extends StatelessWidget {
  final String label;
  final String description;
  final Function()? onTap;

  const _SettingsOption1({this.label = '', this.description = '', this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(6)),
        child: Row(
          children: [
            Expanded(child: _OptionLabels(label: label, description: description)),
            const SizedBox(width: 08),
            SvgImage(image: Assets.svg1.caret_right, height: 20, color: lightBlue),
          ],
        ),
      ),
    );
  }
}

class _OptionLabels extends StatelessWidget {
  final String label;
  final String description;
  const _OptionLabels({this.label = '', this.description = ''});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyles.text14_600.copyWith(color: lightBlue, height: 1.1)),
        const SizedBox(height: 06),
        Text(description, style: TextStyles.text12_600.copyWith(color: lightBlue, fontWeight: w400)),
      ],
    );
  }
}

/*DropdownFlutter<Currency>(
          color: lightBlue,
          background: primary,
          hint: 'select_currency'.recast,
          items: AppPreferences.currencies,
          value: currency.id == null ? null : currency,
          hintLabel: currency.id == null ? null : AppPreferences.currencies.firstWhere((item) => item.id == item.id).label,
          onChanged: (item) => _viewModel.onCurrency(item!),
        ),*/

/*const SizedBox(height: 10),
        Text('measurement'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        DropdownFlutter<DataModel>(
          color: lightBlue,
          background: primary,
          hint: 'select_measurement'.recast,
          items: DATE_MENU_LIST,
          value: measurement.value.isEmpty ? null : measurement,
          hintLabel: measurement.value.isEmpty ? null : DATE_MENU_LIST.firstWhere((item) => item.value == measurement.value).label,
          onChanged: (v) => setState(() => _modelData.measurement = v!),
        ),
        const SizedBox(height: 10),
        Text('your_date_and_time'.recast, style: TextStyles.text14_600.copyWith(color: primary)),
        const SizedBox(height: 04),
        Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(6)),
          child: Row(
            children: [
              Expanded(child: Text('24_hour_time'.recast, style: TextStyles.text14_600.copyWith(color: lightBlue))),
              const SizedBox(width: 08),
              FlutterSwitch(
                height: 22,
                inactiveColor: mediumBlue,
                activeColor: mediumBlue,
                activeToggleColor: lightBlue,
                inactiveToggleColor: skyBlue,
                value: _modelData.is24Hour,
                onToggle: (v) => setState(() => _modelData.is24Hour = v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 04),
        Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(6)),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: Text('set_automatically'.recast, style: TextStyles.text14_600.copyWith(color: lightBlue))),
                  const SizedBox(width: 08),
                  FlutterSwitch(
                    height: 22,
                    inactiveColor: mediumBlue,
                    activeColor: mediumBlue,
                    activeToggleColor: lightBlue,
                    inactiveToggleColor: skyBlue,
                    value: _modelData.is24Hour,
                    onToggle: (v) => setState(() => _modelData.is24Hour = v),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(thickness: 0.5, height: 0.5, color: lightBlue),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: Text('time_zone'.recast, style: TextStyles.text14_600.copyWith(color: lightBlue))),
                  const SizedBox(width: 08),
                  Text('Singapore', style: TextStyles.text14_400.copyWith(color: lightBlue))
                ],
              ),
            ],
          ),
        ),*/

/*class _SettingsOption2 extends StatelessWidget {
  final int index;
  final String label;
  final String description;
  final bool value;
  final Function(bool)? onToggle;

  const _SettingsOption2({this.index = 0, this.label = '', this.description = '', this.value = false, this.onToggle});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) print(index);
    return TweenListItem(
      index: index,
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(6)),
        child: Row(
          children: [
            Expanded(child: _OptionLabels(label: label, description: description)),
            const SizedBox(width: 08),
            FlutterSwitch(
              height: 22,
              inactiveColor: mediumBlue,
              activeColor: mediumBlue,
              activeToggleColor: lightBlue,
              inactiveToggleColor: skyBlue,
              value: value,
              onToggle: (v) => onToggle == null ? null : onToggle!(v),
            ),
          ],
        ),
      ),
    );
  }
}*/
