import 'package:flutter/material.dart';

class FadeAnimation extends StatelessWidget {
  final Widget child;
  final String fadeKey;
  final Duration duration;

  const FadeAnimation({required this.child, this.fadeKey = '', this.duration = const Duration(milliseconds: 500)});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: Key(fadeKey),
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      builder: (context, value, child) => Opacity(opacity: value, child: child),
      child: child,
    );
  }
}
