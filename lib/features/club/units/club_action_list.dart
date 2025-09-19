import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/constants/date_formats.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/helpers/enums.dart';
import 'package:app/libraries/formatters.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';

class ClubActionList extends StatelessWidget {
  final List<String> actions;
  final Function(String)? onTap;
  const ClubActionList({this.actions = const [], this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 78 + 12,
      child: ListView.builder(
        shrinkWrap: true,
        clipBehavior: Clip.antiAlias,
        itemCount: actions.length,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(bottom: 12),
        itemBuilder: _clubActionItemCard,
      ),
    );
  }

  Widget _clubActionItemCard(BuildContext context, int index) {
    final item = actions[index];
    final gap = Dimensions.screen_padding;
    if (kDebugMode) print(item);
    return InkWell(
      // onTap: Routes.user.club(club: item).push,
      child: TweenListItem(
        index: index,
        twinAnim: TwinAnim.right_to_left,
        child: Container(
          width: 44.width,
          key: Key('index_$index'),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          margin: EdgeInsets.only(left: index == 0 ? gap : 0, right: index == actions.length - 1 ? gap : 06),
          decoration: BoxDecoration(color: skyBlue, boxShadow: const [SHADOW_1], borderRadius: BorderRadius.circular(6)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleImage(
                    radius: 14,
                    // image: index.isEven ? DUMMY_PROFILE_IMAGE : null,
                    color: popupBearer.colorOpacity(0.1),
                    backgroundColor: primary,
                    placeholder: const FadingCircle(size: 16, color: lightBlue),
                    errorWidget: SvgImage(image: Assets.svg1.coach, height: 16, color: lightBlue),
                  ),
                  const SizedBox(width: 08),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Wesley De Ridder',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.text12_700.copyWith(color: primary, height: 1),
                        ),
                        const SizedBox(height: 02),
                        Text(
                          Formatters.formatDate(DATE_FORMAT_14, '$currentDate'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.text10_400.copyWith(color: primary, height: 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                'Had the highest PDGA improvemet this month',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.text10_400.copyWith(color: primary, height: 1.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
