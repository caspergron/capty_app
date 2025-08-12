import 'package:app/themes/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Graph Starting from Bottom Center')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Builder(
            builder: (context) {
              final size = MediaQuery.of(context).size;
              final centerX = size.width / 2;
              return LineChart(
                LineChartData(
                  gridData: const FlGridData(drawVerticalLine: false),
                  borderData: FlBorderData(show: false),
                  minX: centerX - 100, // Set minX to start from the center
                  maxX: centerX + 100, // Adjust maxX to fit the graph
                  minY: 0,
                  maxY: 3,

                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(centerX, 0),
                        FlSpot(centerX, 2), // y, extra_y, is_positive, x
                        FlSpot(centerX - 100, 2.5),
                      ],
                      isCurved: true,
                      color: primary,
                      // colors: [Colors.blue],
                      dotData: const FlDotData(show: false),
                      // belowBarData: BarChartBarData(show: false),
                    ),
                    // Second line
                    LineChartBarData(
                      spots: [FlSpot(centerX, 0), FlSpot(centerX, 1.5), FlSpot(centerX - 80, 2.3)],
                      isCurved: true,
                      color: error,
                      dotData: const FlDotData(show: false),
                    ),
                    // Third line
                    LineChartBarData(
                      spots: [FlSpot(centerX, 0), FlSpot(centerX, 1.8), FlSpot(centerX - 90, 2.85)],
                      isCurved: true,
                      dotData: const FlDotData(show: false),
                      color: warning,
                    ),
                    // Fourth line
                    LineChartBarData(
                      spots: [FlSpot(centerX, 0), FlSpot(centerX - 40, 1.8), FlSpot(centerX - 50, 2.8)],
                      isCurved: true,
                      color: info,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
                curve: Curves.bounceIn,
                duration: const Duration(milliseconds: 100),
              );
            },
          ),
        ),
      ),
    );
  }
}
