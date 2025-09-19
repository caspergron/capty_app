import 'package:flutter/material.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/disc/user_disc.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/colored_disc.dart';

class TournamentDiscList extends StatelessWidget {
  final List<UserDisc> discs;
  final Function(UserDisc, int index)? onItem;
  final Function(UserDisc, int index)? onFav;

  const TournamentDiscList({this.discs = const [], this.onItem, this.onFav});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      // physics: physics,
      primary: false,
      clipBehavior: Clip.antiAlias,
      itemCount: discs.length,
      gridDelegate: _gridDelegate,
      itemBuilder: _discItemCard,
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: BOTTOM_GAP),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount get _gridDelegate {
    final screenWidth = SizeConfig.width;
    const crossAxisCount = 2;
    const spacing = 6.0;
    const totalSpacing = (crossAxisCount - 1) * spacing;
    final usableWidth = (screenWidth - totalSpacing) / crossAxisCount;
    const itemHeight = 220;
    final aspectRatio = usableWidth / itemHeight;
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      childAspectRatio: aspectRatio,
      crossAxisSpacing: spacing,
      mainAxisSpacing: 10,
      // childAspectRatio: 0.9,
    );
  }

  Widget _discItemCard(BuildContext context, int index) {
    final item = discs[index];
    return InkWell(
      onTap: onItem == null ? null : () => onItem!(item, index),
      child: TweenListItem(
        index: index,
        child: Container(
          key: Key('index_$index'),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              const SizedBox(height: 08),
              Center(
                child: Builder(builder: (context) {
                  if (item.color != null) {
                    return ColoredDisc(discColor: item.disc_color!, size: 100, brandIcon: item.brand?.media?.url);
                  } else {
                    return CircleImage(
                      radius: 50,
                      borderWidth: 0.4,
                      color: popupBearer.colorOpacity(0.1),
                      backgroundColor: primary,
                      borderColor: lightBlue,
                      image: item.media?.url,
                      placeholder: const FadingCircle(size: 40, color: lightBlue),
                      errorWidget: SvgImage(image: Assets.svg1.disc_3, height: 48, color: lightBlue),
                    );
                  }
                }),
              ),
              const SizedBox(height: 18),
              Text(
                item.name ?? 'n/a'.recast,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.text12_600.copyWith(color: lightBlue, height: 1.1),
              ),
              const SizedBox(height: 08),
              Text(
                item.brand?.name ?? 'n/a'.recast,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.text12_400.copyWith(color: lightBlue, height: 1.1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
