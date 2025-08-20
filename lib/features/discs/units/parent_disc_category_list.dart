import 'package:app/features/discs/units/pdga_horizontal_disc_list.dart';
import 'package:app/models/disc/disc_category.dart';
import 'package:app/models/disc/parent_disc.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/dimensions.dart';
import 'package:flutter/material.dart';

class ParentDiscCategoryList extends StatelessWidget {
  final List<DiscCategory> categories;
  final Function(ParentDisc)? onDiscItem;
  final Function(ParentDisc, int)? onFavDisc;
  const ParentDiscCategoryList({this.categories = const [], this.onDiscItem, this.onFavDisc});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      itemCount: categories.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: _marketplaceItemCard,
    );
  }

  Widget _marketplaceItemCard(BuildContext context, int index) {
    var item = categories[index];
    if (item.discs.isEmpty) return const SizedBox.shrink();
    var gap = EdgeInsets.symmetric(horizontal: Dimensions.screen_padding);
    var style = TextStyles.text18_700.copyWith(color: primary, letterSpacing: 0.54);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: gap, child: Text(item.displayName ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: style)),
        const SizedBox(height: 08),
        PdgaHorizontalDiscList(
          discs: item.discs,
          scrollControl: item.scrollControl,
          onTap: (discItem) => onDiscItem == null ? null : onDiscItem!(discItem),
          onFav: (discItem, discIndex) => onFavDisc == null ? null : onFavDisc!(discItem, discIndex),
        ),
      ],
    );
  }
}
