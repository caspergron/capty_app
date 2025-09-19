import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';

import 'package:fl_chart/fl_chart.dart';

import 'package:app/constants/data_constants.dart';
import 'package:app/models/chart/graph_model.dart';
import 'package:app/models/chart/line_bar.dart';
import 'package:app/models/disc/user_disc.dart';
import 'package:app/models/system/loader.dart';

const _CENTER = 5.0;
const _INITIAL_SPOT = FlSpot(_CENTER, 0);

class FlightPathViewModel with ChangeNotifier {
  var loader = DEFAULT_LOADER;
  var lineBars = <LineBar>[];
  var discs = <UserDisc>[];
  var graph = GraphModel();

  Future<void> initViewModel(List<UserDisc> discItems) async {
    discs = discItems;
    notifyListeners();
    await _fetchFlightPathsInfo();
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  void disposeViewModel() {
    loader = DEFAULT_LOADER;
  }

  Future<void> _fetchFlightPathsInfo() async {
    await Future.delayed(const Duration(seconds: 1));
    // graph.lineBars = sl<GraphHelper>().getLineBarSpots(discs);

    final spots = _DUMMY_SPOTS;
    final colors = _generateColorsForSpots(spots.length);
    lineBars = List.generate(spots.length, (index) => LineBar(spots: spots[index], color: colors[index]));
    notifyListeners();
  }

  List<Color> _generateColorsForSpots(int length) {
    final random = Random();
    List<Color> colors = [];
    colors.addAll(PREDEFINED_COLORS.take(min(length, PREDEFINED_COLORS.length)));
    while (colors.length < length) {
      colors.add(Color.fromARGB(255, random.nextInt(100), random.nextInt(100), random.nextInt(100)));
    }
    return colors;
  }
}

final _DUMMY_SPOTS = [
  [_INITIAL_SPOT, const FlSpot(_CENTER, 8), const FlSpot(_CENTER - 5, 10)],
  [_INITIAL_SPOT, const FlSpot(_CENTER, 7), const FlSpot(_CENTER - 4, 9.3)],
  [_INITIAL_SPOT, const FlSpot(_CENTER, 6), const FlSpot(_CENTER - 3, 9)],
  [_INITIAL_SPOT, const FlSpot(_CENTER, 5), const FlSpot(_CENTER - 4, 7.5)],
];
