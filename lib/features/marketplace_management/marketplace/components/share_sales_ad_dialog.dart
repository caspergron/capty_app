import 'package:flutter/material.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/app_clipboard.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/svg_image.dart';

Future<void> shareSalesAdDialog({required String url}) async {
  final context = navigatorKey.currentState!.context;
  final padding = MediaQuery.of(context).viewInsets;
  final child = Align(child: _DialogView(url));
  // sl<AppAnalytics>().screenView('share-sales-ad-popup');
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Sales Ad Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().topToBottom,
    pageBuilder: (buildContext, anim1, anim2) => Padding(padding: padding, child: PopScopeNavigator(canPop: false, child: child)),
  );
}

class _DialogView extends StatelessWidget {
  final String url;
  const _DialogView(this.url);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.dialog_width,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding, vertical: Dimensions.dialog_padding),
      decoration: BoxDecoration(color: primary, borderRadius: DIALOG_RADIUS, boxShadow: const [SHADOW_2]),
      child: Material(color: transparent, child: _screenView(context), shape: DIALOG_SHAPE),
    );
  }

  Widget _screenView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text('share_your_sales_ad_page'.recast, style: TextStyles.text20_500.copyWith(color: white, fontWeight: w700))),
            const SizedBox(width: 04),
            InkWell(onTap: backToPrevious, child: SvgImage(image: Assets.svg1.close_1, color: white, height: 20))
          ],
        ),
        const SizedBox(height: 24),
        Text('share_sales_ad_desc'.recast, style: TextStyles.text14_400.copyWith(color: white)),
        const SizedBox(height: 24),
        Center(child: Text(url, style: TextStyles.text20_500.copyWith(color: white, fontWeight: w400))),
        const SizedBox(height: 28),
        Center(
          child: ElevateButton(
            radius: 04,
            height: 36,
            padding: 20,
            background: skyBlue,
            width: double.infinity,
            onTap: () => sl<AppClipboard>().copy(url),
            label: 'copy_this_link_to_share'.recast.toUpper,
            textStyle: TextStyles.text14_700.copyWith(color: dark, fontWeight: w600, fontSize: 13.5, height: 1.15),
          ),
        ),
      ],
    );
  }
}
