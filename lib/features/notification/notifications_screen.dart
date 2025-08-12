import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/constants/date_formats.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/notification/notifications_view_model.dart';
import 'package:app/features/notification/units/message_feeds_list.dart';
import 'package:app/features/notification/units/notification_list.dart';
import 'package:app/libraries/formatters.dart';
import 'package:app/models/chat/chat_message.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/library/svg_image.dart';

const _TABS_LIST = ['notifications', 'messages'];

class NotificationsScreen extends StatefulWidget {
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with SingleTickerProviderStateMixin {
  // var _tabIndex = 0;
  var _viewModel = NotificationsViewModel();
  var _modelData = NotificationsViewModel();
  late TabController _tabController;

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('notifications-screen');
    _tabController = TabController(length: _TABS_LIST.length, vsync: this);
    // _tabController.addListener(() => setState(() => _tabIndex = _tabController.index));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<NotificationsViewModel>(context, listen: false);
    _modelData = Provider.of<NotificationsViewModel>(context);
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
      appBar: AppBar(
        centerTitle: true,
        leading: const BackMenu(),
        title: Text('notifications'.recast),
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
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          height: 38,
          margin: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
          decoration: BoxDecoration(color: lightBlue, borderRadius: BorderRadius.circular(60)),
          child: TabBar(
            labelColor: primary,
            unselectedLabelColor: primary,
            controller: _tabController,
            indicator: BoxDecoration(color: skyBlue, borderRadius: BorderRadius.circular(60), border: Border.all(color: primary)),
            tabs: List.generate(_TABS_LIST.length, (index) => Tab(text: _TABS_LIST[index].recast)).toList(),
          ),
        ),
        if (!_modelData.loader.initial)
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: [_notificationView, _messageFeedsView],
            ),
          ),
      ],
    );
  }

  Widget get _notificationView {
    if (_modelData.loader.initial) return const SizedBox.shrink();
    var notifications = _modelData.notifications;
    if (notifications.isEmpty) return _NoNotification();
    var readNotifications = notifications.where((item) => item.is_read == true).toList();
    var unreadNotifications = notifications.where((item) => item.is_read == false).toList();
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
      children: [
        const SizedBox(height: 16),
        if (unreadNotifications.isNotEmpty) ...[
          Text('new'.recast, style: TextStyles.text16_600.copyWith(color: primary, fontWeight: w500, height: 1.1)),
          const SizedBox(height: 10),
          NotificationList(notifications: unreadNotifications, onRead: (v) => _viewModel.onNotification(v)),
          const SizedBox(height: 20),
        ],
        if (readNotifications.isNotEmpty) ...[
          Text('previous'.recast, style: TextStyles.text16_600.copyWith(color: primary, fontWeight: w500, height: 1.1)),
          const SizedBox(height: 10),
          NotificationList(notifications: readNotifications, onRead: (v) => _viewModel.onNotification(v)),
        ],
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  Widget get _messageFeedsView {
    if (_modelData.loader.initial) return const SizedBox.shrink();
    if (_modelData.messageFeeds.isEmpty) return _NoMessages();
    return ListView(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      controller: _modelData.scrollControl,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
      children: [
        const SizedBox(height: 10),
        MessageFeedsList(messageFeeds: _modelData.messageFeeds, onRead: _onRead),
        SizedBox(height: BOTTOM_GAP),
      ],
    );
  }

  void _onRead(ChatMessage item, int index) {
    var date = Formatters.formatDate(DATE_FORMAT_8, '$currentDate');
    setState(() => _modelData.messageFeeds[index].readTime = date);
    Routes.user.chat(buddy: item.chat_buddy).push();
  }
}

class _NoNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10.height),
          SvgImage(image: Assets.svg3.no_notification, height: 35.width, color: primary),
          const SizedBox(height: 28),
          Text('no_notification_found'.recast, textAlign: TextAlign.center, style: TextStyles.text16_600.copyWith(color: primary)),
          const SizedBox(height: 08),
          Text('no_notifications_available_now'.recast, textAlign: TextAlign.center, style: TextStyles.text14_400.copyWith(color: primary)),
        ],
      ),
    );
  }
}

class _NoMessages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10.height),
          SvgImage(image: Assets.svg3.no_message, height: 35.width, color: primary),
          const SizedBox(height: 20),
          Text('no_message_found'.recast, textAlign: TextAlign.center, style: TextStyles.text16_600.copyWith(color: primary)),
          const SizedBox(height: 08),
          Text('no_messages_available_now'.recast, textAlign: TextAlign.center, style: TextStyles.text14_400.copyWith(color: primary)),
        ],
      ),
    );
  }
}
