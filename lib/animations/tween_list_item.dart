import 'package:flutter/material.dart';

import 'package:app/helpers/enums.dart';

class TweenListItem extends StatelessWidget {
  final int index;
  final Widget child;
  final TwinAnim twinAnim;
  const TweenListItem({this.index = 0, this.child = const SizedBox(), this.twinAnim = TwinAnim.bottom_to_top});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 700 + (index * 100)),
      builder: (context, value, builderChild) {
        final offset = twinAnim == TwinAnim.right_to_left ? Offset(30 * (1 - value), 0) : Offset(0, 30 * (1 - value));
        return Opacity(opacity: value, child: Transform.translate(offset: offset, child: builderChild));
      },
      child: child,
    );
  }

  /*Offset _offsetValue(double value) {
    if (twinAnim == TwinAnim.right_to_left) {
      return Offset(30 * (1 - value), 0);
    } else {
      return Offset(0, 30 * (1 - value));
    }
  }*/
}
