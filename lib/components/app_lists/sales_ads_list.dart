import 'package:flutter/material.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/helpers/enums.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/widgets/library/image_network.dart';
import 'package:app/widgets/library/svg_image.dart';

class SalesAdsList extends StatelessWidget {
  final String label;
  final List<SalesAd> salesAdsList;
  final Function(SalesAd)? onItem;

  const SalesAdsList({this.label = '', this.salesAdsList = const [], this.onItem});

  @override
  Widget build(BuildContext context) {
    var listTitle = '$label ${'sales_ads'.recast}'.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
          child: Text(listTitle, style: TextStyles.text18_700.copyWith(color: primary, letterSpacing: 0.54)),
        ),
        const SizedBox(height: 08),
        SizedBox(
          height: 228 + 24,
          child: ListView.builder(
            shrinkWrap: true,
            clipBehavior: Clip.antiAlias,
            itemCount: salesAdsList.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(bottom: 24),
            itemBuilder: _salesAdsItemCard,
          ),
        ),
      ],
    );
  }

  Widget _salesAdsItemCard(BuildContext context, int index) {
    var item = salesAdsList[index];
    var gap = Dimensions.screen_padding;
    var userDisc = item.userDisc;
    var parentDisc = userDisc?.parentDisc;
    return InkWell(
      onTap: onItem == null ? null : () => onItem!(item),
      child: TweenListItem(
        index: index,
        twinAnim: TwinAnim.right_to_left,
        child: Container(
          width: 40.width,
          key: Key('index_$index'),
          padding: const EdgeInsets.all(04),
          margin: EdgeInsets.only(left: index == 0 ? gap : 0, right: index == salesAdsList.length - 1 ? gap : 08),
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ImageNetwork(
                  radius: 12,
                  width: double.infinity,
                  background: mediumBlue,
                  fit: BoxFit.contain,
                  image: userDisc?.media?.url ?? parentDisc?.media.url,
                  placeholder: const FadingCircle(size: 20),
                  errorWidget: SvgImage(image: Assets.svg1.image_square, color: primary.colorOpacity(0.4), height: 24.width),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 04),
                    Text(
                      parentDisc?.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.text12_600.copyWith(color: lightBlue),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${(item.price ?? 0).formatDouble} ${item.currency_code}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.text18_700.copyWith(color: lightBlue),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.address?.formatted_address ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.text10_400.copyWith(color: mediumBlue),
                    ),
                    const SizedBox(height: 2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
