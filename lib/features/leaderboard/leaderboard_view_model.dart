import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/models/common/tag.dart';
import 'package:app/models/leaderboard/leaderboard.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/repository/leaderboard_repo.dart';

class LeaderboardViewModel with ChangeNotifier {
  var loader = DEFAULT_LOADER;
  var tag = Tag();
  var tags = <Tag>[];
  var clubLeaderboard = Leaderboard();
  var friendLeaderboard = Leaderboard();

  void initViewModel() {
    unawaited(_fetchMyFriendLeaderboards());
    _fetchClubLeaderboards();
    notifyListeners();
  }

  void disposeViewModel() {
    loader = DEFAULT_LOADER;
    tag = Tag();
    tags.clear();
    clubLeaderboard = Leaderboard();
    friendLeaderboard = Leaderboard();
  }

  void clearStates() {
    loader = DEFAULT_LOADER;
    tag = Tag();
    tags.clear();
    clubLeaderboard = Leaderboard();
    friendLeaderboard = Leaderboard();
  }

  Future<void> _fetchClubLeaderboards() async {
    var response = await sl<LeaderboardRepository>().fetchClubBasedLeaderboard();
    if (response != null) clubLeaderboard = response;
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  Future<void> _fetchMyFriendLeaderboards() async {
    var response = await sl<LeaderboardRepository>().fetchFriendBasedLeaderboard();
    if (response != null) friendLeaderboard = response;
    notifyListeners();
  }

  void onTag(Tag item) {
    tag = item;
    notifyListeners();
  }
}
