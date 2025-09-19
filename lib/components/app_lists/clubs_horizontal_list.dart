/*import 'package:flutter/material.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/helpers/enums.dart';
import 'package:app/models/club/club.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';

import 'package:app/widgets/library/svg_image.dart';*/

/*class ClubsHorizontalList extends StatelessWidget {
  final List<Club> clubs;
  final Function(Club)? onTap;
  final Function()? onShareLocation;

  const ClubsHorizontalList({this.clubs = const [], this.onTap, this.onShareLocation});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
          child: Text('clubs_close_to_you'.recast, style: TextStyles.text18_700.copyWith(color: primary, letterSpacing: 0.54)),
        ),
        const SizedBox(height: 08),
        if (clubs.isNotEmpty)
          SizedBox(
            height: 150 + 12,
            child: ListView.builder(
              shrinkWrap: true,
              clipBehavior: Clip.antiAlias,
              itemCount: clubs.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(bottom: 12),
              itemBuilder: _clubItemCard,
            ),
          )
        else
          _noClubFound(context)
      ],
    );
  }

  Widget _clubItemCard(BuildContext context, int index) {
    final item = clubs[index];
    final gap = Dimensions.screen_padding;
    return InkWell(
      onTap: Routes.user.club(club: item).push,
      child: TweenListItem(
        index: index,
        twinAnim: TwinAnim.right_to_left,
        child: Container(
          width: 64.width,
          key: Key('index_$index'),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          margin: EdgeInsets.only(left: index == 0 ? gap : 0, right: index == clubs.length - 1 ? gap : 08),
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Singapore Club ',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.text20_500.copyWith(color: lightBlue),
                  ),
                  const SizedBox(height: 02),
                  Row(
                    children: [
                      Row(
                        children: [
                          SvgImage(image: Assets.svg1.users, height: 12, color: skyBlue),
                          const SizedBox(width: 02),
                          Text(
                            '27 ${'members'.recast}',
                            maxLines: 1,
                            style: TextStyles.text10_400.copyWith(color: skyBlue, fontWeight: w500),
                          ),
                        ],
                      ),
                      const SizedBox(width: 08),
                      Expanded(
                        child: Row(
                          children: [
                            SvgImage(image: Assets.svg1.location, height: 12, color: skyBlue),
                            const SizedBox(width: 02),
                            Expanded(
                              child: Text(
                                '10 ${'km'.recast}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.text10_400.copyWith(color: skyBlue, fontWeight: w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 04),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Home course:',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.text14_400.copyWith(color: skyBlue, letterSpacing: 0.42, height: 1),
                  ),
                  const SizedBox(height: 04),
                  Text(
                    'Kallang riverside park',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.text10_400.copyWith(color: skyBlue, height: 1),
                  ),
                ],
              ),
              const SizedBox(height: 06),
              ElevateButton(
                height: 30,
                width: double.infinity,
                radius: 04,
                background: mediumBlue,
                icon: SvgImage(image: Assets.svg1.comment, height: 14, color: white),
                label: 'write_in_club_thread'.recast.toUpper,
                textStyle: TextStyles.text12_700.copyWith(color: white, fontSize: 11, height: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _noClubFound(BuildContext context) {
    final label = 'sorry_we_cant_show_you_the_nearest_events'.recast;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: Dimensions.screen_padding, right: Dimensions.screen_padding, bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(color: skyBlue, borderRadius: BorderRadius.circular(08)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(label, textAlign: TextAlign.center, style: TextStyles.text14_600.copyWith(color: primary)),
          ),
          const SizedBox(height: 10),
          ElevateButton(
            radius: 04,
            height: 38,
            width: double.infinity,
            label: 'share_location'.recast.toUpper,
            onTap: onShareLocation == null ? null : () => onShareLocation!(),
            textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
          ),
        ],
      ),
    );
  }
}*/
