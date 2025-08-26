import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:fl_chart/fl_chart.dart';

import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/helpers/graph_helper.dart';
import 'package:app/models/chart/graph_model.dart';
import 'package:app/models/disc/user_disc.dart';
import 'package:app/models/disc_bag/disc_bag.dart';
import 'package:app/models/system/loader.dart';

class GridPathViewModel with ChangeNotifier {
  var loader = DEFAULT_LOADER;
  var discBags = <DiscBag>[];
  var graphs = <GraphModel>[];

  Future<void> initViewModel(List<DiscBag> bagItems) async {
    discBags = bagItems;
    notifyListeners();
    await _fetchGridPathsInfo();
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  void disposeViewModel() {
    graphs = [];
    discBags = [];
    loader = DEFAULT_LOADER;
  }

  Future<void> _fetchGridPathsInfo() async {
    await Future.delayed(const Duration(seconds: 1));
    discBags.forEach((item) {
      var graph = GraphModel();
      var discs = item.userDiscs ?? [];
      graph.graphSpots = discs.isEmpty ? [] : sl<GraphHelper>().getScatterSpots(discs);
      Map<String, double> maxValues = sl<GraphHelper>().getMaxValuesForGrid(graph.graphSpots);
      graph.maxX = maxValues['max_x']!;
      graph.maxY = maxValues['max_y']!;
      graph.graphSpots = sl<GraphHelper>().updateScatterSpotsOnDXAxis(graph);
      graphs.add(graph);
    });
    loader = Loader(initial: false, common: false);
    notifyListeners();
  }

  int findScattedIndex(ScatterSpot spot, int tabIndex) {
    var graph = graphs[tabIndex];
    if (graph.graphSpots.isEmpty) return -1;
    return graph.graphSpots.indexWhere((item) => item.x == spot.x && item.y == spot.y);
  }

  UserDisc? findDiscItemBySpotData(ScatterSpot spot, int tabIndex) {
    var speed = spot.y;
    var fade_plus_turn = spot.x;
    var discBag = discBags[tabIndex];
    var discs = discBag.userDiscs ?? [];
    if (discs.isEmpty) return UserDisc();
    return discs.where((item) => item.speed?.nullToDouble == speed && item.turn_plus_fade == fade_plus_turn).toList().firstOrNull;
  }
}
