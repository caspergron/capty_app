import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app/themes/colors.dart';

class CircleMemoryImage extends StatelessWidget {
  final Function()? onTap;
  final Uint8List? image;
  final double radius;
  final double elevation;
  final double borderWidth;
  final Color borderColor;
  final Color backgroundColor;
  final Color foregroundColor;
  final Widget? errorWidget;
  final BoxFit imageFit;

  const CircleMemoryImage({
    this.image,
    this.radius = 50,
    this.elevation = 0,
    this.borderWidth = 0,
    this.borderColor = white,
    this.backgroundColor = white,
    this.imageFit = BoxFit.cover,
    this.foregroundColor = transparent,
    this.onTap,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    var borderRadius = BorderRadius.circular(radius);
    var border = Border.all(width: borderWidth, color: borderColor);
    var decoration = BoxDecoration(color: backgroundColor, borderRadius: borderRadius);
    return InkWell(
      onTap: onTap,
      child: Material(
        color: borderColor,
        elevation: elevation,
        type: MaterialType.circle,
        child: Container(
          width: radius * 2,
          height: radius * 2,
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: borderRadius, border: border),
          child: Container(decoration: decoration, child: Stack(fit: StackFit.expand, children: <Widget>[_imageSection(context)])),
        ),
      ),
    );
  }

  Widget _imageSection(BuildContext context) {
    if (image == null) return ClipRRect(borderRadius: BorderRadius.circular(radius), child: errorWidget);
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.memory(
        image!,
        fit: imageFit,
        colorBlendMode: BlendMode.darken,
        filterQuality: FilterQuality.high,
        errorBuilder: errorWidget == null ? null : (context, exception, stackTrace) => errorWidget!,
      ),
    );
  }
}
