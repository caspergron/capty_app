import 'package:flutter/material.dart';

import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/components/loaders/loader_box.dart';
import 'package:app/extensions/flutter_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/services/routes.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/fonts.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/image_network.dart';
import 'package:app/widgets/library/svg_image.dart';

class AdsDiscList extends StatelessWidget {
  final List<String> discList;
  final Function(String, int)? onDisc;
  final ScrollPhysics physics;
  final double gap;
  const AdsDiscList({this.discList = const [], this.onDisc, this.physics = const BouncingScrollPhysics(), this.gap = 20});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: physics,
      clipBehavior: Clip.antiAlias,
      itemCount: discList.length,
      gridDelegate: _gridDelegate,
      itemBuilder: _discItemCard,
      padding: EdgeInsets.symmetric(horizontal: gap),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount get _gridDelegate {
    return const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      childAspectRatio: 0.65,
      crossAxisSpacing: 08,
      mainAxisSpacing: 20,
    );
  }

  Widget _discItemCard(BuildContext context, int index) {
    var item = discList[index];
    if (index == 0 && item == 'add_disc') return _createSalesAdCard;
    var decoration = BoxDecoration(color: primary, borderRadius: BorderRadius.circular(8));
    return InkWell(
      onTap: onDisc == null ? null : () => onDisc!(item, index - 1),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: AspectRatio(aspectRatio: 1.1, child: Container(decoration: decoration)),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 04),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AspectRatio(
                  aspectRatio: 0.95,
                  child: ImageNetwork(
                    radius: 08,
                    height: double.infinity,
                    width: double.infinity,
                    // image: item.,
                    color: popupBearer.colorOpacity(0.1),
                    placeholder: const FadingCircle(size: 40, color: lightBlue),
                    errorWidget: _loaderBox,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      'Champion Orc',
                      textAlign: TextAlign.center,
                      style: TextStyles.text10_400.copyWith(color: lightBlue, fontWeight: w700),
                    ),
                    Text(
                      'Innova',
                      textAlign: TextAlign.center,
                      style: TextStyles.text10_400.copyWith(color: lightBlue),
                    ),
                    Text('126 DKK', style: TextStyles.text10_400.copyWith(color: orange, fontWeight: w600))
                  ],
                ),
              ],
            ),
          ),
          // Positioned(right: 0, top: 0, child: SvgImage(image: Assets.svg1.check_square, height: 18, color: primary)),
        ],
      ),
    );
  }

  Widget get _loaderBox {
    return LoaderBox(
      radius: 08,
      border: lightBlue.colorOpacity(0.6),
      boxSize: const Size(double.infinity, 152),
      child: SvgImage(image: Assets.svg1.disc_2),
      // child: SvgImage(image: Assets.svg1.image_square, height: 36, color: lightBlue),
    );
  }

  Widget get _createSalesAdCard {
    return InkWell(
      onTap: Routes.user.search_disc(index: 1).push,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: const Color(0x6000246B), borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgImage(image: Assets.svg1.plus, color: lightBlue, height: 24),
            const SizedBox(height: 08),
            Text('create_n_sales_ad'.recast, textAlign: TextAlign.center, style: TextStyles.text12_700.copyWith(color: lightBlue))
          ],
        ),
      ),
    );
  }
}
