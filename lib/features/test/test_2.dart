import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/*class Test2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ScatterChart(
          ScatterChartData(
            scatterSpots: [
              ScatterSpot(3, 4),
              ScatterSpot(6, 2),
              ScatterSpot(2, 7),
              ScatterSpot(8, 5),
              ScatterSpot(10, 5),
              ScatterSpot(6, 5),
            ],
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
                // leftTitles: SideTitles(showTitles: true),
                // bottomTitles: SideTitles(showTitles: true),
                ),
            borderData: FlBorderData(show: true),
            minX: 0,
            maxX: 10,
            minY: 0,
            maxY: 10,
          ),
        ),
      ),
    );
  }
}*/

class AnimatedScatterChartExample extends StatefulWidget {
  @override
  _AnimatedScatterChartExampleState createState() => _AnimatedScatterChartExampleState();
}

class _AnimatedScatterChartExampleState extends State<AnimatedScatterChartExample> {
  List<ScatterSpot> _spots = [
    ScatterSpot(3, 4),
    ScatterSpot(6, 2),
    ScatterSpot(2, 7),
    ScatterSpot(8, 5),
  ];

  @override
  void initState() {
    super.initState();
    // Simulate data update after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        // Update the data to animate new positions
        _spots = [ScatterSpot(3, 5), ScatterSpot(7, 3), ScatterSpot(4, 6), ScatterSpot(9, 7)];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Animated ScatterChart Example'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: ScatterChart(
              key: ValueKey<List<ScatterSpot>>(_spots),
              ScatterChartData(
                scatterSpots: _spots,
                gridData: const FlGridData(),
                titlesData: const FlTitlesData(
                    // leftTitles: SideTitles(showTitles: true),
                    // bottomTitles: SideTitles(showTitles: true),
                    ),
                borderData: FlBorderData(show: true),
                minX: 0,
                maxX: 10,
                minY: 0,
                maxY: 10,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
