import 'package:flutter/material.dart';

import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';

class BasicInfo extends StatelessWidget {
  final String label;
  const BasicInfo({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 10),
        const Padding(padding: EdgeInsets.only(top: 8), child: Icon(Icons.circle, size: 08, color: primary)),
        const SizedBox(width: 06),
        Expanded(child: Text(label, style: TextStyles.text14_400.copyWith(color: primary))),
      ],
    );
  }
}
