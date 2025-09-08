import 'package:flutter/material.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/constants/data_constants.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/helpers/enums.dart';
import 'package:app/models/disc/user_disc.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/rectangle_check_box.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/colored_disc.dart';

class DiscGridList extends StatelessWidget {
  final double gap;
  final ScrollPhysics physics;
  final List<UserDisc> discList;
  final List<UserDisc> selectedItems;
  final Function()? onAdd;
  final Function(UserDisc, int)? onDisc;
  final Function(UserDisc, int)? onSelect;

  const DiscGridList({
    this.discList = const [],
    this.selectedItems = const [],
    this.onAdd,
    this.onDisc,
    this.onSelect,
    this.gap = 20,
    this.physics = const BouncingScrollPhysics(),
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: physics,
      clipBehavior: Clip.antiAlias,
      itemCount: discList.length,
      gridDelegate: _gridDelegate,
      itemBuilder: _draggableDiscItemCard,
      padding: EdgeInsets.symmetric(horizontal: gap),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount get _gridDelegate {
    var crossAxisCount = 2;
    var spacing = 6.0;
    var totalSpacing = (crossAxisCount - 1) * spacing;
    var usableWidth = (SizeConfig.width - totalSpacing) / crossAxisCount;
    var itemHeight = 256;
    var aspectRatio = usableWidth / itemHeight;
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      crossAxisSpacing: 06,
      mainAxisSpacing: 08,
      childAspectRatio: aspectRatio,
    );
  }

  Widget _draggableDiscItemCard(BuildContext context, int index) {
    final item = discList[index];
    if (index == 0 && item.id == DEFAULT_ID) return _addDiscItemCard;
    return LongPressDraggable<UserDisc>(
      data: item,
      feedback: Material(type: MaterialType.transparency, child: Opacity(opacity: 0.7, child: _feedBackItem(context, index))),
      childWhenDragging: Opacity(opacity: 0.5, child: _discItemCard(context, index)),
      child: _discItemCard(context, index),
    );
  }

  Widget _feedBackItem(BuildContext context, int index) {
    var width = SizeConfig.width / 4 - 6;
    return Material(color: transparent, child: SizedBox(height: 120, width: width, child: _discItemCard(context, index)));
  }

  Widget _discItemCard(BuildContext context, int index) {
    var item = discList[index];
    if (index == 0 && item.id == DEFAULT_ID) return _addDiscItemCard;
    var isSelected = selectedItems.isNotEmpty && selectedItems.any((element) => element.id == item.id);
    var decoration = BoxDecoration(color: primary, borderRadius: BorderRadius.circular(8));
    var checkBox = RectangleCheckBox(color: primary, isChecked: isSelected, onTap: () => onSelect!(item, index));
    return TweenListItem(
      index: index,
      twinAnim: TwinAnim.right_to_left,
      child: InkWell(
        onTap: onDisc == null ? null : () => onDisc!(item, index),
        child: Stack(
          children: [
            Align(alignment: Alignment.bottomCenter, child: AspectRatio(aspectRatio: 1.1, child: Container(decoration: decoration))),
            _discInformation(item),
            if (onSelect != null) Positioned(top: 0, right: 0, child: checkBox),
          ],
        ),
      ),
    );
  }

  Widget _discInformation(UserDisc item) {
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
              if (item.color != null) {
                return ColoredDisc(
                  iconSize: 30,
                  size: maxSize - 4,
                  discColor: item.disc_color!,
                  brandIcon: item.brand?.media?.url,
                );
              } else {
                return CircleImage(
                  radius: maxSize / 2.2,
                  borderWidth: 0.4,
                  image: item.media?.url,
                  placeholder: const FadingCircle(size: 32),
                  errorWidget: SvgImage(image: Assets.svg1.disc_3, height: 40, color: primary),
                );
              }
            },
          ),
          const SizedBox(height: 02),
          Column(
            children: [
              Text(
                item.name ?? 'n/a'.recast,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.text10_400.copyWith(color: lightBlue, fontWeight: w700),
              ),
              const SizedBox(height: 01),
              Text(
                item.brand?.name ?? 'n/a'.recast,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.text10_400.copyWith(color: lightBlue),
              ),
              const SizedBox(height: 01),
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
