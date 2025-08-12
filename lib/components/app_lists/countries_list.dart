import 'package:flutter/material.dart';

import 'package:app/animations/fade_animation.dart';
import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/models/public/country.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/widgets/library/image_network.dart';
import 'package:app/widgets/library/svg_image.dart';

class CountriesList extends StatelessWidget {
  final Country country;
  final List<Country> countries;
  final Function(Country) onChanged;
  const CountriesList({required this.country, required this.onChanged, this.countries = const []});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      itemCount: countries.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => _countryItemCard(countries[index], index, countries.length),
    );
  }

  Widget _countryItemCard(Country item, int index, int length) {
    var selected = country.id != null && country.id == item.id;
    var checkIcon = SvgImage(image: Assets.svg1.tick, color: lightBlue, height: 18);
    var border = const Border(bottom: BorderSide(color: lightBlue, width: 0.5));
    return InkWell(
      onTap: () => onChanged(item),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: index == 0 ? 0 : 12, bottom: index == length - 1 ? 0 : 12),
        decoration: BoxDecoration(border: index == length - 1 ? null : border),
        child: Row(
          children: [
            ImageNetwork(
              width: 24,
              height: 24,
              // image: item.flag,
              placeholder: const FadingCircle(size: 20, color: lightBlue),
              errorWidget: SvgImage(image: Assets.svg1.image_square, color: lightBlue, height: 22),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(item.name ?? '', style: TextStyles.text14_400.copyWith(color: lightBlue, height: 1.1))),
            if (selected) const SizedBox(width: 12),
            if (selected) FadeAnimation(fadeKey: item.code ?? '', duration: DURATION_1000, child: checkIcon),
          ],
        ),
      ),
    );
  }
}
