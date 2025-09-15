import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/features/buddies/buddies_view_model.dart';
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
    final userId = UserPreferences.user.id.nullToInt;
    final list = Provider.of<BuddiesViewModel>(context).messageFeeds;
    final totalUnread = list.isEmpty ? 0 : list.where((item) => (item.senderId != userId) && (item.readTime == null)).toList().length;
    final chatsIcon = SvgImage(image: Assets.svg1.chats, color: color, height: 24);
    final dotMenu = Container(width: 8, height: 8, decoration: const BoxDecoration(color: orange, shape: BoxShape.circle));
    return InkWell(
      onTap: Routes.user.buddies().push,
      child: Center(
        child: Stack(clipBehavior: Clip.none, children: [chatsIcon, if (totalUnread > 0) Positioned(right: 1, top: 0, child: dotMenu)]),
      ),
    );
  }
}
