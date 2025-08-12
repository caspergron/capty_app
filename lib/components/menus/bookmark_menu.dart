import 'package:flutter/material.dart';

import 'package:app/themes/colors.dart';

class BookmarkMenu extends StatelessWidget {
  final bool status;
  final Function()? onTap;
  const BookmarkMenu({this.onTap, this.status = false});

  @override
  Widget build(BuildContext context) {
    var size = 36.0;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: status ? primary : transparent,
          shape: BoxShape.circle,
          border: status ? null : Border.all(color: grey),
        ),
        /*child: SvgImage(
          color: status ? white : grey2,
          height: 20,
          image: status ? Assets.svg1.bookmark_2 : Assets.svg1.bookmark_1,
        ),*/
      ),
    );
  }
}
