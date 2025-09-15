import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/models/leaderboard/leaderboard.dart';
import 'package:app/models/system/data_model.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/repository/leaderboard_repo.dart';

class LeaderboardViewModel with ChangeNotifier {
  var loader = DEFAULT_LOADER;
  var clubMenu = LEADERBOARD_CATEGORY_LIST.first;
  var friendMenu = LEADERBOARD_CATEGORY_LIST.first;
  var clubLeaderboard = Leaderboard();
  var friendLeaderboard = Leaderboard();

  void initViewModel() {
    unawaited(_fetchMyFriendLeaderboards());
    _fetchClubLeaderboards();
    notifyListeners();
  }

  void disposeViewModel() {
    loader = DEFAULT_LOADER;
    clubMenu = LEADERBOARD_CATEGORY_LIST.first;
    friendMenu = LEADERBOARD_CATEGORY_LIST.first;
    clubLeaderboard = Leaderboard();
    friendLeaderboard = Leaderboard();
  }

  void clearStates() {
    loader = DEFAULT_LOADER;
    clubMenu = LEADERBOARD_CATEGORY_LIST.first;
    friendMenu = LEADERBOARD_CATEGORY_LIST.first;
    clubLeaderboard = Leaderboard();
    friendLeaderboard = Leaderboard();
  }

  Future<void> _fetchClubLeaderboards() async {
    loader.common = true;
    notifyListeners();
    var sortKey = clubMenu.value;
    var response = await sl<LeaderboardRepository>().fetchClubBasedLeaderboard(sortKey: sortKey);
    clubLeaderboard = Leaderboard();
    if (response != null) clubLeaderboard = response;
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  Future<void> _fetchMyFriendLeaderboards({bool isFirst = true}) async {
    if (!isFirst) loader.common = true;
    if (!isFirst) notifyListeners();
    var sortKey = friendMenu.value;
    var response = await sl<LeaderboardRepository>().fetchFriendBasedLeaderboard(sortKey: sortKey);
    friendLeaderboard = Leaderboard();
    if (response != null) friendLeaderboard = response;
    if (!isFirst) loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  void onClubMenu(DataModel item) {
    clubMenu = item;
    notifyListeners();
    _fetchClubLeaderboards();
  }

  void onFriendMenu(DataModel item) {
    friendMenu = item;
    notifyListeners();
    _fetchMyFriendLeaderboards(isFirst: false);
  }
}
