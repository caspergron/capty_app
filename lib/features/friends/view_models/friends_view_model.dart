import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/friends/components/added_friend_dialog.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/friend/friend.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/repository/friend_repo.dart';

class FriendsViewModel with ChangeNotifier {
  var loader = DEFAULT_LOADER;
  var friends = <Friend>[];
  var friendRequests = <Friend>[];

  void initViewModel() {
    _fetchFriends();
    _fetchFriendRequests();
  }

  void disposeViewModel() {
    loader = DEFAULT_LOADER;
    friends.clear();
    friendRequests.clear();
  }

  void updateUi() => notifyListeners();

  Future<void> _fetchFriends() async {
    var response = await sl<FriendRepository>().fetchAllFriends();
    friends.clear();
    if (response.isNotEmpty) friends = response;
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  Future<void> _fetchFriendRequests() async {
    var response = await sl<FriendRepository>().fetchAllFriendRequests();
    friendRequests.clear();
    if (response.isNotEmpty) friendRequests = response;
    notifyListeners();
  }

  Future<void> onDeleteFriend(Friend item, int index) async {
    loader.common = true;
    notifyListeners();
    var response = await sl<FriendRepository>().rejectFriendRequest(item.id!);
    if (response) friends.removeAt(index);
    if (response) FlushPopup.onInfo(message: '${'deleted_successfully'.recast}!!');
    loader.common = false;
    notifyListeners();
  }

  Future<void> onAcceptRequest(Friend item, int index) async {
    loader.common = true;
    notifyListeners();
    var response = await sl<FriendRepository>().acceptFriendRequest(item.id!);
    if (response != null) {
      unawaited(_fetchFriends());
      unawaited(addedFriendDialog(friend: response.requestByUser!));
      await _fetchFriendRequests();
    }
    loader.common = false;
    notifyListeners();
  }

  Future<void> onRejectRequest(Friend item, int index) async {
    loader.common = true;
    notifyListeners();
    var response = await sl<FriendRepository>().rejectFriendRequest(item.id!);
    if (response) {
      unawaited(_fetchFriends());
      await _fetchFriendRequests();
    }
    loader.common = false;
    notifyListeners();
  }
}
