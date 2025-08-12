import 'package:flutter/material.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/features/friends/components/confirm_request_dialog.dart';
import 'package:app/models/friend/friend.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';

class FriendRequestList extends StatelessWidget {
  final double gap;
  final List<Friend> friends;
  final Function(Friend)? onItem;
  final Function(Friend, int)? onConfirm;
  final Function(Friend, int)? onReject;

  const FriendRequestList({this.gap = 0, this.friends = const [], this.onItem, this.onConfirm, this.onReject});

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
    var sender = myId == item.requestToUser?.id ? item.requestByUser : item.requestToUser;
    return InkWell(
      onTap: onItem == null ? null : onItem!(item),
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
                image: sender?.media?.url,
                backgroundColor: lightBlue,
                placeholder: const FadingCircle(size: 14),
                errorWidget: SvgImage(image: Assets.svg1.coach, color: primary, height: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  sender?.name ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.text14_500.copyWith(color: lightBlue, height: 1),
                ),
              ),
              const SizedBox(width: 4),
              InkWell(
                radius: 100,
                hoverColor: Colors.red,
                onTap: onConfirm == null ? null : () => _onConfirm(item, index),
                child: SvgImage(image: Assets.svg1.user_add, color: lightBlue, height: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onConfirm(Friend item, int index) => confirmRequestDialog(
        onReject: () => onReject!(item, index),
        onConfirm: () => onConfirm!(item, index),
      );
}
