import 'dart:async';

import 'package:upgrader/upgrader.dart';

import 'package:app/components/dialogs/app_update_dialog.dart';

class AppUpdater {
  final _upgrader = Upgrader();

  Future<void> checkAppForceUpdate() async {
    // if (appForceUpdateChecked) return;
    await _upgrader.initialize();
    if (_upgrader.isUpdateAvailable()) unawaited(appUpdateDialog(upgrader: _upgrader));
    // appForceUpdateChecked = true;
  }
}
