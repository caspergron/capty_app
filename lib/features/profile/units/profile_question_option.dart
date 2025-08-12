import 'package:flutter/material.dart';

import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/core/flutter_switch.dart';
import 'package:app/widgets/library/svg_image.dart';

class ProfileQuestionOption extends StatelessWidget {
  final String label;
  final bool value;
  final Function(bool) onToggle;

  const ProfileQuestionOption({required this.onToggle, this.label = '', this.value = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: label, style: TextStyles.text14_600.copyWith(color: lightBlue, height: 1)),
                TextSpan(text: ' ', style: TextStyles.text14_600.copyWith(color: lightBlue, height: 1)),
                WidgetSpan(child: SvgImage(image: Assets.svg1.question, height: 18, color: lightBlue)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        FlutterSwitch(
          height: 24,
          value: value,
          onToggle: onToggle,
          inactiveColor: grey,
          activeColor: mediumBlue,
          activeToggleColor: lightBlue,
          inactiveToggleColor: lightBlue,
        ),
      ],
    );
  }
}
