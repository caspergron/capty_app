import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/components/loaders/loader_box.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/libraries/flush_popup.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/services/input_formatters.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/input_field.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/image_network.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/colored_disc.dart';

// type: sell, , sold
Future<void> salesAdDialog({
  required SalesAd marketplace,
  Function(String)? onPrice,
  Function()? onSold,
  Function()? onEdit,
  Function()? onRemove,
}) async {
  var context = navigatorKey.currentState!.context;
  var padding = MediaQuery.of(context).viewInsets;
  var child = Align(child: _DialogView(marketplace, onPrice, onSold, onEdit, onRemove));
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Sales Ad Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().topToBottom,
    pageBuilder: (buildContext, anim1, anim2) => Padding(padding: padding, child: PopScopeNavigator(canPop: false, child: child)),
  );
}

class _DialogView extends StatefulWidget {
  final SalesAd marketplace;
  final Function(String)? onPrice;
  final Function()? onSold;
  final Function()? onEdit;
  final Function()? onRemove;

  const _DialogView(this.marketplace, this.onPrice, this.onSold, this.onEdit, this.onRemove);

  @override
  State<_DialogView> createState() => _DialogViewState();
}

class _DialogViewState extends State<_DialogView> {
  var _focusNode = FocusNode();
  var _price = TextEditingController();

  @override
  void initState() {
    // sl<AppAnalytics>().screenView('disc-info-popup');
    _price.text = widget.marketplace.price.formatDouble;
    _focusNode.addListener(() => setState(() {}));
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
    var marketplace = widget.marketplace;
    var userDisc = marketplace.userDisc;
    var parentDisc = userDisc?.parentDisc;
    var isDescription = marketplace.notes.toKey.isNotEmpty;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(parentDisc?.name ?? 'n/a'.recast, style: TextStyles.text16_600.copyWith(color: lightBlue)),
            InkWell(onTap: backToPrevious, child: SvgImage(image: Assets.svg1.close_1, height: 18, color: lightBlue)),
          ],
        ),
        const SizedBox(height: 20),
        Text('${'price'.recast} (${widget.marketplace.currency_code})', style: TextStyles.text14_600.copyWith(color: lightBlue)),
        const SizedBox(height: 06),
        InputField(
          fontSize: 12,
          controller: _price,
          hintText: '${'ex'.recast}: 125',
          focusNode: _focusNode,
          keyboardType: TextInputType.number,
          enabledBorder: lightBlue,
          focusedBorder: lightBlue,
          borderRadius: BorderRadius.circular(04),
          suffixIcon: InkWell(onTap: _onPrice, child: _inputSuffix),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, PriceInputFormatter()],
        ),
        const SizedBox(height: 28),
        Center(
          child: Builder(builder: (context) {
            if (userDisc?.media?.url != null) {
              return ImageNetwork(
                radius: 08,
                width: 50.width,
                height: 50.width,
                image: userDisc?.media?.url,
                placeholder: const FadingCircle(size: 60, color: lightBlue),
                errorWidget: _loaderBox,
              );
            } else if (userDisc?.color != null) {
              return ColoredDisc(
                size: 50.width,
                iconSize: 24,
                discColor: userDisc!.disc_color!,
                brandIcon: parentDisc?.brand_media.url,
              );
            } else {
              return ImageNetwork(
                radius: 08,
                width: 50.width,
                height: 50.width,
                image: parentDisc?.media.url,
                placeholder: const FadingCircle(size: 60, color: lightBlue),
                errorWidget: _loaderBox,
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
              marketplace.notes ?? '',
              textAlign: TextAlign.center,
              style: TextStyles.text12_400.copyWith(color: lightBlue),
            ),
          ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ElevateButton(
                radius: 04,
                height: 36,
                onTap: _onSold,
                background: skyBlue,
                label: 'mark_as_sold'.recast.toUpper,
                textStyle: TextStyles.text14_700.copyWith(color: primary, fontWeight: w600, height: 1.15),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevateButton(
                radius: 04,
                height: 36,
                padding: 16,
                onTap: _onEdit,
                label: 'edit_details'.recast.toUpper,
                textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevateButton(
            radius: 04,
            height: 36,
            padding: 32,
            onTap: _onRemove,
            background: error,
            label: 'remove_sales_ad'.recast.toUpper,
            textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
          ),
        ),
        const SizedBox(height: 04),
      ],
    );
  }

  void _onSold() {
    if (widget.onSold == null) return;
    backToPrevious();
    widget.onSold!();
  }

  void _onEdit() {
    if (widget.onEdit == null) return;
    backToPrevious();
    widget.onEdit!();
  }

  void _onRemove() {
    if (widget.onRemove == null) return;
    backToPrevious();
    widget.onRemove!();
  }

  void _onPrice() {
    if (widget.onPrice == null) return;
    if (_price.text.isEmpty) return FlushPopup.onWarning(message: 'Please_write_your_sold_amount'.recast);
    backToPrevious();
    widget.onPrice!(_price.text);
  }

  Widget get _inputSuffix {
    var radius = const Radius.circular(04);
    return Container(
      height: 40,
      width: 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: orange, borderRadius: BorderRadius.only(topRight: radius, bottomRight: radius)),
      child: Text('update'.recast.toUpper, style: TextStyles.text14_700.copyWith(color: lightBlue, height: 1.1)),
    );
  }

  Widget get _loaderBox {
    var size = Size(65.width, 65.width);
    var color = lightBlue.colorOpacity(0.6);
    var icon = SvgImage(image: Assets.svg1.disc_4, height: 38.width, color: lightBlue);
    return LoaderBox(radius: 08, border: color, boxSize: size, child: icon);
  }
}
