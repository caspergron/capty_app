import 'package:flutter/material.dart';

import 'package:app/themes/colors.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/svg_image.dart';

class CaptyMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgImage(image: Assets.app.capty, height: 26, color: primary),
        const SizedBox(width: 10),
        SvgImage(image: Assets.app.capty_name, height: 26, color: primary),
      ],
    );
  }
}
