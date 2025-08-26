import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';

import 'package:app/components/dialogs/live_app_dialog.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/notification/notifications_view_model.dart';
import 'package:app/libraries/pusher.dart';
import 'package:app/models/chat/chat_message.dart';
import 'package:app/models/system/data_model.dart';
import 'package:app/repository/chat_repository.dart';
import 'package:app/services/api_status.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/services/routes.dart';
import 'package:app/services/storage_service.dart';

class LandingViewModel with ChangeNotifier {
  var index = 0;
  var loader = false;
  var expansion = 2;
  var navItems = BOTTOM_NAV_ITEMS;
  late Timer _timer;

  void initViewModel(int pageIndex, RemoteMessage? message) {
    if (pageIndex >= 0) updateView(pageIndex);
    if (message != null) _notificationActions(message);
    var context = navigatorKey.currentState!.context;
    Provider.of<NotificationsViewModel>(context, listen: false).fetchNotifications();
    Provider.of<NotificationsViewModel>(context, listen: false).fetchMessageFeeds();
    if (ApiStatus.instance.landing) return;
    navItems = BOTTOM_NAV_ITEMS;
    notifyListeners();
    sl<Pusher>().onInitPusher();
    _startOnlineTimer(isFirst: true);
    _checkAppOpenCount();
  }

  void updateUi() => notifyListeners();

  void clearStates() {
    index = 0;
    loader = false;
  }

  void _checkAppOpenCount() {
    if (ApiStatus.instance.releasePopup) return;
    var count = sl<StorageService>().appOpenCount;
    if (count + 1 < 11) liveAppDialog();
    sl<StorageService>().setAppOpenCount(count + 1);
  }

  void updateView(int value) {
    if (value == index) return;
    index = value;
    if (expansion == 1) expansion = 0;
    notifyListeners();
  }

  void onSpinner() {
    var isOpen = expansion == 1;
    expansion = isOpen ? 0 : 1;
    notifyListeners();
  }

  void _startOnlineTimer({required bool isFirst}) {
    if (isFirst) _setOnlineStatus(status: true);
    _timer = Timer.periodic(const Duration(minutes: 10), (timer) => _setOnlineStatus(status: true));
    notifyListeners();
  }

  void stopOnlineTimer() => _timer.cancel();

  Future<void> _setOnlineStatus({required bool status}) async {
    if (!sl<AuthService>().authStatus) return;
    unawaited(sl<ChatRepository>().setOnlineStatus(status: true));
  }

  void onSpinnerItem(DataModel item) {
    if (item.valueInt == 0) {
      onSpinner();
    } else if (item.valueInt == 1) {
      // Routes.user.create_sales_ad(tabIndex: 1).push();
      Routes.user.search_disc(index: 1).push(); // Create Sales add
      onSpinner();
    } else if (item.valueInt == 2) {
      Routes.user.add_friend().push();
      onSpinner();
    } else if (item.valueInt == 3) {
      Routes.user.search_disc(index: 0).push(); // Add disc
      onSpinner();
    } else {}
  }

  void _notificationActions(RemoteMessage message) {
    // var eventType = message.eventType ?? '';
    if (!sl<AuthService>().authStatus) return;
    var isType = message.data.containsKey('type') && message.data['type'] != null;
    if (!isType) return;
    var type = message.data['type'].toString();
    if (type.toKey == SEND_MESSAGE.toKey || type.toKey == SEND_MESSAGE_1_DAY.toKey || type.toKey == SEND_MESSAGE_3_DAY.toKey) {
      var chatMessage = ChatMessage.fromJson(jsonDecode(message.data['data_payload']));
      Routes.user.chat(buddy: chatMessage.chat_buddy).push();
    } else if (type.toKey == RECEIVE_FRIEND_REQUEST.toKey) {
      Routes.user.friends(index: 1).push();
    } else if (type.toKey == ACCEPT_FRIEND_REQUEST.toKey) {
      Routes.user.friends().push();
    } else {
      return;
    }
  }
}
