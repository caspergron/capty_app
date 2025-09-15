import 'package:app/extensions/flutter_ext.dart';
import 'package:app/features/notification/notifications_view_model.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BellMenu extends StatelessWidget {
  final Color color;
  const BellMenu({this.color = primary});

  @override
  Widget build(BuildContext context) {
    final notifications = Provider.of<NotificationsViewModel>(context).notifications;
    final totalUnread = notifications.isEmpty ? 0 : notifications.where((item) => item.is_read == false).toList().length;
    if (totalUnread < 1) return const SizedBox.shrink();
    final bellIcon = SvgImage(image: Assets.svg1.bell, color: color, height: 24);
    final dotMenu = Container(width: 8, height: 8, decoration: const BoxDecoration(color: orange, shape: BoxShape.circle));
    return InkWell(
      onTap: Routes.user.notification().push,
      child: Center(
        child: Stack(clipBehavior: Clip.none, children: [bellIcon, if (totalUnread > 0) Positioned(right: 1, top: 1, child: dotMenu)]),
      ),
    );
  }
}
