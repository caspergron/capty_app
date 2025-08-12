import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import 'package:app/animations/fade_animation.dart';
import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/graph/view_models/flight_path_view_model.dart';
import 'package:app/models/chart/line_bar.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/size_config.dart';

const _DURATION = Duration(seconds: 1);
const _STRAIT_LINE = FlLine(color: primary, strokeWidth: 0.8);

class FlightPathScreen extends StatefulWidget {
  @override
  State<FlightPathScreen> createState() => _FlightPathScreenState();
}

class _FlightPathScreenState extends State<FlightPathScreen> {
  var _viewModel = FlightPathViewModel();
  var _modelData = FlightPathViewModel();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('flight-path-screen');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<FlightPathViewModel>(context, listen: false);
    _modelData = Provider.of<FlightPathViewModel>(context);
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
    var key = '${_modelData.lineBars.length}';
    return Padding(
      padding: const EdgeInsets.only(left: 08, right: 16),
      child: Column(
        children: [
          const SizedBox(height: 60),
          Expanded(child: FadeAnimation(fadeKey: key, child: LineChart(_lineChartData, curve: Curves.easeIn, duration: _DURATION))),
          SizedBox(height: SizeConfig.bottom + 10),
        ],
      ),
    );
  }

  LineChartData get _lineChartData {
    return LineChartData(
      minY: 0,
      maxY: 10,
      minX: 0,
      maxX: 10,
      titlesData: _titlesData,
      borderData: _borderData,
      clipData: const FlClipData(top: true, bottom: true, left: true, right: true),
      gridData: FlGridData(drawVerticalLine: false, getDrawingHorizontalLine: (value) => _STRAIT_LINE),
      lineBarsData: List.generate(_modelData.lineBars.length, (index) => _lineChartBarData(_modelData.lineBars[index])).toList(),
    );
  }

  LineChartBarData _lineChartBarData(LineBar lineBar) {
    // var colors = [lineBar.color.colorOpacity(0.3), transparent];
    // var gradient = LinearGradient(colors: colors, begin: Alignment.topCenter, end: Alignment.bottomCenter);
    return LineChartBarData(
      barWidth: 2.5,
      isCurved: true,
      // curveSmoothness: 1,
      spots: lineBar.spots,
      color: lineBar.color,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      // belowBarData: BarAreaData(show: true, gradient: gradient),
    );
  }

  FlBorderData get _borderData {
    var border = const BorderSide(color: primary, width: 0.4);
    var topBorder = const BorderSide(color: primary, width: 0.8);
    return FlBorderData(show: true, border: Border(bottom: border, left: border, top: topBorder));
  }

  FlTitlesData get _titlesData {
    var axisTile = const AxisTitles();
    var left = AxisTitles(sideTitles: _leftTitles);
    // var bottom = AxisTitles(sideTitles: _bottomTitles);
    return FlTitlesData(leftTitles: left, bottomTitles: axisTile, topTitles: axisTile, rightTitles: axisTile);
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

  LineTouchData get _lineTouchData {
    return LineTouchData(
      getTouchLineEnd: (_, __) => double.infinity,
      touchTooltipData: LineTouchTooltipData(
        tooltipMargin: 4,
        fitInsideHorizontally: true,
        tooltipHorizontalAlignment: FLHorizontalAlignment.right,
        tooltipPadding: const EdgeInsets.symmetric(horizontal: 06, vertical: 04),
        getTooltipItems: (chartList) {
          List<LineTooltipItem> tooltips = [];
          for (int index = 0; index < chartList.length; index++) {
            var spot = chartList[index];
            var style = const TextStyle(color: white, fontWeight: w600);
            var lineItem = LineTooltipItem('${spot.y.ceil()}', style);
            tooltips.add(lineItem);
          }
          return tooltips;
        },
      ),
    );
  }

  /*SideTitles get _bottomTitles {
    double interval = */ /*graphModel.maxX > 0 ? graphModel.maxX / 5 : */ /* 200;
    return SideTitles(showTitles: true, reservedSize: 24, interval: interval, getTitlesWidget: _bottomTitleWidgets);
  }*/

  /*Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    var chartDate = */ /*!charts.haveList ? '$currentDate' : charts[value.toInt()].date ?? */ /* '$currentDate';
    var formattedDate = Formatters.formatDate(*/ /*bufferTime.value > 365 ? DATE_FORMAT_15 : */ /* DATE_FORMAT_2, chartDate);
    var style = TextStyles.text12_600.copyWith(color: primary);
    var slideData = const SideTitleFitInsideData(enabled: true, axisPosition: 10, parentAxisSize: 10, distanceFromEdge: 10);
    return SideTitleWidget(meta: meta, fitInside: slideData, space: 4, child: Text(formattedDate ?? '', style: style));
  }*/
}
