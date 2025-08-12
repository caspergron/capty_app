import 'package:flutter/material.dart';

import 'package:app/extensions/flutter_ext.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/svg_image.dart';

class AddFriendMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: Routes.user.add_friend().push,
      child: SvgImage(image: Assets.svg1.user_add, height: 24, color: primary),
    );
  }
}
