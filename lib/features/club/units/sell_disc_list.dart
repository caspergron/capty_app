import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/helpers/enums.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:flutter/material.dart';

class SellDiscList extends StatelessWidget {
  final List<SalesAd> discs;
  final Function(SalesAd)? onItem;
  const SellDiscList({this.discs = const [], this.onItem});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112 + 12,
      child: ListView.builder(
        shrinkWrap: true,
        clipBehavior: Clip.antiAlias,
        itemCount: discs.length,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(bottom: 12),
        itemBuilder: _sellDiscItemCard,
      ),
    );
  }

  Widget _sellDiscItemCard(BuildContext context, int index) {
    var item = discs[index];
    var userDisc = item.userDisc;
    var gap = Dimensions.screen_padding;
    return InkWell(
      onTap: () => onItem == null ? null : onItem!(item),
      child: TweenListItem(
        index: index,
        twinAnim: TwinAnim.right_to_left,
        child: Container(
          width: 86,
          key: Key('index_$index'),
          margin: EdgeInsets.only(left: index == 0 ? gap : 0, right: index == discs.length - 1 ? gap : 07),
          decoration: BoxDecoration(color: transparent, borderRadius: BorderRadius.circular(6)),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 70,
                  width: double.infinity,
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.only(left: 04, right: 04, bottom: 04),
                  decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(6)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        userDisc?.name ?? '',
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.text12_700.copyWith(color: lightBlue, fontSize: 11),
                      ),
                      Text(
                        userDisc?.brand?.name ?? '',
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.text10_400.copyWith(color: lightBlue),
                      ),
                      Text(
                        '${(item.price ?? 0).formatDouble} ${item.currency_code}',
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.text10_400.copyWith(color: orange, fontWeight: w500),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 08,
                right: 08,
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double maxSize = constraints.maxWidth;
                      return CircleImage(
                        borderWidth: 0.4,
                        radius: maxSize / 2.35,
                        image: userDisc?.media?.url,
                        placeholder: const FadingCircle(size: 40, color: lightBlue),
                        errorWidget: SvgImage(image: Assets.svg1.disc_3, height: 40, color: primary),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
