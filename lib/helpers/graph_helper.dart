import 'package:app/extensions/number_ext.dart';
import 'package:app/models/chart/graph_model.dart';
import 'package:app/models/disc/user_disc.dart';
import 'package:fl_chart/fl_chart.dart';

// var _CENTER = 5.0;
// var _INITIAL_SPOT = FlSpot(_CENTER, 0);

class GraphHelper {
  List<ScatterSpot> getLineBarSpots(List<UserDisc> discList) {
    if (discList.isEmpty) return [];
    List<ScatterSpot> scatterSpots = [];
    discList.forEach((item) => scatterSpots.add(ScatterSpot(item.turn_plus_fade, item.speed.nullToDouble)));
    return scatterSpots;
  }

  Map<String, double> getMaxValuesForGrid(List<ScatterSpot> scatterSpots) {
    var maxX = scatterSpots.reduce((item1, item2) => item1.x > item2.x ? item1 : item2).x;
    var maxY = scatterSpots.reduce((item1, item2) => item1.y > item2.y ? item1 : item2).y;
    return {'max_x': maxX, 'max_y': maxY};
  }

  List<ScatterSpot> getScatterSpots(List<UserDisc> discList) {
    if (discList.isEmpty) return [];
    List<ScatterSpot> scatterSpots = [];
    discList.forEach((item) => scatterSpots.add(ScatterSpot(item.turn_plus_fade, item.speed.nullToDouble)));
    return scatterSpots;
  }

  List<ScatterSpot> updateScatterSpotsOnDXAxis(GraphModel graphModel) {
    if (graphModel.graphSpots.isEmpty) return graphModel.graphSpots;
    const minX = -5.0;
    final maxX = graphModel.maxX > 6.0 ? graphModel.maxX : 6.0;
    List<ScatterSpot> scatterSpots = [];
    graphModel.graphSpots.forEach((spot) => scatterSpots.add(ScatterSpot(maxX + minX - spot.x, spot.y)));
    return scatterSpots;
  }
}
