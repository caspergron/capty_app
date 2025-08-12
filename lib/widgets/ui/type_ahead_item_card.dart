import 'package:flutter/material.dart';

import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/image_network.dart';
import 'package:app/widgets/library/svg_image.dart';

class TypeAheadItemCard extends StatelessWidget {
  final String? label;
  final String? image;
  final bool showImage;

  const TypeAheadItemCard({this.label, this.image, this.showImage = false});

  @override
  Widget build(BuildContext context) {
    var loader = const FadingCircle(size: 20);
    var style = TextStyles.text14_500.copyWith(color: text, height: 1.1);
    var error = SvgImage(image: Assets.svg1.image_square, height: 20, color: mediumBlue, fit: BoxFit.cover);
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 06, vertical: 05),
      decoration: BoxDecoration(color: lightBlue, border: Border(bottom: BorderSide(color: dark.colorOpacity(0.2)))),
      child: Row(
        children: [
          if (showImage) ImageNetwork(width: 28, height: 28, image: image, placeholder: loader, errorWidget: error),
          if (showImage) const SizedBox(width: 06),
          Expanded(child: Text(label ?? '', maxLines: 1, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis, style: style)),
        ],
      ),
    );
  }
}
