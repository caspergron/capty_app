import 'package:flutter/material.dart';

import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';

// const _DURATION = Duration(milliseconds: 700);

class AnimatedRadio extends StatelessWidget {
  final bool value;
  final Function()? onChanged;
  final String label;
  final double size;
  final Color color;
  final TextStyle style;
  final MainAxisAlignment mainAxisAlignment;

  const AnimatedRadio({
    required this.value,
    this.onChanged,
    this.label = '',
    this.size = 16,
    this.color = primary,
    this.style = const TextStyle(fontSize: 13, color: dark, fontFamily: roboto),
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final decoration2 = BoxDecoration(shape: BoxShape.circle, color: color);
    return InkWell(
      onTap: onChanged,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          AnimatedContainer(
            width: size,
            height: size,
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: color, width: 1.5), color: transparent),
            child: AnimatedOpacity(
              curve: Curves.easeInOut,
              opacity: value ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Center(child: Container(width: size / 2.3, height: size / 2.2, decoration: decoration2)),
            ),
          ),
          if (label.isNotEmpty) const SizedBox(width: 08),
          if (label.isNotEmpty) Expanded(child: Text(label, style: style)),
        ],
      ),
    );
  }
}
// final icon = value ? Assets.svg1.radio_on : Assets.svg1.radio_off;
// FadeAnimation(fadeKey: '$label', duration: _DURATION, child: SvgImage(image: icon, height: size, color: color)),
