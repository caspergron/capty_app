import 'package:flutter/material.dart';

import 'package:app/themes/colors.dart';
import 'package:app/widgets/library/svg_image.dart';

class AnimatedIconBox extends StatelessWidget {
  final bool value;
  final double size;
  final Color active;
  final Color inactive;
  final String activeIcon;
  final String inactiveIcon;
  final Function()? onTap;

  const AnimatedIconBox({
    this.onTap,
    this.size = 24,
    this.value = false,
    this.activeIcon = '',
    this.inactiveIcon = '',
    this.active = primary,
    this.inactive = grey,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        firstChild: inactiveIcon.isEmpty ? const SizedBox.shrink() : SvgImage(image: inactiveIcon, color: inactive, height: size),
        secondChild: activeIcon.isEmpty ? const SizedBox.shrink() : SvgImage(image: activeIcon, color: active, height: size),
        crossFadeState: value ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      ),
    );
  }
}
