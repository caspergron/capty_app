import 'package:flutter/material.dart';

import 'package:app/extensions/string_ext.dart';
import 'package:app/models/club/club.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/svg_image.dart';

class ClubsMenu extends StatelessWidget {
  final Club item;
  final List<Club> clubs;
  final Function(Club) onSelect;

  const ClubsMenu({required this.item, required this.onSelect, this.clubs = const []});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Club>(
      color: white,
      elevation: 2,
      enabled: clubs.length > 1,
      child: clubs.length < 2 ? const SizedBox.shrink() : _itemsInfo,
      // icon: SvgImage(image: Assets.svg1.dots_three, color: grey3, height: 24, width: 24),
      offset: const Offset(16, 48),
      padding: EdgeInsets.zero,
      onSelected: onSelect,
      iconColor: grey,
      style: ButtonStyle(backgroundColor: WidgetStateProperty.all(skyBlue)),
      itemBuilder: (context) => List.generate(clubs.length, (index) {
        final menu = clubs[index];
        return PopupMenuItem(value: menu, height: 34, padding: const EdgeInsets.only(left: 20), child: _itemInfo(menu));
      }).toList(),
    );
  }

  Widget _itemInfo(Club menu) {
    final isSelected = menu.id == item.id;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(menu.name ?? '', style: TextStyles.text14_700.copyWith(color: isSelected ? primary : mediumBlue)),
        if (isSelected) const SizedBox(width: 08),
        if (isSelected) SvgImage(image: Assets.svg1.tick, color: orange, height: 18),
      ],
    );
  }

  Widget get _itemsInfo {
    if (clubs.length < 2) return const SizedBox.shrink();
    return Row(
      children: [
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            '${clubs.length} ${'clubs'.recast}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.text16_600.copyWith(color: primary),
          ),
        ),
        const SizedBox(width: 02),
        Padding(padding: const EdgeInsets.only(top: 4), child: SvgImage(image: Assets.svg1.keyboard_down, height: 14)),
      ],
    );
  }
}
