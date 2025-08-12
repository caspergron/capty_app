import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageMemory extends StatelessWidget {
  final Function()? onTap;
  final Uint8List? imagePath;
  final double? width;
  final double? height;
  final double? radius;
  final Widget? error;
  final BoxFit? fit;
  final Color? color;
  final BlendMode? colorBlendMode;
  final FilterQuality? filterQuality;

  const ImageMemory({
    this.imagePath,
    this.radius,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.onTap,
    this.error,
    this.color,
    this.colorBlendMode,
    this.filterQuality,
  });

  @override
  Widget build(BuildContext context) {
    var b_Radius = BorderRadius.circular(radius ?? 0);
    return InkWell(onTap: onTap, child: ClipRRect(borderRadius: b_Radius, child: imagePath == null ? _errorWidget : _memoryImage(context)));
  }

  Widget _memoryImage(BuildContext context) {
    return Image.memory(
      imagePath!,
      width: width,
      height: height,
      color: color,
      fit: fit ?? BoxFit.contain,
      colorBlendMode: colorBlendMode ?? BlendMode.darken,
      filterQuality: filterQuality ?? FilterQuality.high,
      errorBuilder: error == null ? null : (context, exception, stackTrace) => error!,
    );
  }

  Widget get _errorWidget => Container(width: width, height: height, alignment: Alignment.center, child: error ?? Container());
}
