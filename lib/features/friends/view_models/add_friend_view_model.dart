import 'dart:async';

import 'package:flutter/material.dart';

import 'package:app/di.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/friends/components/add_friend_dialog.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/friend/friend_info.dart';
import 'package:app/models/public/country.dart';
import 'package:app/preferences/app_preferences.dart';
import 'package:app/repository/friend_repo.dart';
import 'package:app/services/app_analytics.dart';
import 'package:app/services/storage_service.dart';

class AddFriendViewModel with ChangeNotifier {
  var loader = true;
  var country = Country();

  Future<void> initViewModel() async {
    await AppPreferences.fetchCountries();
    country = sl<StorageService>().user.country_item;
    loader = false;
    notifyListeners();
  }

  void disposeViewModel() {
    loader = true;
  }

  Future<bool> onAddFriend(String query) async {
    loader = true;
    notifyListeners();
    var response = await sl<FriendRepository>().searchForFriend(query);
    if (response != null) {
      unawaited(addFriendDialog(friend: response, onAdd: () => sendFriendRequest(response), onCancel: () => cancelFriendRequest(response)));
    }
    loader = false;
    notifyListeners();
    return response != null;
  }

  Future<void> sendFriendRequest(FriendInfo friendInfo) async {
    loader = true;
    notifyListeners();
    var body = {'request_to': friendInfo.id};
    var response = await sl<FriendRepository>().sendFriendRequest(body);
    if (response != null) sl<AppAnalytics>().logEvent(name: 'invite_friend', parameters: response.analyticParams);
    loader = false;
    notifyListeners();
  }

  Future<void> cancelFriendRequest(FriendInfo friendInfo) async {
    loader = true;
    notifyListeners();
    var response = await sl<FriendRepository>().rejectFriendRequest(friendInfo.friendId!);
    if (response) FlushPopup.onInfo(message: 'request_cancelled'.recast);
    loader = false;
    notifyListeners();
  }
}
