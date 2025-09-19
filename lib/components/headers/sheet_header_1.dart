import 'package:flutter/material.dart';

import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/dimensions.dart';

class SheetHeader1 extends StatelessWidget {
  final String label;
  final bool isClose;
  final Function()? onClose;

  const SheetHeader1({this.label = '', this.onClose, this.isClose = true});

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(color: mediumBlue, borderRadius: BorderRadius.circular(2));
    return Container(
      width: double.infinity,
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(color: primary, borderRadius: SHEET_RADIUS),
      child: Column(
        children: [
          const SizedBox(height: 06),
          Container(height: 4, width: 28.width, decoration: decoration),
          const SizedBox(height: 14),
          Row(
            children: [
              SizedBox(width: Dimensions.dialog_padding),
              Expanded(child: Text(label, style: TextStyles.text18_600.copyWith(color: lightBlue))),
              if (isClose) const SizedBox(width: 10),
              if (isClose) InkWell(onTap: onClose ?? backToPrevious, child: const Icon(Icons.close, color: lightBlue, size: 22)),
              SizedBox(width: Dimensions.dialog_padding),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: mediumBlue, height: 0.5, thickness: 0.5),
        ],
      ),
    );
  }
}
