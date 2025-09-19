import 'package:flutter/material.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/club/club.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/svg_image.dart';

Future<void> clubTagInfoDialog({List<Club> clubs = const [], Function()? onPositive}) async {
  final context = navigatorKey.currentState!.context;
  final padding = MediaQuery.of(context).viewInsets;
  final child = Align(child: _DialogView(clubs, onPositive));
  // sl<AppAnalytics>().screenView('club-member-info-popup');
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Club Tag Info Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().bottomToTop,
    pageBuilder: (buildContext, anim1, anim2) => Padding(padding: padding, child: PopScopeNavigator(canPop: false, child: child)),
  );
}

class _DialogView extends StatelessWidget {
  final List<Club> clubs;
  final Function()? onPositive;
  const _DialogView(this.clubs, this.onPositive);

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
        Align(
          alignment: Alignment.topRight,
          child: InkWell(onTap: backToPrevious, child: SvgImage(image: Assets.svg1.close_1, height: 18, color: lightBlue)),
        ),
        Center(
          child: Text(
            'sales_add_from_club_members'.recast,
            textAlign: TextAlign.center,
            style: TextStyles.text20_500.copyWith(color: lightBlue, fontWeight: w600),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'here_we_will_show_you_the_sales_ad_from_the_members_of_your_default_club'.recast,
          textAlign: TextAlign.start,
          style: TextStyles.text16_400.copyWith(color: white),
        ),
        const SizedBox(height: 20),
        Text(
          'your_clubs'.recast,
          textAlign: TextAlign.start,
          style: TextStyles.text16_400.copyWith(color: white, fontWeight: w600),
        ),
        const SizedBox(height: 06),
        ListView.builder(
          shrinkWrap: true,
          clipBehavior: Clip.antiAlias,
          itemCount: clubs.length,
          padding: const EdgeInsets.only(left: 12),
          itemBuilder: _soldInfoItemCard,
        ),
        const SizedBox(height: 30),
        ElevateButton(
          radius: 04,
          height: 36,
          onTap: _onPositive,
          width: double.infinity,
          label: 'view_sales_ads'.recast.toUpper,
          textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
        ),
      ],
    );
  }

  void _onPositive() {
    if (onPositive != null) onPositive!();
    backToPrevious();
  }

  Widget _soldInfoItemCard(BuildContext context, int index) {
    final item = clubs[index];
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(bottom: index == clubs.length - 1 ? 0 : 06),
      child: Row(
        children: [
          const Padding(padding: EdgeInsets.only(top: 03), child: Icon(Icons.circle, color: lightBlue, size: 10)),
          const SizedBox(width: 06),
          Expanded(
            child: Text(
              item.name ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.text14_400.copyWith(color: lightBlue, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
