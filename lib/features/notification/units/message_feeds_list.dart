import 'package:flutter/material.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/formatters.dart';
import 'package:app/models/chat/chat_message.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';

class MessageFeedsList extends StatelessWidget {
  final List<ChatMessage> messageFeeds;
  final Function(ChatMessage, int)? onRead;

  const MessageFeedsList({this.messageFeeds = const [], this.onRead});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      itemCount: messageFeeds.length,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: _messageFeedsItemCard,
    );
  }

  Widget _messageFeedsItemCard(BuildContext context, int index) {
    final item = messageFeeds[index];
    final isUnread = item.is_read == false;
    return InkWell(
      onTap: () => onRead == null ? null : onRead!(item, index),
      child: TweenListItem(
        index: index,
        child: Container(
          width: double.infinity,
          key: Key('notification-$index'),
          padding: const EdgeInsets.only(top: 12, bottom: 16),
          decoration: BoxDecoration(border: index == messageFeeds.length - 1 ? null : const Border(bottom: BorderSide(color: offWhite1))),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleImage(
                    borderWidth: 1,
                    borderColor: lightBlue,
                    image: item.endUser?.media?.url,
                    placeholder: const FadingCircle(size: 22),
                    errorWidget: SvgImage(image: Assets.svg1.coach, height: 24, color: primary),
                  ),
                  if (item.is_online) const Positioned(bottom: 0, right: 0, child: CircleAvatar(radius: 5, backgroundColor: success)),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.endUser?.name ?? 'n/a'.recast,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style: TextStyles.text14_700.copyWith(color: isUnread ? dark : primary),
                          ),
                        ),
                        const SizedBox(width: 08),
                        Text(
                          // Formatters.formatDate(DATE_FORMAT_10, item.sendTime),
                          Formatters.formatTime(item.sendTime),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.text12_400.copyWith(color: isUnread ? dark : primary),
                        ),
                        if (isUnread) const SizedBox(width: 04),
                        if (isUnread)
                          const Padding(padding: EdgeInsets.only(top: 02), child: CircleAvatar(radius: 5, backgroundColor: orange)),
                      ],
                    ),
                    const SizedBox(height: 0.5),
                    Text(
                      item.message ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.text13_600.copyWith(color: isUnread ? dark : primary, fontWeight: isUnread ? w600 : w400),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
