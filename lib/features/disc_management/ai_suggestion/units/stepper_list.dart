import 'package:flutter/material.dart';

import 'package:app/extensions/number_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/svg_image.dart';

class StepperList extends StatelessWidget {
  final int totalStep;
  final int step;
  const StepperList({this.totalStep = 0, this.step = 0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ListView.builder(
        shrinkWrap: true,
        clipBehavior: Clip.antiAlias,
        itemCount: totalStep,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemBuilder: _stepItemCard,
      ),
    );
  }

  Widget _stepItemCard(BuildContext context, int index) {
    var isLast = index == totalStep - 1;
    var isChecked = index + 1 <= step;
    return Row(
      children: [
        Container(
          width: 32,
          height: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: isChecked ? primary : skyBlue, border: Border.all(color: primary), shape: BoxShape.circle),
          child: isChecked
              ? SvgImage(image: Assets.svg1.tick, color: white, height: 20)
              : Text('${index + 1}', style: TextStyles.text18_600.copyWith(color: primary, height: 1.2)),
        ),
        if (!isLast) Container(width: 10.width, height: 04, color: mediumBlue),
      ],
    );
  }
}
