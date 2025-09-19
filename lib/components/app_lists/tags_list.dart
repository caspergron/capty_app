import 'package:flutter/material.dart';

import 'package:app/animations/fade_animation.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/common/tag.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/widgets/library/svg_image.dart';

class TagsList extends StatelessWidget {
  final List<Tag> selectedItems;
  final List<Tag> tagItems;
  final Function(Tag)? onChanged;
  const TagsList({this.tagItems = const [], this.selectedItems = const [], this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      itemCount: tagItems.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: _tagItemCard,
    );
  }

  Widget _tagItemCard(BuildContext context, int index) {
    final item = tagItems[index];
    final selected = selectedItems.isNotEmpty && selectedItems.any((element) => element.id == item.id);
    final checkIcon = SvgImage(image: Assets.svg1.tick, color: lightBlue, height: 18);
    const border = Border(bottom: BorderSide(color: lightBlue, width: 0.5));
    return InkWell(
      onTap: () => onChanged == null ? null : onChanged!(item),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: index == 0 ? 0 : 12, bottom: index == tagItems.length - 1 ? 0 : 12),
        decoration: BoxDecoration(border: index == tagItems.length - 1 ? null : border),
        child: Row(
          children: [
            const Icon(Icons.circle, color: lightBlue, size: 08),
            const SizedBox(width: 12),
            Expanded(child: Text(item.displayName ?? 'n/a'.recast, style: TextStyles.text14_500.copyWith(color: lightBlue, height: 1.1))),
            if (selected) const SizedBox(width: 12),
            if (selected) FadeAnimation(fadeKey: item.name ?? '', duration: DURATION_1000, child: checkIcon),
          ],
        ),
      ),
    );
  }
}
