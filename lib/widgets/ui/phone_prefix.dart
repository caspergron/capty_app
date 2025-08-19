import 'dart:async';

import 'package:flutter/material.dart';

import 'package:app/components/sheets/country_sheet.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/public/country.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/svg_image.dart';

class PhonePrefix extends StatelessWidget {
  final Country country;
  final Function(Country)? onChanged;

  const PhonePrefix({required this.country, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onChanged,
      child: Container(
        width: onChanged == null ? 60 : 76,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(right: 02),
        padding: const EdgeInsets.only(left: 10, right: 04),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(country.phonePrefix ?? 'n/a'.recast, style: TextStyles.text16_600.copyWith(color: dark.colorOpacity(0.7), height: 1.1)),
            const SizedBox(width: 06),
            if (onChanged != null) SvgImage(image: Assets.svg1.caret_down_1, height: 16, color: text.colorOpacity(0.7)),
            const SizedBox(width: 06),
            Container(height: 24, width: 1, color: grey),
          ],
        ),
      ),
    );
  }

  Future<void> _onChanged() async {
    if (onChanged == null) return;
    minimizeKeyboard();
    await Future.delayed(const Duration(milliseconds: 200));
    unawaited(countriesSheet(country: country, onChanged: onChanged!));
  }
}
