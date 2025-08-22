import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/test/test_controller.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/size_config.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const _DURATION = Duration(seconds: 1);
const _STRAIT_LINE = FlLine(color: primary, strokeWidth: 0.8);

class TestScreen extends StatefulWidget {
  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  var _viewModel = TestViewModel();
  var _modelData = TestViewModel();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _viewModel.initViewModel());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _viewModel = Provider.of<TestViewModel>(context, listen: false);
    _modelData = Provider.of<TestViewModel>(context);
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
        decoration: BoxDecoration(gradient: BACKGROUND_GRADIENT),
        child: Stack(
          children: [
            _screenView(context),
            if (_modelData.isLoading) const ScreenLoader(), // or keep your existing loader reference
          ],
        ),
      ),
    );
  }

  Widget _screenView(BuildContext context) {
    final key = ValueKey<List<ScatterSpot>>(_modelData.spots);
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 16),
      child: Column(
        children: [
          const SizedBox(height: 60),
          Expanded(
            child: AnimatedSwitcher(
              duration: _DURATION,
              child: ScatterChart(
                key: key,
                _scatterChartData,
                swapAnimationDuration: _DURATION,
              ),
            ),
          ),
          SizedBox(height: SizeConfig.bottom + 32),
        ],
      ),
    );
  }

  ScatterChartData get _scatterChartData {
    return ScatterChartData(
      // 0..10 grid that we map Turn/Fade into
      minX: 0,
      maxX: 10,
      minY: 0,
      maxY: 14,

      titlesData: _titlesData,
      scatterTouchData: _scatterTouchData,

      // Use the ViewModel’s live list, and keep your painter
      scatterSpots: _modelData.spots
          .map((spot) => spot.copyWith(
                  dotPainter: FlDotCirclePainter(
                radius: 10,
                color: primary,
              )))
          .toList(),

      borderData: FlBorderData(show: true, border: Border.all(color: primary, width: 0.4)),
      clipData: const FlClipData(top: true, bottom: true, left: true, right: true),

      // simple grid
      gridData: FlGridData(
        drawHorizontalLine: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (v) => _STRAIT_LINE,
        getDrawingVerticalLine: (v) => _STRAIT_LINE,
      ),
    );
  }

  FlTitlesData get _titlesData {
    final left = AxisTitles(
      axisNameWidget: Text('Fade', style: TextStyles.text16_600.copyWith(color: Colors.white)),
      axisNameSize: 28,
      sideTitles: _leftTitles,
    );
    final bottom = AxisTitles(
      axisNameWidget: Text('Turn', style: TextStyles.text16_600.copyWith(color: Colors.white)),
      axisNameSize: 28,
      sideTitles: _bottomTitles,
    );
    return FlTitlesData(
      leftTitles: left,
      bottomTitles: bottom,
      topTitles: const AxisTitles(),
      rightTitles: const AxisTitles(),
    );
  }

  // Fade: 0..5 => 0..10 grid; show ticks every 2 grid units (=1 fade step)
  SideTitles get _leftTitles {
    return SideTitles(
      showTitles: true,
      reservedSize: 10,
      interval: 1,
      getTitlesWidget: _leftTitleWidgets,
    );
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    // Only label whole Fade steps (0, 1, 2, 3, 4, 5)
    final fade = value;
    if ((fade - fade.round()).abs() > 1e-6) return const SizedBox.shrink();

    final style = TextStyles.text12_600.copyWith(color: primary);
    return Text('${fade.toStringAsFixed(0)}', textAlign: TextAlign.center, style: style);
  }

  // Turn: -5..+5 => 0..10 grid; show ticks every 2 grid units (=1 turn step)
  SideTitles get _bottomTitles {
    return SideTitles(
      showTitles: true,
      reservedSize: 28,
      interval: 1,
      getTitlesWidget: _bottomTitleWidgets,
    );
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    final turn = value; // back to -5..+5
    // if ((turn - turn.round()).abs() > 1e-6) return const SizedBox.shrink();

    final style = TextStyles.text12_600.copyWith(color: primary);
    // final fit = const SideTitleFitInsideData(enabled: true);
    return SideTitleWidget(meta: meta, /*fitInside: fit,*/ child: Text(turn.toStringAsFixed(0), style: style));
  }

  ScatterTouchData get _scatterTouchData {
    return ScatterTouchData(
      enabled: true,
      handleBuiltInTouches: true,
      touchTooltipData: ScatterTouchTooltipData(
        tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        getTooltipItems: (touchedSpot) {
          final d = _modelData.findDiscBySpot(touchedSpot.x, touchedSpot.y);
          final text = (d != null)
              ? 'S${d.speed}  G${d.glide}  T${d.turn}  F${d.fade}'
              : '(${touchedSpot.x.toStringAsFixed(1)}, ${touchedSpot.y.toStringAsFixed(1)})';
          return ScatterTooltipItem(text, textStyle: const TextStyle(color: white, fontWeight: w600));
        },
      ),
      touchCallback: (event, response) {
        if (event is FlTapUpEvent && response?.touchedSpot != null) {
          final spot = response!.touchedSpot!;
          // optional: log the mapped values for debugging
          final d = _modelData.findDiscBySpot(spot.spot.x, spot.spot.y);
          debugPrint(
              'Touched: x=${spot.spot.x}, y=${spot.spot.y}, disc=${d != null ? "S${d.speed} G${d.glide} T${d.turn} F${d.fade}" : "?"}');
        }
      },
    );
  }
}
