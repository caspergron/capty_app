import 'package:flutter/material.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';

Future<void> zoomImageDialog({required SalesAd salesAd}) async {
  var context = navigatorKey.currentState!.context;
  // sl<AppAnalytics>().screenView('zoom-image-popup');
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Zoom Image Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().topToBottom,
    pageBuilder: (buildContext, anim1, anim2) => PopScopeNavigator(canPop: false, child: Align(child: _DialogView(salesAd))),
  );
}

class _DialogView extends StatelessWidget {
  final SalesAd salesAd;
  const _DialogView(this.salesAd);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.dialog_width,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding, vertical: Dimensions.dialog_padding),
      decoration: BoxDecoration(color: primary, borderRadius: DIALOG_RADIUS, boxShadow: const [SHADOW_2]),
      child: Material(color: transparent, shape: DIALOG_SHAPE, child: _screenView(context)),
    );
  }

  Widget _screenView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(child: Text('view_image'.recast, style: TextStyles.text16_600.copyWith(color: lightBlue))),
            const SizedBox(width: 08),
            InkWell(onTap: backToPrevious, child: SvgImage(image: Assets.svg1.close_1, color: lightBlue, height: 17)),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 6.width),
          decoration: BoxDecoration(color: white.colorOpacity(0.3), borderRadius: BorderRadius.circular(12)),
          child: InteractiveViewer(
            minScale: 1,
            maxScale: 3,
            alignment: Alignment.center,
            boundaryMargin: const EdgeInsets.all(double.infinity),
            child: _marketplaceDiscImage,
          ),
        ),
        const SizedBox(height: 32),
        ElevateButton(
          radius: 04,
          height: 38,
          width: double.infinity,
          label: 'close'.recast.toUpper,
          onTap: backToPrevious,
          textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
        ),
        const SizedBox(height: 01),
      ],
    );
  }

  Widget get _marketplaceDiscImage {
    var userDisc = salesAd.userDisc;
    return CircleImage(
      borderWidth: 0.4,
      radius: 38.width,
      image: userDisc?.media?.url,
      backgroundColor: primary,
      placeholder: const FadingCircle(color: lightBlue),
      errorWidget: SvgImage(image: Assets.svg1.disc_3, height: 42.width, color: lightBlue),
    );
  }
}
