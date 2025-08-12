import 'package:flutter/material.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/components/loaders/loader_box.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/helpers/enums.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/widgets/library/image_network.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/colored_disc.dart';

class UsedDiscList extends StatelessWidget {
  final String label;
  final List<SalesAd> discs;
  final Function(SalesAd)? onTap;

  const UsedDiscList({this.label = '', this.discs = const [], this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
          child: Text(
            label,
            maxLines: 1,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.text18_700.copyWith(color: primary, letterSpacing: 0.54),
          ),
        ),
        const SizedBox(height: 08),
        SizedBox(
          height: 226 + 10,
          child: ListView.builder(
            shrinkWrap: true,
            clipBehavior: Clip.antiAlias,
            itemCount: discs.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(bottom: 10),
            itemBuilder: _clubItemCard,
          ),
        ),
      ],
    );
  }

  Widget _clubItemCard(BuildContext context, int index) {
    var item = discs[index];
    var userDisc = item.userDisc;
    var parentDisc = userDisc?.parentDisc;
    var gap = Dimensions.screen_padding;
    return InkWell(
      onTap: onTap == null ? null : () => onTap!(item),
      child: TweenListItem(
        index: index,
        twinAnim: TwinAnim.right_to_left,
        child: Container(
          width: 40.width,
          key: Key('index_$index'),
          padding: const EdgeInsets.all(04),
          margin: EdgeInsets.only(left: index == 0 ? gap : 0, right: index == discs.length - 1 ? gap : 08),
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 08),
              Center(
                child: Builder(builder: (context) {
                  if (userDisc?.media?.url != null) {
                    return ImageNetwork(
                      height: 132,
                      width: 32.width,
                      fit: BoxFit.contain,
                      image: userDisc?.media?.url,
                      placeholder: const FadingCircle(size: 40, color: lightBlue),
                      errorWidget: _errorImageBox,
                    );
                  } else if (userDisc?.color != null) {
                    return ColoredDisc(
                      size: 132,
                      iconSize: 24,
                      discColor: userDisc!.disc_color!,
                      brandIcon: parentDisc?.brand_media.url,
                    );
                  } else {
                    return ImageNetwork(
                      height: 132,
                      width: 32.width,
                      fit: BoxFit.contain,
                      image: parentDisc?.media.url,
                      placeholder: const FadingCircle(size: 40, color: lightBlue),
                      errorWidget: _errorImageBox,
                    );
                  }
                }),
              ),
              /*Center(
                child: ImageNetwork(
                  height: 132,
                  width: 35.width,
                  fit: BoxFit.contain,
                  image: userDisc?.media?.url ?? parentDisc?.media.url,
                  // placeholder: const FadingCircle(size: 40, color: lightBlue),
                  errorWidget: _errorImageBox,
                ),
              ),*/
              const SizedBox(height: 06),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      parentDisc?.name ?? 'n/a'.recast,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.text12_600.copyWith(color: lightBlue),
                    ),
                    const SizedBox(height: 04),
                    Text(
                      '${item.price.formatDouble} ${UserPreferences.currencyCode}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.text14_700.copyWith(color: lightBlue, height: 1),
                    ),
                    const SizedBox(height: 02),
                    Text(
                      item.address?.formatted_address ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.text10_400.copyWith(color: mediumBlue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _errorImageBox {
    return LoaderBox(
      radius: 12,
      border: lightBlue.colorOpacity(0.4),
      boxSize: const Size(double.infinity, 144),
      child: SvgImage(image: Assets.svg1.image_square, height: 70, color: lightBlue.colorOpacity(0.5)),
    );
  }
}
