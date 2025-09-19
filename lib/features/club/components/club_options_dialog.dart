import 'package:flutter/material.dart';

import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/system/data_model.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/library/svg_image.dart';

final _SETTINGS = DataModel(icon: Assets.svg1.repair, label: 'club_settings');
// final _MAINTENANCE = DataModel(icon: Assets.svg1.repair, label: 'club_maintenance');
final _SCHEDULE_EVENT = DataModel(icon: Assets.svg1.calendar_dots, label: 'schedule_event');

Future<void> clubOptionsDialog({Function()? onSchedule, Function()? onSettings}) async {
  final context = navigatorKey.currentState!.context;
  // sl<AppAnalytics>().screenView('club-options-popup');
  await showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Club Options Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().topToBottom,
    pageBuilder: (buildContext, anim1, anim2) => Align(child: _DialogView(onSchedule, onSettings)),
  );
}

class _DialogView extends StatelessWidget {
  final Function()? onSchedule;
  final Function()? onSettings;
  const _DialogView(this.onSchedule, this.onSettings);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.dialog_width,
      padding: EdgeInsets.symmetric(vertical: Dimensions.dialog_padding, horizontal: Dimensions.dialog_padding + 4),
      decoration: BoxDecoration(color: primary, borderRadius: DIALOG_RADIUS, boxShadow: const [SHADOW_2]),
      child: Material(color: transparent, child: _screenView(context), shape: DIALOG_SHAPE),
    );
  }

  Widget _screenView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 4),
        _OptionMenu(item: _SETTINGS, onTap: () => onSettings == null ? null : onSettings!()),
        // _OptionMenu(item: _SETTINGS, onTap: clubManagementDialog),
        const SizedBox(height: 14),
        const Divider(color: mediumBlue),
        const SizedBox(height: 14),
        _OptionMenu(item: _SCHEDULE_EVENT, onTap: () => onSchedule == null ? null : onSchedule!()),
        const SizedBox(height: 4),
      ],
    );
  }
}

class _OptionMenu extends StatelessWidget {
  final DataModel item;
  final Function()? onTap;

  const _OptionMenu({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onPressed,
      child: Row(
        children: [
          SvgImage(image: item.icon, height: 22, color: lightBlue),
          const SizedBox(width: 12),
          Expanded(child: Text(item.label.recast.toUpper, style: TextStyles.text16_600.copyWith(color: lightBlue, fontWeight: w500)))
        ],
      ),
    );
  }

  void _onPressed() {
    if (onTap == null) return;
    backToPrevious();
    onTap!();
  }
}
