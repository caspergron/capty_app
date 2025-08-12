import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:app/extensions/flutter_ext.dart';
import 'package:app/themes/colors.dart';

class CircleLoader extends StatelessWidget {
  final double radius;
  final Size size;
  final Color color;

  const CircleLoader({this.color = white, this.radius = 20, this.size = const Size(30, 30)});

  @override
  Widget build(BuildContext context) {
    var iosLoader = CupertinoActivityIndicator(color: color, radius: radius);
    var androidLoader = CircularProgressIndicator(color: color, backgroundColor: color.colorOpacity(0.3));
    return Platform.isIOS ? iosLoader : Center(child: SizedBox(height: size.height, width: size.width, child: androidLoader));
  }
}
