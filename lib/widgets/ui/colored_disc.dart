import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/image_network.dart';
import 'package:app/widgets/library/svg_image.dart';

class ColoredDisc extends StatelessWidget {
  final double size;
  final Color discColor;
  final String? brandIcon;
  final double iconSize;
  final double elevation;

  const ColoredDisc({
    this.size = 150.0,
    this.brandIcon,
    this.iconSize = 16,
    this.elevation = 4,
    this.discColor = const Color(0xFF4CAF50),
  });

  Color get _rimColor => _getDeepColorHSL(discColor, factor: 0.4);
  Color get _shadowColor => _getDeepColorHSL(discColor, factor: 0.6);
  Color get _innerRimColor => _getDeepColorHSL(discColor, factor: 0.2);

  @override
  Widget build(BuildContext context) {
    var shadow = BoxShadow(color: _shadowColor.colorOpacity(0.4), blurRadius: elevation, offset: Offset(0, elevation / 2));
    var radialGradient = RadialGradient(colors: [discColor.colorOpacity(0.9), discColor, _rimColor], stops: const [0.0, 0.7, 1.0]);
    var linearGradient = LinearGradient(colors: [Colors.white.colorOpacity(0.3), Colors.transparent]);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [shadow]),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main disc body
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(shape: BoxShape.circle, gradient: radialGradient),
          ),
          // Inner rim detail
          Container(
            width: size * 0.85,
            height: size * 0.85,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 2, color: _innerRimColor.colorOpacity(0.6))),
          ),
          // Center flight plate
          Container(
            width: size * 0.6,
            height: size * 0.6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: discColor.colorOpacity(0.2),
              border: Border.all(color: _innerRimColor.colorOpacity(0.6), width: 1.5),
            ),
          ),
          // Brand content
          ImageNetwork(
            radius: 08,
            height: iconSize,
            width: iconSize,
            image: brandIcon,
            fit: BoxFit.contain,
            placeholder: const FadingCircle(size: 20, color: lightBlue),
            errorWidget: SvgImage(image: Assets.app.capty, height: iconSize * 0.75, color: white),
          ),
          // Subtle highlight for 3D effect
          Positioned(
            top: size * 0.1,
            left: size * 0.2,
            child: Container(
              width: size * 0.3,
              height: size * 0.15,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(size * 0.1), gradient: linearGradient),
            ),
          ),
        ],
      ),
    );
  }
}

Color _getDeepColorHSL(Color color, {double factor = 0.3}) {
  assert(factor >= 0.0 && factor <= 1.0, 'Factor must be between 0.0 and 1.0');
  HSLColor hslColor = HSLColor.fromColor(color);
  double newLightness = hslColor.lightness * (1.0 - factor);
  newLightness = math.max(0, newLightness);
  return hslColor.withLightness(newLightness).toColor();
}
