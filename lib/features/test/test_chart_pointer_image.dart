import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWithImagePointer extends StatelessWidget {
  final List<FlSpot> spots = [const FlSpot(1, 2), const FlSpot(2, 3), const FlSpot(3, 1.5), const FlSpot(4, 2.5)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Line Chart with Image Pointer')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    barWidth: 4,
                    belowBarData: BarAreaData(),
                    dotData: const FlDotData(show: false), // Hide default dots
                  ),
                ],
                borderData: FlBorderData(show: true),
              ),
            ),
            ...spots.map((spot) {
              // Add an overlay image at each spot
              return Positioned(
                left: _calculatePosition(context, spot.x, isX: true),
                top: _calculatePosition(context, spot.y, isX: false),
                child: Image.network(
                  'https://plus.unsplash.com/premium_photo-1671209878866-29cff77f6f54?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  width: 20,
                  height: 20,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, color: Colors.red); // Fallback
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2));
                  },
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  double _calculatePosition(BuildContext context, double value, {required bool isX}) {
    // Placeholder for actual position calculation
    // You need to map the `value` (x or y) to screen coordinates
    // This requires knowledge of the chart's dimensions and boundaries
    return isX ? value * 80 : 300 - value * 80; // Adjust based on your chart
  }
}
