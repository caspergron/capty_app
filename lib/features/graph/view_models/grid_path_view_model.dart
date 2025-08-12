import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:fl_chart/fl_chart.dart';

import 'package:app/constants/data_constants.dart';
import 'package:app/models/system/loader.dart';

class GridPathViewModel with ChangeNotifier {
  var loader = DEFAULT_LOADER;
  var spots = <ScatterSpot>[];

  Future<void> initViewModel() async {
    await _fetchGridPathsInfo();
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  void disposeViewModel() {
    loader = DEFAULT_LOADER;
  }

  Future<void> _fetchGridPathsInfo() async {
    await Future.delayed(const Duration(seconds: 1));
    spots = [ScatterSpot(3, 5), ScatterSpot(7, 3), ScatterSpot(4, 6), ScatterSpot(9, 7)];
    notifyListeners();
  }
}
