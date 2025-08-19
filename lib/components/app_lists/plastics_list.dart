import 'package:flutter/material.dart';

import 'package:app/animations/fade_animation.dart';
import 'package:app/models/plastic/plastic.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/widgets/library/svg_image.dart';

class PlasticsList extends StatelessWidget {
  final Plastic plastic;
  final List<Plastic> plastics;
  final Function(Plastic)? onChanged;
  const PlasticsList({required this.plastic, this.plastics = const [], this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      itemCount: plastics.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: _plasticItemCard,
    );
  }

  Widget _plasticItemCard(BuildContext context, int index) {
    var item = plastics[index];
    var selected = plastic.id != null && plastic.id == item.id;
    var checkIcon = SvgImage(image: Assets.svg1.tick, color: lightBlue, height: 18);
    var border = const Border(bottom: BorderSide(color: lightBlue, width: 0.5));
    return InkWell(
      onTap: () => onChanged == null ? null : onChanged!(item),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: index == 0 ? 0 : 12, bottom: index == plastics.length - 1 ? 0 : 12),
        decoration: BoxDecoration(border: index == plastics.length - 1 ? null : border),
        child: Row(
          children: [
            const Icon(Icons.circle, color: lightBlue, size: 08),
            const SizedBox(width: 12),
            Expanded(child: Text(item.name ?? '', style: TextStyles.text14_400.copyWith(color: lightBlue, height: 1.1))),
            if (selected) const SizedBox(width: 12),
            if (selected) FadeAnimation(fadeKey: item.name ?? '', duration: DURATION_1000, child: checkIcon),
          ],
        ),
      ),
    );
  }
}
