import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/constants/data_constants.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/features/discs/units/disc_speciality_list.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/services/routes.dart';
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
import 'package:flutter/material.dart';

Future<void> publicSalesAdInfoDialog({required SalesAd disc}) async {
  var context = navigatorKey.currentState!.context;
  var padding = MediaQuery.of(context).viewInsets;
  var child = Align(child: _DialogView(disc));
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Public Sales Ad Info Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().topToBottom,
    pageBuilder: (buildContext, anim1, anim2) => Padding(padding: padding, child: PopScopeNavigator(canPop: false, child: child)),
  );
}

class _DialogView extends StatefulWidget {
  final SalesAd disc;
  const _DialogView(this.disc);

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
      padding: EdgeInsets.symmetric(vertical: Dimensions.dialog_padding),
      decoration: BoxDecoration(color: primary, borderRadius: DIALOG_RADIUS, boxShadow: const [SHADOW_2]),
      child: Material(color: transparent, child: SingleChildScrollView(child: _screenView(context)), shape: DIALOG_SHAPE),
    );
  }

  Widget _screenView(BuildContext context) {
    var userDisc = widget.disc.userDisc;
    var parentDisc = userDisc?.parentDisc;
    var isDescription = widget.disc.notes.toKey.isNotEmpty;
    var specialities = widget.disc.specialityDiscs ?? [];
    var weight = userDisc?.weight == null ? 'n/a'.recast : '${userDisc?.weight.formatDouble} ${'gram'.recast}';
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Spacer(),
            InkWell(onTap: backToPrevious, child: SvgImage(image: Assets.svg1.close_1, height: 18, color: lightBlue)),
            SizedBox(width: Dimensions.dialog_padding),
          ],
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: Builder(builder: (context) {
                if (userDisc?.media?.url != null) {
                  return CircleImage(
                    borderWidth: 0.4,
                    radius: 22.width,
                    image: userDisc?.media?.url,
                    backgroundColor: primary,
                    placeholder: const FadingCircle(color: lightBlue),
                    errorWidget: SvgImage(image: Assets.svg1.disc_3, height: 42.width, color: lightBlue),
                  );
                } else if (userDisc?.color != null) {
                  return ColoredDisc(
                    size: 60.width,
                    iconSize: 24.width,
                    discColor: userDisc!.disc_color!,
                    brandIcon: parentDisc?.brand_media.url,
                  );
                } else {
                  return CircleImage(
                    borderWidth: 0.4,
                    radius: 31.width,
                    image: parentDisc?.media.url,
                    backgroundColor: primary,
                    placeholder: const FadingCircle(color: lightBlue),
                    errorWidget: SvgImage(image: Assets.svg1.disc_3, height: 42.width, color: lightBlue),
                  );
                }
              }),
            ),
            Positioned(left: 0, right: 0, bottom: -20, child: Center(child: _discInfo))
          ],
        ),
        const SizedBox(height: 40),
        const Divider(color: mediumBlue),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          margin: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding),
          decoration: BoxDecoration(border: Border.all(color: lightBlue), borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgImage(image: Assets.svg1.review, height: 24, color: lightBlue),
                  const SizedBox(width: 06),
                  Text('specialty'.recast, style: TextStyles.text14_600.copyWith(color: lightBlue, height: 1)),
                ],
              ),
              const SizedBox(height: 12),
              specialities.isNotEmpty
                  ? DiscSpecialityList(specialities: specialities)
                  : Text('no_speciality_available'.recast, style: TextStyles.text14_600.copyWith(color: lightBlue, height: 1)),
              const SizedBox(height: 04),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            SizedBox(width: Dimensions.dialog_padding),
            Expanded(flex: 10, child: _DiscInfo(icon: Assets.svg1.weight_scale, label: 'disc_weight'.recast, value: weight)),
            const SizedBox(width: 12),
            Expanded(
                flex: 10, child: _DiscInfo(icon: Assets.svg1.target, label: 'disc_type'.recast, value: parentDisc?.type ?? 'n/a'.recast)),
            SizedBox(width: Dimensions.dialog_padding),
          ],
        ),
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding),
          child: _DiscInfo(
            icon: Assets.svg1.disc_2,
            label: '${'disc_condition'.recast}: ${widget.disc.condition_number}',
            value: widget.disc.condition_value == null ? 'n/a'.recast : USED_DISC_INFO[widget.disc.condition_value!].recast,
          ),
        ),
        if (isDescription) ...[
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding),
            child: Text('about_this_disc'.recast, style: TextStyles.text16_600.copyWith(color: lightBlue)),
          ),
          const SizedBox(height: 08),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.dialog_padding),
            child: Text(widget.disc.notes ?? '',
                maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyles.text12_400.copyWith(color: lightBlue)),
          ),
        ],
        const SizedBox(height: 28),
        const SizedBox(height: 14),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.screen_padding),
          child: ElevateButton(
            radius: 04,
            height: 40,
            width: double.infinity,
            onTap: _onCreateAccount,
            label: 'create_account'.recast.toUpper,
          ),
        ),
      ],
    );
  }

  Widget get _discInfo {
    var name = widget.disc.userDisc?.parentDisc?.name ?? '';
    var price = '${widget.disc.price.formatDouble} ${widget.disc.currency_code}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 04),
      decoration: BoxDecoration(color: skyBlue, border: Border.all(color: primary), borderRadius: BorderRadius.circular(06)),
      child: Column(
        children: [
          Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyles.text14_700.copyWith(color: dark, fontWeight: w700)),
          Text(price, style: TextStyles.text16_700.copyWith(color: orange, fontWeight: w700)),
        ],
      ),
    );
  }

  void _onCreateAccount() {
    backToPrevious();
    Routes.auth.sign_in().push();
  }
}

class _DiscInfo extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  const _DiscInfo({this.icon = '', this.label = '', this.value = ''});

  @override
  Widget build(BuildContext context) {
    var style = TextStyles.text13_600.copyWith(color: lightBlue, fontWeight: w300);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgImage(image: icon, height: 34, color: lightBlue),
        const SizedBox(width: 06),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyles.text14_500.copyWith(color: lightBlue)),
              Text(value, maxLines: 2, overflow: TextOverflow.ellipsis, style: style),
            ],
          ),
        )
      ],
    );
  }
}
