import 'dart:async';

import 'package:app/constants/app_keys.dart';
import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/home/home_view_model.dart';
import 'package:app/models/chat/chat_message.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/models/system/paginate.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/repository/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuddiesViewModel with ChangeNotifier {
  var loader = DEFAULT_LOADER;
  var paginate = Paginate();
  var scrollControl = ScrollController();
  var messageFeeds = <ChatMessage>[];

  Future<void> initViewModel() async {
    unawaited(fetchMessageFeeds());
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  void disposeViewModel() {
    loader.common = true;
    messageFeeds.clear();
  }

  void clearStates() {
    loader = DEFAULT_LOADER;
  }

  Future<void> fetchMessageFeeds({bool isPaginate = false}) async {
    if (paginate.pageLoader) return;
    paginate.pageLoader = isPaginate;
    notifyListeners();
    var response = await sl<ChatRepository>().fetchChats();
    paginate.length = response.length;
    if (paginate.page == 1) messageFeeds.clear();
    if (paginate.length >= LENGTH_20) paginate.page++;
    if (response.isNotEmpty) messageFeeds.addAll(response);
    paginate.pageLoader = false;
    notifyListeners();
    if (messageFeeds.isNotEmpty) scrollControl.addListener(_paginationCheck);
  }

  void _paginationCheck() {
    final position = scrollControl.position;
    final isPosition80 = position.pixels >= position.maxScrollExtent * 0.85;
    if (isPosition80 && paginate.length == LENGTH_20) fetchMessageFeeds(isPaginate: true);
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
