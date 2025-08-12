import 'package:flutter/material.dart';

import 'package:app/animations/tween_list_item.dart';
import 'package:app/libraries/formatters.dart';
import 'package:app/models/user/notification.dart' as notify;
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/widgets/library/svg_image.dart';

class NotificationList extends StatelessWidget {
  final List<notify.Notification> notifications;
  final Function(notify.Notification)? onRead;

  const NotificationList({this.notifications = const [], this.onRead});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      clipBehavior: Clip.antiAlias,
      itemCount: notifications.length,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: _notificationItemCard,
    );
  }

  Widget _notificationItemCard(BuildContext context, int index) {
    var item = notifications[index];
    var borderSide = const BorderSide(color: mediumBlue);
    return InkWell(
      onTap: () => onRead == null ? null : onRead!(item),
      child: TweenListItem(
        index: index,
        child: Container(
          width: double.infinity,
          key: Key('notification-$index'),
          padding: EdgeInsets.only(top: index == 0 ? 0 : 10, bottom: 10),
          decoration: BoxDecoration(border: index == notifications.length - 1 ? null : Border(bottom: borderSide)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: mediumBlue, borderRadius: BorderRadius.circular(7)),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SvgImage(height: 30, color: primary, image: item.type_based_notify_icon),
                    if (!item.is_read) const Positioned(right: 0, top: 0, child: CircleAvatar(radius: 5, backgroundColor: orange)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            item.title ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.text14_700.copyWith(color: primary, height: 1.2),
                          ),
                        ),
                        if (item.sentAt != null) const SizedBox(width: 08),
                        if (item.sentAt != null) Container(height: 12, width: 1, color: mediumBlue),
                        if (item.sentAt != null) const SizedBox(width: 08),
                        if (item.sentAt != null)
                          Text(Formatters.formatTime(item.sentAt), style: TextStyles.text10_400.copyWith(color: primary)),
                      ],
                    ),
                    const SizedBox(height: 02),
                    Text(
                      item.message ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.text13_600.copyWith(color: primary, height: 1.2, fontWeight: w400),
                    )
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
