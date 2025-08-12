import 'package:app/utils/assets.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomPointerChart extends StatefulWidget {
  @override
  _CustomPointerChartState createState() => _CustomPointerChartState();
}

class _CustomPointerChartState extends State<CustomPointerChart> {
  Offset? pointerPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Pointer Chart')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    spots: [
                      const FlSpot(1, 1),
                      const FlSpot(2, 3),
                      const FlSpot(3, 1.5),
                      const FlSpot(4, 2),
                      const FlSpot(5, 4),
                    ],
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchCallback: (event, response) {
                    if (event is FlPanStartEvent || event is FlPanUpdateEvent) {
                      setState(() {
                        // pointerPosition = response?.lineBarSpots!.first.;
                      });
                    } else if (event is FlPanEndEvent || event is FlTapUpEvent) {
                      setState(() {
                        pointerPosition = null;
                      });
                    }
                  },
                ),
              ),
            ),
          ),
          if (pointerPosition != null)
            Positioned(
              left: pointerPosition!.dx - 0,
              top: pointerPosition!.dy - 0,
              child: Image.asset(
                Assets.png_image.winner_cup_2, // Replace with your custom image path
                width: 24,
                height: 24,
              ),
            ),
        ],
      ),
    );
  }
}
