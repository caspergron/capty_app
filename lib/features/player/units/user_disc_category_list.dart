import 'package:flutter/material.dart';

import 'package:app/features/player/units/user_disc_horizontal_list.dart';
import 'package:app/models/disc/user_disc.dart';
import 'package:app/models/disc/user_disc_category.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/dimensions.dart';

class UserDiscCategoryList extends StatelessWidget {
  final List<UserDiscCategory> categories;
  final List<UserDisc> selectedItems;
  final Function(UserDisc)? onDiscItem;
  final Function(UserDisc)? onFavDisc;
  final Function(UserDisc)? onSelectDisc;

  const UserDiscCategoryList({
    this.categories = const [],
    this.selectedItems = const [],
    this.onDiscItem,
    this.onFavDisc,
    this.onSelectDisc,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      itemCount: categories.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: _userDiscCategoryItemCard,
    );
  }

  Widget _userDiscCategoryItemCard(BuildContext context, int index) {
    var item = categories[index];
    if (item.discs.isEmpty) return const SizedBox.shrink();
    var gap = EdgeInsets.symmetric(horizontal: Dimensions.screen_padding);
    var style = TextStyles.text18_700.copyWith(color: primary, letterSpacing: 0.54);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: gap, child: Text(item.displayName ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: style)),
        const SizedBox(height: 08),
        UserDiscHorizontalList(
          discs: item.discs,
          selectedItems: selectedItems,
          scrollControl: item.scrollControl,
          onTap: (discItem) => onDiscItem == null ? null : onDiscItem!(discItem),
          onFav: (discItem) => onFavDisc == null ? null : onFavDisc!(discItem),
          onSelect: (discItem) => onSelectDisc == null ? null : onSelectDisc!(discItem),
        ),
      ],
    );
  }
}
