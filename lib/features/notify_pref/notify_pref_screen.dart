import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/notify_pref/notify_pref_view_model.dart';
import 'package:app/models/settings/settings.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/flutter_switch.dart';
import 'package:app/widgets/library/svg_image.dart';

class NotifyPrefScreen extends StatefulWidget {
  final Settings settings;
  const NotifyPrefScreen({required this.settings});

  @override
  State<NotifyPrefScreen> createState() => _NotifyPrefScreenState();
}

class _NotifyPrefScreenState extends State<NotifyPrefScreen> {
  var _viewModel = NotifyPrefViewModel();
  var _modelData = NotifyPrefViewModel();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('notification-preference-screen');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel(widget.settings));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<NotifyPrefViewModel>(context, listen: false);
    _modelData = Provider.of<NotifyPrefViewModel>(context);
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
        title: Text('notification_preferences'.recast),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: SizeConfig.width,
        height: SizeConfig.height,
        decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
        child: Stack(children: [_screenView(context), if (_modelData.loader) const ScreenLoader()]),
      ),
    );
  }

  Widget _screenView(BuildContext context) {
    final settings = _modelData.settings;
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 16),
        TweenListItem(index: -1, child: _notificationOption),
        const SizedBox(height: 20),
        _PreferenceOption(
          label: 'tournament_notifications',
          description: 'receive_a_reminder_at_least_1_day_before_your_tournament',
          value: settings.tournament_notification,
          onToggle: _viewModel.onTournamentNotification,
        ),
        const SizedBox(height: 12),
        _PreferenceOption(
          index: 1,
          label: 'club_notifications',
          description: 'receive_a_reminder_at_least_1_day_before_your_tournament',
          value: settings.club_notification,
          onToggle: _viewModel.onClubNotification,
        ),
        const SizedBox(height: 12),
        _PreferenceOption(
          index: 2,
          label: 'club_event_notifications',
          description: 'receive_a_reminder_at_least_1_day_before_your_tournament',
          value: settings.club_event_notification,
          onToggle: _viewModel.onClubEventNotification,
        ),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  Widget get _notificationOption {
    final settings = _modelData.settings;
    final style = TextStyles.text14_600.copyWith(color: lightBlue, height: 1.2);
    return Container(
      width: double.infinity,
      key: const Key('notification--1'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          SvgImage(image: Assets.svg1.bell, color: lightBlue, height: 20),
          const SizedBox(width: 12),
          Expanded(child: Text('allow_notifications'.recast, maxLines: 1, overflow: TextOverflow.ellipsis, style: style)),
          const SizedBox(width: 4),
          FlutterSwitch(
            width: 40,
            height: 22,
            inactiveColor: mediumBlue,
            activeColor: mediumBlue,
            activeToggleColor: lightBlue,
            inactiveToggleColor: skyBlue,
            value: settings.enable_notification,
            onToggle: _viewModel.onNotification,
          ),
        ],
      ),
    );
  }
}

class _PreferenceOption extends StatelessWidget {
  final int index;
  final bool value;
  final String label;
  final String description;
  final Function(bool)? onToggle;

  const _PreferenceOption({this.index = 0, this.label = '', this.description = '', this.value = false, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return TweenListItem(
      index: index,
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label.recast, style: TextStyles.text14_600.copyWith(color: lightBlue)),
            const SizedBox(height: 06),
            Text(description.recast, style: TextStyles.text12_600.copyWith(color: mediumBlue, fontWeight: w400)),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'push_notification'.recast,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.text12_600.copyWith(color: lightBlue, fontSize: 12.5),
                  ),
                ),
                const SizedBox(width: 4),
                FlutterSwitch(
                  height: 22,
                  width: 40,
                  inactiveColor: mediumBlue,
                  activeColor: mediumBlue,
                  activeToggleColor: lightBlue,
                  inactiveToggleColor: skyBlue,
                  value: value,
                  onToggle: (v) => onToggle == null ? null : onToggle!(v),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
