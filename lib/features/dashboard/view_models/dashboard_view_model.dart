import 'dart:async';

import 'package:flutter/material.dart';

import 'package:app/di.dart';
import 'package:app/libraries/app_updater.dart';
import 'package:app/libraries/permissions.dart';
import 'package:app/models/public/app_statistics.dart';
import 'package:app/models/public/country.dart';
import 'package:app/preferences/app_preferences.dart';
import 'package:app/repository/public_repo.dart';

class DashboardViewModel with ChangeNotifier {
  var loader = true;
  var country = Country();
  var statistics = AppStatistics();

  void initViewModel() {
    sl<AppUpdater>().checkAppForceUpdate();
    AppPreferences.fetchCountries();
    _fetchStatistics();
  }

  void clearStates() {
    loader = true;
    country = Country();
  }

  Future<void> _fetchStatistics() async {
    var response = await sl<PublicRepository>().fetchAppStatistics();
    if (response != null) statistics = response;
    loader = false;
    notifyListeners();
    unawaited(sl<Permissions>().getLocationPermission());
  }
}
