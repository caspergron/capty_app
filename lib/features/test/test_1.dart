import 'package:app/themes/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraphWidget extends StatefulWidget {
  const GraphWidget({super.key});

  @override
  State<GraphWidget> createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
  List<ScatterSpot> _spots = [
    ScatterSpot(3, 4),
    ScatterSpot(6, 2),
    ScatterSpot(2, 7),
    ScatterSpot(8, 5),
  ];

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        // Update the data to animate new positions
        _spots = [ScatterSpot(3, 5), ScatterSpot(7, 3), ScatterSpot(4, 6), ScatterSpot(9, 7)];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60, bottom: 24),
        child: AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          child: LineChart(
            key: ValueKey<List<ScatterSpot>>(_spots),
            LineChartData(
              gridData: FlGridData(
                horizontalInterval: 0.6,
                verticalInterval: 0.3,
                getDrawingHorizontalLine: (value) => FlLine(color: Colors.blue[300]!, strokeWidth: 0.5),
                getDrawingVerticalLine: (value) => FlLine(color: Colors.blue[300]!, strokeWidth: 0.5),
              ),
              borderData: FlBorderData(show: false),
              titlesData: const FlTitlesData(
                topTitles: AxisTitles(),
                rightTitles: AxisTitles(),
                /*leftTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTextStyles: (context, value) =>
                      TextStyle(color: Colors.blue[900], fontSize: 10),
                ),
                bottomTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTextStyles: (context, value) =>
                      TextStyle(color: Colors.blue[900], fontSize: 10),
                ),*/
              ),
              lineBarsData: [
                LineChartBarData(
                  color: transparent,
                  spots: [
                    const FlSpot(1, 20), // Destiny point
                    const FlSpot(1, 12), // Destiny point
                    const FlSpot(2, 9), // Hatchet point
                    const FlSpot(3, 6), // Destiny point
                    const FlSpot(4, 4), // Another Hatchet
                    const FlSpot(2.5, 0), // Another Hatchet
                    const FlSpot(2.5, 14.5), // Another Hatchet
                    const FlSpot(3, 14.5), // Another Hatchet
                    const FlSpot(2, 10.5), // Another Hatchet
                  ],
                  dotData: FlDotData(
                    getDotPainter: (spot, _, __, ___) {
                      return FlDotCirclePainter(radius: 4, color: Colors.blue[900]!, strokeColor: Colors.white, strokeWidth: 2);
                    },
                  ),
                  // colors: [Colors.transparent], // Hide line
                  // barWidth: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
