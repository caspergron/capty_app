import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/app_icons/favourite.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/helpers/enums.dart';
import 'package:app/models/disc/parent_disc.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:flutter/material.dart';

class ParentDiscHorizontalList extends StatelessWidget {
  final List<ParentDisc> discs;
  final ScrollPhysics physics;
  final ScrollController? scrollControl;
  final Function(ParentDisc, int index)? onTap;
  final Function(ParentDisc, int index)? onFav;

  const ParentDiscHorizontalList({
    this.onTap,
    this.onFav,
    this.discs = const [],
    this.scrollControl,
    this.physics = const BouncingScrollPhysics(),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (onFav == null ? 200 : 210) + 10,
      child: ListView.builder(
        shrinkWrap: true,
        controller: scrollControl,
        clipBehavior: Clip.antiAlias,
        itemCount: discs.length,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(bottom: 10),
        itemBuilder: _discItemCard,
        physics: physics,
      ),
    );
  }

  Widget _discItemCard(BuildContext context, int index) {
    var item = discs[index];
    var gap = Dimensions.screen_padding;
    var discFeatures = [item.speed ?? 0, item.glide ?? 0, item.turn ?? 0, item.fade ?? 0];
    return InkWell(
      onTap: onTap == null ? null : () => onTap!(item, index),
      child: TweenListItem(
        index: index,
        twinAnim: TwinAnim.right_to_left,
        child: Container(
          width: 40.width,
          key: Key('index_$index'),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 08),
          margin: EdgeInsets.only(left: index == 0 ? gap : 0, right: index == discs.length - 1 ? gap : 08),
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              const SizedBox(height: 02),
              if (onFav != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: Favourite(status: item.is_wishListed, onTap: onFav == null ? null : () => onFav!(item, index)),
                ),
              CircleImage(
                radius: 54,
                borderWidth: 0.4,
                borderColor: lightBlue,
                fit: BoxFit.contain,
                image: item.media.url,
                placeholder: const FadingCircle(size: 40),
                errorWidget: SvgImage(image: Assets.svg1.disc_3, height: 62, color: primary),
              ),
              const Spacer(),
              Text(
                item.name ?? 'n/a'.recast,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.text12_600.copyWith(color: lightBlue, height: 1.1, fontSize: 13),
              ),
              const SizedBox(height: 04),
              Text(
                item.brand?.name ?? 'n/a'.recast,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.text14_700.copyWith(color: lightBlue, height: 1.2),
              ),
              const SizedBox(height: 03),
              Wrap(
                alignment: WrapAlignment.center,
                children: List.generate(discFeatures.length, (index) => _numberListItem(discFeatures, index)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _numberListItem(List<double> items, int index) {
    var item = items[index];
    var isFirst = index == 0;
    var isLast = index == items.length - 1;
    var decoration = BoxDecoration(color: mediumBlue, borderRadius: BorderRadius.circular(2));
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isFirst) const SizedBox(width: 06),
        Text(item.formatDouble, style: TextStyles.text12_600.copyWith(color: lightBlue)),
        if (!isLast) const SizedBox(width: 06),
        if (!isLast) Container(height: 12, width: 1, decoration: decoration),
      ],
    );
  }
}
