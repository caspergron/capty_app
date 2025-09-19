import 'package:fl_chart/fl_chart.dart';

import 'package:app/models/chart/line_bar.dart';

class GraphModel {
  double maxX;
  double maxY;
  List<LineBar> lineBars;
  List<ScatterSpot> graphSpots;

  GraphModel({this.maxX = 0, this.maxY = 0, this.graphSpots = const [], this.lineBars = const []});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['max_x'] = maxX;
    map['max_y'] = maxY;
    map['graph_spots'] = graphSpots;
    map['line_bars'] = lineBars;
    return map;
  }
}
