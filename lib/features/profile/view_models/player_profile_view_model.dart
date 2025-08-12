import 'dart:async';

import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/libraries/locations.dart';
import 'package:app/models/common/tournament.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/models/user/user.dart';
import 'package:app/repository/player_repo.dart';
import 'package:flutter/cupertino.dart';

class PlayerProfileViewModel with ChangeNotifier {
  var player = User();
  var loader = DEFAULT_LOADER;
  var salesAdDiscs = <SalesAd>[];
  var upcomingTournaments = <Tournament>[];

  Future<void> initViewModel(int playerId) async {
    unawaited(_fetchPlayerProfileInfo(playerId));
    unawaited(_fetchSalesAdDiscs(playerId));
    await _fetchPlayerTournamentInfo(playerId);
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  void disposeViewModel() {
    player = User();
    loader = DEFAULT_LOADER;
    upcomingTournaments.clear();
    salesAdDiscs.clear();
  }

  Future<void> _fetchPlayerProfileInfo(int userId) async {
    var response = await sl<PlayerRepository>().fetchPlayerProfileInfo(userId);
    if (response != null) player = response;
    notifyListeners();
  }

  Future<void> _fetchSalesAdDiscs(int userId) async {
    var coordinates = await sl<Locations>().fetchLocationPermission();
    var locationParams = '&latitude=${coordinates.lat}&longitude=${coordinates.lng}';
    var params = '$userId$locationParams';
    var response = await sl<PlayerRepository>().fetchSalesAdDiscs(params);
    if (response.isNotEmpty) salesAdDiscs = response;
    notifyListeners();
  }

  Future<void> _fetchPlayerTournamentInfo(int userId) async {
    var response = await sl<PlayerRepository>().fetchPlayerTournamentInfo(userId);
    if (response.isNotEmpty) upcomingTournaments = response;
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }
}
