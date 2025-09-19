import 'package:flutter/material.dart';

import 'package:app/models/system/data_model.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/widgets/library/svg_image.dart';

class RectangleChip extends StatelessWidget {
  final DataModel item;
  final DataModel selectedItem;
  final Function() onTap;
  const RectangleChip({required this.item, required this.onTap, required this.selectedItem});

  @override
  Widget build(BuildContext context) {
    final selected = selectedItem.value == item.value;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? white : offWhite2,
          border: !selected ? null : Border.all(color: primary),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.icon.isNotEmpty) SvgImage(image: item.icon, height: 17, color: selected ? primary : text),
            if (item.icon.isNotEmpty) const SizedBox(width: 08),
            Text(item.label, style: TextStyles.text14_700.copyWith(color: selected ? primary : text)),
          ],
        ),
      ),
    );
  }
}
