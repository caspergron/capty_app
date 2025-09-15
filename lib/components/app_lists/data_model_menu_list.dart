import 'package:flutter/material.dart';

import 'package:app/animations/fade_animation.dart';
import 'package:app/animations/tween_list_item.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/helpers/enums.dart';
import 'package:app/models/system/data_model.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/dimensions.dart';

class DataModelMenuList extends StatelessWidget {
  final DataModel menu;
  final List<DataModel> menuItems;
  final Function(DataModel)? onTap;
  const DataModelMenuList({required this.menu, this.menuItems = const [], this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30 + 10,
      child: ListView.builder(
        shrinkWrap: true,
        clipBehavior: Clip.antiAlias,
        itemCount: menuItems.length,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(bottom: 10),
        itemBuilder: _menuItemCard,
      ),
    );
  }

  Widget _menuItemCard(BuildContext context, int index) {
    var item = menuItems[index];
    var selected = menu.value.toKey == item.value.toKey;
    var gap = Dimensions.screen_padding;
    var border = !selected ? null : Border.all(color: primary);
    return InkWell(
      onTap: onTap == null ? null : () => onTap!(item),
      child: TweenListItem(
        index: index,
        twinAnim: TwinAnim.right_to_left,
        child: FadeAnimation(
          fadeKey: selected ? '$index' : 'no_animation',
          duration: const Duration(milliseconds: 700),
          child: Container(
            height: 30,
            key: Key('index_$index'),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: EdgeInsets.only(left: index == 0 ? gap : 0, right: index == menuItems.length - 1 ? gap : 08),
            decoration: BoxDecoration(color: selected ? skyBlue : lightBlue, borderRadius: BorderRadius.circular(4), border: border),
            child: Text(item.label.recast, style: TextStyles.text12_600.copyWith(color: primary, height: 1)),
          ),
        ),
      ),
    );
  }
}
