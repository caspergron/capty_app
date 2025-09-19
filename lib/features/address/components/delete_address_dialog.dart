import 'package:flutter/material.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';

Future<void> deleteAddressDialog({Function()? onDelete}) async {
  final context = navigatorKey.currentState!.context;
  final child = Align(child: _DialogView(onDelete));
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Delete Address Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().topToBottom,
    pageBuilder: (buildContext, anim1, anim2) => PopScopeNavigator(canPop: false, child: child),
  );
}

class _DialogView extends StatelessWidget {
  final Function()? onDelete;

  const _DialogView(this.onDelete);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.dialog_width,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding, vertical: Dimensions.dialog_padding),
      decoration: BoxDecoration(color: primary, borderRadius: DIALOG_RADIUS),
      child: Material(color: transparent, child: _screenView(context), shape: DIALOG_SHAPE),
    );
  }

  Widget _screenView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 04),
        Text('delete_address'.recast, style: TextStyles.text18_600.copyWith(color: white)),
        const SizedBox(height: 26),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.width),
          child: Text(
            'are_you_sure_you_want_to_delete_this_address'.recast,
            textAlign: TextAlign.center,
            style: TextStyles.text14_400.copyWith(color: offWhite3, fontSize: 15),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ElevateButton(
                radius: 04,
                height: 38,
                onTap: backToPrevious,
                background: skyBlue,
                label: 'no_wait'.recast.toUpper,
                textStyle: TextStyles.text14_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
              ),
            ),
            const SizedBox(width: 08),
            Expanded(
              child: ElevateButton(
                radius: 04,
                height: 38,
                onTap: _onDelete,
                label: 'yes_delete'.recast.toUpper,
                textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
              ),
            ),
          ],
        ),
        const SizedBox(height: 04),
      ],
    );
  }

  void _onDelete() {
    if (onDelete != null) onDelete!();
    backToPrevious();
  }
}
