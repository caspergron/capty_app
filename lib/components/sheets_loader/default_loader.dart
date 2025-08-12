import 'dart:async';

import 'package:flutter/material.dart';

import 'package:app/constants/app_keys.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/svg_image.dart';

Future<void> defaultLoaderSheet({String label = ''}) async {
  var context = navigatorKey.currentState!.context;
  await showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: false,
    isScrollControlled: true,
    shape: BOTTOM_SHEET_SHAPE,
    clipBehavior: Clip.antiAlias,
    builder: (builder) => Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: PopScopeNavigator(canPop: false, child: _BottomSheetView(label)),
    ),
  );
}

class _BottomSheetView extends StatelessWidget {
  final String label;
  const _BottomSheetView(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.width,
      height: SizeConfig.height,
      decoration: BoxDecoration(color: orange, borderRadius: SHEET_RADIUS),
      child: _screenView,
    );
  }

  Widget get _screenView {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Center(
              child: Container(
                width: 40.width,
                height: 40.width,
                margin: EdgeInsets.only(bottom: 5.height),
                child: CircularProgressIndicator(color: white, backgroundColor: white.colorOpacity(0.3), strokeWidth: 5),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 8.width,
              child: Center(child: SvgImage(image: Assets.app.capty, height: 20.width, color: white)),
            ),
          ],
        ),
        Text(label.recast, textAlign: TextAlign.center, style: TextStyles.text24_600.copyWith(color: white, fontWeight: w500)),
      ],
    );
  }
}
