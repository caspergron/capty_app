import 'package:flutter/material.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:app/components/buttons/elevate_button.dart';
import 'package:app/constants/app_keys.dart';
import 'package:app/di.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/shadows.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/utils/transitions.dart';
import 'package:app/widgets/core/pop_scope_navigator.dart';
import 'package:app/widgets/library/svg_image.dart';

Future<void> colorPickerDialog({required Color? color, required Function(Color) onChanged}) async {
  var context = navigatorKey.currentState!.context;
  // sl<AppAnalytics>().screenView('color-picker-popup');
  await showGeneralDialog(
    context: context,
    barrierLabel: 'Color Picker Dialog',
    transitionDuration: DIALOG_DURATION,
    transitionBuilder: sl<Transitions>().topToBottom,
    pageBuilder: (buildContext, anim1, anim2) => PopScopeNavigator(canPop: false, child: Align(child: _DialogView(color, onChanged))),
  );
}

class _DialogView extends StatefulWidget {
  final Color? color;
  final Function(Color) onChanged;
  const _DialogView(this.color, this.onChanged);

  @override
  State<_DialogView> createState() => _DialogViewState();
}

class _DialogViewState extends State<_DialogView> {
  var _color = const Color(0xFFFD131B);

  @override
  void initState() {
    if (widget.color != null) _color = widget.color!;
    super.initState();
  }

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${'pick_a_color'.recast}!',
              textAlign: TextAlign.center,
              style: TextStyles.text18_600.copyWith(color: lightBlue, height: 1),
            ),
            InkWell(onTap: backToPrevious, child: SvgImage(image: Assets.svg1.close_1, color: lightBlue, height: 18)),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: lightBlue,
            borderRadius: BorderRadius.circular(08),
          ),
          child: ColorPicker(
            portraitOnly: true,
            pickerColor: _color,
            paletteType: PaletteType.hueWheel,
            pickerAreaHeightPercent: 0.9,
            onColorChanged: (value) => setState(() => _color = _convertRgbToColor(value)),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ElevateButton(
                radius: 04,
                height: 42,
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
                height: 42,
                onTap: _onConfirm,
                label: 'confirm'.recast.toUpper,
                textStyle: TextStyles.text14_700.copyWith(color: lightBlue, fontWeight: w600, height: 1.15),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  void _onConfirm() {
    widget.onChanged(_color);
    backToPrevious();
  }

  Color _convertRgbToColor(Color rgbColor) {
    var alpha = rgbColor.a;
    var red = rgbColor.r;
    var green = rgbColor.g;
    var blue = rgbColor.b;

    var a = (alpha * 255).toInt();
    var r = (red * 255).toInt();
    var g = (green * 255).toInt();
    var b = (blue * 255).toInt();

    var colorValue = (a << 24) | (r << 16) | (g << 8) | b;

    return Color(colorValue);
  }
}
