import 'package:flutter/material.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/system/data_model.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/core/animated_icon_box.dart';
import 'package:app/widgets/library/svg_image.dart';

class SortByList extends StatelessWidget {
  final List<DataModel> selectedItems;
  final Function(DataModel)? onSelect;

  const SortByList({this.selectedItems = const [], this.onSelect});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      itemCount: SORT_BY_LIST.length,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: _sortByItemCard,
      separatorBuilder: (context, index) => SizedBox(height: index == SORT_BY_LIST.length - 1 ? 0 : 08),
    );
  }

  Widget _sortByItemCard(BuildContext context, int index) {
    var item = SORT_BY_LIST[index];
    var selected = selectedItems.isNotEmpty && selectedItems.any((element) => element.value == item.value);
    return InkWell(
      onTap: onSelect == null ? null : () => onSelect!(item),
      child: TweenListItem(
        index: index,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            onSelect == null
                ? SvgImage(image: Assets.svg1.tick, height: 14, color: lightBlue)
                : AnimatedIconBox(
                    size: 19,
                    value: selected,
                    inactive: primary,
                    inactiveIcon: Assets.svg1.square,
                    activeIcon: Assets.svg1.check_square,
                  ),
            const SizedBox(width: 06),
            Expanded(
              child: Text(
                item.label.recast,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.text13_600.copyWith(color: primary, fontWeight: w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
