import 'package:flutter/material.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/buttons/outline_button.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/club/club.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/svg_image.dart';

class NearestClubsList extends StatelessWidget {
  final Color background;
  final List<Club> clubs;
  final Function(Club, int index)? onJoin;
  final Function(Club, int index)? onLeft;

  const NearestClubsList({this.clubs = const [], this.onJoin, this.background = skyBlue, this.onLeft});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      itemCount: clubs.length,
      padding: EdgeInsets.zero,
      itemBuilder: _clubItemCard,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  Widget _clubItemCard(BuildContext context, int index) {
    var item = clubs[index];
    var isJoined = item.is_member;
    var textColor = background == skyBlue ? primary : lightBlue;
    var buttonTextColor = background == skyBlue ? (isJoined ? orange : mediumBlue) : (isJoined ? lightBlue : mediumBlue);
    // print(item.toJson());
    return TweenListItem(
      index: index,
      child: Container(
        width: double.infinity,
        key: Key('index_$index'),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        margin: EdgeInsets.only(bottom: index == clubs.length - 1 ? 0 : 12),
        decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name ?? 'N/A'.recast,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.text20_500.copyWith(color: textColor, height: 1.1),
            ),
            if (item.description.toKey.isNotEmpty)
              Text(
                item.description ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.text14_400.copyWith(color: textColor),
              ),
            const SizedBox(height: 04),
            Row(
              children: [
                if (item.totalMember != null)
                  Row(
                    children: [
                      SvgImage(image: Assets.svg1.users, height: 12, color: textColor),
                      const SizedBox(width: 02),
                      Text(
                        '${item.totalMember} ${'members'.recast}',
                        style: TextStyles.text10_400.copyWith(color: textColor, fontWeight: w500),
                      ),
                    ],
                  ),
                if (item.distance != null) const SizedBox(width: 08),
                if (item.distance != null)
                  Expanded(
                    child: Row(
                      children: [
                        SvgImage(image: Assets.svg1.location, height: 12, color: textColor),
                        const SizedBox(width: 02),
                        Expanded(
                          child: Text(
                            '${item.distance.formatDouble} ${'km'.recast}',
                            style: TextStyles.text10_400.copyWith(color: textColor, fontWeight: w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(width: 08),
                OutlineButton(
                  height: 36,
                  radius: 50,
                  width: 120,
                  label: isJoined ? 'club_joined'.recast : '${'join_club'.recast}?',
                  background: background == skyBlue ? skyBlue : (isJoined ? orange : skyBlue),
                  border: isJoined ? orange : mediumBlue,
                  onTap: () => isJoined ? (onLeft == null ? null : onLeft!(item, index)) : (onJoin == null ? null : onJoin!(item, index)),
                  textStyle: TextStyles.text14_500.copyWith(color: buttonTextColor, fontWeight: w500, height: 1.3),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
