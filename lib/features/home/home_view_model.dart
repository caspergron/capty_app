import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/libraries/locations.dart';
import 'package:app/models/club/club.dart';
import 'package:app/models/club/event.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/models/user/dashboard_count.dart';
import 'package:app/preferences/app_preferences.dart';
import 'package:app/repository/club_repo.dart';
import 'package:app/repository/user_repo.dart';
import 'package:app/services/api_status.dart';

class HomeViewModel with ChangeNotifier {
  var loader = DEFAULT_LOADER;
  var clubEvents = <Event>[];
  var dashboardCount = DashboardCount();
  var clubInfo = Club();

  Future<void> initViewModel() async {
    if (ApiStatus.instance.home) return;
    unawaited(AppPreferences.fetchCountries());
    unawaited(sl<UserRepository>().fetchProfileInfo());
    unawaited(fetchDashboardCount());
    unawaited(fetchDefaultClubInfo());
    unawaited(_fetchClosestClubEvents());
    ApiStatus.instance.home = true;
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  void updateUi() => notifyListeners();

  void clearStates() {
    clubEvents.clear();
    loader = DEFAULT_LOADER;
    dashboardCount = DashboardCount();
    clubInfo = Club();
  }

  Future<void> fetchDashboardCount({bool isDelay = false}) async {
    if (isDelay) await Future.delayed(const Duration(milliseconds: 3500));
    final response = await sl<UserRepository>().fetchDashboardCount();
    if (response != null) dashboardCount = response;
    notifyListeners();
  }

  Future<void> fetchDefaultClubInfo() async {
    final response = await sl<ClubRepository>().fetchDefaultClubInfo();
    clubInfo = Club();
    if (response != null) clubInfo = response;
    notifyListeners();
  }

  Future<void> _fetchClosestClubEvents() async {
    final coordinates = await sl<Locations>().fetchLocationPermission();
    if (!coordinates.is_coordinate) loader = Loader(initial: false, common: false);
    if (!coordinates.is_coordinate) return notifyListeners();
    final response = await sl<ClubRepository>().findEvents(coordinates);
    if (response.isNotEmpty) clubEvents = response;
    loader = Loader(initial: false, common: false);
    notifyListeners();
    return;
  }
}
