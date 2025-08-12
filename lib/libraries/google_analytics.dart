import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:app/extensions/string_ext.dart';

class GoogleAnalytics {
  final firebaseAnalytics = FirebaseAnalytics.instance;

  Future<void> screenViewEvent(String screen) => firebaseAnalytics.logScreenView(screenName: screen);

  Future<void> appUpdateEvent(Map<String, Object?> parameters) async => firebaseAnalytics.logEvent(name: 'app_update');

  void logEvent({String name = '', Map<String, dynamic>? parameters}) {
    Map<String, Object>? params = parameters == null ? null : {name: parameters};
    if (name.toKey.isNotEmpty) firebaseAnalytics.logEvent(name: name, parameters: params);
  }

  Future<void> firstOpenAppEvent() async {}

  Future<void> logoutEvent() async {}

  Future<void> loginEvent() async {}

  Future<void> createAccountEvent() async {}
}
