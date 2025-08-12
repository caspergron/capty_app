import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';

import 'package:app/themes/colors.dart';

class LineBar {
  List<FlSpot> spots;
  Color color;

  LineBar({this.spots = const [], this.color = warning});

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['spots'] = spots;
    map['color'] = color;
    return map;
  }
}
