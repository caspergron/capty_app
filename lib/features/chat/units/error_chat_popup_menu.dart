import 'package:flutter/material.dart';

import 'package:app/models/system/data_model.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/svg_image.dart';

class ErrorChatPopupMenu extends StatelessWidget {
  final DataModel item;
  final Function(int) onSelect;

  const ErrorChatPopupMenu({required this.item, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      color: white,
      elevation: 2,
      menuPadding: EdgeInsets.zero,
      icon: SvgImage(image: Assets.svg2.warning, color: primary, height: 16, width: 16),
      offset: const Offset(0, 30),
      constraints: const BoxConstraints(maxHeight: 16, maxWidth: 16),
      padding: EdgeInsets.zero,
      onSelected: onSelect,
      itemBuilder: (context) => List.generate(RECORD_MENU_LIST.length, (index) {
        final menu = RECORD_MENU_LIST[index];
        return PopupMenuItem(value: index, height: 34, padding: const EdgeInsets.only(left: 20), child: _itemInfo(menu));
      }).toList(),
    );
  }

  Widget _itemInfo(DataModel menu) {
    final isRed = menu.value == DELETE.value;
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
