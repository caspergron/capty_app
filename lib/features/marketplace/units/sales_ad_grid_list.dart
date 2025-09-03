import 'package:flutter/material.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/constants/data_constants.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/helpers/enums.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/colored_disc.dart';

class SalesAdGridList extends StatelessWidget {
  final double gap;
  final ScrollPhysics physics;
  final List<SalesAd> discList;
  final Function()? onAdd;
  final Function(SalesAd, int)? onDisc;

  const SalesAdGridList({
    this.discList = const [],
    this.onAdd,
    this.onDisc,
    this.gap = 20,
    this.physics = const NeverScrollableScrollPhysics(),
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: physics,
      clipBehavior: Clip.antiAlias,
      itemCount: discList.length,
      gridDelegate: _gridDelegate,
      itemBuilder: _discItemCard,
      padding: EdgeInsets.symmetric(horizontal: gap),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount get _gridDelegate {
    var crossAxisCount = 2;
    var spacing = 6.0;
    var totalSpacing = (crossAxisCount - 1) * spacing;
    var usableWidth = (SizeConfig.width - totalSpacing) / crossAxisCount;
    var itemHeight = 270;
    var aspectRatio = usableWidth / itemHeight;
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      // childAspectRatio: 0.75,
      crossAxisSpacing: 06,
      mainAxisSpacing: 20,
      childAspectRatio: aspectRatio,
    );
  }

  Widget _discItemCard(BuildContext context, int index) {
    var item = discList[index];
    if (index == 0 && item.id == DEFAULT_ID) return _addDiscItemCard;
    var decoration = BoxDecoration(color: primary, borderRadius: BorderRadius.circular(8));
    var rationSection = AspectRatio(aspectRatio: 1.1, child: Container(decoration: decoration));
    return TweenListItem(
      index: index,
      twinAnim: TwinAnim.right_to_left,
      child: InkWell(
        onTap: onDisc == null ? null : () => onDisc!(item, index),
        child: Stack(children: [Align(alignment: Alignment.bottomCenter, child: rationSection), _discInformation(item)]),
      ),
    );
  }

  Widget _discInformation(SalesAd item) {
    var userDisc = item.userDisc;
    var parentDisc = userDisc?.parentDisc;
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 04),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              double maxSize = constraints.maxWidth;
              if (userDisc?.media?.url != null) {
                /*return Container(
                  color: Colors.red,
                  child: Image.network(userDisc!.media!.url!),
                );*/
                return CircleImage(
                  radius: maxSize / 2.2,
                  borderWidth: 0.4,
                  image: userDisc?.media?.url,
                  placeholder: const FadingCircle(size: 32),
                  errorWidget: SvgImage(image: Assets.svg1.disc_3, height: 40, color: primary),
                );
              } else if (userDisc?.color != null) {
                return ColoredDisc(
                  iconSize: 20,
                  size: maxSize - 4,
                  discColor: userDisc!.disc_color!,
                  brandIcon: parentDisc?.brand_media.url,
                );
              } else {
                return CircleImage(
                  radius: maxSize / 2.2,
                  borderWidth: 0.4,
                  image: parentDisc?.media.url,
                  placeholder: const FadingCircle(size: 32),
                  errorWidget: SvgImage(image: Assets.svg1.disc_3, height: 40, color: primary),
                );
              }
            },
          ),
          Column(
            children: [
              Text(
                item.userDisc?.parentDisc?.name ?? 'n/a'.recast,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyles.text10_400.copyWith(color: lightBlue, fontWeight: w700),
              ),
              Text(
                item.userDisc?.parentDisc?.brand?.name ?? 'n/a'.recast,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyles.text10_400.copyWith(color: lightBlue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget get _addDiscItemCard {
    return InkWell(
      onTap: onAdd,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 04),
        decoration: BoxDecoration(color: const Color(0x6000246B), borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgImage(image: Assets.svg1.plus, color: lightBlue, height: 24),
            const SizedBox(height: 08),
            Text('add_a_disc'.recast.toUpper, textAlign: TextAlign.center, style: TextStyles.text12_700.copyWith(color: lightBlue))
          ],
        ),
      ),
    );
  }
}
