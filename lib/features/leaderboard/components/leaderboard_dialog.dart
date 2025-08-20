import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:flutter/material.dart';

Future<void> leaderboardDialog() async {
  var context = navigatorKey.currentState!.context;
  // sl<AppAnalytics>().screenView('leaderboard-popup');
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Leaderboard Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().topToBottom,
    pageBuilder: (buildContext, anim1, anim2) => PopScopeNavigator(canPop: false, child: Align(child: _DialogView())),
  );
}

class _DialogView extends StatelessWidget {
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
            Expanded(child: Text('leaderboards'.recast, style: TextStyles.text20_500.copyWith(color: lightBlue, height: 1))),
            const SizedBox(width: 08),
            InkWell(onTap: backToPrevious, child: SvgImage(image: Assets.svg1.close_1, height: 20, color: lightBlue)),
          ],
        ),
        const SizedBox(height: 24),
        Text('pdga_rating'.recast, style: TextStyles.text14_700.copyWith(color: lightBlue)),
        const SizedBox(height: 02),
        Text('pdga_rating_desc'.recast, style: TextStyles.text14_400.copyWith(color: lightBlue)),
        const SizedBox(height: 20),
        Text('best_pdga_improvement'.recast, style: TextStyles.text14_700.copyWith(color: lightBlue)),
        const SizedBox(height: 02),
        Text('best_pdga_improvement_desc'.recast, style: TextStyles.text14_400.copyWith(color: lightBlue)),
        const SizedBox(height: 08),
        /*Text('Current bagtags', style: TextStyles.text14_700.copyWith(color: lightBlue)),
        const SizedBox(height: 02),
        Text(
          'Lorem ipsum dolor sit amet consectetur. Etiam fermentum interdum tincidunt ipsum.',
          style: TextStyles.text14_400.copyWith(color: lightBlue),
        ),
        const SizedBox(height: 20),
        Text('Best circle 1 putting', style: TextStyles.text14_700.copyWith(color: lightBlue)),
        const SizedBox(height: 02),
        Text(
          'Lorem ipsum dolor sit amet consectetur. Etiam fermentum interdum tincidunt ipsum.',
          style: TextStyles.text14_400.copyWith(color: lightBlue),
        ),
        const SizedBox(height: 20),
        Text('Most played rounds', style: TextStyles.text14_700.copyWith(color: lightBlue)),
        const SizedBox(height: 02),
        Text(
          'Lorem ipsum dolor sit amet consectetur. Etiam fermentum interdum tincidunt ipsum.',
          style: TextStyles.text14_400.copyWith(color: lightBlue),
        ),
        const SizedBox(height: 08),*/
      ],
    );
  }
}
