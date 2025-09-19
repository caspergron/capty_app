import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:app/extensions/flutter_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/utils/size_config.dart';

class ScreenLoader extends StatelessWidget {
  final double gap;
  final double radius;
  final Color color;
  final Color background;
  const ScreenLoader({this.gap = 0, this.radius = 0, this.background = primary, this.color = white});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.width,
      height: SizeConfig.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: primary.colorOpacity(0.4), borderRadius: BorderRadius.circular(radius)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [_loader(context), SizedBox(height: gap)]),
    );
  }

  Widget _loader(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoActivityIndicator(color: color, radius: 20);
    } else {
      final circleLoader = CircularProgressIndicator(color: color, backgroundColor: color.colorOpacity(0.3));
      return SizedBox(height: 36, width: 36, child: circleLoader);
    }
  }
}
