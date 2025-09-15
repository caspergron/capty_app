import 'dart:async';
import 'dart:convert';

import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/chat/chat_message.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/models/user/notification.dart' as notify;
import 'package:app/repository/notifiation_repo.dart';
import 'package:app/services/routes.dart';
import 'package:flutter/material.dart';

class NotificationsViewModel with ChangeNotifier {
  var loader = DEFAULT_LOADER;
  var notifications = <notify.Notification>[];

  Future<void> initViewModel() async {
    await fetchNotifications();
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  void disposeViewModel() {
    loader.common = true;
  }

  void clearStates() {
    loader = DEFAULT_LOADER;
    notifications.clear();
  }

  Future<void> fetchNotifications() async {
    var response = await sl<NotificationRepository>().fetchNotifications();
    if (response.isNotEmpty) notifications = response;
    notifyListeners();
  }

  void onNotification(notify.Notification notificationItem) {
    if (!notificationItem.is_read) onReadNotifications(notificationItem);
    var notifyKey = notificationItem.notificationType.toKey;
    if (notifyKey == SEND_MESSAGE.toKey || notifyKey == SEND_MESSAGE_1_DAY.toKey || notifyKey == SEND_MESSAGE_3_DAY.toKey) {
      if (notificationItem.metadata == null) return;
      var chatMessage = ChatMessage.fromJson(jsonDecode(notificationItem.metadata!));
      if (chatMessage.endUser == null) return;
      Routes.user.chat(buddy: chatMessage.chat_buddy).push();
    } else if (notifyKey == RECEIVE_FRIEND_REQUEST.toKey) {
      Routes.user.friends(index: 1).push();
    } else if (notifyKey == ACCEPT_FRIEND_REQUEST.toKey) {
      Routes.user.friends().push();
    } else {
      return;
    }
  }

  Future<void> onReadNotifications(notify.Notification notificationItem) async {
    var response = await sl<NotificationRepository>().readNotification(notificationItem.id!);
    if (response == null) return;
    var index = notifications.indexWhere((item) => item.id == notificationItem.id);
    if (index < 0) return;
    notifications[index] = response;
    notifyListeners();
  }
}
