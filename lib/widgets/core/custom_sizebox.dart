import 'package:flutter/material.dart';

import 'package:app/di.dart';
import 'package:app/helpers/dimension_helper.dart';
import 'package:app/models/system/dimension.dart';

class SizeBoxHeight extends StatelessWidget {
  final Dimension dimension;
  const SizeBoxHeight({required this.dimension});

  @override
  Widget build(BuildContext context) {
    final height = sl<DimensionHelper>().dimensionSizer(dimension);
    return SizedBox(height: height);
  }
}

class SizeBoxWidth extends StatelessWidget {
  final Dimension dimension;
  const SizeBoxWidth({required this.dimension});

  @override
  Widget build(BuildContext context) {
    final width = sl<DimensionHelper>().dimensionSizer(dimension);
    return SizedBox(width: width);
  }
}
