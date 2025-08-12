import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app/extensions/flutter_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/core/circle_memory_image.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';

class StackImages extends StatelessWidget {
  final List<String> imageList;
  final List<Uint8List> assetImages;
  final double boxSize;
  final int itemCount;
  final int totalCount;
  final double borderWidth;
  final Color borderColor;
  final TextStyle countStyle;
  final Color backgroundColor;
  final String? source;
  final bool showTotalCount;

  const StackImages({
    this.imageList = const [],
    this.assetImages = const [],
    this.boxSize = 20,
    this.itemCount = 3,
    this.totalCount = 0,
    this.borderWidth = 2,
    this.borderColor = white,
    this.source = 'network',
    this.showTotalCount = true,
    this.countStyle = const TextStyle(color: white, fontSize: 9, fontWeight: w700, height: 1),
    this.backgroundColor = white,
  });

  @override
  Widget build(BuildContext context) {
    var items = List.from(imageList);
    var images = (source == 'network' ? imageList : assetImages).sublist(0, min(itemCount, items.length));
    var widgetList = images
        .asMap()
        .map((index, value) => MapEntry(index, Padding(padding: EdgeInsets.only(left: 0.7 * boxSize * index), child: _imageItem(value))))
        .values
        .toList();
    var count = totalCount - widgetList.length;
    var counterBox = Padding(padding: EdgeInsets.only(left: 0.7 * boxSize * widgetList.length), child: _totalCountBox(count));
    if (showTotalCount && totalCount - widgetList.length > 0) widgetList.add(counterBox);
    return FittedBox(child: Stack(clipBehavior: Clip.none, children: [...widgetList]));
  }

  Widget _totalCountBox(int count) {
    var border = Border.all(color: borderColor, width: borderWidth);
    return Container(
      height: boxSize,
      width: boxSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle, border: border),
      child: Text('+$count', textAlign: TextAlign.center, style: countStyle),
    );
  }

  Widget _imageItem(Object image) {
    return source == 'network'
        ? CircleImage(
            image: image as String,
            radius: boxSize / 2,
            borderWidth: borderWidth,
            borderColor: borderColor,
            backgroundColor: backgroundColor,
            color: primary.colorOpacity(0.1),
            placeholder: SvgImage(image: Assets.svg1.coach, height: boxSize / 1.5, color: primary),
            errorWidget: SvgImage(image: Assets.svg1.coach, height: boxSize / 1.5, color: primary),
          )
        : CircleMemoryImage(
            image: image as Uint8List,
            radius: boxSize / 2,
            borderColor: borderColor,
            backgroundColor: backgroundColor,
            borderWidth: borderWidth,
          );
  }
}

enum ImageSource { asset, network, file }
