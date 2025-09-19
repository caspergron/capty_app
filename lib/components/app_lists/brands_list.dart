import 'package:flutter/material.dart';

import 'package:app/animations/fade_animation.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/models/common/brand.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/widgets/library/image_network.dart';
import 'package:app/widgets/library/svg_image.dart';

class BrandsList extends StatelessWidget {
  final List<Brand> selectedItems;
  final List<Brand> brands;
  final Function(Brand)? onChanged;
  const BrandsList({this.brands = const [], this.selectedItems = const [], this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      itemCount: brands.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: _brandItemCard,
    );
  }

  Widget _brandItemCard(BuildContext context, int index) {
    final item = brands[index];
    final selected = selectedItems.isNotEmpty && selectedItems.any((element) => element.id == item.id);
    final checkIcon = SvgImage(image: Assets.svg1.tick, color: lightBlue, height: 18);
    const border = Border(bottom: BorderSide(color: lightBlue, width: 0.5));
    return InkWell(
      onTap: () => onChanged == null ? null : onChanged!(item),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: index == 0 ? 0 : 12, bottom: index == brands.length - 1 ? 0 : 12),
        decoration: BoxDecoration(border: index == brands.length - 1 ? null : border),
        child: Row(
          children: [
            ImageNetwork(
              width: 24,
              height: 24,
              image: item.media?.url,
              placeholder: const FadingCircle(size: 20, color: lightBlue),
              errorWidget: SvgImage(image: Assets.svg1.image_square, color: lightBlue, height: 22),
            ),
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
