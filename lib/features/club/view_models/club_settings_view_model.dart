import 'package:flutter/foundation.dart';

import 'package:app/models/club/club.dart';

class ClubSettingsViewModel with ChangeNotifier {
  var loader = false;
  var club = Club();

  void initViewModel(Club clubInfo) {
    club = clubInfo;
    notifyListeners();
  }

  void disposeViewModel() {
    loader = false;
    club = Club();
  }
}
