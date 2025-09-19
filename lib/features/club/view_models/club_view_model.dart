import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/libraries/locations.dart';
import 'package:app/models/club/club.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/repository/club_repo.dart';
import 'package:app/repository/marketplace_repo.dart';
import 'package:app/services/api_status.dart';
import 'package:app/services/app_analytics.dart';

class ClubViewModel with ChangeNotifier {
  var loader = DEFAULT_LOADER;
  var clubs = <Club>[];
  var club = Club();
  var clubActions = <String>[];
  var salesAdDiscs = <SalesAd>[];

  Future<void> initViewModelHome() async {
    if (ApiStatus.instance.club) return;
    await fetchUserClubs(true);
    ApiStatus.instance.club = true;
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  Future<void> initViewModelClub(Club item) async {
    club = item;
    notifyListeners();
    await _fetchClubDetails(club);
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  void disposeViewModel() {
    loader = DEFAULT_LOADER;
    clubs.clear();
    club = Club();
    salesAdDiscs.clear();
    clubActions.clear();
  }

  void updateUi() => notifyListeners();

  void clearStates() {
    loader = DEFAULT_LOADER;
    clubs.clear();
    club = Club();
    salesAdDiscs.clear();
    clubActions.clear();
  }

  Future<void> fetchUserClubs(bool isHome) async {
    final response = await sl<ClubRepository>().fetchUserClubs();
    if (response.isNotEmpty) clubs = response;
    notifyListeners();
    if (isHome) await fetchDefaultClub();
  }

  Future<void> fetchDefaultClub() async {
    final response = await sl<ClubRepository>().fetchDefaultClubInfo();
    if (response != null) club = response;
    final index = clubs.isEmpty || club.id == null ? -1 : clubs.indexWhere((element) => element.id == club.id);
    if (index >= 0) clubs[index] = club;
    if (club.id != null) await fetchSellingDiscs();
    notifyListeners();
    if (response != null) sl<AppAnalytics>().logEvent(name: 'club_view', parameters: club.analyticParams);
  }

  Future<void> _fetchClubDetails(Club item) async {
    loader.common = true;
    notifyListeners();
    final response = await sl<ClubRepository>().fetchClubDetails(item);
    if (response != null) club = response;
    await fetchSellingDiscs();
    loader.common = false;
    notifyListeners();
    if (response != null) sl<AppAnalytics>().logEvent(name: 'club_view', parameters: club.analyticParams);
  }

  void onSelectClub(Club item) {
    club = item;
    notifyListeners();
    _fetchClubDetails(club);
  }

  /*Future<void> _fetchClubActions() async {
    clubActions = ['', '', '', '', '', ''];
    notifyListeners();
  }*/

  Future<void> fetchSellingDiscs() async {
    final coordinates = await sl<Locations>().fetchLocationPermission();
    final locationParams = '&latitude=${coordinates.lat}&longitude=${coordinates.lng}';
    final params = '&club_id=${club.id}&page=1$locationParams';
    final response = await sl<MarketplaceRepository>().fetchSalesDiscsByClub(params);
    salesAdDiscs.clear();
    if (response.isNotEmpty) salesAdDiscs = response;
    notifyListeners();
  }

  Future<void> onScheduleEvent(Map<String, dynamic> body) async {
    loader.common = true;
    notifyListeners();
    final response = await sl<ClubRepository>().createClubEvent(body);
    if (response != null) club.events?.insert(0, response);
    loader.common = false;
    notifyListeners();
  }
}
