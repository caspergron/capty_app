import 'package:flutter/material.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/svg_image.dart';

class LabelWrapList extends StatelessWidget {
  final int animIndex;
  final double fontSize;
  final List<String> items;
  final Function(int)? onItem;
  const LabelWrapList({this.animIndex = 0, this.fontSize = 14, this.items = const [], this.onItem});

  @override
  Widget build(BuildContext context) {
    return TweenListItem(
      index: animIndex,
      child: Wrap(spacing: 06, runSpacing: 04, children: List.generate(items.length, _listItemCard).toList()),
    );
  }

  Widget _listItemCard(int index) {
    final item = items[index];
    final label = Text(item, style: TextStyles.text14_500.copyWith(color: primary, height: 1, fontSize: fontSize));
    final icon = SvgImage(image: Assets.svg1.close_2, color: primary, height: 14);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 05, vertical: 05),
      decoration: BoxDecoration(color: lightBlue, borderRadius: BorderRadius.circular(03)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [label, const SizedBox(width: 04), InkWell(onTap: () => onItem == null ? null : onItem!(index), child: icon)],
      ),
    );
  }
}
