import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/graph/view_models/grid_path_view_model.dart';
import 'package:app/models/disc/user_disc.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/size_config.dart';

const _DURATION = Duration(seconds: 1);
const _STRAIT_LINE = FlLine(color: primary, strokeWidth: 0.8);
var _DOT_PAINTER = FlDotCirclePainter(radius: 8, color: primary);

class GridPathScreen extends StatefulWidget {
  final String name;
  final List<UserDisc> discs;
  const GridPathScreen({this.discs = const [], this.name = ''});

  @override
  State<GridPathScreen> createState() => _GridPathScreenState();
}

class _GridPathScreenState extends State<GridPathScreen> {
  var _viewModel = GridPathViewModel();
  var _modelData = GridPathViewModel();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('grid-path-screen');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel(widget.discs));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<GridPathViewModel>(context, listen: false);
    _modelData = Provider.of<GridPathViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _viewModel.disposeViewModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        leading: const BackMenu(),
        title: Text(widget.name.isEmpty ? 'grid_view_of_your_discs' : '${'grid_view_of'.recast} ${widget.name}'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: SizeConfig.width,
        height: SizeConfig.height,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
        child: Stack(children: [_screenView(context), if (_modelData.loader.loader) const ScreenLoader()]),
      ),
    );
  }

  Widget _screenView(BuildContext context) {
    var key = ValueKey<List<ScatterSpot>>(_modelData.graph.graphSpots);
    return Padding(
      padding: const EdgeInsets.only(left: 08, right: 16),
      child: Column(
        children: [
          const SizedBox(height: 14),
          Expanded(child: AnimatedSwitcher(duration: _DURATION, child: ScatterChart(key: key, _scatterChartData))),
          SizedBox(height: SizeConfig.bottom + 32),
        ],
      ),
    );
  }

  ScatterChartData get _scatterChartData {
    return ScatterChartData(
      minX: -5,
      maxX: _modelData.graph.maxX > 6 ? _modelData.graph.maxX : 6,
      minY: 0,
      maxY: _modelData.graph.maxY > 14 ? _modelData.graph.maxY : 14,
      titlesData: _titlesData,
      scatterTouchData: _scatterTouchData,
      scatterSpots: _modelData.graph.graphSpots.map((spot) => spot.copyWith(dotPainter: _DOT_PAINTER)).toList(),
      borderData: FlBorderData(show: true, border: Border.all(color: primary, width: 0.4)),
      clipData: const FlClipData(top: false, bottom: false, left: false, right: false),
      gridData: FlGridData(getDrawingHorizontalLine: (v) => _STRAIT_LINE, getDrawingVerticalLine: (v) => _STRAIT_LINE),
      showingTooltipIndicators: List.generate(_modelData.graph.graphSpots.length, (index) => index),
    );
  }

  FlTitlesData get _titlesData {
    var style = TextStyles.text16_600.copyWith(color: primary, fontWeight: w500, fontSize: 20);
    var bottomLabel = Text('${'stability'.recast} (${'turn'.recast} + ${'fade'.recast})', style: style);
    var top = AxisTitles(sideTitles: _topTitles, axisNameWidget: bottomLabel, axisNameSize: 26);
    var left = AxisTitles(sideTitles: _leftTitles, axisNameWidget: Text('speed'.recast, style: style), axisNameSize: 26);
    // var bottom = AxisTitles(sideTitles: _bottomTitles, axisNameWidget: bottomLabel, axisNameSize: 26);
    return FlTitlesData(topTitles: top, leftTitles: left, bottomTitles: const AxisTitles(), rightTitles: const AxisTitles());
  }

  SideTitles get _topTitles => SideTitles(getTitlesWidget: _topTitleWidgets, showTitles: true, interval: 1, reservedSize: 40);
  SideTitles get _leftTitles => SideTitles(getTitlesWidget: _leftTitleWidgets, showTitles: true, interval: 1, reservedSize: 30);
  // SideTitles get _bottomTitles => SideTitles(getTitlesWidget: _bottomTitleWidgets, showTitles: true, interval: 1, reservedSize: 24);

  Widget _topTitleWidgets(double value, TitleMeta meta) {
    final maxX = _modelData.graph.maxX > 6 ? _modelData.graph.maxX : 6;
    final reversedValue = maxX + (-5) - value;
    var style = TextStyles.text13_600.copyWith(color: primary);
    var slideData = const SideTitleFitInsideData(enabled: true, axisPosition: 10, parentAxisSize: 10, distanceFromEdge: 0);
    return SideTitleWidget(meta: meta, fitInside: slideData, child: Text(reversedValue.formatDouble, style: style));
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyles.text13_600.copyWith(color: primary);
    var slideData = const SideTitleFitInsideData(enabled: true, axisPosition: -20, parentAxisSize: 10, distanceFromEdge: -30);
    return SideTitleWidget(meta: meta, fitInside: slideData, child: Text(value.formatDouble, style: style));
  }

  /*Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyles.text13_600.copyWith(color: primary);
    var slideData = const SideTitleFitInsideData(enabled: true, axisPosition: 10, parentAxisSize: 10, distanceFromEdge: 0);
    return SideTitleWidget(meta: meta, fitInside: slideData, child: Text(value.formatDouble, style: style));
  }*/

  ScatterTouchData get _scatterTouchData {
    return ScatterTouchData(
      enabled: false,
      handleBuiltInTouches: true,
      touchTooltipData: ScatterTouchTooltipData(
        tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 04),
        getTooltipItems: (scatterSpot) {
          var scatterSpotIndex = _modelData.findScattedIndex(scatterSpot);
          var disc = scatterSpotIndex < 0 ? UserDisc() : _modelData.discs[scatterSpotIndex];
          var style = const TextStyle(color: white, fontWeight: w600, height: 1);
          return ScatterTooltipItem(disc.parentDisc?.name ?? '', textStyle: style);
        },
      ),
      touchCallback: (event, response) {},
    );
  }
}
