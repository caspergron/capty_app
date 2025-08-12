import 'dart:async';
import 'dart:convert';

import 'package:app/constants/app_keys.dart';
import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/home/home_view_model.dart';
import 'package:app/models/chat/chat_message.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/models/system/paginate.dart';
import 'package:app/models/user/notification.dart' as notify;
import 'package:app/preferences/user_preferences.dart';
import 'package:app/repository/chat_repository.dart';
import 'package:app/repository/notifiation_repo.dart';
import 'package:app/services/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsViewModel with ChangeNotifier {
  var loader = DEFAULT_LOADER;
  var notifications = <notify.Notification>[];
  var paginate = Paginate();
  var scrollControl = ScrollController();
  var messageFeeds = <ChatMessage>[];

  Future<void> initViewModel() async {
    await fetchNotifications();
    unawaited(fetchMessageFeeds());
    unawaited(_paginationCheck());
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  void disposeViewModel() {
    loader.common = true;
    messageFeeds.clear();
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

  Future<void> _paginationCheck() async {
    scrollControl.addListener(() {
      var maxPosition = scrollControl.position.pixels == scrollControl.position.maxScrollExtent;
      if (maxPosition && paginate.length == COMMON_LENGTH_20) fetchMessageFeeds(isPaginate: true);
    });
  }

  Future<void> fetchMessageFeeds({bool isPaginate = false}) async {
    if (paginate.pageLoader) return;
    paginate.pageLoader = isPaginate;
    notifyListeners();
    var response = await sl<ChatRepository>().fetchChats();
    paginate.length = response.length;
    if (paginate.page == 1) messageFeeds.clear();
    if (paginate.length >= COMMON_LENGTH_20) paginate.page++;
    if (response.isNotEmpty) messageFeeds.addAll(response);
    paginate.pageLoader = false;
    notifyListeners();
  }

  void removeMessage(int receiverId) {
    if (messageFeeds.isEmpty) return;
    var index = messageFeeds.indexWhere((item) => item.senderId == receiverId);
    if (index < 0) return;
    messageFeeds.removeAt(index);
    notifyListeners();
  }

  void setLastMessage(ChatMessage message) {
    if (messageFeeds.isEmpty) return;
    if (message.chatStatus == null) return;
    var meAsSender = message.senderId == UserPreferences.user.id;
    var index = messageFeeds.indexWhere((item) => meAsSender ? item.receiverId == message.receiverId : item.senderId == message.senderId);
    if (index < 0) return;
    messageFeeds[index].message = message.message;
    messageFeeds[index].sendTime = message.sendTime;
    messageFeeds[index].readTime = message.sendTime;
    messageFeeds[index].dateMilliSecond = message.dateMilliSecond;
    messageFeeds[index].updatedAt = message.updatedAt;
    messageFeeds.sort((item1, item2) => item2.sendTime.dateToKey.compareTo(item1.sendTime.dateToKey));
    notifyListeners();
    var context = navigatorKey.currentState!.context;
    Provider.of<HomeViewModel>(context, listen: false).updateUi();
  }

  void setReceivedMessage(ChatMessage message) {
    if (messageFeeds.isEmpty) return;
    if (message.chatStatus == null) return;
    var index = messageFeeds.indexWhere((item) => item.endUser?.id == message.endUser?.id);
    if (index < 0) return;
    messageFeeds[index].message = message.message;
    messageFeeds[index].sendTime = message.sendTime;
    messageFeeds[index].readTime = message.sendTime;
    messageFeeds[index].dateMilliSecond = message.dateMilliSecond;
    messageFeeds[index].updatedAt = message.updatedAt;
    messageFeeds.sort((item1, item2) => item2.sendTime.dateToKey.compareTo(item1.sendTime.dateToKey));
    notifyListeners();
    var context = navigatorKey.currentState!.context;
    Provider.of<HomeViewModel>(context, listen: false).updateUi();
  }

  void setReadStatus(ChatMessage message) {
    var index = messageFeeds.indexWhere((item) => item.endUser?.id == message.endUser?.id);
    if (index < 0) return;
    messageFeeds[index].readTime = message.sendTime;
    messageFeeds[index].chatStatus = 'received';
    notifyListeners();
  }
}
