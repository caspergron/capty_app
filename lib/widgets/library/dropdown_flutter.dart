import 'package:flutter/material.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:app/constants/data_constants.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/size_config.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/dropdown_item.dart';

class DropdownFlutter<T> extends StatelessWidget {
  final String hint;
  final double height;
  final double radius;
  final double fontSize;
  final Color color;
  final Color borderColor;
  final Color background;
  final List<BoxShadow> shadows;
  final T? value;
  final String? hintLabel;
  final List<T> items;
  final ValueChanged<T?>? onChanged;

  const DropdownFlutter({
    this.hint = '',
    this.height = 44,
    this.items = const [],
    this.shadows = const [],
    this.color = dark,
    this.background = lightBlue,
    this.borderColor = primary,
    this.value,
    this.onChanged,
    this.hintLabel,
    this.radius = 04,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);
    final decoration = BoxDecoration(color: background, borderRadius: borderRadius);
    final style = TextStyles.text12_600.copyWith(color: color.colorOpacity(0.5), fontWeight: w400);
    final textWidget = Text('$DROPDOWN_SPACE$hint', maxLines: 1, overflow: TextOverflow.ellipsis, style: style);
    return Container(
      height: height,
      width: SizeConfig.width,
      decoration: BoxDecoration(color: background, border: Border.all(color: borderColor), borderRadius: borderRadius, boxShadow: shadows),
      child: items.isEmpty
          ? Align(alignment: Alignment.centerLeft, child: textWidget)
          : DropdownButtonHideUnderline(
              child: DropdownButton2<T>(
                value: value,
                isDense: true,
                isExpanded: true,
                onChanged: onChanged,
                items: _dropdownMenuItems,
                hint: _dropdownHint(context, color),
                menuItemStyleData: MenuItemStyleData(customHeights: _itemsHeights, padding: const EdgeInsets.symmetric(horizontal: 4)),
                buttonStyleData: const ButtonStyleData(height: 46, width: double.infinity),
                dropdownStyleData: DropdownStyleData(maxHeight: 200, elevation: 2, decoration: decoration),
                iconStyleData: IconStyleData(icon: _suffixIcon),
              ),
            ),
    );
  }

  DropdownMenuItem<T> get _divider => const DropdownMenuItem(enabled: false, child: Divider());

  List<DropdownMenuItem<T>> get _dropdownMenuItems {
    List<DropdownMenuItem<T>> menuItems = [];
    if (!items.haveList) return menuItems;
    items.forEach((item) => menuItems.addAll([
          DropdownMenuItem(value: item, child: DropdownItem(label: (item as dynamic).label, color: color)),
          if (item != items.last) _divider
        ]));
    return menuItems;
  }

  List<double> get _itemsHeights {
    List<double> _itemsHeights = [];
    for (var i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) _itemsHeights.add(40);
      if (i.isOdd) _itemsHeights.add(4);
    }
    return _itemsHeights;
  }

  Widget get _suffixIcon {
    final icon = SvgImage(image: Assets.svg1.caret_down_1, height: 20, color: color.colorOpacity(value == null ? 0.7 : 1));
    return Padding(padding: const EdgeInsets.only(right: 14), child: icon);
  }

  Widget _dropdownHint(BuildContext context, Color textColor) {
    final title = '$DROPDOWN_SPACE${hintLabel ?? hint}';
    final color = background == primary ? lightBlue : textColor.colorOpacity(hintLabel == null ? 0.8 : 1);
    final style = TextStyles.text12_600.copyWith(color: color, fontSize: fontSize, fontWeight: w400);
    return Text(title, textAlign: TextAlign.start, maxLines: 1, overflow: TextOverflow.ellipsis, style: style);
  }
}
