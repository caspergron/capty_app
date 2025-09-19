import 'package:flutter/material.dart';

import 'package:app/components/loaders/animation_box.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/lottie_animation.dart';

Future<void> allSetLoaderSheet({required String desc}) async {
  final context = navigatorKey.currentState!.context;
  await showModalBottomSheet(
    context: context,
    enableDrag: false,
    showDragHandle: false,
    isDismissible: false,
    isScrollControlled: true,
    clipBehavior: Clip.antiAlias,
    builder: (builder) => PopScopeNavigator(canPop: false, child: _BottomSheetView(desc)),
  );
}

class _BottomSheetView extends StatelessWidget {
  final String desc;
  const _BottomSheetView(this.desc);

  @override
  Widget build(BuildContext context) {
    return Container(width: SizeConfig.width, height: SizeConfig.height, color: orange, child: _screenView(context));
  }

  Widget _screenView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimationBox(animation: LottieAnimation(animPath: Assets.anim.rocket, height: 37.width)),
        const SizedBox(height: 28),
        Text('you_are_all_set'.recast, style: TextStyles.text20_500.copyWith(color: white)),
        const SizedBox(height: 06),
        Text(desc.recast, style: TextStyles.text14_400.copyWith(color: white)),
        SizedBox(height: 28.height),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.width),
          child: const LinearProgressIndicator(backgroundColor: lightBlue, color: primary, minHeight: 04),
        ),
        const SizedBox(height: 52),
      ],
    );
  }
}
