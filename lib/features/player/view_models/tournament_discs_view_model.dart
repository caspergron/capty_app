import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/models/disc/user_disc.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/models/user/user.dart';
import 'package:app/repository/player_repo.dart';
import 'package:app/repository/user_repo.dart';

class TournamentDiscsViewModel with ChangeNotifier {
  var loader = DEFAULT_LOADER;
  var discs = <UserDisc>[];

  Future<void> initViewModel(User? player) async => player == null ? fetchMyTournamentDiscs() : fetchPlayerTournamentDiscs(player.id!);

  void disposeViewModel() {
    loader = DEFAULT_LOADER;
    discs.clear();
  }

  Future<void> fetchMyTournamentDiscs() async {
    var response = await sl<UserRepository>().fetchTournamentDiscs();
    discs.clear();
    if (response.isNotEmpty) discs = response;
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  Future<void> fetchPlayerTournamentDiscs(int playerId) async {
    var response = await sl<PlayerRepository>().fetchPlayerTournamentDiscs(playerId);
    discs.clear();
    if (response.isNotEmpty) discs = response;
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  /*Future<void> onDiscItem(UserDisc item, int index) async {
    loader.common = true;
    notifyListeners();
    var response = await sl<DiscRepository>().fetchUserDiscDetails(item.id!);
    loader.common = false;
    if (response == null) return notifyListeners();
    unawaited(discInfoDialog(
      disc: response,
      onDelete: () => onDeleteDisc(response, index),
      onSell: () => Routes.user.create_sales_ad(tabIndex: 1, disc: response).push(),
      onDetails: () => editDiscDialog(disc: response, onSave: (params) => _onUpdateDisc(response, index)),
    ));
    notifyListeners();
  }*/
}
