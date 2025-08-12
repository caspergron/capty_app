import 'package:flutter/material.dart';

import 'package:readmore/readmore.dart';

import 'package:app/extensions/string_ext.dart';
import 'package:app/themes/colors.dart';

class ReadingMore extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextStyle? moreStyle;
  final TextStyle? lessStyle;

  const ReadingMore({this.text = '', this.style, this.moreStyle, this.lessStyle});

  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
      text,
      trimMode: TrimMode.Line,
      trimLines: 07,
      colorClickableText: primary,
      trimCollapsedText: 'read_more'.recast,
      trimExpandedText: 'show_less'.recast,
      moreStyle: moreStyle,
      lessStyle: lessStyle,
      style: style,
    );
  }
}
