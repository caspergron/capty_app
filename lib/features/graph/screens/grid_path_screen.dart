import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/constants/date_formats.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/graph/view_models/grid_path_view_model.dart';
import 'package:app/libraries/formatters.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/size_config.dart';

const _DURATION = Duration(seconds: 1);
const _STRAIT_LINE = FlLine(color: primary, strokeWidth: 0.8);
var _DOT_PAINTER = FlDotCirclePainter(radius: 8, color: primary);

class GridPathScreen extends StatefulWidget {
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel());
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
        title: Text('your_discs'.recast),
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
    var key = ValueKey<List<ScatterSpot>>(_modelData.spots);
    return Padding(
      padding: const EdgeInsets.only(left: 08, right: 16),
      child: Column(
        children: [
          const SizedBox(height: 60),
          Expanded(child: AnimatedSwitcher(duration: _DURATION, child: ScatterChart(key: key, _scatterChartData))),
          SizedBox(height: SizeConfig.bottom + 32),
        ],
      ),
    );
  }

  ScatterChartData get _scatterChartData {
    return ScatterChartData(
      minX: 0,
      maxX: 10,
      minY: 0,
      maxY: 10,
      // scatterSpots: _modelData.spots,
      titlesData: _titlesData,
      scatterTouchData: _scatterTouchData,
      scatterSpots: _modelData.spots.map((spot) => spot.copyWith(dotPainter: _DOT_PAINTER)).toList(),
      borderData: FlBorderData(show: true, border: Border.all(color: primary, width: 0.4)),
      clipData: const FlClipData(top: true, bottom: true, left: true, right: true),
      gridData: FlGridData(getDrawingHorizontalLine: (v) => _STRAIT_LINE, getDrawingVerticalLine: (v) => _STRAIT_LINE),
    );
  }

  FlTitlesData get _titlesData {
    var axisTile = const AxisTitles();
    var left = AxisTitles(sideTitles: _leftTitles);
    var bottom = AxisTitles(sideTitles: _bottomTitles);
    return FlTitlesData(leftTitles: left, bottomTitles: bottom, topTitles: axisTile, rightTitles: axisTile);
  }

  SideTitles get _leftTitles {
    double interval = /*graphModel.maxY > 0 ? graphModel.maxY / 5 : */ 1;
    return SideTitles(getTitlesWidget: _leftTitleWidgets, showTitles: true, interval: interval, reservedSize: 40);
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    var leftValue = value / 1;
    var label = leftValue > 1 ? '${leftValue.formatDouble} m' : '${leftValue.formatDouble} m';
    var style = TextStyles.text12_600.copyWith(color: primary);
    return Text(label, textAlign: TextAlign.center, style: style);
  }

  SideTitles get _bottomTitles {
    // double interval =  maxX > 0 ? graphModel.maxX / 3 :   200;
    return SideTitles(showTitles: true, reservedSize: 24, interval: 10 / 3 /*interval*/, getTitlesWidget: _bottomTitleWidgets);
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    if (value < 1) return const SizedBox.shrink();
    var chartDate = /*!charts.haveList ? '$currentDate' : charts[value.toInt()].date ?? */ '$currentDate';
    var formattedDate = Formatters.formatDate(/*bufferTime.value > 365 ? DATE_FORMAT_15 : */ DATE_FORMAT_2, chartDate);
    var style = TextStyles.text12_600.copyWith(color: primary);
    var slideData = const SideTitleFitInsideData(enabled: true, axisPosition: 10, parentAxisSize: 10, distanceFromEdge: 10);
    return SideTitleWidget(meta: meta, fitInside: slideData, child: Text(formattedDate, style: style));
  }

  ScatterTouchData get _scatterTouchData {
    return ScatterTouchData(
      enabled: true,
      handleBuiltInTouches: true,
      touchTooltipData: ScatterTouchTooltipData(
        tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 04),
        getTooltipItems: (touchedSpot) {
          var style = const TextStyle(color: white, fontWeight: w600);
          return ScatterTooltipItem('(${touchedSpot.x.formatDouble}, ${touchedSpot.y.formatDouble})', textStyle: style);
        },
      ),
      touchCallback: (event, response) {
        if (event is FlTapUpEvent && response != null && response.touchedSpot != null) {
          final spot = response.touchedSpot!;
          debugPrint('Touched spot: (${spot.spot.x}, ${spot.spot.y})');
        }
      },
    );
  }
}
