import 'package:flutter/material.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/models/common/tag.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/animated_icon_box.dart';
import 'package:app/widgets/library/svg_image.dart';

class DiscSpecialityList extends StatelessWidget {
  final Color background;
  final List<Tag> specialities;
  final List<Tag> selectedSpecialities;
  final Function(Tag)? onSelect;

  const DiscSpecialityList({
    this.specialities = const [],
    this.selectedSpecialities = const [],
    this.onSelect,
    this.background = lightBlue,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      itemCount: specialities.length,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: _gridDelegate,
      itemBuilder: _discOptionItemCard,
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount get _gridDelegate {
    var crossAxisCount = 2;
    var spacing = 6.0;
    var totalSpacing = (crossAxisCount - 1) * spacing;
    var usableWidth = (SizeConfig.width - totalSpacing) / crossAxisCount;
    var itemHeight = 20;
    var aspectRatio = usableWidth / itemHeight;
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 06,
      mainAxisSpacing: 08,
      childAspectRatio: aspectRatio,
    );
  }

  Widget _discOptionItemCard(BuildContext context, int index) {
    var item = specialities[index];
    var selected = selectedSpecialities.isNotEmpty && selectedSpecialities.any((element) => element.id == item.id);
    var isLight = background == lightBlue;
    var color = onSelect == null ? lightBlue : (isLight ? primary : lightBlue);
    return InkWell(
      onTap: onSelect == null ? null : () => onSelect!(item),
      child: TweenListItem(
        index: index,
        child: Row(
          children: [
            onSelect == null
                ? SvgImage(image: Assets.svg1.tick, height: 14, color: lightBlue)
                : AnimatedIconBox(
                    size: 19,
                    value: selected,
                    active: isLight ? primary : lightBlue,
                    inactive: isLight ? primary : lightBlue,
                    inactiveIcon: Assets.svg1.square,
                    activeIcon: Assets.svg1.check_square,
                  ),
            const SizedBox(width: 06),
            Expanded(
              child: Text(
                item.displayName ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.text13_600.copyWith(color: color, fontWeight: w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
