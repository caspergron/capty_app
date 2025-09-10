import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:app/components/sheets_loader/default_loader.dart';
import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/public/currency.dart';
import 'package:app/models/public/language.dart';
import 'package:app/models/settings/settings.dart';
import 'package:app/models/system/data_model.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/preferences/app_preferences.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/repository/pref_repo.dart';
import 'package:app/repository/public_repo.dart';
import 'package:app/repository/user_repo.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/services/storage_service.dart';

class SettingsViewModel with ChangeNotifier {
  var loader = DEFAULT_LOADER;
  var settings = Settings();
  var isLocation = false;
  var currency = Currency();
  var measurement = DataModel();
  var is24Hour = false;

  Future<void> initViewModel() async {
    unawaited(AppPreferences.fetchLanguages());
    await AppPreferences.fetchCurrencies();
    await _fetchAllPreferences();
    if (AppPreferences.currencies.isNotEmpty) _setInitialData();
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  void disposeViewModel() {
    loader = DEFAULT_LOADER;
    settings = Settings();
    isLocation = false;
    currency = Currency();
    measurement = DataModel();
    is24Hour = false;
  }

  Future<void> _fetchAllPreferences() async {
    var response = await sl<PreferencesRepository>().fetchAllPreferences();
    if (response != null) settings = response;
    notifyListeners();
  }

  void _setInitialData() {
    var user = sl<StorageService>().user;
    var currencies = AppPreferences.currencies;
    var code = user.currency?.code ?? UserPreferences.currencyCode;
    var index = currencies.indexWhere((item) => item.code.toKey == code.toKey);
    if (index < 0) return;
    currency = currencies[index];
    user.currency = currency;
    sl<StorageService>().setUser(user);
    UserPreferences.currency = currency;
    UserPreferences.currencyCode = currency.code!;
    notifyListeners();
  }

  Future<void> onLanguage(Language item) async {
    loader.common = true;
    notifyListeners();
    await sl<PublicRepository>().fetchTranslations(item);
    loader.common = false;
    notifyListeners();
  }

  Future<void> onCurrency(Currency item) async {
    loader.common = true;
    notifyListeners();
    var user = sl<StorageService>().user;
    var body = {'currency_id': item.id};
    var response = await sl<PreferencesRepository>().updateCurrency(body);
    loader.common = false;
    if (response == null) return notifyListeners();
    currency = item;
    user.currency = currency;
    sl<StorageService>().setUser(user);
    UserPreferences.currency = currency;
    UserPreferences.currencyCode = item.code!;
    settings = response;
    notifyListeners();
  }

  Future<void> onLocation(bool value) async {
    // var isLocation = await sl<Locations>().fetchLocationPermission();
    // settings.enableLocation = value;
    // notifyListeners();
  }

  Future<void> onShareLeaderboard(bool value) async {
    loader.common = true;
    notifyListeners();
    var body = {'share_leaderboard': value ? 1 : 0};
    var response = await sl<UserRepository>().updateLeaderboardSharing(body);
    if (response != null) FlushPopup.onInfo(message: '${'leaderboard_sharing_is'.recast} ${(value ? 'turned_on' : 'turned_off').recast}');
    loader.common = false;
    notifyListeners();
  }

  void updateSettings(Settings item) {
    settings = item;
    notifyListeners();
  }

  Future<void> onDeleteAccount() async {
    unawaited(defaultLoaderSheet(label: 'deleting_account'));
    await Future.delayed(const Duration(milliseconds: 1000));
    var response = await sl<UserRepository>().deleteAccount();
    if (!response) {
      backToPrevious();
      FlushPopup.onWarning(message: 'server_error_please_contact_with_capty'.recast);
    } else {
      backToPrevious();
      sl<AuthService>().onLogout();
    }
  }
}
