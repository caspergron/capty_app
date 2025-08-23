import 'package:app/components/loaders/fading_circle.dart';
import 'package:app/extensions/number_ext.dart';
import 'package:app/extensions/string_ext.dart';
import 'package:app/models/marketplace/sales_ad.dart';
import 'package:app/themes/colors.dart';
import 'package:app/themes/text_styles.dart';
import 'package:app/utils/assets.dart';
import 'package:app/widgets/library/circle_image.dart';
import 'package:app/widgets/library/svg_image.dart';
import 'package:app/widgets/ui/colored_disc.dart';
import 'package:flutter/material.dart';

class DiscInfoChatBox extends StatelessWidget {
  final SalesAd salesAd;
  final Function()? onClose;
  const DiscInfoChatBox({required this.salesAd, this.onClose});

  @override
  Widget build(BuildContext context) {
    var userDisc = salesAd.userDisc;
    var parentDisc = userDisc?.parentDisc;
    return Container(
      margin: const EdgeInsets.only(bottom: 06),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            children: [
              Builder(builder: (context) {
                if (userDisc?.media?.url != null) {
                  return CircleImage(
                    radius: 36,
                    borderWidth: 0.4,
                    borderColor: lightBlue,
                    image: userDisc?.media?.url,
                    placeholder: const FadingCircle(size: 30),
                    errorWidget: SvgImage(image: Assets.svg1.disc_3, height: 50, color: primary),
                    // errorWidget: ColoredDisc(size: 104, iconSize: 24, discColor: Colors.deepOrangeAccent),
                  );
                } else if (userDisc?.color != null) {
                  return ColoredDisc(
                    size: 72,
                    iconSize: 26,
                    discColor: userDisc!.disc_color!,
                    brandIcon: parentDisc?.brand_media.url,
                  );
                } else {
                  return CircleImage(
                    radius: 36,
                    borderWidth: 0.4,
                    borderColor: lightBlue,
                    image: parentDisc?.media.url,
                    placeholder: const FadingCircle(size: 30),
                    errorWidget: SvgImage(image: Assets.svg1.disc_3, height: 50, color: lightBlue),
                  );
                }
              }),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            parentDisc?.name ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.text16_600.copyWith(color: lightBlue),
                          ),
                        ),
                        const SizedBox(width: 02),
                        InkWell(
                          onTap: () => onClose == null ? null : onClose!(),
                          child: SvgImage(image: Assets.svg1.close_1, height: 16, color: lightBlue),
                        ),
                      ],
                    ),
                    const SizedBox(height: 02),
                    Text(
                      '${parentDisc?.brand?.name ?? ''} ${userDisc?.plastic == null ? '' : '•'} ${userDisc?.plastic?.name ?? ''}',
                      textAlign: TextAlign.center,
                      style: TextStyles.text14_500.copyWith(color: skyBlue),
                    ),
                    const SizedBox(height: 02),
                    Text(
                      '${salesAd.price.formatDouble} ${salesAd.currency_code}',
                      style: TextStyles.text16_600.copyWith(color: warning),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 06),
          Text(
            'this_box_will_show_the_seller_which_discs_you_are_interested_in'.recast,
            maxLines: 2,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.text14_500.copyWith(color: skyBlue, height: 1.2),
          ),
        ],
      ),
    );
  }
}
