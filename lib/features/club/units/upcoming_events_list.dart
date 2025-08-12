import 'package:flutter/material.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/constants/date_formats.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/helpers/enums.dart';
import 'package:app/libraries/formatters.dart';
import 'package:app/models/club/event.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/widgets/core/stack_images.dart';
import 'package:app/widgets/library/svg_image.dart';

class UpcomingEventsList extends StatelessWidget {
  final List<Event> events;
  final Function(Event)? onTap;
  const UpcomingEventsList({this.events = const [], this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86 + 12,
      child: ListView.builder(
        shrinkWrap: true,
        clipBehavior: Clip.antiAlias,
        itemCount: events.length,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(bottom: 12),
        itemBuilder: _clubEventsItemCard,
      ),
    );
  }

  Widget _clubEventsItemCard(BuildContext context, int index) {
    var item = events[index];
    var gap = Dimensions.screen_padding;
    return InkWell(
      onTap: Routes.user.club_event(event: item).push,
      child: TweenListItem(
        index: index,
        twinAnim: TwinAnim.right_to_left,
        child: Container(
          width: 44.width,
          key: Key('index_$index'),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          margin: EdgeInsets.only(left: index == 0 ? gap : 0, right: index == events.length - 1 ? gap : 06),
          decoration: BoxDecoration(color: skyBlue, boxShadow: const [SHADOW_1], borderRadius: BorderRadius.circular(6)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.name ?? 'n/a'.recast,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.text12_700.copyWith(color: primary, height: 1),
                    ),
                  ),
                  const SizedBox(width: 08),
                  const StackImages(
                    boxSize: 12,
                    borderWidth: 0,
                    // imageList: [DUMMY_PROFILE_IMAGE, '', ''],
                  ),
                ],
              ),
              const SizedBox(height: 06),
              Row(
                children: [
                  SvgImage(image: Assets.svg1.calendar_check, height: 12, color: primary),
                  const SizedBox(width: 04),
                  Expanded(
                    child: Text(
                      Formatters.formatDate(DATE_FORMAT_14, item.eventDate),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.text10_400.copyWith(color: primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 03),
              Row(
                children: [
                  SvgImage(image: Assets.svg1.clock, height: 12, color: primary),
                  const SizedBox(width: 04),
                  Expanded(
                    child: Text(
                      Formatters.formatDate(TIME_FORMAT_1, item.eventDate),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.text10_400.copyWith(color: primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 03),
              Row(
                children: [
                  SvgImage(image: Assets.svg1.map_pin, height: 12, color: primary),
                  const SizedBox(width: 03),
                  Expanded(
                    child: Text(
                      item.course?.name ?? 'n/a'.recast,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.text10_400.copyWith(color: primary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
