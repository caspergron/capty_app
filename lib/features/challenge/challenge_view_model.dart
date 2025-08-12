import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:app/constants/data_constants.dart';
import 'package:app/models/system/data_model.dart';
import 'package:app/models/system/loader.dart';
import 'package:app/services/api_status.dart';

class ChallengeViewModel with ChangeNotifier {
  var loader = DEFAULT_LOADER;
  var menu = CHAT_SUGGESTIONS.first;
  var discList = <String>[];

  Future<void> initViewModel() async {
    if (ApiStatus.instance.marketplace) return;
    unawaited(_fetchUsedDiscs());
    await _fetchNewDiscs();
    ApiStatus.instance.marketplace = true;
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  void clearStates() {
    loader = DEFAULT_LOADER;
  }

  Future<void> _fetchNewDiscs() async {
    await Future.delayed(const Duration(seconds: 1));
    discList = ['', '', '', '', '', ''];
    notifyListeners();
  }

  Future<void> _fetchUsedDiscs() async {
    await Future.delayed(const Duration(seconds: 1));
    discList = ['', '', '', '', '', ''];
    notifyListeners();
  }
}
