import 'package:flutter/foundation.dart' as foundation;

import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:app/di.dart';
import 'package:app/libraries/google_analytics.dart';
import 'package:app/models/user/user.dart';
import 'package:app/preferences/user_preferences.dart';

class AppAnalytics {
  var analytics = FirebaseAnalytics.instance;

  User get _user => UserPreferences.user;
  bool get _isProd => foundation.kReleaseMode;

  void appUpdate() {
    Map<String, Object?> parameters = {'id': _user.id ?? 'un-auth user', 'name': _user.name ?? '', 'email': _user.email ?? ''};
    if (_isProd) sl<GoogleAnalytics>().appUpdateEvent(parameters);
  }

  void screenView(String screen) {
    if (_isProd) sl<GoogleAnalytics>().screenViewEvent(screen);
  }

  void logEvent({String name = '', Map<String, dynamic>? parameters}) {
    if (_isProd && name.isNotEmpty) sl<GoogleAnalytics>().logEvent(name: name, parameters: parameters);
  }
}
