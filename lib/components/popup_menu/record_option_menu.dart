import 'package:flutter/material.dart';

import 'package:app/models/system/data_model.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/widgets/library/svg_image.dart';

class RecordOptionMenu extends StatelessWidget {
  final DataModel item;
  final Function(int) onSelect;

  const RecordOptionMenu({required this.item, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      color: white,
      elevation: 2,
      // icon: SvgImage(image: Assets.svg1.dots_three, color: grey3, height: 24, width: 24),
      offset: const Offset(0, 30),
      padding: EdgeInsets.zero,
      onSelected: onSelect,
      iconColor: grey,
      itemBuilder: (context) => List.generate(RECORD_MENU_LIST.length, (index) {
        var menu = RECORD_MENU_LIST[index];
        return PopupMenuItem(value: index, height: 34, padding: const EdgeInsets.only(left: 20), child: _itemInfo(menu));
      }).toList(),
    );
  }

  Widget _itemInfo(DataModel menu) {
    var isRed = menu.value == DELETE.value;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgImage(image: menu.icon, color: isRed ? error : grey, height: 18),
        const SizedBox(width: 08),
        Text(menu.label, style: TextStyles.text14_700.copyWith(color: isRed ? error : grey)),
      ],
    );
  }
}
