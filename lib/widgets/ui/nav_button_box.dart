import 'package:flutter/material.dart';

import 'package:app/themes/colors.dart';
import 'package:app/utils/dimensions.dart';

class NavButtonBox extends StatelessWidget {
  final bool loader;
  final Widget? child;
  final double childHeight;
  final Color background;

  const NavButtonBox({this.child, this.loader = false, this.background = primary, this.childHeight = 0});

  @override
  Widget build(BuildContext context) {
    // if (child == null) return const SizedBox.shrink();
    final top = child == null ? 0.0 : 16.0;
    return Opacity(
      opacity: loader ? 0.55 : 1,
      child: AnimatedContainer(
        child: child,
        width: double.infinity,
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(color: background),
        height: child == null ? 0 : (BOTTOM_GAP_NAV + 16 + childHeight),
        padding: EdgeInsets.only(left: 24, right: 24, top: top, bottom: BOTTOM_GAP_NAV),
      ),
    );
  }
}
