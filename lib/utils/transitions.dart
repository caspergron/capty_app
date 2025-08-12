import 'package:flutter/material.dart';

class Transitions {
  FadeTransition fadeTransaction(context, anim1, anim2, child) => FadeTransition(opacity: anim1, child: child);

  Tween<Offset> _tweenLeftToRight = Tween(begin: const Offset(-1, 0), end: const Offset(0, 0));
  SlideTransition leftToRight(context, anim1, anim2, child) => SlideTransition(position: _tweenLeftToRight.animate(anim1), child: child);
  Tween<Offset> _tweenRightToLeft = Tween(begin: const Offset(1, 0), end: const Offset(0, 0));
  SlideTransition rightToLeft(context, anim1, anim2, child) => SlideTransition(position: _tweenRightToLeft.animate(anim1), child: child);
  Tween<Offset> _tweenTopToBottom = Tween(begin: const Offset(0, -1), end: const Offset(0, 0));
  SlideTransition topToBottom(context, anim1, anim2, child) => SlideTransition(position: _tweenTopToBottom.animate(anim1), child: child);
  Tween<Offset> _tweenBottomToTop = Tween(begin: const Offset(0, 0.5), end: const Offset(0, 0));
  // Tween<Offset> _tweenBottomToTop = Tween(begin: const Offset(0, 1), end: const Offset(0, 0));
  SlideTransition bottomToTop(context, anim1, anim2, child) => SlideTransition(position: _tweenBottomToTop.animate(anim1), child: child);
}
