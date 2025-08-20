import 'dart:async';

import 'package:app/components/dialogs/app_update_dialog.dart';
import 'package:upgrader/upgrader.dart';

class AppUpdater {
  final _upgrader = Upgrader();

  Future<void> checkAppForceUpdate() async {
    // if (appForceUpdateChecked) return;
    // print('++++++');
    await _upgrader.initialize();
    // print(_upgrader.versionInfo.toString());
    // print('isUpdate: ${_upgrader.isUpdateAvailable()}');
    if (_upgrader.isUpdateAvailable()) unawaited(appUpdateDialog(upgrader: _upgrader));
    // appForceUpdateChecked = true;
  }
}
