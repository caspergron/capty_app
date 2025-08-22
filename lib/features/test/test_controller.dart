import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';

// Put this near your ViewModel, e.g. under initViewModel() or as a top-level const.
const sampleDiscs = <DiscFlight>[
  // Putters / mids
  DiscFlight(speed: 2, glide: 3, turn: 0, fade: 1),
  DiscFlight(speed: 3, glide: 4, turn: -1, fade: 1),
  DiscFlight(speed: 4, glide: 5, turn: -2, fade: 1),
  DiscFlight(speed: 5, glide: 6, turn: -3, fade: 0),

  // Fairways
  // DiscFlight(speed: 6, glide: 4, turn: 0, fade: 2),
  // DiscFlight(speed: 7, glide: 5, turn: -2, fade: 1),
  // DiscFlight(speed: 7, glide: 4, turn: -1, fade: 2),
  // DiscFlight(speed: 8, glide: 6, turn: -1, fade: 2),

  // Drivers (mix of under/overstable)
  // DiscFlight(speed: 9, glide: 5, turn: -3, fade: 2),
  // DiscFlight(speed: 9, glide: 3, turn: 0, fade: 5),
  // DiscFlight(speed: 10, glide: 5, turn: -2, fade: 2),
  // DiscFlight(speed: 11, glide: 5, turn: -1, fade: 3),
  // DiscFlight(speed: 12, glide: 5, turn: -3, fade: 2),
  // DiscFlight(speed: 12, glide: 4, turn: 0, fade: 4),
  // DiscFlight(speed: 13, glide: 4, turn: -1, fade: 3),
  // DiscFlight(speed: 13, glide: 3, turn: 1, fade: 4),
];

class DiscFlight {
  final int speed;
  final int glide;
  final int turn; // usually -5..+1
  final int fade; // usually 0..5

  const DiscFlight({
    required this.speed,
    required this.glide,
    required this.turn,
    required this.fade,
  });
}

class TestViewModel extends ChangeNotifier {
  // Public: consumed by your UI
  List<ScatterSpot> get spots => List.unmodifiable(_spots);

  // Keep the raw discs so we can show richer tooltips
  final List<DiscFlight> discs = [];

  // Internal
  final List<ScatterSpot> _spots = [];
  bool _disposed = false;

  // OPTIONAL: if you already have a loader object in your app, keep it.
  // Expose a simple boolean if that’s easier:
  bool get isLoading => _isLoading;
  bool _isLoading = false;

  Future<void> initViewModel() async {
    _isLoading = true;
    notifyListeners();

    // Example data (your JSON example)
    discs.clear();
    discs.addAll(sampleDiscs);

    // Clear current spots and reveal them one-by-one (video-style)
    _spots.clear();
    notifyListeners();

    // Small delay feels nicer
    await Future.delayed(const Duration(milliseconds: 150));

    for (var i = 0; i < discs.length; i++) {
      if (_disposed) break;
      final d = discs[i];

      // Map Turn/Fade into the 0..10 grid:
      // X: turn -5..+5 => 0..10  => x = turn + 5
      // Y: fade 0..5   => 0..10  => y = fade * 2
      final x = d.speed.toDouble();
      final y = (d.turn + d.fade).toDouble();

      // Dot radius scaled by speed (1..14) -> ~6..12
      final radius = _radiusFromSpeed(d.speed);

      _spots.add(ScatterSpot(x, y));
      notifyListeners();

      // Staggered reveal
      await Future.delayed(const Duration(milliseconds: 220));
    }

    _isLoading = false;
    notifyListeners();
  }

  void disposeViewModel() {
    _disposed = true;
    super.dispose();
  }

  // Helper to look up a disc for tooltips using spot coords
  DiscFlight? findDiscBySpot(double x, double y) {
    // Reverse the mapping with a tiny tolerance
    const eps = 0.0001;
    for (final d in discs) {
      final tx = (d.turn + 5).toDouble();
      final ty = (d.fade * 2).toDouble();
      if ((tx - x).abs() < eps && (ty - y).abs() < eps) {
        return d;
      }
    }
    return null;
  }

  double _radiusFromSpeed(int speed) {
    const minR = 6.0;
    const maxR = 12.0;
    final clamped = speed.clamp(1, 14);
    return minR + (maxR - minR) * (clamped / 14.0);
  }
}
