import 'package:flutter/material.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/colored_disc.dart';

class MarketplaceGridList extends StatelessWidget {
  final double gap;
  final double bottomGap;
  final ScrollPhysics physics;
  final List<SalesAd> discList;
  final Function(SalesAd, int)? onItem;
  final Function(SalesAd, int index)? onFav;

  const MarketplaceGridList({
    this.discList = const [],
    this.onItem,
    this.onFav,
    this.gap = 0,
    this.bottomGap = 0,
    this.physics = const BouncingScrollPhysics(),
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: physics,
      primary: false,
      clipBehavior: Clip.antiAlias,
      itemCount: discList.length,
      gridDelegate: _gridDelegate,
      itemBuilder: _discItemCard,
      padding: EdgeInsets.only(left: gap, right: gap, bottom: bottomGap),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount get _gridDelegate {
    var screenWidth = SizeConfig.width;
    var crossAxisCount = 2;
    var spacing = 6.0;
    var totalSpacing = (crossAxisCount - 1) * spacing;
    var usableWidth = (screenWidth - totalSpacing) / crossAxisCount;
    var itemHeight = 230;
    var aspectRatio = usableWidth / itemHeight;
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      childAspectRatio: aspectRatio,
      crossAxisSpacing: spacing,
      mainAxisSpacing: 10,
      // childAspectRatio: 0.9,
    );
  }

  Widget _discItemCard(BuildContext context, int index) {
    var item = discList[index];
    var userDisc = item.userDisc;
    var parentDisc = userDisc?.parentDisc;
    return InkWell(
      onTap: onItem == null ? null : () => onItem!(item, index),
      child: TweenListItem(
        index: index,
        child: Container(
          key: Key('index_$index'),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              const SizedBox(height: 08),
              Builder(builder: (context) {
                if (userDisc?.media?.url != null) {
                  return CircleImage(
                    radius: 54,
                    borderWidth: 0.4,
                    borderColor: lightBlue,
                    image: userDisc?.media?.url,
                    placeholder: const FadingCircle(size: 40),
                    errorWidget: SvgImage(image: Assets.svg1.disc_3, height: 62, color: primary),
                    // errorWidget: ColoredDisc(size: 104, iconSize: 24, discColor: Colors.deepOrangeAccent),
                  );
                } else if (userDisc?.color != null) {
                  return ColoredDisc(
                    size: 108,
                    iconSize: 24,
                    discColor: userDisc!.disc_color!,
                    brandIcon: parentDisc?.brand_media.url,
                  );
                } else {
                  return CircleImage(
                    radius: 54,
                    borderWidth: 0.4,
                    borderColor: lightBlue,
                    image: parentDisc?.media.url,
                    placeholder: const FadingCircle(size: 40),
                    errorWidget: SvgImage(image: Assets.svg1.disc_3, height: 62, color: lightBlue),
                  );
                }
              }),
              /*Center(
                child: CircleImage(
                  radius: 54,
                  borderWidth: 0.4,
                  backgroundColor: primary,
                  borderColor: lightBlue,
                  image: userDisc?.media?.url ?? parentDisc?.media.url,
                  placeholder: const FadingCircle(size: 40, color: lightBlue),
                  errorWidget: SvgImage(image: Assets.svg1.disc_3, height: 48, color: lightBlue),
                ),
              ),*/
              const SizedBox(height: 16),
              Text(
                parentDisc?.name ?? 'n/a'.recast,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.text12_600.copyWith(color: lightBlue, height: 1.1),
              ),
              const SizedBox(height: 04),
              Text(
                '${(item.price ?? 0).formatDouble} ${item.currency_code}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.text14_700.copyWith(color: lightBlue, height: 1.2),
              ),
              const SizedBox(height: 03),
              Text(
                parentDisc?.brand?.name ?? 'n/a'.recast,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.text12_400.copyWith(color: lightBlue, height: 1.1),
              ),
              const SizedBox(height: 04),
            ],
          ),
        ),
      ),
    );
  }
}
