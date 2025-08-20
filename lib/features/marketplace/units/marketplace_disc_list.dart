import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/app_icons/favourite.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/helpers/enums.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/colored_disc.dart';
import 'package:flutter/material.dart';

class MarketplaceDiscList extends StatelessWidget {
  final List<SalesAd> discs;
  final ScrollPhysics physics;
  final ScrollController? scrollControl;
  final Function(SalesAd)? onTap;
  final Function(SalesAd, bool)? onFav;

  const MarketplaceDiscList({
    this.onTap,
    this.onFav,
    this.discs = const [],
    this.scrollControl,
    this.physics = const BouncingScrollPhysics(),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 216 + 10,
      child: ListView.builder(
        shrinkWrap: true,
        physics: physics,
        controller: scrollControl,
        clipBehavior: Clip.antiAlias,
        itemCount: discs.length,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(bottom: 10),
        itemBuilder: _discItemCard,
      ),
    );
  }

  Widget _discItemCard(BuildContext context, int index) {
    var item = discs[index];
    var gap = Dimensions.screen_padding;
    var userDisc = item.userDisc;
    var parentDisc = userDisc?.parentDisc;
    var distance = item.address?.distance_number ?? 0;
    var distanceLabel = '${item.address?.distance_number.formatInt ?? 0} ${'km'.recast}';
    var flightDataStyle = TextStyles.text13_600.copyWith(color: lightBlue, height: 1);
    var isMyDisc = UserPreferences.user.id == item.sellerInfo?.id;
    return InkWell(
      onTap: () => onTap == null ? null : onTap!(item),
      child: TweenListItem(
        index: index,
        twinAnim: TwinAnim.right_to_left,
        child: Container(
          width: 40.width,
          key: Key('index_$index'),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          margin: EdgeInsets.only(left: index == 0 ? gap : 0, right: index == discs.length - 1 ? gap : 08),
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!isMyDisc) Favourite(status: item.is_favourite, onTap: onFav == null ? null : () => onFav!(item, item.is_favourite)),
                  const Spacer(),
                  if (distance > 0) Text(distanceLabel, style: TextStyles.text12_600.copyWith(color: lightBlue, height: 1.1))
                ],
              ),
              SizedBox(height: distance > 0 ? 05 : 08),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(
                    child: Builder(builder: (context) {
                      if (userDisc?.media?.url != null) {
                        // print('name: ${parentDisc?.name} -> image: ${userDisc?.media?.url} -> distance: ${item.address?.distance}');
                        // return Image.network(userDisc!.media!.url!, height: 100, width: 100);
                        return CircleImage(
                          radius: 54,
                          borderWidth: 0.4,
                          borderColor: lightBlue,
                          fit: BoxFit.contain,
                          image: userDisc?.media?.url,
                          placeholder: const FadingCircle(size: 40),
                          errorWidget: SvgImage(image: Assets.svg1.disc_3, height: 62, color: primary),
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
                  ),
                  Positioned(
                    left: 04,
                    right: 04,
                    bottom: -30,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 04, vertical: 04),
                      decoration: BoxDecoration(color: skyBlue, borderRadius: BorderRadius.circular(05)),
                      child: Column(
                        children: [
                          Text(
                            parentDisc?.name ?? 'n/a'.recast,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.text13_600.copyWith(color: primary, height: 1),
                          ),
                          const SizedBox(height: 04),
                          Text(
                            '${(item.price ?? 0).formatDouble} ${item.currency_code}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.text14_700.copyWith(color: primary, height: 1),
                          ),
                          const SizedBox(height: 02),
                          Text(
                            parentDisc?.brand?.name ?? 'n/a'.recast,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.text12_400.copyWith(color: primary, height: 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                height: 24,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(border: Border.all(color: lightBlue), borderRadius: BorderRadius.circular(4)),
                child: Row(
                  children: [
                    Expanded(child: Center(child: Text('${userDisc?.speed.formatDouble ?? 0}', style: flightDataStyle))),
                    Container(height: 24, width: 0.5, color: lightBlue),
                    Expanded(child: Center(child: Text('${userDisc?.glide.formatDouble ?? 0}', style: flightDataStyle))),
                    Container(height: 24, width: 0.5, color: lightBlue),
                    Expanded(child: Center(child: Text('${userDisc?.fade.formatDouble ?? 0}', style: flightDataStyle))),
                    Container(height: 24, width: 0.5, color: lightBlue),
                    Expanded(child: Center(child: Text('${userDisc?.turn.formatDouble ?? 0}', style: flightDataStyle))),
                  ],
                ),
              ),
              // const SizedBox(height: 02),
            ],
          ),
        ),
      ),
    );
  }
}
