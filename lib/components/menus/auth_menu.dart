import 'package:flutter/material.dart';

import 'package:app/extensions/flutter_ext.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/svg_image.dart';

class AuthMenu extends StatelessWidget {
  final Color color;
  const AuthMenu({this.color = primary});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: Routes.auth.sign_in().push,
      child: Center(child: SvgImage(image: Assets.svg1.user_circle, color: color, height: 26)),
    );
  }
}
