import 'package:flutter/material.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/disc/parent_disc.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';

class ParentDiscGridList extends StatelessWidget {
  final double gap;
  final double bottomGap;
  final ScrollPhysics physics;
  final List<ParentDisc> discList;
  final Function(ParentDisc, int)? onItem;

  const ParentDiscGridList({
    this.discList = const [],
    this.onItem,
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
    final screenWidth = SizeConfig.width;
    const crossAxisCount = 2;
    const spacing = 6.0;
    const totalSpacing = (crossAxisCount - 1) * spacing;
    final usableWidth = (screenWidth - totalSpacing) / crossAxisCount;
    const itemHeight = 216;
    final aspectRatio = usableWidth / itemHeight;
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      childAspectRatio: aspectRatio,
      crossAxisSpacing: spacing,
      mainAxisSpacing: 10,
    );
  }

  Widget _discItemCard(BuildContext context, int index) {
    final item = discList[index];
    final discFeatures = [item.speed ?? 0, item.glide ?? 0, item.turn ?? 0, item.fade ?? 0];
    return InkWell(
      onTap: onItem == null ? null : () => onItem!(item, index),
      child: TweenListItem(
        index: index,
        child: Container(
          key: Key('index_$index'),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 08),
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              const SizedBox(height: 04),
              Center(
                child: CircleImage(
                  radius: 53,
                  borderWidth: 0.4,
                  color: popupBearer.colorOpacity(0.1),
                  backgroundColor: primary,
                  borderColor: lightBlue,
                  image: item.media.url,
                  placeholder: const FadingCircle(size: 40, color: lightBlue),
                  errorWidget: SvgImage(image: Assets.svg1.disc_3, height: 48, color: lightBlue),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                item.name ?? 'n/a'.recast,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.text12_600.copyWith(color: lightBlue, height: 1.1),
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
              const SizedBox(height: 02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _numberListItem(List<double> items, int index) {
    final item = items[index];
    final isFirst = index == 0;
    final isLast = index == items.length - 1;
    final decoration = BoxDecoration(color: mediumBlue, borderRadius: BorderRadius.circular(2));
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
