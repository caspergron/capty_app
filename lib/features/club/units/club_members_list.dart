import 'package:flutter/material.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/user/user.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';

class ClubMembersList extends StatelessWidget {
  final double gap;
  final List<User> members;
  final Function(User)? onViewProfile;

  const ClubMembersList({this.gap = 0, this.members = const [], this.onViewProfile});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      itemCount: members.length,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: gap),
      itemBuilder: _friendItemCard,
    );
  }

  Widget _friendItemCard(BuildContext context, int index) {
    final item = members[index];
    final isLast = index == members.length - 1;
    return TweenListItem(
      index: index,
      child: Container(
        width: double.infinity,
        key: Key('player-$index'),
        padding: const EdgeInsets.symmetric(vertical: 14),
        margin: EdgeInsets.only(bottom: isLast ? 0 : 0),
        decoration: BoxDecoration(color: primary, border: isLast ? null : const Border(bottom: BorderSide(color: lightBlue))),
        child: Row(
          children: [
            CircleImage(
              radius: 14,
              image: item.media?.url,
              backgroundColor: lightBlue,
              placeholder: const FadingCircle(size: 14),
              errorWidget: SvgImage(image: Assets.svg1.coach, color: primary, height: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.text14_500.copyWith(color: lightBlue, height: 1),
              ),
            ),
            const SizedBox(width: 4),
            ElevateButton(
              radius: 04,
              height: 26,
              label: 'view_profile'.recast.toUpper,
              onTap: () => onViewProfile == null ? null : onViewProfile!(item),
              textStyle: TextStyles.text13_600.copyWith(color: lightBlue, height: 1.15),
            ),
          ],
        ),
      ),
    );
  }
}
