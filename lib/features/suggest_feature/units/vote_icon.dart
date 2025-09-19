import 'package:flutter/material.dart';

import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/svg_image.dart';

class VoteIcon extends StatelessWidget {
  final int totalVote;
  final Function()? onTap;
  const VoteIcon({this.totalVote = 0, this.onTap});

  @override
  Widget build(BuildContext context) {
    final icon = SvgImage(image: Assets.svg1.arrow_up, color: white, height: 15);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(onTap: onTap, child: CircleAvatar(radius: 14, backgroundColor: orange, child: icon)),
        if (totalVote > 0) Positioned(right: -5, bottom: -7, child: _voteCountView)
      ],
    );
  }

  Widget get _voteCountView {
    final style = TextStyles.text12_400.copyWith(color: orange, fontWeight: w900, letterSpacing: 0, height: 1);
    return Container(
      padding: const EdgeInsets.all(4),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: lightBlue, shape: BoxShape.circle, border: Border.all(color: orange)),
      child: Text('$totalVote', style: style),
    );
  }
}
