import 'package:flutter/material.dart';

class PopScopeNavigator extends StatelessWidget {
  final Widget child;
  final bool canPop;
  final Function()? onPop;

  const PopScopeNavigator({required this.child, required this.canPop, this.onPop});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      child: child,
      onPopInvokedWithResult: (result, v) => _onPopInvoked(result),
      // onPopInvoked: onPop == null ? null : onPopInvoked,
    );
  }

  void _onPopInvoked(bool didPop) {
    if (didPop) return;
    if (onPop != null) onPop!();
  }
}
