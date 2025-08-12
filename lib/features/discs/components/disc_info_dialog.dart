import 'package:flutter/material.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/disc/user_disc.dart';
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
import 'package:app/widgets/ui/colored_disc.dart';

Future<void> discInfoDialog({
  required UserDisc disc,
  Function()? onSell,
  Function()? onDetails,
  Function()? onDelete,
}) async {
  var context = navigatorKey.currentState!.context;
  var padding = MediaQuery.of(context).viewInsets;
  var child = Align(child: _DialogView(disc, onSell, onDetails, onDelete));
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Disc Info Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().topToBottom,
    pageBuilder: (buildContext, anim1, anim2) => Padding(padding: padding, child: PopScopeNavigator(canPop: false, child: child)),
  );
}

class _DialogView extends StatefulWidget {
  final UserDisc disc;
  final Function()? onSell;
  final Function()? onDetails;
  final Function()? onDelete;

  const _DialogView(this.disc, this.onSell, this.onDetails, this.onDelete);

  @override
  State<_DialogView> createState() => _DialogViewState();
}

class _DialogViewState extends State<_DialogView> {
  @override
  void initState() {
    // sl<AppAnalytics>().screenView('disc-info-popup');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.dialog_width,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding, vertical: Dimensions.dialog_padding),
      decoration: BoxDecoration(color: primary, borderRadius: DIALOG_RADIUS, boxShadow: const [SHADOW_2]),
      child: Material(color: transparent, child: SingleChildScrollView(child: _screenView(context)), shape: DIALOG_SHAPE),
    );
  }

  Widget _screenView(BuildContext context) {
    var disc = widget.disc;
    var isDescription = widget.disc.description != null && widget.disc.parentDisc?.description != null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(disc.parentDisc?.name ?? 'n/a'.recast, style: TextStyles.text16_600.copyWith(color: lightBlue)),
            InkWell(onTap: backToPrevious, child: SvgImage(image: Assets.svg1.close_1, height: 18, color: lightBlue)),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          height: 66,
          width: double.infinity,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(border: Border.all(color: lightBlue), borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Expanded(child: _DicInfo(label: 'speed'.recast, value: disc.speed ?? 0)),
              Container(height: 66, width: 0.5, color: lightBlue),
              Expanded(child: _DicInfo(label: 'glide'.recast, value: disc.glide ?? 0)),
              Container(height: 66, width: 0.5, color: lightBlue),
              Expanded(child: _DicInfo(label: 'turn'.recast, value: disc.turn ?? 0)),
              Container(height: 66, width: 0.5, color: lightBlue),
              Expanded(child: _DicInfo(label: 'fade'.recast, value: disc.fade ?? 0)),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Center(
          child: Builder(builder: (context) {
            if (disc.media?.url != null) {
              return CircleImage(
                borderWidth: 0.4,
                radius: 31.width,
                image: disc.media?.url,
                backgroundColor: primary,
                placeholder: const FadingCircle(color: lightBlue),
                errorWidget: SvgImage(image: Assets.svg1.disc_3, height: 42.width, color: lightBlue),
              );
            } else if (disc.color != null) {
              return ColoredDisc(
                size: 60.width,
                iconSize: 24.width,
                discColor: disc.disc_color!,
                brandIcon: disc.parentDisc?.brand_media.url,
              );
            } else {
              return CircleImage(
                borderWidth: 0.4,
                radius: 31.width,
                image: disc.parentDisc?.media.url,
                backgroundColor: primary,
                placeholder: const FadingCircle(color: lightBlue),
                errorWidget: SvgImage(image: Assets.svg1.disc_3, height: 42.width, color: lightBlue),
              );
            }
          }),
        ),
        if (isDescription) const SizedBox(height: 20),
        if (isDescription) Center(child: Text('About this Disc', style: TextStyles.text16_600.copyWith(color: lightBlue))),
        if (isDescription) const SizedBox(height: 08),
        if (isDescription)
          Center(
            child: Text(
              disc.description ?? disc.parentDisc?.description ?? '',
              textAlign: TextAlign.center,
              style: TextStyles.text12_400.copyWith(color: lightBlue),
            ),
          ),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ElevateButton(
                radius: 04,
                height: 36,
                onTap: _onSell,
                background: skyBlue,
                label: 'sell_this_disc'.recast.toUpper,
                textStyle: TextStyles.text14_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevateButton(
                radius: 04,
                height: 36,
                padding: 16,
                onTap: _onDetails,
                label: 'edit_details'.recast.toUpper,
                textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Center(
          child: ElevateButton(
            radius: 04,
            height: 36,
            width: 40.width,
            onTap: _onDelete,
            background: skyBlue,
            label: 'delete'.recast.toUpper,
            textStyle: TextStyles.text14_700.copyWith(color: dark, fontWeight: w600, height: 1.15),
          ),
        ),
      ],
    );
  }

  void _onDelete() {
    if (widget.onDelete == null) return;
    widget.onDelete!();
    backToPrevious();
  }

  void _onDetails() {
    if (widget.onDetails == null) return;
    backToPrevious();
    widget.onDetails!();
  }

  void _onSell() {
    if (widget.onSell == null) return;
    backToPrevious();
    widget.onSell!();
  }
}

class _DicInfo extends StatelessWidget {
  final String label;
  final double value;

  const _DicInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    var style1 = TextStyles.text14_600.copyWith(color: lightBlue);
    var style2 = TextStyles.text16_700.copyWith(color: lightBlue);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 04),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(label, style: style1), const SizedBox(height: 01), Text(value.formatDouble, style: style2)],
      ),
    );
  }
}
