import 'package:flutter/material.dart';

import 'package:app/constants/date_formats.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/formatters.dart';
import 'package:app/models/club/club_comment.dart';
import 'package:app/models/user/user.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/svg_image.dart';

class CommentsList extends StatelessWidget {
  final User sender;
  final List<ClubComment> messages;
  final ScrollPhysics physics;

  const CommentsList({required this.sender, this.messages = const [], this.physics = const NeverScrollableScrollPhysics()});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      itemCount: messages.length,
      itemBuilder: _messageItemCard,
      physics: physics,
    );
  }

  bool _isSameUser(int? userId1, int? userId2) => userId1 == null || userId2 == null ? true : userId1 == userId2;

  bool _isShowTime(int index) {
    final message = messages[index];
    if (message.createdAt == null) return false;
    if (index == messages.length - 1) return true;
    return !_isSameUser(message.userId, messages[index + 1].userId);
  }

  Widget _messageItemCard(BuildContext context, int index) {
    final item = messages[index];
    final isMe = item.userId == sender.id;
    final isShowTime = _isShowTime(index);
    // final isSameBot = index == 0 ? true : _isSameUser(item.userId, messages[index - 1].userId);
    return Container(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      margin: EdgeInsets.only(bottom: index == messages.length - 1 ? 20 : (!isShowTime ? 6 : 16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isMe /*&& !isSameBot*/) _clubMemberInfo(item.user ?? User()),
          if (!isMe /*&& !isSameBot*/) const SizedBox(height: 04),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: _boxDecoration(index, isMe),
            constraints: BoxConstraints(minWidth: 20, maxWidth: 68.width),
            child: _chatMessage(item.comment, isMe),
          ),
          if (isMe) _chatStatus(item, index),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration(int index, bool isMe) {
    const radius = Radius.circular(10);
    final isNextSame = index != messages.length - 1 && _isSameUser(messages[index].id, messages[index + 1].id);
    final left = isMe || (!isMe && isNextSame) ? radius : Radius.zero;
    final right = !isMe || (isMe && isNextSame) ? radius : Radius.zero;
    final borderRadius = BorderRadius.only(topLeft: radius, topRight: radius, bottomLeft: left, bottomRight: right);
    return BoxDecoration(color: isMe ? primary : offWhite2, borderRadius: borderRadius);
  }

  Widget _clubMemberInfo(User item) {
    final icon = SvgImage(image: Assets.svg1.coach, height: 16, color: lightBlue);
    final style = TextStyles.text12_600.copyWith(color: lightBlue, height: 1.1);
    final day = Formatters.formatDate(DATE_FORMAT_1, '$currentDate');
    final time = Formatters.formatDate(TIME_FORMAT_1, '$currentDate');
    return Row(children: [icon, const SizedBox(width: 04), Text('Casper  $day, $time', style: style)]);
  }

  Widget _chatStatus(ClubComment item, int index) {
    final style = TextStyles.text10_400.copyWith(color: lightBlue, fontWeight: w400);
    if (item.createdAt == null) return Text('${'sending'.recast}...', style: style);
    if (!_isShowTime(index)) return const SizedBox.shrink();
    return Padding(padding: const EdgeInsets.only(top: 02), child: Text(Formatters.formatTime('${item.createdAt}'), style: style));
  }

  Widget _chatMessage(String? message, bool isMe) {
    if (message.toKey.isEmpty) return const SizedBox.shrink();
    final style = TextStyles.text14_400.copyWith(color: isMe ? white : grey);
    return Text(message ?? '', textAlign: TextAlign.left, style: style);
  }
}
