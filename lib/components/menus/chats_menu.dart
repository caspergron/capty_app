import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/features/notification/notifications_view_model.dart';
import 'package:app/preferences/user_preferences.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatsMenu extends StatelessWidget {
  final Color color;
  const ChatsMenu({this.color = primary});

  @override
  Widget build(BuildContext context) {
    var userId = UserPreferences.user.id.nullToInt;
    var notifications = Provider.of<NotificationsViewModel>(context).notifications;
    var messages = Provider.of<NotificationsViewModel>(context).messageFeeds;
    var totalUnreadN = notifications.isEmpty ? 0 : notifications.where((item) => item.is_read == false).toList().length;
    var totalUnreadM =
        messages.isEmpty ? 0 : messages.where((item) => (item.senderId != userId) && (item.readTime == null)).toList().length;
    var isUnred = (totalUnreadN + totalUnreadM) > 0;
    var decoration = const BoxDecoration(color: orange, shape: BoxShape.circle);
    return InkWell(
      onTap: Routes.user.notification().push,
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SvgImage(image: Assets.svg1.chats, color: color, height: 24),
            if (isUnred) Positioned(right: 1, top: 0, child: Container(width: 8, height: 8, decoration: decoration)),
          ],
        ),
      ),
    );
  }
}
