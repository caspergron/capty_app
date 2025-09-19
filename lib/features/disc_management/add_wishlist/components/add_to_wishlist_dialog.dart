import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/dialogs/description_dialog.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/disc/wishlist.dart';
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

Future<void> addToWishlistDialog({
  required Wishlist wishlist,
  bool isEdit = false,
  bool added = false,
  Function()? onEdit,
  Function()? onAdd,
  Function()? onRemove,
}) async {
  final context = navigatorKey.currentState!.context;
  final padding = MediaQuery.of(context).viewInsets;
  final child = Align(child: _DialogView(wishlist, added, isEdit, onEdit, onAdd, onRemove));
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Add To Wishlist Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().topToBottom,
    pageBuilder: (buildContext, anim1, anim2) => Padding(padding: padding, child: PopScopeNavigator(canPop: false, child: child)),
  );
}

class _DialogView extends StatelessWidget {
  final Wishlist wishlist;
  final bool added;
  final bool isEdit;
  final Function()? onEdit;
  final Function()? onAdd;
  final Function()? onRemove;

  const _DialogView(this.wishlist, this.added, this.isEdit, this.onEdit, this.onAdd, this.onRemove);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.dialog_width,
      padding: EdgeInsets.symmetric(vertical: Dimensions.dialog_padding, horizontal: Dimensions.dialog_padding),
      decoration: BoxDecoration(color: primary, borderRadius: DIALOG_RADIUS, boxShadow: const [SHADOW_2]),
      child: Material(color: transparent, shape: DIALOG_SHAPE, child: _screenView(context)),
    );
  }

  Widget _screenView(BuildContext context) {
    final disc = wishlist.disc;
    final userDisc = wishlist.userDisc;
    final parentDisc = wishlist.disc;
    final isDescription = userDisc?.description != null || disc?.description != null;
    final description = userDisc?.description ?? disc?.description ?? '';
    final isLongDescription = description.length > 450;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(disc?.name ?? 'n/a'.recast, style: TextStyles.text16_600.copyWith(color: lightBlue)),
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
              Expanded(child: _DicInfo(label: 'speed'.recast, value: userDisc?.speed ?? disc?.speed ?? 0)),
              Container(height: 66, width: 0.5, color: lightBlue),
              Expanded(child: _DicInfo(label: 'glide'.recast, value: userDisc?.glide ?? disc?.glide ?? 0)),
              Container(height: 66, width: 0.5, color: lightBlue),
              Expanded(child: _DicInfo(label: 'turn'.recast, value: userDisc?.turn ?? disc?.turn ?? 0)),
              Container(height: 66, width: 0.5, color: lightBlue),
              Expanded(child: _DicInfo(label: 'fade'.recast, value: userDisc?.fade ?? disc?.fade ?? 0)),
            ],
          ),
        ),
        const SizedBox(height: 40),
        Center(
          child: Builder(builder: (context) {
            if (userDisc?.media?.url != null) {
              return CircleImage(
                radius: 25.width,
                borderWidth: 0.4,
                backgroundColor: primary,
                borderColor: lightBlue,
                placeholder: const FadingCircle(size: 56, color: lightBlue),
                errorWidget: SvgImage(image: Assets.svg1.disc_3, height: 30.width, color: lightBlue),
                image: userDisc?.media?.url,
              );
            } else if (userDisc?.color != null) {
              return ColoredDisc(
                size: 50.width,
                iconSize: 10.width,
                discColor: userDisc!.disc_color!,
                brandIcon: parentDisc?.brand_media.url,
              );
            } else {
              return CircleImage(
                radius: 25.width,
                borderWidth: 0.4,
                backgroundColor: primary,
                borderColor: lightBlue,
                placeholder: const FadingCircle(size: 56, color: lightBlue),
                errorWidget: SvgImage(image: Assets.svg1.disc_3, height: 30.width, color: lightBlue),
                image: parentDisc?.media.url,
              );
            }
          }),
        ),
        if (isDescription) ...[
          const SizedBox(height: 28),
          Center(child: Text('about_the_disc'.recast, style: TextStyles.text16_600.copyWith(color: lightBlue))),
          const SizedBox(height: 08),
          Center(
            child: Text.rich(
              TextSpan(
                text: isLongDescription ? '${description.substring(0, 450)}...' : description,
                style: TextStyles.text12_400.copyWith(color: lightBlue),
                children: [if (isLongDescription) _readMoreTextButton(description)],
              ),
              textAlign: TextAlign.center,
              style: TextStyles.text12_400.copyWith(color: lightBlue),
            ),
          ),
        ],
        const SizedBox(height: 24),
        added
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 15,
                    child: ElevateButton(
                      radius: 04,
                      height: 38,
                      background: skyBlue,
                      onTap: _onRemoveFromWishlist,
                      label: 'remove_from_wishlist'.recast.toUpper,
                      textStyle: TextStyles.text14_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
                    ),
                  ),
                  if (onEdit != null && isEdit) const SizedBox(width: 08),
                  if (onEdit != null && isEdit)
                    Expanded(
                      flex: 11,
                      child: ElevateButton(
                        radius: 04,
                        height: 38,
                        onTap: _onEditDetails,
                        label: 'edit_details'.recast.toUpper,
                        textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
                      ),
                    ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevateButton(
                      radius: 04,
                      height: 38,
                      background: skyBlue,
                      onTap: backToPrevious,
                      label: 'cancel'.recast.toUpper,
                      textStyle: TextStyles.text14_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
                    ),
                  ),
                  const SizedBox(width: 08),
                  Expanded(
                    child: ElevateButton(
                      radius: 04,
                      height: 38,
                      onTap: _onEditDetails,
                      // onTap: _onAddToWishlist,
                      label: 'add_to_wishlist'.recast.toUpper,
                      textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
                    ),
                  ),
                ],
              ),
        const SizedBox(height: 04),
      ],
    );
  }

  TextSpan _readMoreTextButton(String description) {
    return TextSpan(
      text: 'read_more'.recast,
      style: TextStyles.text12_700.copyWith(color: lightBlue),
      recognizer: TapGestureRecognizer()..onTap = () => descriptionDialog(description: description),
    );
  }

  /*Future<void> _onAddToWishlist() async {
    if (onAdd == null) return;
    onAdd!();
    backToPrevious();
  }*/

  Future<void> _onRemoveFromWishlist() async {
    if (onRemove == null) return;
    onRemove!();
    backToPrevious();
  }

  Future<void> _onEditDetails() async {
    if (onEdit == null) return;
    backToPrevious();
    onEdit!();
  }
}

class _DicInfo extends StatelessWidget {
  final String label;
  final double value;

  const _DicInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final style1 = TextStyles.text14_600.copyWith(color: lightBlue);
    final style2 = TextStyles.text16_700.copyWith(color: lightBlue);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 04),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(label, style: style1), const SizedBox(height: 01), Text(value.formatDouble, style: style2)],
      ),
    );
  }
}
