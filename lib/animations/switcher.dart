import 'package:flutter/material.dart';

class Switcher extends StatelessWidget {
  final Widget child;
  const Switcher({required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      switchInCurve: Curves.easeIn,
      duration: const Duration(seconds: 1),
      transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
      child: child,
    );
  }
}
