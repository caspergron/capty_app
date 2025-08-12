import 'package:clipboard/clipboard.dart';

import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/toasts_popups.dart';

class AppClipboard {
  void copy(String text) {
    FlutterClipboard.copy(text);
    ToastPopup.onInfo(message: 'copied'.recast.firstLetterCapital, isTop: false);
  }
}
