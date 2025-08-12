import 'package:flutter/material.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/features/friends/components/delete_friend_dialog.dart';
import 'package:app/models/friend/friend.dart';
import 'package:app/models/friend/friend_info.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';

class FriendsList extends StatelessWidget {
  final double gap;
  final List<Friend> friends;
  final Function(FriendInfo)? onItem;
  final Function(Friend, int)? onDelete;

  const FriendsList({this.gap = 0, this.friends = const [], this.onItem, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      itemCount: friends.length,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: gap),
      itemBuilder: _friendItemCard,
    );
  }

  Widget _friendItemCard(BuildContext context, int index) {
    var item = friends[index];
    var myId = UserPreferences.user.id;
    var friend = myId == item.requestToUser?.id ? item.requestByUser : item.requestToUser;
    return InkWell(
      onTap: () => onItem == null ? null : onItem!(friend!),
      child: TweenListItem(
        index: index,
        child: Container(
          width: double.infinity,
          key: Key('player-$index'),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          margin: EdgeInsets.only(bottom: index == friends.length - 1 ? 0 : 08),
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              CircleImage(
                radius: 14,
                image: friend?.media?.url,
                backgroundColor: lightBlue,
                placeholder: const FadingCircle(size: 14),
                errorWidget: SvgImage(image: Assets.svg1.coach, color: primary, height: 18),
              ),
              /*ImageNetwork(
                width: 28,
                radius: 06,
                height: 28,
                background: skyBlue,
                placeholder: const FadingCircle(size: 20),
                errorWidget: SvgImage(image: Assets.svg1.coach, color: primary, height: 24),
              ),*/
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  friend?.name ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.text14_500.copyWith(color: lightBlue, height: 1),
                ),
              ),
              const SizedBox(width: 4),
              InkWell(
                radius: 100,
                hoverColor: Colors.red,
                onTap: onDelete == null ? null : () => deleteFriendDialog(onDelete: () => onDelete!(item, index)),
                child: SvgImage(image: Assets.svg1.trash, color: lightBlue, height: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
