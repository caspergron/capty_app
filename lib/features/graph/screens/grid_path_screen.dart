import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import 'package:app/components/loaders/screen_loader.dart';
import 'package:app/components/menus/back_menu.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/graph/view_models/grid_path_view_model.dart';
import 'package:app/models/disc/user_disc.dart';
import 'package:app/models/disc_bag/disc_bag.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/gradients.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/library/svg_image.dart';

const _DURATION = Duration(seconds: 1);
const _STRAIT_LINE = FlLine(color: primary, strokeWidth: 0.8);
final _DOT_PAINTER = FlDotCirclePainter(radius: 8, color: primary);

class GridPathScreen extends StatefulWidget {
  final int index;
  final List<DiscBag> bags;
  const GridPathScreen({this.bags = const [], this.index = 0});

  @override
  State<GridPathScreen> createState() => _GridPathScreenState();
}

class _GridPathScreenState extends State<GridPathScreen> with SingleTickerProviderStateMixin {
  var _tabIndex = 0;
  var _viewModel = GridPathViewModel();
  var _modelData = GridPathViewModel();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('grid-path-screen');
    _tabIndex = widget.index > 0 ? widget.index : 0;
    _tabController = TabController(length: widget.bags.length, vsync: this, initialIndex: _tabIndex);
    _tabController.addListener(() => setState(() => _tabIndex = _tabController.index));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _viewModel.initViewModel(widget.bags));
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
    final bagName = widget.bags[_tabIndex].bag_menu_display_name;
    final label1 = '${'grid_view_of'.recast} $bagName';
    final label2 = 'grid_view_of_your_discs'.recast;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        leading: const BackMenu(),
        automaticallyImplyLeading: false,
        title: Text(widget.bags.length < 2 ? label1 : label2),
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
    const padding = EdgeInsets.only(left: 08, right: 16);
    return Column(
      children: [
        if (widget.bags.length > 1) const SizedBox(height: 10),
        if (widget.bags.length > 1)
          Container(
            height: 38,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
            decoration: BoxDecoration(color: lightBlue, borderRadius: BorderRadius.circular(60)),
            child: TabBar(
              labelColor: primary,
              unselectedLabelColor: primary,
              controller: _tabController,
              isScrollable: widget.bags.length > 3,
              labelPadding: EdgeInsets.symmetric(horizontal: widget.bags.length > 3 ? 14 : 04),
              indicator: BoxDecoration(color: skyBlue, borderRadius: BorderRadius.circular(60), border: Border.all(color: primary)),
              tabs: List.generate(widget.bags.length, (index) => Tab(text: widget.bags[index].bag_menu_display_name)).toList(),
            ),
          ),
        const SizedBox(height: 12),
        if (!_modelData.loader.initial)
          Expanded(
            child: AnimatedSwitcher(
              duration: _DURATION,
              child: Padding(
                padding: padding,
                child: TabBarView(
                  controller: _tabController,
                  physics: widget.bags.length < 2 ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                  children: List.generate(_modelData.graphs.length, (i) {
                    final graph = _modelData.graphs[i];
                    final key = ValueKey<List<ScatterSpot>>(graph.graphSpots);
                    if (graph.graphSpots.isEmpty) return _NoGraphDataFound();
                    return ScatterChart(key: key, _scatterChartData(i), duration: _DURATION);
                  }).toList(),
                ),
              ),
            ),
          ),
        SizedBox(height: SizeConfig.bottom + 32),
      ],
    );
  }

  ScatterChartData _scatterChartData(int index) {
    final graph = _modelData.graphs[index];
    return ScatterChartData(
      minX: -5,
      minY: 0,
      maxX: graph.maxX > 6 ? graph.maxX : 6,
      maxY: graph.maxY > 14 ? graph.maxY : 14,
      titlesData: _titlesData,
      scatterTouchData: _scatterTouchData(index),
      scatterSpots: graph.graphSpots.map((spot) => spot.copyWith(dotPainter: _DOT_PAINTER)).toList(),
      borderData: FlBorderData(show: true, border: Border.all(color: primary, width: 0.4)),
      clipData: const FlClipData(top: false, bottom: false, left: false, right: false),
      gridData: FlGridData(getDrawingHorizontalLine: (v) => _STRAIT_LINE, getDrawingVerticalLine: (v) => _STRAIT_LINE),
      showingTooltipIndicators: List.generate(graph.graphSpots.length, (index) => index),
    );
  }

  FlTitlesData get _titlesData {
    final style = TextStyles.text16_600.copyWith(color: primary, fontWeight: w500, fontSize: 20);
    final bottomLabel = Text('${'stability'.recast} (${'turn'.recast} + ${'fade'.recast})', style: style);
    final top = AxisTitles(sideTitles: _topTitles, axisNameWidget: bottomLabel, axisNameSize: 26);
    final left = AxisTitles(sideTitles: _leftTitles, axisNameWidget: Text('speed'.recast, style: style), axisNameSize: 26);
    // final bottom = AxisTitles(sideTitles: _bottomTitles, axisNameWidget: bottomLabel, axisNameSize: 26);
    return FlTitlesData(topTitles: top, leftTitles: left, bottomTitles: const AxisTitles(), rightTitles: const AxisTitles());
  }

  SideTitles get _topTitles => SideTitles(getTitlesWidget: _topTitleWidgets, showTitles: true, interval: 1, reservedSize: 40);
  SideTitles get _leftTitles => SideTitles(getTitlesWidget: _leftTitleWidgets, showTitles: true, interval: 1, reservedSize: 30);
  // SideTitles get _bottomTitles => SideTitles(getTitlesWidget: _bottomTitleWidgets, showTitles: true, interval: 1, reservedSize: 24);

  Widget _topTitleWidgets(double value, TitleMeta meta) {
    final graph = _modelData.graphs[_tabIndex];
    final maxX = graph.maxX > 6 ? graph.maxX : 6;
    final reversedValue = maxX + (-5) - value;
    final style = TextStyles.text13_600.copyWith(color: primary);
    const slideData = SideTitleFitInsideData(enabled: true, axisPosition: 10, parentAxisSize: 10, distanceFromEdge: 0);
    return SideTitleWidget(meta: meta, fitInside: slideData, child: Text(reversedValue.formatDouble, style: style));
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyles.text13_600.copyWith(color: primary);
    const slideData = SideTitleFitInsideData(enabled: true, axisPosition: -20, parentAxisSize: 10, distanceFromEdge: -30);
    return SideTitleWidget(meta: meta, fitInside: slideData, child: Text(value.formatDouble, style: style));
  }

  /*Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyles.text13_600.copyWith(color: primary);
    final slideData = const SideTitleFitInsideData(enabled: true, axisPosition: 10, parentAxisSize: 10, distanceFromEdge: 0);
    return SideTitleWidget(meta: meta, fitInside: slideData, child: Text(value.formatDouble, style: style));
  }*/

  ScatterTouchData _scatterTouchData(index) {
    return ScatterTouchData(
      enabled: false,
      handleBuiltInTouches: true,
      touchTooltipData: ScatterTouchTooltipData(
        tooltipPadding: const EdgeInsets.symmetric(horizontal: 06, vertical: 04),
        getTooltipItems: (scatterSpot) {
          const style = TextStyle(color: white, fontWeight: w600, height: 1);
          final scatterSpotIndex = _modelData.findScattedIndex(scatterSpot, index);
          final disc = scatterSpotIndex < 0 ? UserDisc() : _modelData.discBags[index].userDiscs?[scatterSpotIndex] ?? UserDisc();
          return ScatterTooltipItem(disc.name ?? '', textStyle: style);
        },
      ),
      touchCallback: (event, response) {},
    );
  }
}

class _NoGraphDataFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const desc = 'we_could_not_find_any_discs_right_now_please_try_again_later';
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10.height),
          SvgImage(image: Assets.svg3.graph, height: 16.height, color: mediumBlue),
          const SizedBox(height: 18),
          Text('no_graph_data_found'.recast, textAlign: TextAlign.center, style: TextStyles.text16_600.copyWith(color: primary)),
          const SizedBox(height: 04),
          Text(desc.recast, textAlign: TextAlign.center, style: TextStyles.text14_400.copyWith(color: primary)),
        ],
      ),
    );
  }
}
