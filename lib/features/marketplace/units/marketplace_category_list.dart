import 'package:app/features/marketplace/units/marketplace_disc_list.dart';
import 'package:app/features/marketplace/units/marketplace_product_list.dart';
import 'package:app/models/marketplace/marketplace_category.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/dimensions.dart';
import 'package:flutter/material.dart';

class MarketplaceCategoryList extends StatelessWidget {
  final bool isModifiedData;
  final List<MarketplaceCategory> categories;
  final Function(SalesAd)? onDiscItem;
  final Function(SalesAd)? onSetFav;
  final Function(SalesAd)? onRemoveFav;
  const MarketplaceCategoryList({
    this.categories = const [],
    this.onDiscItem,
    this.onSetFav,
    this.onRemoveFav,
    this.isModifiedData = false,
  });

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
    // print(item.discs.length);
    var gap = EdgeInsets.symmetric(horizontal: Dimensions.screen_padding);
    var style = TextStyles.text18_700.copyWith(color: primary, letterSpacing: 0.54);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: gap, child: Text(item.displayName ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: style)),
        const SizedBox(height: 08),
        isModifiedData
            ? MarketplaceProductList(discs: item.discs, scrollControl: item.scrollControl, onTap: _onDiscItem, onFav: _onFavourite)
            : MarketplaceDiscList(discs: item.discs, scrollControl: item.scrollControl, onTap: _onDiscItem, onFav: _onFavourite),
      ],
    );
  }

  void _onDiscItem(SalesAd item) => onDiscItem == null ? null : onDiscItem!(item);

  void _onFavourite(SalesAd item, bool status) {
    if (status) {
      if (onRemoveFav == null) return;
      onRemoveFav!(item);
    } else {
      if (onSetFav == null) return;
      onSetFav!(item);
    }
  }
}
