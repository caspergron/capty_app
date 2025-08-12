import 'package:flutter/material.dart';

import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';

class DiscSizeList extends StatelessWidget {
  final List<double> sizes;
  final Function(double)? onTap;
  const DiscSizeList({this.sizes = const [], this.onTap});

  @override
  Widget build(BuildContext context) {
    if (sizes.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 06,
      runSpacing: 04,
      children: List.generate(sizes.length, (index) => _sizeItemCard(sizes[index])).toList(),
    );
  }

  Widget _sizeItemCard(double size) {
    return InkWell(
      onTap: onTap == null ? null : () => onTap!(size),
      child: Container(
        height: 25,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 5.5),
        decoration: BoxDecoration(
          color: lightBlue,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(width: 0.5, color: dark.colorOpacity(0.3)),
        ),
        child: Text(size.formatDouble, style: TextStyles.text12_600.copyWith(color: dark, fontWeight: w400, height: 1)),
      ),
    );
  }
}
