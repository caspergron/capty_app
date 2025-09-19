import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/settings/settings_view_model.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/settings/settings.dart';
import 'package:app/repository/pref_repo.dart';

class NotifyPrefViewModel with ChangeNotifier {
  var loader = true;
  var settings = Settings();

  void initViewModel(Settings item) {
    settings = item;
    loader = false;
    notifyListeners();
  }

  void disposeViewModel() {
    loader = true;
    settings = Settings();
  }

  Future<void> onNotification(bool value) async {
    loader = true;
    notifyListeners();
    final body = {'enable_notifications': value ? 1 : 0};
    final response = await sl<PreferencesRepository>().updatePreferences(body);
    if (response != null) settings = response;
    if (response != null) _updateSettings(response);
    loader = false;
    notifyListeners();
  }

  Future<void> onTournamentNotification(bool value) async {
    if (!settings.enable_notification) return FlushPopup.onInfo(message: 'please_allow_notification_first'.recast);
    loader = true;
    notifyListeners();
    final body = {'enable_tournament_notification': value ? 1 : 0};
    final response = await sl<PreferencesRepository>().updatePreferences(body);
    if (response != null) settings = response;
    if (response != null) _updateSettings(response);
    loader = false;
    notifyListeners();
  }

  Future<void> onClubNotification(bool value) async {
    if (!settings.enable_notification) return FlushPopup.onInfo(message: 'please_allow_notification_first'.recast);
    loader = true;
    notifyListeners();
    final body = {'enable_club_notification': value ? 1 : 0};
    final response = await sl<PreferencesRepository>().updatePreferences(body);
    if (response != null) settings = response;
    if (response != null) _updateSettings(response);
    loader = false;
    notifyListeners();
  }

  Future<void> onClubEventNotification(bool value) async {
    if (!settings.enable_notification) return FlushPopup.onInfo(message: 'please_allow_notification_first'.recast);
    loader = true;
    notifyListeners();
    final body = {'enable_club_event_notification': value ? 1 : 0};
    final response = await sl<PreferencesRepository>().updatePreferences(body);
    if (response != null) settings = response;
    if (response != null) _updateSettings(response);
    loader = false;
    notifyListeners();
  }

  void _updateSettings(Settings item) {
    final context = navigatorKey.currentState!.context;
    Provider.of<SettingsViewModel>(context, listen: false).updateSettings(item);
  }
}
