import 'package:flutter/material.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/helpers/enums.dart';
import 'package:app/models/disc/user_disc.dart';
import 'package:app/models/disc_bag/disc_bag.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/widgets/library/svg_image.dart';

class DiscBagsList extends StatelessWidget {
  final DiscBag discBag;
  final List<DiscBag> discBags;
  final Function(DiscBag)? onItem;
  final Function()? onAddBag;
  final Function(DiscBag)? onDelete;
  final Function(DragTargetDetails<UserDisc>, DiscBag)? onAccept;
  const DiscBagsList({required this.discBag, this.discBags = const [], this.onItem, this.onAddBag, this.onAccept, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30 + 10,
      child: ListView.builder(
        shrinkWrap: true,
        clipBehavior: Clip.antiAlias,
        itemCount: discBags.length,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(bottom: 10),
        itemBuilder: _dragTargetMenuItemCard,
      ),
    );
  }

  /*Widget _dragTargetMenuItemCard(BuildContext context, int index) {
    return DragTarget<UserDisc>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: onAccept == null ? null : (details) => onAccept!(details, discBags[index]),
      builder: (context, candidateData, rejectedData) {
        final UserDisc? candidate = candidateData.cast<UserDisc?>().firstWhere((e) => e != null, orElse: () => null);
        final hasCandidate = candidate != null;
        return InkWell(
          onLongPress: (hasCandidate && onAccept != null)
              ? () {
                  final details = DragTargetDetails<UserDisc>(data: candidate, offset: Offset.zero);
                  onAccept!(details, discBags[index]);
                }
              : null,
          child: _menuItemCard(context, index, hasCandidate),
        );
      },
    );
  }*/

  Widget _dragTargetMenuItemCard(BuildContext context, int index) {
    return DragTarget<UserDisc>(
      onWillAcceptWithDetails: (data) => true,
      onAcceptWithDetails: onAccept == null ? null : (data) => onAccept!(data, discBags[index]),
      builder: (context, candidateData, rejectedData) => _menuItemCard(context, index, candidateData.isNotEmpty),
    );
  }

  Widget _menuItemCard(BuildContext context, int index, bool isHighlighted) {
    var gap = Dimensions.screen_padding;
    var item = discBags[index];
    var selected = discBag.id != null && discBag.id == item.id;
    var invalidDelete = item.id == 1000001 || item.id == 1000002 || !item.is_delete;
    return InkWell(
      onTap: () => _onItem(index),
      child: TweenListItem(
        index: index,
        twinAnim: TwinAnim.right_to_left,
        child: Container(
          height: 30,
          key: Key('index_$index'),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: EdgeInsets.only(left: index == 0 ? gap : 0, right: index == discBags.length - 1 ? gap : 08),
          decoration: BoxDecoration(
            color: isHighlighted ? mediumBlue : (selected ? skyBlue : lightBlue),
            // color: selected ? skyBlue : lightBlue,
            borderRadius: BorderRadius.circular(4),
            border: !selected ? null : Border.all(color: primary),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(item.bag_menu_display_name, style: TextStyles.text12_600.copyWith(color: primary, height: 1)),
              if (!invalidDelete) const SizedBox(width: 06),
              if (!invalidDelete)
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: InkWell(onTap: () => _onDelete(index), child: SvgImage(image: Assets.svg1.close_1, height: 13, color: primary)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _onDelete(int index) {
    if (onDelete == null) return;
    onDelete!(discBags[index]);
  }

  void _onItem(int index) {
    var item = discBags[index];
    if (item.id == 1000001) {
      // if (onAll == null) return;
      // onAll!();
      if (onItem == null) return;
      onItem!(item);
    } else if (item.id == 1000002) {
      if (onAddBag == null) return;
      onAddBag!();
    } else {
      if (onItem == null) return;
      onItem!(item);
    }
  }
}
