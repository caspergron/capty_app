import 'dart:core';

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:app/themes/colors.dart';

class CircleImage extends StatelessWidget {
  final Function()? onTap;
  final String? image;
  final double radius;
  final double elevation;
  final double borderWidth;
  final Color borderColor;
  final Color color;
  final Color backgroundColor;
  final Color foregroundColor;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BoxFit fit;
  final BlendMode colorBlendMode;
  final FilterQuality filterQuality;

  const CircleImage({
    this.image,
    this.radius = 20,
    this.elevation = 0,
    this.borderWidth = 0,
    this.borderColor = white,
    this.backgroundColor = white,
    this.fit = BoxFit.cover,
    this.foregroundColor = transparent,
    this.onTap,
    this.color = transparent,
    this.placeholder,
    this.errorWidget,
    this.colorBlendMode = BlendMode.darken,
    this.filterQuality = FilterQuality.high,
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
          child: Container(decoration: decoration, child: _imageSection(context)),
        ),
      ),
    );
  }

  Widget _imageSection(BuildContext context) {
    if (image == null) return ClipRRect(borderRadius: BorderRadius.circular(radius), child: Center(child: _errorWidget()));
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: image!,
            width: double.infinity,
            height: double.infinity,
            fit: fit,
            // useOldImageOnUrlChange: true,
            colorBlendMode: colorBlendMode,
            filterQuality: filterQuality,
            placeholder: placeholder == null ? null : (context, url) => _placeholder(),
            errorWidget: errorWidget == null ? null : (context, url, error) => _errorWidget(),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(radius)),
          ),
        ],
      ),
    );
  }

  Widget _errorWidget() => Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
        child: errorWidget ?? Container(),
      );
  Widget _placeholder() => Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
        child: placeholder ?? Container(),
      );
}
